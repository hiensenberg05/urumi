import httpx
import json

BASE = "http://127.0.0.1"
INV_HEADERS = {
    "Host": "gateway.local",
    "X-API-Key": "inv-key-urumi-2026",
    "Content-Type": "application/json",
}
ADMIN_HEADERS = {
    "Host": "gateway.local",
    "X-API-Key": "admin-key-urumi-2026",
    "Content-Type": "application/json",
}

def call(tool, args, headers=INV_HEADERS):
    r = httpx.post(
        f"{BASE}/api/v1/tools/call",
        headers=headers,
        json={"tool": tool, "arguments": args},
        timeout=20,
    )
    return r.status_code, r.json()

print("=" * 60)
print("1. Testing inventory__adjust_stock (+5, 'shipment received')")
status, res = call("inventory__adjust_stock", {"sku": "SKU-1001", "delta": 5, "reason": "shipment received"})
print(f"Status: {status}\nResult: {json.dumps(res, indent=2)}")

print("\n" + "=" * 60)
print("2. Testing inventory__adjust_stock (Negative stock protection)")
status, res = call("inventory__adjust_stock", {"sku": "SKU-1001", "delta": -500, "reason": "damaged items"})
print(f"Status: {status}\nResult: {json.dumps(res, indent=2)}")

print("\n" + "=" * 60)
print("3. Testing inventory__update_stock with optimistic lock & reason")
# First check current stock
_, check = call("inventory__check_stock", {"sku": "SKU-1001"})
current_qty = check.get("result", {}).get("stock_quantity", 47)
print(f"Current stock: {current_qty}")

# Test matching expected_previous_quantity (should succeed)
status, res = call("inventory__update_stock", {
    "sku": "SKU-1001",
    "quantity": current_qty,
    "expected_previous_quantity": current_qty,
    "reason": "quarterly reconciliation"
})
print(f"Match expected previous qty -> Status: {status}\nResult: {json.dumps(res, indent=2)}")

# Test mismatch expected_previous_quantity (should be rejected)
status, res = call("inventory__update_stock", {
    "sku": "SKU-1001",
    "quantity": current_qty + 10,
    "expected_previous_quantity": current_qty + 999,  # Wrong expectation
    "reason": "concurrent edit"
})
print(f"Mismatch expected previous qty -> Status: {status}\nResult: {json.dumps(res, indent=2)}")

print("\n" + "=" * 60)
print("4. Testing inventory__batch_check_stock")
status, res = call("inventory__batch_check_stock", {"skus": ["SKU-1001", "SKU-1002", "SKU-1004", "INVALID-SKU-999"]})
print(f"Status: {status}\nResult: {json.dumps(res, indent=2)}")

print("\n" + "=" * 60)
print("5. Testing woocommerce__list_orders with SKU filter & pagination totals")
status, res = call("woocommerce__list_orders", {"sku": "SKU-1001", "per_page": 3, "page": 1})
print(f"Status: {status}\nResult: {json.dumps(res, indent=2)}")

print("\n" + "=" * 60)
print("6. Testing woocommerce__list_orders with date range filter")
status, res = call("woocommerce__list_orders", {"start_date": "2026-10-18", "end_date": "2026-10-19", "per_page": 3})
print(f"Status: {status}\nResult: {json.dumps(res, indent=2)}")

print("\n" + "=" * 60)
print("7. Testing analytics__get_daily_sales with date filter (as admin)")
status, res = call("analytics__get_daily_sales", {"date": "2026-10-19"}, headers=ADMIN_HEADERS)
print(f"Status: {status}\nResult: {json.dumps(res, indent=2)}")

print("\n" + "=" * 60)
print("8. Testing analytics__get_revenue_summary with group_by='product' (as admin)")
status, res = call("analytics__get_revenue_summary", {"period": "30d", "group_by": "product"}, headers=ADMIN_HEADERS)
print(f"Status: {status}\nResult: {json.dumps(res, indent=2)}")

print("\n" + "=" * 60)
print("9. Testing RBAC security: inventory_manager attempting analytics__get_revenue_summary (Denied)")
status, res = call("analytics__get_revenue_summary", {"period": "30d"}, headers=INV_HEADERS)
print(f"Status: {status}\nResult: {json.dumps(res, indent=2)}")
