from typing import Any, Dict, List, Optional
import httpx
from wc_config import settings

class WooCommerceClient:
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

    async def list_products(
        self,
        per_page: int = 10,
        page: int = 1,
        category: Optional[str] = None,
        status: str = "publish",
    ) -> List[Dict[str, Any]]:
        params: Dict[str, Any] = {"per_page": per_page, "page": page, "status": status}
        if category:
            params["category"] = category
        async with self._get_client() as client:
            resp = await client.get(f"{self.api_base}/products", params=params)
            resp.raise_for_status()
            return resp.json()

    async def create_product(
        self,
        name: str,
        regular_price: str,
        sku: str,
        stock_quantity: int = 0,
        manage_stock: bool = True,
        description: str = "",
    ) -> Dict[str, Any]:
        payload: Dict[str, Any] = {
            "name": name,
            "type": "simple",
            "regular_price": str(regular_price),
            "sku": sku,
            "manage_stock": manage_stock,
            "description": description,
        }
        if manage_stock:
            payload["stock_quantity"] = stock_quantity

        async with self._get_client() as client:
            resp = await client.post(f"{self.api_base}/products", json=payload)
            resp.raise_for_status()
            return resp.json()

    async def list_orders(
        self,
        status: Optional[str] = None,
        per_page: int = 10,
        page: int = 1,
        product_id: Optional[int] = None,
        sku: Optional[str] = None,
        start_date: Optional[str] = None,
        end_date: Optional[str] = None,
    ) -> Dict[str, Any]:
        params: Dict[str, Any] = {"per_page": per_page, "page": page}
        if status and status != "any":
            params["status"] = status

        if start_date:
            after_val = start_date if "T" in start_date else f"{start_date}T00:00:00"
            params["after"] = after_val
        if end_date:
            before_val = end_date if "T" in end_date else f"{end_date}T23:59:59"
            params["before"] = before_val

        target_product_id = product_id
        if not target_product_id and sku:
            async with self._get_client() as client:
                p_resp = await client.get(f"{self.api_base}/products", params={"sku": sku.strip()})
                if p_resp.status_code == 200 and p_resp.json():
                    target_product_id = p_resp.json()[0]["id"]

        if target_product_id:
            params["product"] = target_product_id

        async with self._get_client() as client:
            resp = await client.get(f"{self.api_base}/orders", params=params)
            resp.raise_for_status()
            raw_orders = resp.json()
            total_count = int(resp.headers.get("x-wp-total", len(raw_orders)))
            total_pages = int(resp.headers.get("x-wp-totalpages", 1 if total_count <= per_page else (total_count + per_page - 1) // per_page))
            return {
                "orders": raw_orders,
                "total": total_count,
                "page": page,
                "per_page": per_page,
                "total_pages": total_pages,
                "has_more": page < total_pages,
            }

    async def get_order(self, order_id: int) -> Dict[str, Any]:
        async with self._get_client() as client:
            resp = await client.get(f"{self.api_base}/orders/{order_id}")
            resp.raise_for_status()
            return resp.json()

    async def create_order(
        self,
        line_items: List[Dict[str, Any]],
        customer_name: str = "Test Shopper",
        customer_email: str = "shopper@example.com",
        payment_method: str = "cod",
        payment_title: str = "Cash on delivery",
        status: str = "processing",
    ) -> Dict[str, Any]:
        parts = customer_name.strip().split()
        first_name = parts[0] if parts else "Test"
        last_name = " ".join(parts[1:]) if len(parts) > 1 else "Shopper"
        payload = {
            "payment_method": payment_method,
            "payment_method_title": payment_title,
            "set_paid": False,
            "status": status,
            "billing": {
                "first_name": first_name,
                "last_name": last_name,
                "email": customer_email,
            },
            "line_items": line_items,
        }
        async with self._get_client() as client:
            resp = await client.post(f"{self.api_base}/orders", json=payload)
            resp.raise_for_status()
            return resp.json()

    async def update_order_status(self, order_id: int, status: str) -> Dict[str, Any]:
        async with self._get_client() as client:
            resp = await client.put(f"{self.api_base}/orders/{order_id}", json={"status": status})
            resp.raise_for_status()
            return resp.json()

client = WooCommerceClient()
