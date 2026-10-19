import os
import sys
from typing import Any, Dict, List, Optional
import httpx
from fastmcp import FastMCP

# Initialize FastMCP Server
mcp = FastMCP(
    name="Urumi Team MCP Gateway Bridge",
)

GATEWAY_URL = os.environ.get("GATEWAY_URL", "http://127.0.0.1").rstrip("/")
GATEWAY_HOST_HEADER = os.environ.get("GATEWAY_HOST_HEADER", "gateway.local")
GATEWAY_API_KEY = os.environ.get("GATEWAY_API_KEY", "admin-key-urumi-2026")

def _call_gateway(tool_name: str, arguments: Dict[str, Any]) -> Any:
    """Helper to forward tool calls to the Kubernetes MCP Gateway with RBAC and Audit logging."""
    headers = {
        "Authorization": f"Bearer {GATEWAY_API_KEY}",
        "Host": GATEWAY_HOST_HEADER,
        "Content-Type": "application/json",
        "User-Agent": "Antigravity-MCP-Bridge/1.0",
    }
    with httpx.Client(timeout=30.0) as client:
        resp = client.post(
            f"{GATEWAY_URL}/api/v1/tools/call",
            headers=headers,
            json={"tool": tool_name, "arguments": arguments},
        )
        if resp.status_code == 200:
            data = resp.json()
            return data.get("result", data)
        elif resp.status_code == 403:
            return {"error": "RBAC Permission Denied", "detail": resp.json().get("detail")}
        elif resp.status_code == 401:
            return {"error": "Unauthorized", "detail": "Invalid or revoked API key."}
        else:
            return {"error": f"HTTP {resp.status_code}", "detail": resp.text}

# -------------------------------------------------------------
# WooCommerce Storefront MCP Tools
# -------------------------------------------------------------
@mcp.tool(name="woocommerce__list_products")
def list_products(per_page: int = 10, page: int = 1) -> Any:
    """List products from WooCommerce store catalog."""
    return _call_gateway("woocommerce__list_products", {"per_page": per_page, "page": page})

@mcp.tool(name="woocommerce__create_product")
def create_product(
    name: str,
    regular_price: str,
    sku: str,
    stock_quantity: int = 0,
    description: str = "",
) -> Any:
    """Create a new product in the WooCommerce store."""
    return _call_gateway(
        "woocommerce__create_product",
        {
            "name": name,
            "regular_price": regular_price,
            "sku": sku,
            "stock_quantity": stock_quantity,
            "description": description,
        },
    )

@mcp.tool(name="woocommerce__list_orders")
def list_orders(
    status: Optional[str] = None,
    per_page: int = 10,
    page: int = 1,
    product_id: Optional[int] = None,
    sku: Optional[str] = None,
    start_date: Optional[str] = None,
    end_date: Optional[str] = None,
) -> Any:
    """List customer orders with filtering (by status, product_id, SKU, date range) and total count pagination."""
    args: Dict[str, Any] = {"per_page": per_page, "page": page}
    if status is not None:
        args["status"] = status
    if product_id is not None:
        args["product_id"] = product_id
    if sku is not None:
        args["sku"] = sku
    if start_date is not None:
        args["start_date"] = start_date
    if end_date is not None:
        args["end_date"] = end_date
    return _call_gateway("woocommerce__list_orders", args)

@mcp.tool(name="woocommerce__get_order")
def get_order(order_id: int) -> Any:
    """Retrieve details for a specific order by ID."""
    return _call_gateway("woocommerce__get_order", {"order_id": order_id})

@mcp.tool(name="woocommerce__create_order")
def create_order(
    product_id: int,
    quantity: int = 1,
    customer_name: str = "Sarah Chen",
    status: str = "processing",
) -> Any:
    """Create a new customer order with automatic inventory decrement."""
    return _call_gateway(
        "woocommerce__create_order",
        {
            "product_id": product_id,
            "quantity": quantity,
            "customer_name": customer_name,
            "status": status,
        },
    )

@mcp.tool(name="woocommerce__update_order_status")
def update_order_status(order_id: int, status: str) -> Any:
    """Update order status in WooCommerce (e.g. 'completed', 'cancelled')."""
    return _call_gateway(
        "woocommerce__update_order_status",
        {"order_id": order_id, "status": status},
    )

# -------------------------------------------------------------
# Warehouse Inventory MCP Tools
# -------------------------------------------------------------
@mcp.tool(name="inventory__check_stock")
def check_stock(sku: str) -> Any:
    """Check inventory stock levels and availability by SKU."""
    return _call_gateway("inventory__check_stock", {"sku": sku})

@mcp.tool(name="inventory__batch_check_stock")
def batch_check_stock(skus: List[str]) -> Any:
    """Check inventory stock levels for a batch of SKUs in a single call."""
    return _call_gateway("inventory__batch_check_stock", {"skus": skus})

@mcp.tool(name="inventory__list_low_stock")
def list_low_stock(threshold: int = 10) -> Any:
    """Find items whose stock quantity is below or equal to a threshold."""
    return _call_gateway("inventory__list_low_stock", {"threshold": threshold})

@mcp.tool(name="inventory__update_stock")
def update_stock(
    sku: str,
    quantity: int,
    expected_previous_quantity: Optional[int] = None,
    reason: Optional[str] = None,
) -> Any:
    """Update warehouse inventory count with optimistic concurrency check and audit reason."""
    args: Dict[str, Any] = {"sku": sku, "quantity": quantity}
    if expected_previous_quantity is not None:
        args["expected_previous_quantity"] = expected_previous_quantity
    if reason is not None:
        args["reason"] = reason
    return _call_gateway("inventory__update_stock", args)

@mcp.tool(name="inventory__adjust_stock")
def adjust_stock(
    sku: str,
    delta: int,
    reason: Optional[str] = None,
) -> Any:
    """Safely adjust warehouse inventory by a relative delta (e.g. +20, -5) with an audit reason."""
    args: Dict[str, Any] = {"sku": sku, "delta": delta}
    if reason is not None:
        args["reason"] = reason
    return _call_gateway("inventory__adjust_stock", args)

# -------------------------------------------------------------
# Business Analytics MCP Tools
# -------------------------------------------------------------
@mcp.tool(name="analytics__get_daily_sales")
def get_daily_sales(
    date: Optional[str] = None,
    start_date: Optional[str] = None,
    end_date: Optional[str] = None,
) -> Any:
    """Get gross revenue, total orders, and metrics for today, a specific date, or a custom date range."""
    args: Dict[str, Any] = {}
    if date is not None:
        args["date"] = date
    if start_date is not None:
        args["start_date"] = start_date
    if end_date is not None:
        args["end_date"] = end_date
    return _call_gateway("analytics__get_daily_sales", args)

@mcp.tool(name="analytics__get_revenue_summary")
def get_revenue_summary(
    period: str = "30d",
    group_by: Optional[str] = None,
) -> Any:
    """Get revenue summary over a given period, with optional product grouping ('group_by=product')."""
    args: Dict[str, Any] = {"period": period}
    if group_by is not None:
        args["group_by"] = group_by
    return _call_gateway("analytics__get_revenue_summary", args)

@mcp.tool(name="analytics__get_top_selling_products")
def get_top_selling_products(limit: int = 5) -> Any:
    """Get top-selling products ranked by sales count."""
    return _call_gateway("analytics__get_top_selling_products", {"limit": limit})

if __name__ == "__main__":
    mcp.run()
