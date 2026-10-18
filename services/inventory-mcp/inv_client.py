from typing import Any, Dict, List, Optional
import httpx
from inv_config import settings

class InventoryClient:
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

    async def get_product_by_sku(self, sku: str) -> Optional[Dict[str, Any]]:
        async with self._get_client() as client:
            resp = await client.get(f"{self.api_base}/products", params={"sku": sku})
            resp.raise_for_status()
            products = resp.json()
            return products[0] if products else None

    async def check_stock(self, sku: str) -> Dict[str, Any]:
        prod = await self.get_product_by_sku(sku)
        if not prod:
            return {"found": False, "sku": sku, "message": f"Product with SKU '{sku}' not found"}
        return {
            "found": True,
            "id": prod.get("id"),
            "name": prod.get("name"),
            "sku": prod.get("sku"),
            "price": prod.get("price"),
            "manage_stock": prod.get("manage_stock"),
            "stock_quantity": prod.get("stock_quantity"),
            "stock_status": prod.get("stock_status"),
        }

    async def list_low_stock(self, threshold: int = 10, per_page: int = 100) -> List[Dict[str, Any]]:
        async with self._get_client() as client:
            resp = await client.get(f"{self.api_base}/products", params={"per_page": per_page, "status": "publish"})
            resp.raise_for_status()
            products = resp.json()

        low_stock_items = []
        for p in products:
            qty = p.get("stock_quantity")
            manage_stock = p.get("manage_stock")
            if manage_stock and qty is not None and qty <= threshold:
                low_stock_items.append({
                    "id": p.get("id"),
                    "name": p.get("name"),
                    "sku": p.get("sku"),
                    "price": p.get("price"),
                    "stock_quantity": qty,
                    "stock_status": p.get("stock_status"),
                    "threshold": threshold,
                    "is_critically_low": qty == 0 or p.get("stock_status") == "outofstock",
                })
            elif p.get("stock_status") == "outofstock":
                low_stock_items.append({
                    "id": p.get("id"),
                    "name": p.get("name"),
                    "sku": p.get("sku"),
                    "price": p.get("price"),
                    "stock_quantity": qty or 0,
                    "stock_status": "outofstock",
                    "threshold": threshold,
                    "is_critically_low": True,
                })

        low_stock_items.sort(key=lambda x: x["stock_quantity"])
        return low_stock_items

    async def update_stock(self, sku: str, quantity: int) -> Dict[str, Any]:
        prod = await self.get_product_by_sku(sku)
        if not prod:
            raise ValueError(f"Product with SKU '{sku}' not found.")

        product_id = prod["id"]
        stock_status = "instock" if quantity > 0 else "outofstock"
        payload = {
            "manage_stock": True,
            "stock_quantity": quantity,
            "stock_status": stock_status,
        }

        async with self._get_client() as client:
            resp = await client.put(f"{self.api_base}/products/{product_id}", json=payload)
            resp.raise_for_status()
            updated = resp.json()
            return {
                "id": updated.get("id"),
                "name": updated.get("name"),
                "sku": updated.get("sku"),
                "stock_quantity": updated.get("stock_quantity"),
                "stock_status": updated.get("stock_status"),
                "previous_quantity": prod.get("stock_quantity"),
                "status": "success",
            }

client = InventoryClient()
