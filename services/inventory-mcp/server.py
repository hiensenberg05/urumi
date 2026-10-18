from typing import Any, Dict, List
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

@mcp.tool(name="inventory__list_low_stock")
async def list_low_stock(threshold: int = 10) -> List[Dict[str, Any]]:
    """Find and return all products whose available inventory is below or equal to a threshold.
    
    Args:
        threshold: Stock threshold to trigger alert (default: 10 units)
    """
    return await inventory_client.list_low_stock(threshold=threshold)

@mcp.tool(name="inventory__update_stock")
async def update_stock(sku: str, quantity: int) -> Dict[str, Any]:
    """Update inventory stock level for a product by SKU.
    
    Args:
        sku: Unique SKU identifier of the product
        quantity: New inventory count (e.g. 50)
    """
    return await inventory_client.update_stock(sku=sku, quantity=quantity)

app = mcp.http_app()

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=settings.service_port)
