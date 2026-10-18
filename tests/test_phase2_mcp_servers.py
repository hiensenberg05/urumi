import os
import sys
import importlib.util
import pytest

# Configure environment for live WooCommerce backend in Kind
os.environ["WC_URL"] = "https://172.18.0.2"
os.environ["WC_CONSUMER_KEY"] = "ck_98fbc18596f264871d8717904e5d61483acfb0a1"
os.environ["WC_CONSUMER_SECRET"] = "cs_12cda47b1981cb02720b08051a8bc8f895f3b7d1"
os.environ["WC_VERIFY_SSL"] = "false"
os.environ["WC_HOST_HEADER"] = "store.local"

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

from fastmcp import Client
from starlette.testclient import TestClient

def load_server(service_name: str):
    svc_dir = os.path.join(BASE_DIR, "services", service_name)
    if svc_dir not in sys.path:
        sys.path.insert(0, svc_dir)
    server_path = os.path.join(svc_dir, "server.py")
    module_name = service_name.replace("-", "_") + "_server"
    spec = importlib.util.spec_from_file_location(module_name, server_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module

wc_srv = load_server("woocommerce-mcp")
inv_srv = load_server("inventory-mcp")
ana_srv = load_server("analytics-mcp")

# ---------------------------------------------------------
# Test 1: WooCommerce MCP Server
# ---------------------------------------------------------
@pytest.mark.asyncio
async def test_woocommerce_mcp_health():
    test_client = TestClient(wc_srv.app)
    resp = test_client.get("/health")
    assert resp.status_code == 200
    data = resp.json()
    assert data["status"] == "healthy"
    assert data["service"] == "woocommerce-mcp"
    print("\n[WooCommerce MCP] /health endpoint OK")

@pytest.mark.asyncio
async def test_woocommerce_mcp_tools():
    async with Client(wc_srv.mcp) as client:
        # 1. List tools
        tools = await client.list_tools()
        tool_names = [t.name for t in tools]
        assert "woocommerce__list_products" in tool_names
        assert "woocommerce__create_product" in tool_names
        assert "woocommerce__list_orders" in tool_names
        assert "woocommerce__get_order" in tool_names
        assert "woocommerce__update_order_status" in tool_names
        print(f"\n[WooCommerce MCP] Verified {len(tool_names)} registered tools: {tool_names}")

        # 2. Call list_products
        prod_res = await client.call_tool("woocommerce__list_products", {"per_page": 5})
        products = prod_res.data
        assert isinstance(products, list) and len(products) >= 5
        print(f"[WooCommerce MCP] list_products returned {len(products)} products. First: {products[0]['name']}")

        # 3. Call create_product
        create_res = await client.call_tool(
            "woocommerce__create_product",
            {
                "name": "Phase 2 Automated Test Mic",
                "regular_price": "75.00",
                "sku": f"SKU-TEST-P2-{len(products)+1}",
                "stock_quantity": 25,
                "manage_stock": True,
                "description": "Created via FastMCP client during automated test suite.",
            }
        )
        created_item = create_res.data
        assert created_item["sku"].startswith("SKU-TEST-P2-")
        created_id = created_item["id"]
        print(f"[WooCommerce MCP] create_product success: ID {created_id}, SKU {created_item['sku']}")

        # 4. Call list_orders
        orders_res = await client.call_tool("woocommerce__list_orders", {"per_page": 5})
        orders = orders_res.data
        assert isinstance(orders, list) and len(orders) >= 3
        print(f"[WooCommerce MCP] list_orders returned {len(orders)} orders")

        # 5. Call get_order
        first_order_id = orders[0]["id"]
        get_res = await client.call_tool("woocommerce__get_order", {"order_id": first_order_id})
        order_details = get_res.data
        assert order_details["id"] == first_order_id
        print(f"[WooCommerce MCP] get_order #{first_order_id} total: ${order_details['total']}")

# ---------------------------------------------------------
# Test 2: Inventory MCP Server
# ---------------------------------------------------------
@pytest.mark.asyncio
async def test_inventory_mcp_health():
    test_client = TestClient(inv_srv.app)
    resp = test_client.get("/health")
    assert resp.status_code == 200
    data = resp.json()
    assert data["status"] == "healthy"
    assert data["service"] == "inventory-mcp"
    print("\n[Inventory MCP] /health endpoint OK")

@pytest.mark.asyncio
async def test_inventory_mcp_tools():
    async with Client(inv_srv.mcp) as client:
        # 1. List tools
        tools = await client.list_tools()
        tool_names = [t.name for t in tools]
        assert "inventory__check_stock" in tool_names
        assert "inventory__list_low_stock" in tool_names
        assert "inventory__update_stock" in tool_names
        print(f"\n[Inventory MCP] Verified {len(tool_names)} registered tools: {tool_names}")

        # 2. Check stock of SKU-1001
        stock_res = await client.call_tool("inventory__check_stock", {"sku": "SKU-1001"})
        stock_data = stock_res.data
        assert stock_data["found"] is True
        assert stock_data["sku"] == "SKU-1001"
        print(f"[Inventory MCP] check_stock SKU-1001: {stock_data['name']} stock={stock_data['stock_quantity']}")

        # 3. List low stock products
        low_res = await client.call_tool("inventory__list_low_stock", {"threshold": 15})
        low_items = low_res.data
        assert isinstance(low_items, list) and len(low_items) >= 1
        print(f"[Inventory MCP] list_low_stock (<= 15) found {len(low_items)} items")
        for item in low_items:
            print(f"   • {item['sku']} - {item['name']}: {item['stock_quantity']} units")

        # 4. Update stock of SKU-1004
        update_res = await client.call_tool("inventory__update_stock", {"sku": "SKU-1004", "quantity": 95})
        update_data = update_res.data
        assert update_data["status"] == "success"
        assert update_data["stock_quantity"] == 95
        print(f"[Inventory MCP] update_stock SKU-1004 successfully updated to 95 units")

# ---------------------------------------------------------
# Test 3: Analytics MCP Server
# ---------------------------------------------------------
@pytest.mark.asyncio
async def test_analytics_mcp_health():
    test_client = TestClient(ana_srv.app)
    resp = test_client.get("/health")
    assert resp.status_code == 200
    data = resp.json()
    assert data["status"] == "healthy"
    assert data["service"] == "analytics-mcp"
    print("\n[Analytics MCP] /health endpoint OK")

@pytest.mark.asyncio
async def test_analytics_mcp_tools():
    async with Client(ana_srv.mcp) as client:
        # 1. List tools
        tools = await client.list_tools()
        tool_names = [t.name for t in tools]
        assert "analytics__get_daily_sales" in tool_names
        assert "analytics__get_revenue_summary" in tool_names
        assert "analytics__get_top_selling_products" in tool_names
        print(f"\n[Analytics MCP] Verified {len(tool_names)} registered tools: {tool_names}")

        # 2. Get daily sales
        daily_res = await client.call_tool("analytics__get_daily_sales", {})
        daily_data = daily_res.data
        assert "gross_sales" in daily_data
        assert "orders_count" in daily_data
        print(f"[Analytics MCP] get_daily_sales: Gross Sales=${daily_data['gross_sales']}, Orders={daily_data['orders_count']}")

        # 3. Get revenue summary
        rev_res = await client.call_tool("analytics__get_revenue_summary", {"period": "30d"})
        rev_data = rev_res.data
        assert "total_revenue" in rev_data
        assert "average_order_value" in rev_data
        print(f"[Analytics MCP] get_revenue_summary: Total Revenue=${rev_data['total_revenue']}, AOV=${rev_data['average_order_value']}")

        # 4. Get top selling products
        top_res = await client.call_tool("analytics__get_top_selling_products", {"limit": 3})
        top_items = top_res.data
        assert isinstance(top_items, list)
        print(f"[Analytics MCP] get_top_selling_products returned {len(top_items)} products")
        for item in top_items:
            print(f"   • {item['name']}: {item['total_units_sold']} units sold (${item['total_revenue']})")
