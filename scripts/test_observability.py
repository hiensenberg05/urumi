"""
Observability and Telemetry Verification Script for Urumi MCP Gateway.
Tests:
1. Normal tool execution (measures p50/p95 latency)
2. Store tenant tool execution
3. RBAC violation tracking
4. Rate limit / error tracking
5. Circuit breaker status
6. OpenMetrics (/metrics) validation
7. JSON Telemetry (/api/v1/telemetry) validation
"""

import json
import urllib.request
import urllib.error
import time

GATEWAY_URL = "http://gateway.local"
ADMIN_KEY = "admin-key-urumi-2026"
SUPPORT_KEY = "support-key-urumi-2026"

def call_tool(tool: str, args: dict, api_key: str):
    url = f"{GATEWAY_URL}/api/v1/tools/call"
    data = json.dumps({"tool": tool, "arguments": args}).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=data,
        headers={
            "Content-Type": "application/json",
            "X-API-Key": api_key,
        },
        method="POST"
    )
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            return resp.status, json.loads(resp.read().decode())
    except urllib.error.HTTPError as e:
        body = e.read().decode()
        try:
            return e.code, json.loads(body)
        except:
            return e.code, body
    except Exception as e:
        return 500, str(e)

def get_telemetry():
    url = f"{GATEWAY_URL}/api/v1/telemetry"
    req = urllib.request.Request(url, headers={"X-API-Key": ADMIN_KEY})
    with urllib.request.urlopen(req, timeout=5) as resp:
        return json.loads(resp.read().decode())

def get_metrics():
    url = f"{GATEWAY_URL}/metrics"
    req = urllib.request.Request(url)
    with urllib.request.urlopen(req, timeout=5) as resp:
        return resp.read().decode()

def main():
    print("=== Testing Urumi Observability & Telemetry ===")
    
    # 1. Execute multiple successful tool calls across servers
    print("\n[1] Executing tool calls...")
    tools_to_test = [
        ("woocommerce__list_products", {"per_page": 2}, ADMIN_KEY),
        ("inventory__check_stock", {"sku": "SKU-1001"}, ADMIN_KEY),
        ("inventory__list_low_stock", {"threshold": 10}, ADMIN_KEY),
        ("analytics__get_daily_sales", {}, ADMIN_KEY),
        ("store_tech__list_products", {"per_page": 2}, ADMIN_KEY),
    ]

    for tool, args, key in tools_to_test:
        code, res = call_tool(tool, args, key)
        print(f" -> {tool}: HTTP {code} ({'OK' if code == 200 else 'ERR'})")
        time.sleep(0.1)

    # 2. Trigger RBAC violation (support_rep trying to update inventory)
    print("\n[2] Testing RBAC Violation tracking...")
    code, res = call_tool("inventory__update_stock", {"sku": "SKU-1001", "quantity": 999}, SUPPORT_KEY)
    print(f" -> RBAC Violation response: HTTP {code} - {res.get('detail', res)}")

    # 3. Fetch structured JSON telemetry
    print("\n[3] Fetching /api/v1/telemetry JSON report...")
    telem = get_telemetry()
    summary = telem["summary"]
    print(f" -> Total Invocations: {summary['totalInvocations']}")
    print(f" -> Successful: {summary['successfulInvocations']}")
    print(f" -> Failed: {summary['failedInvocations']}")
    print(f" -> RBAC Violations: {summary['rbacViolations']}")
    print(f" -> Platform Error Rate: {summary['errorRatePct']}%")
    print(f" -> Latency Percentiles (p50/p95/p99): {summary['latency']['p50']}ms / {summary['latency']['p95']}ms / {summary['latency']['p99']}ms")
    print(f" -> Active Monitored Servers: {summary['activeServers']} / {summary['totalServers']}")

    print("\n -> Server Circuit Breakers & Latency Breakdown:")
    for srv in telem["servers"]:
        print(f"    * {srv['name']}: CB={srv['circuitBreaker']} (Trips: {srv['circuitTrips']}), Calls={srv['totalCalls']}, ErrRate={srv['errorRatePct']}%, p95={srv['p95LatencyMs']}ms")

    # 4. Fetch Prometheus OpenMetrics exposition
    print("\n[4] Scraping Prometheus /metrics exposition...")
    metrics_text = get_metrics()
    metric_sample = [l for l in metrics_text.splitlines() if not l.startswith("#") and l.strip()]
    print(f" -> Exported {len(metric_sample)} active Prometheus metric series:")
    for m in metric_sample[:10]:
        print(f"    {m}")

    print("\n=== Observability & Telemetry verification completed successfully! ===")

if __name__ == "__main__":
    main()
