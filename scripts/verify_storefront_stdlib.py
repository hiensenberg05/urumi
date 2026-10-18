#!/usr/bin/env python3
import json
import sys
import urllib.parse
import urllib.request
import ssl

if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8")

import base64

BASE_URL = "http://172.18.0.2"
API_URL = f"{BASE_URL}/wp-json/wc/v3"
CK = "ck_98fbc18596f264871d8717904e5d61483acfb0a1"
CS = "cs_12cda47b1981cb02720b08051a8bc8f895f3b7d1"
HOST_HEADER = "store.local"

def request(method, path, params=None, data=None):
    query = ""
    if params:
        query = "?" + urllib.parse.urlencode(params)
    url = f"{BASE_URL}{path}{query}"
    
    basic_token = base64.b64encode(f"{CK}:{CS}".encode("utf-8")).decode("utf-8")
    headers = {
        "Host": HOST_HEADER,
        "X-Forwarded-Proto": "https",
        "Authorization": f"Basic {basic_token}"
    }
    body_bytes = None
    if data is not None:
        headers["Content-Type"] = "application/json"
        body_bytes = json.dumps(data).encode("utf-8")
        
    req = urllib.request.Request(url, data=body_bytes, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
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
    print("=" * 60)
    print("STEP 1 VERIFICATION: WooCommerce Storefront & Ingress")
    print("=" * 60)

    # 1. Homepage
    print("\n[1/5] Checking storefront homepage (HTTP 200 via Ingress)...")
    status, body = request("GET", "/")
    print(f"Status: {status}")
    assert status == 200, f"Expected 200, got {status}"
    assert "Urumi Store" in body or "woocommerce" in body, "Expected store title in HTML"
    print("PASSED: Storefront homepage is serving via Ingress on port 80!")

    # 2. Products
    print("\n[2/5] Testing WooCommerce REST API: GET /wp-json/wc/v3/products ...")
    auth_params = {"consumer_key": CK, "consumer_secret": CS}
    status, products = request("GET", "/wp-json/wc/v3/products", params=auth_params)
    print(f"Status: {status}")
    assert status == 200, f"Failed: {products}"
    print(f"Found {len(products)} products in store:")
    for p in products:
        print(f"   * [{p['id']}] SKU: {p['sku']} | {p['name']} | Price: ${p['price']} | Stock: {p.get('stock_quantity')}")
    assert len(products) >= 5, "Expected at least 5 products"
    print("PASSED: Products API is fully functional!")

    # 3. Orders
    print("\n[3/5] Testing WooCommerce REST API: GET /wp-json/wc/v3/orders ...")
    status, orders = request("GET", "/wp-json/wc/v3/orders", params=auth_params)
    print(f"Status: {status}")
    assert status == 200, f"Failed: {orders}"
    print(f"Found {len(orders)} orders in store:")
    for o in orders:
        b = o.get("billing", {})
        print(f"   * Order #{o['id']}: Status: {o['status']} | Total: ${o['total']} | Customer: {b.get('first_name')} {b.get('last_name')}")
    assert len(orders) >= 3, "Expected at least 3 orders"
    print("PASSED: Orders API is fully functional!")

    # 4. Create Product
    print("\n[4/5] Testing Product Creation via REST API: POST /products ...")
    new_prod_payload = {
        "name": "Noise-Cancelling Studio Boom Mic",
        "type": "simple",
        "regular_price": "79.99",
        "sku": f"SKU-TEST-{len(products)+1}",
        "description": "Created dynamically via WooCommerce REST API verification test.",
        "manage_stock": True,
        "stock_quantity": 30
    }
    status, created_prod = request("POST", "/wp-json/wc/v3/products", params=auth_params, data=new_prod_payload)
    print(f"Status: {status}")
    assert status == 201, f"Failed: {created_prod}"
    print(f"PASSED: Created product ID {created_prod['id']} (SKU: {created_prod['sku']}, Price: ${created_prod['price']})!")

    # 5. Create Order
    print("\n[5/5] Testing Order Placement via REST API: POST /orders ...")
    new_order_payload = {
        "payment_method": "cod",
        "payment_method_title": "Cash on Delivery",
        "set_paid": False,
        "billing": {
            "first_name": "Dev",
            "last_name": "Engineer",
            "email": "dev@urumi.local",
            "address_1": "Tech Park 4B",
            "city": "Bengaluru",
            "state": "KA",
            "postcode": "560001",
            "country": "IN"
        },
        "line_items": [
            {
                "product_id": created_prod["id"],
                "quantity": 1
            }
        ]
    }
    status, created_order = request("POST", "/wp-json/wc/v3/orders", params=auth_params, data=new_order_payload)
    print(f"Status: {status}")
    assert status == 201, f"Failed: {created_order}"
    print(f"PASSED: Placed order #{created_order['id']} (Status: {created_order['status']}, Total: ${created_order['total']})!")

    print("\n" + "=" * 60)
    print("ALL 5/5 STEP 1 STOREFRONT VERIFICATIONS PASSED!")
    print("=" * 60)

if __name__ == "__main__":
    run()
