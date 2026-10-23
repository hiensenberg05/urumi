"""
Advanced Multi-MCP, Analytics, Multi-Store & Inventory End-to-End Test Suite
"""
import sys
import time
import httpx
import json

sys.stdout.reconfigure(encoding='utf-8')

BASE_URL = "http://gateway.local"
ADMIN_KEY = "admin-key-urumi-2026"
SUPPORT_KEY = "support-key-urumi-2026"

ADVANCED_TESTS = [
    {
        "id": 1,
        "name": "Analytics + Inventory Co-Pilot",
        "role": "admin",
        "key": ADMIN_KEY,
        "prompt": "Which products are our top sellers, and do we have enough warehouse stock for them?",
        "expected_tools": ["analytics__get_top_selling_products"],
    },
    {
        "id": 2,
        "name": "WooCommerce + Hosted Currency FX",
        "role": "admin",
        "key": ADMIN_KEY,
        "prompt": "What is the price of the Ultra-Comfort Gaming Chair, and how much is that in EUR and GBP?",
        "expected_tools": ["woocommerce__list_products", "hosted_currency__convert_price"],
    },
    {
        "id": 3,
        "name": "Inventory + Hosted Slack Alert",
        "role": "admin",
        "key": ADMIN_KEY,
        "prompt": "Check which products are out of stock and dispatch an informational alert to Slack channel #operations summarizing the findings.",
        "expected_tools": ["inventory__list_low_stock", "hosted_notify__send_slack_alert"],
    },
    {
        "id": 4,
        "name": "Order Pipeline + Product Stock Cross-Check",
        "role": "admin",
        "key": ADMIN_KEY,
        "prompt": "Look up Order #45, see which product was purchased, and check how much stock is currently left for that product.",
        "expected_tools": ["woocommerce__get_order"],
    },
    {
        "id": 5,
        "name": "Multi-Tenant Store Catalog Comparison",
        "role": "admin",
        "key": ADMIN_KEY,
        "prompt": "Compare the stock and price of the USB-C Multi-Port Hub between the Default Store and Tech Store.",
        "expected_tools": ["woocommerce__list_products", "store_tech__list_products"],
    },
    {
        "id": 6,
        "name": "Tenant Store Order Pipeline",
        "role": "admin",
        "key": ADMIN_KEY,
        "prompt": "Show the recent orders placed in the Tech Store.",
        "expected_tools": ["store_tech__list_orders"],
    },
    {
        "id": 7,
        "name": "Unprovisioned Store Detection",
        "role": "admin",
        "key": ADMIN_KEY,
        "prompt": "Show me the catalog and daily revenue for European Electronics Store.",
        "expected_tools": [],  # Should not call fake tools
    },
    {
        "id": 8,
        "name": "Daily Gross Sales Metrics",
        "role": "admin",
        "key": ADMIN_KEY,
        "prompt": "What were our total gross sales and order counts for today?",
        "expected_tools": ["analytics__get_daily_sales"],
    },
    {
        "id": 9,
        "name": "Product-Level Revenue Grouping",
        "role": "admin",
        "key": ADMIN_KEY,
        "prompt": "Show revenue summary for the last 30 days grouped by product.",
        "expected_tools": ["analytics__get_revenue_summary"],
    },
    {
        "id": 10,
        "name": "Inventory Custom Threshold Scan",
        "role": "admin",
        "key": ADMIN_KEY,
        "prompt": "List all products with stock quantity below 20 units.",
        "expected_tools": ["inventory__list_low_stock"],
    },
    {
        "id": 11,
        "name": "Inventory Audit Stock Adjustment",
        "role": "admin",
        "key": ADMIN_KEY,
        "prompt": "Adjust stock for SKU-1002 by +10 with reason 'Supplier restock batch #48'.",
        "expected_tools": ["inventory__adjust_stock"],
    },
    {
        "id": 12,
        "name": "Customer Order Verification",
        "role": "support_rep",
        "key": SUPPORT_KEY,
        "prompt": "Check the status of Order #45 and verify the customer email.",
        "expected_tools": ["woocommerce__get_order"],
    },
    {
        "id": 13,
        "name": "Customer Order Status Update",
        "role": "support_rep",
        "key": SUPPORT_KEY,
        "prompt": "Update order #45 status to processing.",
        "expected_tools": ["woocommerce__update_order_status"],
    },
    {
        "id": 14,
        "name": "Forex Live Exchange Rates",
        "role": "admin",
        "key": ADMIN_KEY,
        "prompt": "Get live exchange rate lookup table relative to USD for EUR, GBP, JPY, and INR.",
        "expected_tools": ["hosted_currency__get_exchange_rates"],
    },
    {
        "id": 15,
        "name": "International Pricing Matrix",
        "role": "admin",
        "key": ADMIN_KEY,
        "prompt": "Format $129.99 for our 4K Ultra HD Webcam across world retail markets.",
        "expected_tools": ["hosted_currency__format_international_pricing"],
    },
    {
        "id": 16,
        "name": "System Banner Broadcast Alert",
        "role": "admin",
        "key": ADMIN_KEY,
        "prompt": "Publish a live system-wide alert banner across connected store portals: 'Scheduled warehouse inventory cycle count at 14:00 UTC'.",
        "expected_tools": ["hosted_notify__broadcast_banner"],
    },
    {
        "id": 17,
        "name": "Cross-Domain RBAC Inquiry",
        "role": "support_rep",
        "key": SUPPORT_KEY,
        "prompt": "Can I check today's financial sales metrics and adjust warehouse inventory counts?",
        "expected_tools": [],
    },
    {
        "id": 18,
        "name": "Support Rep Permitted Dual-Tool Flow",
        "role": "support_rep",
        "key": SUPPORT_KEY,
        "prompt": "Check open orders in the store and check stock for SKU-1001.",
        "expected_tools": ["woocommerce__list_orders", "inventory__check_stock"],
    },
    {
        "id": 19,
        "name": "Live Catalog Product Addition",
        "role": "admin",
        "key": ADMIN_KEY,
        "prompt": "Add a new product 'Smart Noise-Isolating Desk Microphone' for $119.00 with SKU SKU-MIC-SMART and stock 30.",
        "expected_tools": ["woocommerce__create_product"],
    },
    {
        "id": 20,
        "name": "Post-Creation Verification",
        "role": "admin",
        "key": ADMIN_KEY,
        "prompt": "Verify if the Smart Noise-Isolating Desk Microphone is now active in the catalog and check its price and stock.",
        "expected_tools": ["woocommerce__list_products"],
    },
]

def run_advanced_suite():
    client = httpx.Client(base_url=BASE_URL, timeout=120.0)
    print("=" * 85)
    print("URUMI MCP GATEWAY - ADVANCED MULTI-MCP, ANALYTICS, MULTI-STORE & INVENTORY SUITE")
    print("Testing Cross-Server Coordination, Multi-Tenant Isolation & Deep Operations")
    print("=" * 85)

    results = []
    passed = 0

    for test in ADVANCED_TESTS:
        t0 = time.time()
        print(f"\n[Test {test['id']:02d}/20] [{test['role'].upper()}] {test['name']}")
        print(f"  Prompt: \"{test['prompt']}\"")

        session_id = f"adv_sess_{test['id']}_{int(time.time())}"

        try:
            resp = client.post(
                "/api/v1/chat",
                headers={
                    "X-API-Key": test["key"],
                    "Authorization": f"Bearer {test['key']}",
                },
                json={
                    "message": test["prompt"],
                    "role_override": test["role"],
                    "session_id": session_id,
                }
            )
            duration_s = round(time.time() - t0, 1)

            if resp.status_code != 200:
                print(f"  ❌ FAILED HTTP {resp.status_code}: {resp.text[:120]}")
                results.append({**test, "passed": False, "status": f"HTTP_{resp.status_code}"})
                continue

            data = resp.json()
            content = data.get("content", "")
            steps = data.get("steps", [])
            tools_called = [s.get("tool") for s in steps]

            # Check if expected tools were called
            tools_ok = True
            for et in test["expected_tools"]:
                if et not in tools_called:
                    tools_ok = False
                    break

            # Check if content has substance
            has_substance = len(content.strip()) > 30 and "error" not in content.lower()[:30]

            is_pass = has_substance and (tools_ok or len(test["expected_tools"]) == 0)
            if is_pass:
                passed += 1
                icon = "✔ PASS"
            else:
                icon = "❌ WARN"

            print(f"  {icon} | Latency: {duration_s}s | Tools Called: {tools_called or 'None'}")
            print(f"  -> Snippet: {content.replace(chr(10), ' ')[:140]}...")

            results.append({
                "id": test["id"],
                "name": test["name"],
                "role": test["role"],
                "passed": is_pass,
                "duration_s": duration_s,
                "tools_called": tools_called,
                "response_snippet": content[:200]
            })

        except Exception as e:
            print(f"  ❌ EXCEPTION: {e}")
            results.append({**test, "passed": False, "error": str(e)})

    print("\n" + "=" * 85)
    print("ADVANCED TEST SUITE SUMMARY")
    print("=" * 85)
    print(f"Total Tests Executed : {len(ADVANCED_TESTS)}")
    print(f"Passed Successfully  : {passed}/{len(ADVANCED_TESTS)} ({round(passed / len(ADVANCED_TESTS) * 100, 1)}%)")
    print("=" * 85)

    with open("scripts/advanced_evaluation_results.json", "w") as f:
        json.dump(results, f, indent=2)
    print("Results saved to scripts/advanced_evaluation_results.json")

if __name__ == "__main__":
    run_advanced_suite()
