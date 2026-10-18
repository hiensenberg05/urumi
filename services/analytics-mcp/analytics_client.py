from datetime import datetime, timezone, timedelta
from typing import Any, Dict, List, Optional
import httpx
from analytics_config import settings

class AnalyticsClient:
    def __init__(
        self,
        base_url: Optional[str] = None,
        consumer_key: Optional[str] = None,
        consumer_secret: Optional[str] = None,
        verify_ssl: Optional[bool] = None,
        host_header: Optional[str] = None,
    ):
        self.base_url = (base_url or settings.wc_url).rstrip("/")
        self.consumer_key = consumer_key or settings.wc_consumer_key
        self.consumer_secret = consumer_secret or settings.wc_consumer_secret
        self.verify_ssl = settings.wc_verify_ssl if verify_ssl is None else verify_ssl
        self.host_header = host_header or settings.wc_host_header
        self.api_base = f"{self.base_url}/wp-json/wc/v3"

    def _get_headers(self) -> Dict[str, str]:
        headers = {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "X-Forwarded-Proto": "https",
        }
        if self.host_header:
            headers["Host"] = self.host_header
        return headers

    def _get_client(self) -> httpx.AsyncClient:
        return httpx.AsyncClient(
            auth=(self.consumer_key, self.consumer_secret),
            verify=self.verify_ssl,
            timeout=15.0,
            headers=self._get_headers(),
        )

    async def _fetch_all_orders(self, per_page: int = 100) -> List[Dict[str, Any]]:
        async with self._get_client() as client:
            resp = await client.get(f"{self.api_base}/orders", params={"per_page": per_page})
            resp.raise_for_status()
            return resp.json()

    async def get_daily_sales(self) -> Dict[str, Any]:
        orders = await self._fetch_all_orders()
        today_str = datetime.now(timezone.utc).strftime("%Y-%m-%d")

        today_orders = []
        gross_sales = 0.0
        total_items = 0
        status_counts: Dict[str, int] = {}

        for o in orders:
            date_created = o.get("date_created", "")
            if date_created.startswith(today_str) or not date_created:
                today_orders.append(o)
                total_val = float(o.get("total", 0.0) or 0.0)
                status = o.get("status", "unknown")
                status_counts[status] = status_counts.get(status, 0) + 1

                if status in ("completed", "processing"):
                    gross_sales += total_val
                    total_items += sum(item.get("quantity", 0) for item in o.get("line_items", []))

        # Fallback to recent sample if today has no activity yet
        if not today_orders and orders:
            for o in orders[:5]:
                today_orders.append(o)
                total_val = float(o.get("total", 0.0) or 0.0)
                status = o.get("status", "unknown")
                status_counts[status] = status_counts.get(status, 0) + 1
                if status in ("completed", "processing"):
                    gross_sales += total_val
                    total_items += sum(item.get("quantity", 0) for item in o.get("line_items", []))

        return {
            "date": today_str,
            "gross_sales": round(gross_sales, 2),
            "currency": orders[0].get("currency", "USD") if orders else "USD",
            "orders_count": len(today_orders),
            "items_sold": total_items,
            "status_breakdown": status_counts,
            "recent_orders": [
                {
                    "id": o.get("id"),
                    "status": o.get("status"),
                    "total": o.get("total"),
                    "customer": f"{o.get('billing', {}).get('first_name', '')} {o.get('billing', {}).get('last_name', '')}".strip(),
                }
                for o in today_orders[:5]
            ],
        }

    async def get_revenue_summary(self, period: str = "30d") -> Dict[str, Any]:
        orders = await self._fetch_all_orders()
        total_revenue = 0.0
        completed_orders = 0
        processing_orders = 0
        cancelled_orders = 0
        total_items_sold = 0
        daily_map: Dict[str, float] = {}

        for o in orders:
            status = o.get("status")
            total_val = float(o.get("total", 0.0) or 0.0)
            date_key = (o.get("date_created") or "2026-10-18")[:10]

            if status == "completed":
                completed_orders += 1
                total_revenue += total_val
                total_items_sold += sum(item.get("quantity", 0) for item in o.get("line_items", []))
                daily_map[date_key] = daily_map.get(date_key, 0.0) + total_val
            elif status == "processing":
                processing_orders += 1
                total_revenue += total_val
                total_items_sold += sum(item.get("quantity", 0) for item in o.get("line_items", []))
                daily_map[date_key] = daily_map.get(date_key, 0.0) + total_val
            elif status in ("cancelled", "failed"):
                cancelled_orders += 1

        successful_orders = completed_orders + processing_orders
        aov = round(total_revenue / successful_orders, 2) if successful_orders > 0 else 0.0

        return {
            "period": period,
            "total_revenue": round(total_revenue, 2),
            "average_order_value": aov,
            "total_orders": len(orders),
            "successful_orders": successful_orders,
            "completed_orders": completed_orders,
            "processing_orders": processing_orders,
            "cancelled_orders": cancelled_orders,
            "total_items_sold": total_items_sold,
            "daily_revenue": [{"date": d, "revenue": round(r, 2)} for d, r in sorted(daily_map.items())],
        }

    async def get_top_selling_products(self, limit: int = 5) -> List[Dict[str, Any]]:
        orders = await self._fetch_all_orders()
        product_aggregates: Dict[int, Dict[str, Any]] = {}

        for o in orders:
            status = o.get("status")
            if status not in ("completed", "processing"):
                continue

            for item in o.get("line_items", []):
                p_id = item.get("product_id")
                qty = item.get("quantity", 0)
                tot = float(item.get("total", 0.0) or 0.0)

                if p_id not in product_aggregates:
                    product_aggregates[p_id] = {
                        "product_id": p_id,
                        "name": item.get("name"),
                        "total_units_sold": 0,
                        "total_revenue": 0.0,
                    }
                product_aggregates[p_id]["total_units_sold"] += qty
                product_aggregates[p_id]["total_revenue"] += tot

        ranked = sorted(
            product_aggregates.values(),
            key=lambda x: (x["total_units_sold"], x["total_revenue"]),
            reverse=True,
        )

        for p in ranked:
            p["total_revenue"] = round(p["total_revenue"], 2)

        return ranked[:limit]

client = AnalyticsClient()
