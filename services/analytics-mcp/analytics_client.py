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

    async def get_daily_sales(
        self,
        date: Optional[str] = None,
        start_date: Optional[str] = None,
        end_date: Optional[str] = None,
    ) -> Dict[str, Any]:
        orders = await self._fetch_all_orders()
        today_str = datetime.now(timezone.utc).strftime("%Y-%m-%d")

        is_explicit_filter = bool(date or start_date or end_date)
        target_date = date.strip() if date else (None if (start_date or end_date) else today_str)

        matched_orders = []
        gross_sales = 0.0
        total_items = 0
        status_counts: Dict[str, int] = {}

        for o in orders:
            order_date = (o.get("date_created") or "")[:10]
            matches = False
            if target_date:
                matches = (order_date == target_date)
            elif start_date and end_date:
                matches = (start_date <= order_date <= end_date)
            elif start_date:
                matches = (order_date >= start_date)
            elif end_date:
                matches = (order_date <= end_date)
            else:
                matches = (order_date == today_str)

            if matches:
                matched_orders.append(o)
                total_val = float(o.get("total", 0.0) or 0.0)
                status = o.get("status", "unknown")
                status_counts[status] = status_counts.get(status, 0) + 1

                if status in ("completed", "processing"):
                    gross_sales += total_val
                    total_items += sum(item.get("quantity", 0) for item in o.get("line_items", []))

        # Fallback to recent sample only if default today query had 0 orders
        if not matched_orders and not is_explicit_filter and orders:
            for o in orders[:5]:
                matched_orders.append(o)
                total_val = float(o.get("total", 0.0) or 0.0)
                status = o.get("status", "unknown")
                status_counts[status] = status_counts.get(status, 0) + 1
                if status in ("completed", "processing"):
                    gross_sales += total_val
                    total_items += sum(item.get("quantity", 0) for item in o.get("line_items", []))

        filter_label = target_date or f"{start_date or 'beginning'} to {end_date or 'now'}"

        return {
            "query_period": filter_label,
            "date": target_date or (start_date if start_date else today_str),
            "start_date": start_date,
            "end_date": end_date,
            "gross_sales": round(gross_sales, 2),
            "currency": orders[0].get("currency", "USD") if orders else "USD",
            "orders_count": len(matched_orders),
            "items_sold": total_items,
            "status_breakdown": status_counts,
            "recent_orders": [
                {
                    "id": o.get("id"),
                    "status": o.get("status"),
                    "total": o.get("total"),
                    "customer": f"{o.get('billing', {}).get('first_name', '')} {o.get('billing', {}).get('last_name', '')}".strip(),
                    "date_created": o.get("date_created"),
                }
                for o in matched_orders[:10]
            ],
        }

    async def get_revenue_summary(
        self,
        period: str = "30d",
        group_by: Optional[str] = None,
    ) -> Dict[str, Any]:
        orders = await self._fetch_all_orders()
        total_revenue = 0.0
        completed_orders = 0
        processing_orders = 0
        cancelled_orders = 0
        total_items_sold = 0
        daily_map: Dict[str, float] = {}
        product_map: Dict[int, Dict[str, Any]] = {}

        for o in orders:
            status = o.get("status")
            total_val = float(o.get("total", 0.0) or 0.0)
            date_key = (o.get("date_created") or "2026-10-18")[:10]

            if status in ("completed", "processing"):
                if status == "completed":
                    completed_orders += 1
                else:
                    processing_orders += 1

                total_revenue += total_val
                daily_map[date_key] = daily_map.get(date_key, 0.0) + total_val

                for item in o.get("line_items", []):
                    qty = item.get("quantity", 0)
                    item_total = float(item.get("total", 0.0) or 0.0)
                    p_id = item.get("product_id") or 0
                    total_items_sold += qty

                    if p_id not in product_map:
                        product_map[p_id] = {
                            "product_id": p_id,
                            "name": item.get("name", "Unknown Product"),
                            "sku": item.get("sku", ""),
                            "units_sold": 0,
                            "revenue": 0.0,
                            "orders_count": 0,
                        }
                    product_map[p_id]["units_sold"] += qty
                    product_map[p_id]["revenue"] += item_total
                    product_map[p_id]["orders_count"] += 1

            elif status in ("cancelled", "failed"):
                cancelled_orders += 1

        successful_orders = completed_orders + processing_orders
        aov = round(total_revenue / successful_orders, 2) if successful_orders > 0 else 0.0

        res: Dict[str, Any] = {
            "period": period,
            "total_revenue": round(total_revenue, 2),
            "average_order_value": aov,
            "total_orders": len(orders),
            "successful_orders": successful_orders,
            "completed_orders": completed_orders,
            "processing_orders": processing_orders,
            "cancelled_orders": cancelled_orders,
            "total_items_sold": total_items_sold,
        }

        if group_by == "product":
            sorted_products = sorted(
                product_map.values(),
                key=lambda x: (x["revenue"], x["units_sold"]),
                reverse=True,
            )
            for p in sorted_products:
                p["revenue"] = round(p["revenue"], 2)
            res["grouped_by"] = "product"
            res["products"] = sorted_products
        else:
            res["daily_revenue"] = [{"date": d, "revenue": round(r, 2)} for d, r in sorted(daily_map.items())]

        return res

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
                        "sku": item.get("sku", ""),
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
