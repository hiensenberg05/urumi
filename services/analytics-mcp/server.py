from typing import Any, Dict, List, Optional
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
async def get_daily_sales(
    date: Optional[str] = None,
    start_date: Optional[str] = None,
    end_date: Optional[str] = None,
) -> Dict[str, Any]:
    """Retrieve gross sales, order volume, and unit metrics for today, a specific date, or a custom date range.
    
    Args:
        date: Specific date in YYYY-MM-DD format (default: today)
        start_date: Start date for date range query (YYYY-MM-DD)
        end_date: End date for date range query (YYYY-MM-DD)
    """
    return await analytics_client.get_daily_sales(date=date, start_date=start_date, end_date=end_date)

@mcp.tool(name="analytics__get_revenue_summary")
async def get_revenue_summary(
    period: str = "30d",
    group_by: Optional[str] = None,
) -> Dict[str, Any]:
    """Calculate aggregated store revenue, average order value (AOV), and optional product revenue grouping.
    
    Args:
        period: Reporting period window, e.g. '7d', '30d', 'all' (default: '30d')
        group_by: Optional grouping dimension. Use 'product' to group revenue and units sold by product, or omit for daily trend.
    """
    return await analytics_client.get_revenue_summary(period=period, group_by=group_by)

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
