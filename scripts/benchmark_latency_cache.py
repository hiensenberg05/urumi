"""
Latency & Prompt Caching Benchmark Runner for Urumi MCP Gateway
"""
import sys
import time
import httpx

sys.stdout.reconfigure(encoding='utf-8')

BASE_URL = "http://gateway.local"
ADMIN_KEY = "admin-key-urumi-2026"

BENCHMARK_PROMPTS = [
    {
        "name": "Product Price & Stock Lookup",
        "prompt": "What is the price and stock of the Ultra-Comfort Gaming Chair?",
    },
    {
        "name": "30-Day Product Revenue Summary",
        "prompt": "Show revenue summary for the last 30 days grouped by product.",
    },
    {
        "name": "Warehouse Single SKU Balance",
        "prompt": "Check warehouse stock for SKU-1002.",
    },
    {
        "name": "Recent Customer Order Pipeline",
        "prompt": "List the most recent customer orders in the store.",
    },
    {
        "name": "Top Selling Products Volume",
        "prompt": "What are the top 3 best-selling products by volume?",
    },
]

def run_benchmark():
    client = httpx.Client(base_url=BASE_URL, timeout=90.0)
    print("=" * 90)
    print("URUMI MCP GATEWAY - LATENCY & PROMPT CACHING BENCHMARK REPORT")
    print("Measuring Cold Execution vs Redis Prompt Cache Acceleration")
    print("=" * 90)

    results = []

    for idx, item in enumerate(BENCHMARK_PROMPTS, start=1):
        prompt = item["prompt"]
        name = item["name"]
        print(f"\n[Test {idx}/5] Scenario: {name}")
        print(f"  Query: \"{prompt}\"")

        # 1. Cold Turn (Execution + ReAct tool loop)
        t0 = time.perf_counter()
        r1 = client.post(
            "/api/v1/chat",
            headers={"X-API-Key": ADMIN_KEY},
            json={"message": prompt, "session_id": f"bench_{idx}_cold_{int(time.time())}"}
        )
        cold_ms = round((time.perf_counter() - t0) * 1000.0, 1)
        data1 = r1.json()
        tokens1 = data1.get("memory", {}).get("tokensSaved", 0)
        tools1 = [s.get("tool") for s in data1.get("steps", [])]

        print(f"  -> Cold Run (Turn 1)  : {cold_ms:>8.1f} ms | Tools Called: {tools1} | Tokens Saved: {tokens1}")

        # Short pause between calls
        time.sleep(0.3)

        # 2. Warm Turn (Redis Prompt & Query Cache Hit)
        t1 = time.perf_counter()
        r2 = client.post(
            "/api/v1/chat",
            headers={"X-API-Key": ADMIN_KEY},
            json={"message": prompt, "session_id": f"bench_{idx}_warm_{int(time.time())}"}
        )
        warm_ms = round((time.perf_counter() - t1) * 1000.0, 1)
        data2 = r2.json()
        tokens2 = data2.get("memory", {}).get("tokensSaved", 0)
        storage2 = data2.get("memory", {}).get("storage", "N/A")

        speedup = round(cold_ms / max(1.0, warm_ms), 1)
        print(f"  -> Cached Run (Turn 2): {warm_ms:>8.1f} ms | Storage: {storage2} | Tokens Saved: {tokens2}")
        print(f"  ⚡ Speedup: {speedup}x Faster ({cold_ms} ms -> {warm_ms} ms)")

        results.append({
            "name": name,
            "cold_ms": cold_ms,
            "warm_ms": warm_ms,
            "speedup": speedup,
            "tokens_saved": tokens2,
        })

    # Summary Table
    print("\n" + "=" * 90)
    print(f"{'Scenario Name':<35} | {'Cold (ms)':<10} | {'Cached (ms)':<12} | {'Speedup':<10} | {'Tokens Saved'}")
    print("-" * 90)
    for r in results:
        print(f"{r['name']:<35} | {r['cold_ms']:<10.1f} | {r['warm_ms']:<12.1f} | {str(r['speedup']) + 'x':<10} | {r['tokens_saved']}")
    print("=" * 90)

    avg_cold = round(sum(r["cold_ms"] for r in results) / len(results), 1)
    avg_warm = round(sum(r["warm_ms"] for r in results) / len(results), 1)
    avg_speedup = round(avg_cold / max(1.0, avg_warm), 1)

    print(f"Average Cold Latency   : {avg_cold} ms")
    print(f"Average Cached Latency : {avg_warm} ms")
    print(f"Overall Acceleration   : {avg_speedup}x Faster")
    print("=" * 90)

if __name__ == "__main__":
    run_benchmark()
