#!/usr/bin/env python3
import json
import urllib.request
import urllib.error

GATEWAY_URL = "http://172.18.0.2"
HOST_HEADER = "gateway.local"

ADMIN_KEY = "admin-key-urumi-2026"
INV_KEY = "inv-key-urumi-2026"
ANALYST_KEY = "analyst-key-urumi-2026"
SUPPORT_KEY = "support-key-urumi-2026"

def req(path, method="GET", api_key=None, body=None):
    url = f"{GATEWAY_URL}{path}"
    headers = {"Host": HOST_HEADER}
    if api_key:
        headers["X-API-Key"] = api_key
    data = None
    if body is not None:
        headers["Content-Type"] = "application/json"
        data = json.dumps(body).encode("utf-8")
    
    request = urllib.request.Request(url, data=data, headers=headers, method=method)
    try:
        with urllib.request.urlopen(request, timeout=10) as resp:
            content = resp.read().decode("utf-8")
            try:
                return resp.status, json.loads(content)
            except Exception:
                return resp.status, content
    except urllib.error.HTTPError as e:
        content = e.read().decode("utf-8")
        try:
            return e.code, json.loads(content)
        except Exception:
            return e.code, content

def run_tests():
    print("=" * 65)
    print("🚀 COMPREHENSIVE PHASE 3 GATEWAY INGRESS VERIFICATION TEST")
    print("=" * 65)

    # 1. Health
    print("\n[1/8] Testing Gateway /health via Ingress...")
    status, data = req("/health")
    assert status == 200 and data["status"] == "healthy"
    print(f"✅ Health OK! Connected Upstreams: {len(data['upstreams'])}")

    # 2. Unauthenticated check
    print("\n[2/8] Testing Authentication Rejection (Missing Key)...")
    status, data = req("/api/v1/servers")
    assert status == 401
    print(f"✅ HTTP 401 Unauthorized correctly returned when key is omitted: {data['detail']}")

    # 3. Authenticated Servers API
    print("\n[3/8] Testing /api/v1/servers with Admin Key...")
    status, servers = req("/api/v1/servers", api_key=ADMIN_KEY)
    assert status == 200 and len(servers) == 3
    for s in servers:
        print(f"   • [{s['id']}] {s['name']} ({s['tag']}): {s['status']} ({s['toolsCount']} tools)")
    print("✅ Upstream servers API verified!")

    # 4. RBAC Tool Filtering
    print("\n[4/8] Testing RBAC Tool Discovery for Inventory Manager...")
    status, tools = req("/api/v1/tools", api_key=INV_KEY)
    assert status == 200
    allowed = [t["namespacedName"] for t in tools if t["isAllowed"]]
    denied = [t["namespacedName"] for t in tools if not t["isAllowed"]]
    assert "inventory__check_stock" in allowed
    assert "analytics__get_revenue_summary" in denied
    print(f"✅ RBAC Discovery OK: {len(allowed)} Allowed, {len(denied)} Denied for role 'inventory_manager'")

    # 5. RBAC Enforcement: Unauthorized Tool Call Blocked
    print("\n[5/8] Testing RBAC Tool Execution: Unauthorized Call Blocked...")
    status, res = req(
        "/api/v1/tools/call",
        method="POST",
        api_key=INV_KEY,
        body={"tool": "analytics__get_daily_sales", "arguments": {}}
    )
    assert status == 403
    print(f"✅ HTTP 403 Forbidden correctly returned! Detail: {res['detail']}")

    # 6. RBAC Execution: Authorized Inventory Tool Call Succeeded
    print("\n[6/8] Testing Authorized Tool Call: inventory__check_stock...")
    status, res = req(
        "/api/v1/tools/call",
        method="POST",
        api_key=INV_KEY,
        body={"tool": "inventory__check_stock", "arguments": {"sku": "SKU-1001"}}
    )
    assert status == 200 and res["status"] == "success"
    stock_info = res["result"]
    print(f"✅ Tool execution success (Duration: {res['duration_ms']}ms): SKU-1001 Stock={stock_info.get('stock_quantity')}")

    # 7. Authorized Analytics Call via Analyst Key
    print("\n[7/8] Testing Authorized Analytics Call: analytics__get_revenue_summary...")
    status, res = req(
        "/api/v1/tools/call",
        method="POST",
        api_key=ANALYST_KEY,
        body={"tool": "analytics__get_revenue_summary", "arguments": {"period": "30d"}}
    )
    assert status == 200 and res["status"] == "success"
    rev = res["result"]
    print(f"✅ Revenue Summary (Duration: {res['duration_ms']}ms): Total=${rev.get('total_revenue')}, AOV=${rev.get('average_order_value')}")

    # 8. Audit Logs & Telemetry
    print("\n[8/8] Testing Gateway Audit Logs & Telemetry...")
    status, logs = req("/api/v1/audit-logs?limit=10", api_key=ADMIN_KEY)
    assert status == 200 and len(logs) >= 2
    for l in logs[:3]:
        print(f"   • [{l['timestamp']}] {l['status']} | {l['principal']} ({l['actualRole']}) -> {l['toolName']} ({l['durationMs']}ms)")
    status, stats = req("/api/v1/stats", api_key=ADMIN_KEY)
    assert status == 200 and stats["blocked_requests"] >= 1
    print(f"✅ Telemetry Stats: Total={stats['total_requests']}, Blocked={stats['blocked_requests']}, Latency={stats['avg_latency_ms']}ms")

    print("\n" + "=" * 65)
    print("🎉 ALL 8 PHASE 3 GATEWAY INGRESS TESTS PASSED WITH 100% SUCCESS!")
    print("=" * 65)

if __name__ == "__main__":
    run_tests()
