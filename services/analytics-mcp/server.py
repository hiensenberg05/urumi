from typing import Any, Dict, List
from fastmcp import FastMCP
from starlette.responses import JSONResponse
from starlette.requests import Request
import uvicorn

from analytics_config import settings
from analytics_client import AnalyticsClient

mcp = FastMCP("analytics-mcp")
analytics_client = AnalyticsClient()

@mcp.custom_route("/health", methods=["GET"])
async def health(request: Request) -> JSONResponse:
    return JSONResponse({
        "status": "healthy",
        "service": "analytics-mcp",
        "wc_url": settings.wc_url,
    })

@mcp.tool(name="analytics__get_daily_sales")
async def get_daily_sales() -> Dict[str, Any]:
    """Retrieve today's gross sales, order volume, and unit metrics.
    
    Returns gross sales revenue, order counts, units sold, and status breakdown.
    """
    return await analytics_client.get_daily_sales()

@mcp.tool(name="analytics__get_revenue_summary")
async def get_revenue_summary(period: str = "30d") -> Dict[str, Any]:
    """Calculate aggregated store revenue, average order value (AOV), and order breakdown.
    
    Args:
        period: Reporting period window, e.g. '7d', '30d', 'all' (default: '30d')
    """
    return await analytics_client.get_revenue_summary(period=period)

@mcp.tool(name="analytics__get_top_selling_products")
async def get_top_selling_products(limit: int = 5) -> List[Dict[str, Any]]:
    """Identify top performing products ranked by total volume sold and generated revenue.
    
    Args:
        limit: Number of top selling products to return (default: 5)
    """
    return await analytics_client.get_top_selling_products(limit=limit)

app = mcp.http_app()

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=settings.service_port)
