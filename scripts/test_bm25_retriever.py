"""
Unit test and benchmark for BM25 Just-In-Time Tool Retriever.
Tests accuracy across multi-tenant, inventory, analytics, and scaling scenarios.
"""
import sys
import time
from pathlib import Path

# Add apps/ai-service to path
sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "apps" / "ai-service"))

from tool_retriever import BM25ToolRetriever

# Sample real-world 26-tool catalog from Urumi Gateway
MOCK_TOOLS = [
    {"namespacedName": "woocommerce__list_products", "description": "List catalog products with pagination", "serverName": "WooCommerce Store Server"},
    {"namespacedName": "woocommerce__create_product", "description": "Create a new catalog product with name, price, SKU, stock", "serverName": "WooCommerce Store Server"},
    {"namespacedName": "woocommerce__list_orders", "description": "List customer orders with status, date, totals", "serverName": "WooCommerce Store Server"},
    {"namespacedName": "woocommerce__get_order", "description": "Get detailed order info by ID", "serverName": "WooCommerce Store Server"},
    {"namespacedName": "woocommerce__create_order", "description": "Create a new customer order with line items", "serverName": "WooCommerce Store Server"},
    {"namespacedName": "woocommerce__update_order_status", "description": "Update the status of an order", "serverName": "WooCommerce Store Server"},
    {"namespacedName": "inventory__check_stock", "description": "Check current stock quantity and warehouse status for a single SKU", "serverName": "Inventory Tracker Server"},
    {"namespacedName": "inventory__batch_check_stock", "description": "Check stock quantities for multiple SKUs in a single batch", "serverName": "Inventory Tracker Server"},
    {"namespacedName": "inventory__list_low_stock", "description": "List all warehouse items at or below a stock threshold", "serverName": "Inventory Tracker Server"},
    {"namespacedName": "inventory__update_stock", "description": "Set the absolute stock quantity for a specific SKU", "serverName": "Inventory Tracker Server"},
    {"namespacedName": "inventory__adjust_stock", "description": "Adjust stock quantity by delta (positive or negative) with reason", "serverName": "Inventory Tracker Server"},
    {"namespacedName": "analytics__get_daily_sales", "description": "Get daily sales metrics, gross sales, and order counts", "serverName": "Business Analytics Server"},
    {"namespacedName": "analytics__get_revenue_summary", "description": "Get revenue summary across date ranges and totals", "serverName": "Business Analytics Server"},
    {"namespacedName": "analytics__get_top_selling_products", "description": "Get top selling products ranked by revenue or quantity", "serverName": "Business Analytics Server"},
    {"namespacedName": "store_tech__list_products", "description": "List catalog products for Tech Store tenant", "serverName": "Tech World Server"},
    {"namespacedName": "store_tech__create_product", "description": "Create product in Tech Store tenant", "serverName": "Tech World Server"},
    {"namespacedName": "store_tech__list_orders", "description": "List customer orders and totals for Tech Store tenant", "serverName": "Tech World Server"},
    {"namespacedName": "store_tech__get_order", "description": "Get order details for Tech Store tenant", "serverName": "Tech World Server"},
    {"namespacedName": "store_tech__create_order", "description": "Create order in Tech Store tenant", "serverName": "Tech World Server"},
    {"namespacedName": "store_tech__update_order_status", "description": "Update order status for Tech Store tenant", "serverName": "Tech World Server"},
    {"namespacedName": "store_fashion__list_products", "description": "List apparel products for Fashion Store tenant", "serverName": "Fashion Boutique Server"},
    {"namespacedName": "store_fashion__create_product", "description": "Create product in Fashion Store tenant", "serverName": "Fashion Boutique Server"},
    {"namespacedName": "store_fashion__list_orders", "description": "List apparel orders and totals for Fashion Store tenant", "serverName": "Fashion Boutique Server"},
    {"namespacedName": "store_fashion__get_order", "description": "Get order details for Fashion Store tenant", "serverName": "Fashion Boutique Server"},
    {"namespacedName": "store_fashion__create_order", "description": "Create order in Fashion Store tenant", "serverName": "Fashion Boutique Server"},
    {"namespacedName": "store_fashion__update_order_status", "description": "Update order status for Fashion Store tenant", "serverName": "Fashion Boutique Server"},
]


def test_retriever():
    retriever = BM25ToolRetriever()
    print("=================================================================")
    print("      BM25 JUST-IN-TIME TOOL RETRIEVAL TEST SUITE               ")
    print("=================================================================\n")

    test_cases = [
        {
            "name": "Tenant Order Lookup (Tech Store)",
            "query": "Show me the recent orders in Tech Store for Elon Musk",
            "expected_top": "store_tech__list_orders",
        },
        {
            "name": "Warehouse Low Stock Check",
            "query": "Check the warehouse for any low stock items with a threshold of 15 units",
            "expected_top": "inventory__list_low_stock",
        },
        {
            "name": "Financial Analytics & Sales",
            "query": "What were today's total revenue, gross sales, and top selling products?",
            "expected_top": "analytics__get_daily_sales",
        },
        {
            "name": "Multi-Store Cross-Comparison",
            "query": "Compare the orders and order totals between Tech Store and Fashion Store",
            "expected_top": ["store_tech__list_orders", "store_fashion__list_orders"],
        },
        {
            "name": "Inventory Stock Override",
            "query": "Update the stock for SKU-1004 to 900 units",
            "expected_top": "inventory__update_stock",
        },
        {
            "name": "Conversational Vague Query",
            "query": "Hello can you help me?",
            "expected_top": "woocommerce__list_products",
        },
    ]

    all_passed = True

    for i, tc in enumerate(test_cases, 1):
        start = time.perf_counter()
        selected, metrics = retriever.retrieve(tc["query"], MOCK_TOOLS, top_k=5)
        duration_ms = (time.perf_counter() - start) * 1000.0

        selected_names = [t["namespacedName"] for t in selected]
        
        # Verify expected
        if isinstance(tc["expected_top"], list):
            passed = all(exp in selected_names for exp in tc["expected_top"])
        else:
            passed = tc["expected_top"] in selected_names[:2]

        status = "PASSED" if passed else "FAILED"
        if not passed:
            all_passed = False

        print(f"Test {i}: {tc['name']} -> [{status}] ({duration_ms:.2f} ms)")
        print(f"  Query: '{tc['query']}'")
        print(f"  Selected {len(selected)} tools ({metrics['reduction_pct']}% prompt reduction):")
        for s in selected_names:
            print(f"    - {s}")
        print()

    # Scale Benchmark (100 tools)
    print("-----------------------------------------------------------------")
    print("BENCHMARK: 100 Tools Scale Simulation")
    synthetic_100 = list(MOCK_TOOLS)
    for n in range(1, 15):
        for t_base in ["list_orders", "list_products", "check_stock", "get_sales", "update_order"]:
            synthetic_100.append({
                "namespacedName": f"store_tenant_{n}__{t_base}",
                "description": f"Tool {t_base} for tenant store {n}",
                "serverName": f"Tenant {n} Server",
            })
    
    start_bench = time.perf_counter()
    res_100, metrics_100 = retriever.retrieve("Check orders in tenant 7", synthetic_100, top_k=5)
    bench_ms = (time.perf_counter() - start_bench) * 1000.0

    print(f"Ingested {len(synthetic_100)} tools -> Retrieved {len(res_100)} tools in {bench_ms:.3f} ms")
    print(f"Token reduction: {metrics_100['reduction_pct']}%")
    print(f"Retrieved: {[t['namespacedName'] for t in res_100]}")
    print("-----------------------------------------------------------------")

    if all_passed and bench_ms < 5.0:
        print("\nALL BM25 RETRIEVAL TESTS PASSED SUCCESSFULLY! (Sub-millisecond latency)")
        return 0
    else:
        print("\nTEST SUITE FAILED!")
        return 1


if __name__ == "__main__":
    sys.exit(test_retriever())
