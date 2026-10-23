"""
Verify WooCommerce product and order creation through Gateway MCP tool execution.
"""
import httpx
import json
import time

BASE_URL = "http://gateway.local"
ADMIN_KEY = "admin-key-urumi-2026"

def verify_store_creation():
    client = httpx.Client(base_url=BASE_URL, timeout=30.0)

    # 1. Create a new product
    test_sku = f"SKU-DEMO-{int(time.time())}"
    print(f"\n[1] Creating new product with SKU {test_sku}...")
    r = client.post(
        "/api/v1/tools/call",
        headers={"X-API-Key": ADMIN_KEY},
        json={
            "tool": "woocommerce__create_product",
            "arguments": {
                "name": "Wireless Noise-Canceling Earbuds Pro",
                "regular_price": "189.99",
                "sku": test_sku,
                "stock_quantity": 40,
                "manage_stock": True,
                "description": "Premium sound with active noise cancelation."
            }
        }
    )
    assert r.status_code == 200, f"Product creation failed: {r.status_code} {r.text}"
    prod_data = r.json()["result"]
    new_product_id = prod_data["id"]
    print(f"  [SUCCESS] Product Created in Storefront!")
    print(f"  -> Product ID   : {new_product_id}")
    print(f"  -> Name         : {prod_data['name']}")
    print(f"  -> Price        : ${prod_data['price']}")
    print(f"  -> Stock Status : {prod_data['stock_status']} ({prod_data['stock_quantity']} units)")

    # 2. Create a customer order for this new product
    print(f"\n[2] Placing a customer purchase order for Product ID {new_product_id}...")
    r_order = client.post(
        "/api/v1/tools/call",
        headers={"X-API-Key": ADMIN_KEY},
        json={
            "tool": "woocommerce__create_order",
            "arguments": {
                "product_id": new_product_id,
                "quantity": 2,
                "customer_name": "Antigravity Evaluator",
                "customer_email": "evaluator@urumi.enterprise",
                "status": "processing"
            }
        }
    )
    assert r_order.status_code == 200, f"Order creation failed: {r_order.status_code} {r_order.text}"
    order_data = r_order.json()["result"]
    order_id = order_data["id"]
    print(f"  [SUCCESS] Order Created in Storefront!")
    print(f"  -> Order ID     : {order_id}")
    print(f"  -> Status       : {order_data.get('status')}")
    print(f"  -> Total Charged: ${order_data.get('total')}")
    print(f"  -> Items Bought : {order_data.get('line_items')}")

    # 3. Retrieve order directly to confirm persistence
    print(f"\n[3] Verifying order persistence in WooCommerce...")
    r_verify = client.post(
        "/api/v1/tools/call",
        headers={"X-API-Key": ADMIN_KEY},
        json={
            "tool": "woocommerce__get_order",
            "arguments": {"order_id": order_id}
        }
    )
    assert r_verify.status_code == 200
    retrieved = r_verify.json()["result"]
    print(f"  [VERIFIED] Order #{retrieved['id']} is permanently stored in WooCommerce MariaDB database.")
    print(f"  -> Customer Name: {retrieved['customer']['first_name']} {retrieved['customer']['last_name']}")
    print(f"  -> Customer Email: {retrieved['customer']['email']}")

if __name__ == "__main__":
    verify_store_creation()
