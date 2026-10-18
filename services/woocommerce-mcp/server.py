from typing import Any, Dict, List, Optional
from fastmcp import FastMCP
from starlette.responses import JSONResponse
from starlette.requests import Request
import uvicorn

from wc_config import settings
from wc_client import WooCommerceClient

mcp = FastMCP("woocommerce-mcp")
wc_client = WooCommerceClient()

@mcp.custom_route("/health", methods=["GET"])
async def health(request: Request) -> JSONResponse:
    return JSONResponse({
        "status": "healthy",
        "service": "woocommerce-mcp",
        "wc_url": settings.wc_url,
    })

@mcp.tool(name="woocommerce__list_products")
async def list_products(
    per_page: int = 10,
    page: int = 1,
    category: Optional[str] = None,
    status: str = "publish",
) -> List[Dict[str, Any]]:
    """List products from WooCommerce store with pagination and category filtering.
    
    Args:
        per_page: Number of products to return per page (default: 10)
        page: Page number to retrieve (default: 1)
        category: Category ID or slug to filter by (optional)
        status: Product status filter (default: 'publish')
    """
    products = await wc_client.list_products(per_page=per_page, page=page, category=category, status=status)
    return [
        {
            "id": p.get("id"),
            "name": p.get("name"),
            "sku": p.get("sku"),
            "price": p.get("price"),
            "regular_price": p.get("regular_price"),
            "manage_stock": p.get("manage_stock"),
            "stock_quantity": p.get("stock_quantity"),
            "stock_status": p.get("stock_status"),
            "status": p.get("status"),
        }
        for p in products
    ]

@mcp.tool(name="woocommerce__create_product")
async def create_product(
    name: str,
    regular_price: str,
    sku: str,
    stock_quantity: int = 0,
    manage_stock: bool = True,
    description: str = "",
) -> Dict[str, Any]:
    """Create a new product in the WooCommerce catalog.
    
    Args:
        name: Name of the product
        regular_price: Product regular price (e.g. '89.50')
        sku: Unique SKU identifier
        stock_quantity: Initial inventory count (default: 0)
        manage_stock: Whether stock management is enabled (default: True)
        description: Product description text
    """
    res = await wc_client.create_product(
        name=name,
        regular_price=regular_price,
        sku=sku,
        stock_quantity=stock_quantity,
        manage_stock=manage_stock,
        description=description,
    )
    return {
        "id": res.get("id"),
        "name": res.get("name"),
        "sku": res.get("sku"),
        "price": res.get("price"),
        "stock_quantity": res.get("stock_quantity"),
        "stock_status": res.get("stock_status"),
        "status": res.get("status"),
    }

@mcp.tool(name="woocommerce__list_orders")
async def list_orders(
    status: Optional[str] = None,
    per_page: int = 10,
    page: int = 1,
) -> List[Dict[str, Any]]:
    """List customer orders from WooCommerce store.
    
    Args:
        status: Filter by order status: 'pending', 'processing', 'completed', 'cancelled', etc.
        per_page: Number of orders per page (default: 10)
        page: Page number to retrieve (default: 1)
    """
    orders = await wc_client.list_orders(status=status, per_page=per_page, page=page)
    return [
        {
            "id": o.get("id"),
            "status": o.get("status"),
            "currency": o.get("currency"),
            "total": o.get("total"),
            "date_created": o.get("date_created"),
            "customer_name": f"{o.get('billing', {}).get('first_name', '')} {o.get('billing', {}).get('last_name', '')}".strip(),
            "customer_email": o.get("billing", {}).get("email"),
            "item_count": sum(item.get("quantity", 0) for item in o.get("line_items", [])),
            "line_items": [
                {
                    "product_id": item.get("product_id"),
                    "name": item.get("name"),
                    "quantity": item.get("quantity"),
                    "subtotal": item.get("subtotal"),
                    "total": item.get("total"),
                }
                for item in o.get("line_items", [])
            ],
        }
        for o in orders
    ]

@mcp.tool(name="woocommerce__get_order")
async def get_order(order_id: int) -> Dict[str, Any]:
    """Retrieve full details of a specific order by its order ID.
    
    Args:
        order_id: Numeric ID of the order to retrieve
    """
    o = await wc_client.get_order(order_id)
    return {
        "id": o.get("id"),
        "status": o.get("status"),
        "currency": o.get("currency"),
        "total": o.get("total"),
        "date_created": o.get("date_created"),
        "payment_method": o.get("payment_method"),
        "customer": {
            "first_name": o.get("billing", {}).get("first_name"),
            "last_name": o.get("billing", {}).get("last_name"),
            "email": o.get("billing", {}).get("email"),
            "phone": o.get("billing", {}).get("phone"),
            "city": o.get("billing", {}).get("city"),
            "country": o.get("billing", {}).get("country"),
        },
        "line_items": [
            {
                "product_id": item.get("product_id"),
                "name": item.get("name"),
                "quantity": item.get("quantity"),
                "subtotal": item.get("subtotal"),
                "total": item.get("total"),
            }
            for item in o.get("line_items", [])
        ],
    }

@mcp.tool(name="woocommerce__update_order_status")
async def update_order_status(order_id: int, status: str) -> Dict[str, Any]:
    """Update an order status in WooCommerce.
    
    Args:
        order_id: Numeric ID of the order
        status: New status ('completed', 'processing', 'cancelled', 'refunded', 'on-hold')
    """
    res = await wc_client.update_order_status(order_id, status)
    return {
        "id": res.get("id"),
        "status": res.get("status"),
        "total": res.get("total"),
        "date_modified": res.get("date_modified"),
    }

@mcp.tool(name="woocommerce__create_order")
async def create_order(
    product_id: int,
    quantity: int = 1,
    customer_name: str = "Test Shopper",
    customer_email: str = "shopper@example.com",
    status: str = "processing",
) -> Dict[str, Any]:
    """Create a new customer purchase order in WooCommerce with Cash on Delivery (COD) dummy payment.
    
    Args:
        product_id: WooCommerce product ID to purchase
        quantity: Number of units to buy (default: 1)
        customer_name: Customer billing full name (e.g. 'Sarah Chen')
        customer_email: Customer billing email address
        status: Initial order status: 'processing', 'pending', or 'completed'
    """
    res = await wc_client.create_order(
        line_items=[{"product_id": product_id, "quantity": quantity}],
        customer_name=customer_name,
        customer_email=customer_email,
        status=status,
    )
    return {
        "id": res.get("id"),
        "status": res.get("status"),
        "currency": res.get("currency"),
        "total": res.get("total"),
        "payment_method": res.get("payment_method"),
        "date_created": res.get("date_created"),
        "customer_name": f"{res.get('billing', {}).get('first_name', '')} {res.get('billing', {}).get('last_name', '')}".strip(),
        "line_items_count": len(res.get("line_items", [])),
    }

app = mcp.http_app()

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=settings.service_port)
