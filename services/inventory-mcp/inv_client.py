import asyncio
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

    async def batch_check_stock(self, skus: List[str]) -> Dict[str, Any]:
        """Check inventory stock levels for a batch of SKUs in one call."""
        async def _check_one(sku: str) -> Dict[str, Any]:
            return await self.check_stock(sku)

        cleaned_skus = [s.strip() for s in skus if s and s.strip()]
        tasks = [_check_one(sku) for sku in cleaned_skus]
        results = await asyncio.gather(*tasks, return_exceptions=True)

        items = []
        found_count = 0
        for sku, res in zip(cleaned_skus, results):
            if isinstance(res, Exception):
                items.append({"sku": sku, "found": False, "error": str(res)})
            elif isinstance(res, dict):
                items.append(res)
                if res.get("found"):
                    found_count += 1
            else:
                items.append({"sku": sku, "found": False})

        return {
            "items": items,
            "total_requested": len(cleaned_skus),
            "total_found": found_count,
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

    async def update_stock(
        self,
        sku: str,
        quantity: int,
        expected_previous_quantity: Optional[int] = None,
        reason: Optional[str] = None,
    ) -> Dict[str, Any]:
        if quantity < 0:
            raise ValueError(f"Invalid inventory quantity: {quantity}. Stock cannot be negative.")
        if quantity > 500000:
            raise ValueError(f"Quantity {quantity} exceeds maximum batch threshold (500,000 units).")

        prod = await self.get_product_by_sku(sku)
        if not prod:
            raise ValueError(f"Product with SKU '{sku}' not found.")

        current_qty = prod.get("stock_quantity")
        if expected_previous_quantity is not None and current_qty != expected_previous_quantity:
            raise ValueError(
                f"Optimistic Lock Conflict: Expected previous stock {expected_previous_quantity}, "
                f"but current stock is {current_qty}. The stock has changed concurrently."
            )

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
            result = {
                "id": updated.get("id"),
                "name": updated.get("name"),
                "sku": updated.get("sku"),
                "stock_quantity": updated.get("stock_quantity"),
                "stock_status": updated.get("stock_status"),
                "previous_quantity": current_qty,
                "status": "success",
            }
            if reason:
                result["reason"] = reason
            return result

    async def adjust_stock(
        self,
        sku: str,
        delta: int,
        reason: Optional[str] = None,
    ) -> Dict[str, Any]:
        if delta == 0:
            raise ValueError("Stock delta cannot be 0. Provide a non-zero positive or negative adjustment.")
        if abs(delta) > 50000:
            raise ValueError(f"Adjustment delta {delta} exceeds safe threshold of ±50,000 units.")

        prod = await self.get_product_by_sku(sku)
        if not prod:
            raise ValueError(f"Product with SKU '{sku}' not found.")

        current_qty = prod.get("stock_quantity") or 0
        new_quantity = current_qty + delta
        if new_quantity < 0:
            raise ValueError(
                f"Invalid Stock Adjustment: Adjustment of {delta:+d} on current stock {current_qty} "
                f"would result in negative inventory ({new_quantity})."
            )

        product_id = prod["id"]
        stock_status = "instock" if new_quantity > 0 else "outofstock"
        payload = {
            "manage_stock": True,
            "stock_quantity": new_quantity,
            "stock_status": stock_status,
        }

        async with self._get_client() as client:
            resp = await client.put(f"{self.api_base}/products/{product_id}", json=payload)
            resp.raise_for_status()
            updated = resp.json()
            result = {
                "id": updated.get("id"),
                "name": updated.get("name"),
                "sku": updated.get("sku"),
                "stock_quantity": updated.get("stock_quantity"),
                "stock_status": updated.get("stock_status"),
                "previous_quantity": current_qty,
                "delta": delta,
                "status": "success",
            }
            if reason:
                result["reason"] = reason
            return result

client = InventoryClient()
