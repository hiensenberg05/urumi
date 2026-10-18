import httpx
import json
import sys

if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8")

BASE_URL = "http://127.0.0.1"
API_URL = f"{BASE_URL}/wp-json/wc/v3"
CK = "ck_98fbc18596f264871d8717904e5d61483acfb0a1"
CS = "cs_12cda47b1981cb02720b08051a8bc8f895f3b7d1"
HEADERS = {"Host": "store.local"}
AUTH_PARAMS = {"consumer_key": CK, "consumer_secret": CS}

def run_verification():
    print("=" * 60)
    print("🚀 STEP 1 VERIFICATION: WooCommerce Storefront & Ingress")
    print("=" * 60)

    client = httpx.Client(timeout=15.0, headers=HEADERS)

    # 1. Test Ingress storefront homepage
    print("\n[1/5] Checking storefront home page...")
    r_home = client.get(BASE_URL)
    print(f"Status: {r_home.status_code}")
    assert r_home.status_code == 200, f"Expected 200, got {r_home.status_code}"
    assert "Urumi Store" in r_home.text or "woocommerce" in r_home.text, "Store page content missing"
    print("✅ Storefront is reachable through Ingress on port 80!")

    # 2. Test Listing Products
    print("\n[2/5] Testing WooCommerce REST API: GET /products ...")
    r_products = client.get(f"{API_URL}/products", params=AUTH_PARAMS)
    print(f"Status: {r_products.status_code}")
    assert r_products.status_code == 200, f"Failed to list products: {r_products.text}"
    products = r_products.json()
    print(f"Found {len(products)} seeded products:")
    for p in products:
        print(f"   • [{p['id']}] {p['sku']}: {p['name']} - ${p['price']} (Stock: {p.get('stock_quantity')})")
    assert len(products) >= 5, "Expected at least 5 seeded products"
    print("✅ WooCommerce Products API verified!")

    # 3. Test Listing Orders
    print("\n[3/5] Testing WooCommerce REST API: GET /orders ...")
    r_orders = client.get(f"{API_URL}/orders", params=AUTH_PARAMS)
    print(f"Status: {r_orders.status_code}")
    assert r_orders.status_code == 200, f"Failed to list orders: {r_orders.text}"
    orders = r_orders.json()
    print(f"Found {len(orders)} seeded orders:")
    for o in orders:
        billing = o.get("billing", {})
        print(f"   • Order #{o['id']}: Status: {o['status']} | Total: ${o['total']} | Customer: {billing.get('first_name')} {billing.get('last_name')}")
    assert len(orders) >= 3, "Expected at least 3 seeded orders"
    print("✅ WooCommerce Orders API verified!")

    # 4. Test Creating a New Product via REST API
    print("\n[4/5] Testing Product Creation via REST API: POST /products ...")
    new_product_payload = {
        "name": "Live Test Product",
        "type": "simple",
        "regular_price": "29.99",
        "description": "Created dynamically during Step 1 verification test.",
        "sku": f"TEST-SKU-{len(products) + 1}",
        "manage_stock": True,
        "stock_quantity": 25
    }
    r_create_prod = client.post(f"{API_URL}/products", params=AUTH_PARAMS, json=new_product_payload)
    print(f"Status: {r_create_prod.status_code}")
    assert r_create_prod.status_code == 201, f"Failed to create product: {r_create_prod.text}"
    created_prod = r_create_prod.json()
    print(f"✅ Successfully created product: ID={created_prod['id']}, SKU={created_prod['sku']}")

    # 5. Test Creating a New Order via REST API
    print("\n[5/5] Testing Order Placement via REST API: POST /orders ...")
    new_order_payload = {
        "payment_method": "cod",
        "payment_method_title": "Cash on Delivery",
        "set_paid": False,
        "billing": {
            "first_name": "Test",
            "last_name": "Buyer",
            "email": "buyer@urumi.local",
            "address_1": "123 Kubernetes Way",
            "city": "Bengaluru",
            "state": "KA",
            "postcode": "560001",
            "country": "IN"
        },
        "line_items": [
            {
                "product_id": created_prod['id'],
                "quantity": 2
            }
        ]
    }
    r_create_order = client.post(f"{API_URL}/orders", params=AUTH_PARAMS, json=new_order_payload)
    print(f"Status: {r_create_order.status_code}")
    assert r_create_order.status_code == 201, f"Failed to place order: {r_create_order.text}"
    created_order = r_create_order.json()
    print(f"✅ Successfully placed order #{created_order['id']} with status '{created_order['status']}', total ${created_order['total']}!")

    print("\n" + "=" * 60)
    print("🎉 ALL STEP 1 STOREFRONT VERIFICATIONS PASSED SUCCESSFULLY!")
    print("=" * 60)

if __name__ == "__main__":
    run_verification()
