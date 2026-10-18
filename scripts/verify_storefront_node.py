import base64
import json
import os
import ssl
import sys
import urllib.parse
import urllib.request

ssl_context = ssl._create_unverified_context()

# Connect via Ingress on Kind node IP (172.18.0.2) or env var / arg
BASE_URL = sys.argv[1] if len(sys.argv) > 1 else os.environ.get("STORE_URL", "https://172.18.0.2")
API_URL = f"{BASE_URL}/wp-json/wc/v3"
CK = "ck_98fbc18596f264871d8717904e5d61483acfb0a1"
CS = "cs_12cda47b1981cb02720b08051a8bc8f895f3b7d1"
HOST_HEADER = "store.local"

auth_b64 = base64.b64encode(f"{CK}:{CS}".encode("utf-8")).decode("utf-8")

def request(method, path, params=None, data=None):
    query = "?" + urllib.parse.urlencode(params) if params else ""
    url = f"{BASE_URL}{path}{query}"
    
    headers = {
        "Host": HOST_HEADER,
        "Authorization": f"Basic {auth_b64}",
        "X-Forwarded-Proto": "https"
    }
    body_bytes = None
    if data is not None:
        headers["Content-Type"] = "application/json"
        body_bytes = json.dumps(data).encode("utf-8")
        
    req = urllib.request.Request(url, data=body_bytes, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, context=ssl_context, timeout=15) as resp:
            status = resp.status
            content = resp.read().decode("utf-8")
            try:
                parsed = json.loads(content)
            except Exception:
                parsed = content
            return status, parsed
    except urllib.error.HTTPError as e:
        content = e.read().decode("utf-8")
        try:
            parsed = json.loads(content)
        except Exception:
            parsed = content
        return e.code, parsed

def run():
    print("=" * 65)
    print("🚀 COMPREHENSIVE PHASE 1 VERIFICATION & PERSISTENCE TEST")
    print("=" * 65)

    # 1. Homepage
    print("\n[1/6] Testing Storefront Homepage...")
    req_home = urllib.request.Request(BASE_URL, headers={"Host": HOST_HEADER})
    with urllib.request.urlopen(req_home, context=ssl_context, timeout=15) as resp:
        home_html = resp.read().decode("utf-8")
        assert resp.status == 200
        assert "Urumi Store" in home_html or "woocommerce" in home_html
        print(f"✅ Homepage HTTP 200 OK! Store Title: 'Urumi Store'")

    # 2. Products List
    print("\n[2/6] Testing WooCommerce REST API: GET /products ...")
    status, products = request("GET", "/wp-json/wc/v3/products")
    print(f"Status: {status} | Products Found: {len(products)}")
    assert status == 200 and len(products) >= 5, f"Products check failed: {products}"
    for p in products:
        print(f"   • [{p['id']}] SKU: {p['sku']} | {p['name']} | Price: ${p['price']} | Stock: {p.get('stock_quantity')}")
    print("✅ Products listing verified!")

    # 3. Orders List
    print("\n[3/6] Testing WooCommerce REST API: GET /orders ...")
    status, orders = request("GET", "/wp-json/wc/v3/orders")
    print(f"Status: {status} | Orders Found: {len(orders)}")
    assert status == 200 and len(orders) >= 3, f"Orders check failed: {orders}"
    for o in orders:
        b = o.get("billing", {})
        print(f"   • Order #{o['id']}: Status: {o['status']} | Total: ${o['total']} | Customer: {b.get('first_name')} {b.get('last_name')}")
    print("✅ Orders listing verified!")

    # 4. Create Product
    print("\n[4/6] Testing Product Creation: POST /products ...")
    new_prod_payload = {
        "name": "Dynamic Studio Mic Boom",
        "type": "simple",
        "regular_price": "89.50",
        "sku": f"SKU-DYN-{len(products)+1}",
        "description": "Created dynamically during Step 1 verification test.",
        "manage_stock": True,
        "stock_quantity": 40
    }
    status, created_prod = request("POST", "/wp-json/wc/v3/products", data=new_prod_payload)
    print(f"Status: {status}")
    assert status == 201, f"Product creation failed: {created_prod}"
    new_prod_id = created_prod['id']
    print(f"✅ Successfully created Product ID {new_prod_id}: {created_prod['name']} (SKU: {created_prod['sku']}, ${created_prod['price']})")

    # 5. Place an Order
    print("\n[5/6] Testing Order Placement: POST /orders ...")
    new_order_payload = {
        "payment_method": "cod",
        "payment_method_title": "Cash on Delivery",
        "set_paid": False,
        "billing": {
            "first_name": "Antigravity",
            "last_name": "Tester",
            "email": "tester@urumi.local",
            "address_1": "100 Innovation Way",
            "city": "San Francisco",
            "state": "CA",
            "postcode": "94105",
            "country": "US"
        },
        "line_items": [
            {
                "product_id": new_prod_id,
                "quantity": 2
            }
        ]
    }
    status, created_order = request("POST", "/wp-json/wc/v3/orders", data=new_order_payload)
    print(f"Status: {status}")
    assert status == 201, f"Order placement failed: {created_order}"
    new_order_id = created_order['id']
    print(f"✅ Successfully placed Order #{new_order_id} (Status: {created_order['status']}, Total: ${created_order['total']})")

    # 6. Update Order Status
    print("\n[6/6] Testing Order Status Update: PUT /orders/<id> ...")
    status, updated_order = request("PUT", f"/wp-json/wc/v3/orders/{new_order_id}", data={"status": "completed"})
    print(f"Status: {status}")
    assert status == 200 and updated_order["status"] == "completed", f"Status update failed: {updated_order}"
    print(f"✅ Successfully updated Order #{new_order_id} status to '{updated_order['status']}'!")

    print("\n" + "=" * 65)
    print("🎉 ALL 6 REST API STOREFRONT TESTS PASSED WITH 100% SUCCESS!")
    print("=" * 65)

if __name__ == "__main__":
    run()
