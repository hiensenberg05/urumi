import httpx
import json

URL = "http://127.0.0.1/wp-json/wc/v3"
CK = "ck_98fbc18596f264871d8717904e5d61483acfb0a1"
CS = "cs_12cda47b1981cb02720b08051a8bc8f895f3b7d1"
HEADERS = {"Host": "store.local"}

def test_api():
    client = httpx.Client(timeout=10.0, headers=HEADERS)

    # 1. Query products with query param auth
    print("--> Testing GET /products ...")
    r = client.get(f"{URL}/products", params={"consumer_key": CK, "consumer_secret": CS})
    print(f"Status: {r.status_code}")
    if r.status_code == 200:
        products = r.json()
        print(f"Found {len(products)} products:")
        for p in products:
            print(f" - [{p['id']}] {p['sku']}: {p['name']} (${p['price']}) [Stock: {p.get('stock_quantity')}]")
    else:
        print(f"Error: {r.text}")

    # 2. Query orders
    print("\n--> Testing GET /orders ...")
    r_orders = client.get(f"{URL}/orders", params={"consumer_key": CK, "consumer_secret": CS})
    print(f"Status: {r_orders.status_code}")
    if r_orders.status_code == 200:
        orders = r_orders.json()
        print(f"Found {len(orders)} orders:")
        for o in orders:
            print(f" - Order #{o['id']}: Status: {o['status']}, Total: ${o['total']}, Customer: {o.get('billing', {}).get('first_name')} {o.get('billing', {}).get('last_name')}")
    else:
        print(f"Error: {r_orders.text}")

if __name__ == "__main__":
    test_api()
