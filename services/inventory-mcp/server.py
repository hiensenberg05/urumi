from typing import Any, Dict, List, Optional
from fastmcp import FastMCP
from starlette.responses import JSONResponse
from starlette.requests import Request
import uvicorn

from inv_config import settings
from inv_client import InventoryClient

mcp = FastMCP("inventory-mcp")
inventory_client = InventoryClient()

@mcp.custom_route("/health", methods=["GET"])
async def health(request: Request) -> JSONResponse:
    return JSONResponse({
        "status": "healthy",
        "service": "inventory-mcp",
        "wc_url": settings.wc_url,
    })

@mcp.tool(name="inventory__check_stock")
async def check_stock(sku: str) -> Dict[str, Any]:
    """Check inventory stock levels and availability for a specific product by SKU.
    
    Args:
        sku: Unique SKU identifier (e.g. 'SKU-1001')
    """
    return await inventory_client.check_stock(sku=sku)

@mcp.tool(name="inventory__batch_check_stock")
async def batch_check_stock(skus: List[str]) -> Dict[str, Any]:
    """Check inventory stock levels for a batch of product SKUs in a single call.
    
    Args:
        skus: List of product SKU identifiers (e.g. ['SKU-1001', 'SKU-1002', 'SKU-1003'])
    """
    return await inventory_client.batch_check_stock(skus=skus)

@mcp.tool(name="inventory__list_low_stock")
async def list_low_stock(threshold: int = 10) -> List[Dict[str, Any]]:
    """Find and return all products whose available inventory is below or equal to a threshold.
    
    Args:
        threshold: Stock threshold to trigger alert (default: 10 units)
    """
    return await inventory_client.list_low_stock(threshold=threshold)

@mcp.tool(name="inventory__update_stock")
async def update_stock(
    sku: str,
    quantity: int,
    expected_previous_quantity: Optional[int] = None,
    reason: Optional[str] = None,
) -> Dict[str, Any]:
    """Update inventory stock level for a product by SKU with optimistic concurrency protection.
    
    Args:
        sku: Unique SKU identifier of the product
        quantity: New absolute inventory count (e.g. 50)
        expected_previous_quantity: Optional expected current quantity for optimistic locking (fails if stock changed concurrently)
        reason: Optional audit note explaining the change (e.g. 'quarterly inventory count')
    """
    return await inventory_client.update_stock(
        sku=sku,
        quantity=quantity,
        expected_previous_quantity=expected_previous_quantity,
        reason=reason,
    )

@mcp.tool(name="inventory__adjust_stock")
async def adjust_stock(
    sku: str,
    delta: int,
    reason: Optional[str] = None,
) -> Dict[str, Any]:
    """Safely adjust inventory stock by a relative delta (positive to restock, negative to deduct) with audit tracking.
    
    Args:
        sku: Unique SKU identifier of the product
        delta: Relative stock change (e.g. +20 for shipment received, -3 for damaged items)
        reason: Optional audit note explaining the adjustment (e.g. 'shipment received', 'returned item')
    """
    return await inventory_client.adjust_stock(sku=sku, delta=delta, reason=reason)

app = mcp.http_app()

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=settings.service_port)
