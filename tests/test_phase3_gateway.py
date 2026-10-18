import os
import sys
import pytest
from fastapi.testclient import TestClient

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GATEWAY_DIR = os.path.join(BASE_DIR, "apps", "gateway")
if GATEWAY_DIR not in sys.path:
    sys.path.insert(0, GATEWAY_DIR)

from server import app, api_keys_db, rate_limiter
from config import settings

client = TestClient(app)

ADMIN_KEY = "admin-key-urumi-2026"
INV_KEY = "inv-key-urumi-2026"
ANALYST_KEY = "analyst-key-urumi-2026"
SUPPORT_KEY = "support-key-urumi-2026"

# -------------------------------------------------------------
# 1. Health & Public Endpoints
# -------------------------------------------------------------
def test_gateway_health():
    resp = client.get("/health")
    assert resp.status_code == 200
    data = resp.json()
    assert data["status"] == "healthy"
    assert data["service"] == "team-mcp-gateway"
    assert len(data["upstreams"]) == 3
    print("\n[Gateway Test] Health endpoint OK with 3 upstream servers")

# -------------------------------------------------------------
# 2. Authentication Verification
# -------------------------------------------------------------
def test_authentication_missing_and_invalid_keys():
    # Missing key
    resp = client.get("/api/v1/servers")
    assert resp.status_code == 401
    assert "Missing authentication" in resp.json()["detail"]

    # Invalid key
    resp = client.get("/api/v1/servers", headers={"X-API-Key": "bogus-key-99999"})
    assert resp.status_code == 401
    assert "Invalid or revoked" in resp.json()["detail"]

    # Valid key (Admin)
    resp = client.get("/api/v1/servers", headers={"X-API-Key": ADMIN_KEY})
    assert resp.status_code == 200
    assert len(resp.json()) == 3

    # Valid key via Bearer token
    resp = client.get("/api/v1/servers", headers={"Authorization": f"Bearer {ADMIN_KEY}"})
    assert resp.status_code == 200
    print("[Gateway Test] Authentication (Missing, Invalid, Valid Header, Bearer) verified OK")

# -------------------------------------------------------------
# 3. RBAC Filtering in Tool Listing
# -------------------------------------------------------------
def test_rbac_tool_listing_for_each_role():
    # 1. Admin views all tools as allowed
    resp = client.get("/api/v1/tools", headers={"X-API-Key": ADMIN_KEY})
    assert resp.status_code == 200
    tools = resp.json()
    assert all(t["isAllowed"] for t in tools)
    print(f"[Gateway Test] Admin listing: all {len(tools)} tools ALLOWED")

    # 2. Inventory Manager views only inventory and product list
    resp = client.get("/api/v1/tools", headers={"X-API-Key": INV_KEY})
    assert resp.status_code == 200
    tools = resp.json()
    allowed = [t["namespacedName"] for t in tools if t["isAllowed"]]
    denied = [t["namespacedName"] for t in tools if not t["isAllowed"]]
    assert "inventory__check_stock" in allowed
    assert "inventory__list_low_stock" in allowed
    assert "woocommerce__list_products" in allowed
    assert "analytics__get_revenue_summary" in denied
    assert "woocommerce__update_order_status" in denied
    print(f"[Gateway Test] Inventory Manager listing: {len(allowed)} allowed, {len(denied)} denied")

    # 3. Analyst views only analytics and read-only
    resp = client.get("/api/v1/tools", headers={"X-API-Key": ANALYST_KEY})
    assert resp.status_code == 200
    tools = resp.json()
    allowed = [t["namespacedName"] for t in tools if t["isAllowed"]]
    denied = [t["namespacedName"] for t in tools if not t["isAllowed"]]
    assert "analytics__get_revenue_summary" in allowed
    assert "analytics__get_daily_sales" in allowed
    assert "inventory__update_stock" in denied
    assert "woocommerce__create_product" in denied
    print(f"[Gateway Test] Analyst listing: {len(allowed)} allowed, {len(denied)} denied")

# -------------------------------------------------------------
# 4. RBAC Enforcement on Execution
# -------------------------------------------------------------
def test_rbac_execution_enforcement():
    # 1. Inventory Manager attempting unauthorized analytics call -> 403 Forbidden
    resp = client.post(
        "/api/v1/tools/call",
        headers={"X-API-Key": INV_KEY},
        json={"tool": "analytics__get_revenue_summary", "arguments": {}},
    )
    assert resp.status_code == 403
    assert "Permission Denied" in resp.json()["detail"]
    print("[Gateway Test] RBAC correctly BLOCKED Inventory Manager calling analytics (403 Forbidden)")

    # 2. Analyst attempting unauthorized inventory write call -> 403 Forbidden
    resp = client.post(
        "/api/v1/tools/call",
        headers={"X-API-Key": ANALYST_KEY},
        json={"tool": "inventory__update_stock", "arguments": {"sku": "SKU-1001", "quantity": 10}},
    )
    assert resp.status_code == 403
    assert "Permission Denied" in resp.json()["detail"]
    print("[Gateway Test] RBAC correctly BLOCKED Analyst calling inventory update (403 Forbidden)")

    # 3. Support Rep attempting unauthorized create product -> 403 Forbidden
    resp = client.post(
        "/api/v1/tools/call",
        headers={"X-API-Key": SUPPORT_KEY},
        json={"tool": "woocommerce__create_product", "arguments": {"name": "Hacked", "regular_price": "1"}},
    )
    assert resp.status_code == 403
    print("[Gateway Test] RBAC correctly BLOCKED Support Rep creating product (403 Forbidden)")

# -------------------------------------------------------------
# 5. Token Bucket Rate Limiting
# -------------------------------------------------------------
def test_rate_limiting():
    # Use a custom key to trigger rate limit threshold
    temp_key = "rate-limit-test-key"
    api_keys_db[temp_key] = {
        "id": "key_rl_test",
        "name": "Rate Limit Test Principal",
        "key": temp_key,
        "keyPrefix": f"{temp_key[:8]}...",
        "role": "admin",
        "scope": "test",
        "createdAt": "2026-10-18 10:00:00 UTC",
        "lastUsedAt": "never",
        "expiresAt": "Never",
        "isRevoked": False,
    }

    # Burst capacity is 15. Exhaust the bucket:
    got_429 = False
    for i in range(25):
        resp = client.get("/api/v1/tools", headers={"X-API-Key": temp_key})
        if resp.status_code == 429:
            got_429 = True
            assert "Rate limit exceeded" in resp.json()["detail"]
            assert "Retry-After" in resp.headers
            print(f"[Gateway Test] Rate limit 429 triggered after {i} fast requests (Retry-After: {resp.headers['Retry-After']}s)")
            break

    assert got_429, "Expected 429 Too Many Requests was not triggered"

# -------------------------------------------------------------
# 6. Audit Logging & Metrics Telemetry
# -------------------------------------------------------------
def test_audit_logs_and_stats():
    resp = client.get("/api/v1/audit-logs", headers={"X-API-Key": ADMIN_KEY})
    assert resp.status_code == 200
    logs = resp.json()
    assert len(logs) > 0
    print(f"[Gateway Test] Audit logs retrieved: {len(logs)} entries recorded")

    # Check for recorded 403 block
    blocked_entries = [l for l in logs if "403" in l.get("status", "")]
    assert len(blocked_entries) >= 1
    sample = blocked_entries[0]
    assert sample["status"] == "403 Blocked"
    assert "RBAC Policy Violation" in sample["lifecycle"]["policyRuleDetail"]
    print(f"[Gateway Test] Verified 403 audit entry: tool={sample['toolName']}, principal={sample['principal']}")

    # Check stats endpoint
    stats_resp = client.get("/api/v1/stats", headers={"X-API-Key": ADMIN_KEY})
    assert stats_resp.status_code == 200
    stats = stats_resp.json()
    assert stats["total_requests"] > 0
    assert stats["blocked_requests"] >= 1
    assert stats["active_servers"] == 3
    print(f"[Gateway Test] Stats OK: total={stats['total_requests']}, blocked={stats['blocked_requests']}, tools={stats['total_tools']}")

# -------------------------------------------------------------
# 7. Key Management Lifecycle (Create, List, Revoke)
# -------------------------------------------------------------
def test_api_key_lifecycle():
    # 1. Non-admin cannot create keys
    create_resp = client.post(
        "/api/v1/api-keys",
        headers={"X-API-Key": INV_KEY},
        json={"name": "Attacker Key", "role": "admin"},
    )
    assert create_resp.status_code == 403

    # 2. Admin creates new key
    create_resp = client.post(
        "/api/v1/api-keys",
        headers={"X-API-Key": ADMIN_KEY},
        json={"name": "Temporary Inventory Auditor", "role": "inventory_manager"},
    )
    assert create_resp.status_code == 201
    created_key_data = create_resp.json()
    new_key = created_key_data["key"]
    new_id = created_key_data["id"]

    # 3. Verify newly created key works
    verify_resp = client.get("/api/v1/tools", headers={"X-API-Key": new_key})
    assert verify_resp.status_code == 200

    # 4. Revoke key
    revoke_resp = client.delete(f"/api/v1/api-keys/{new_id}", headers={"X-API-Key": ADMIN_KEY})
    assert revoke_resp.status_code == 200

    # 5. Revoked key now fails authentication
    post_revoke_resp = client.get("/api/v1/tools", headers={"X-API-Key": new_key})
    assert post_revoke_resp.status_code == 401
    print(f"[Gateway Test] API Key lifecycle (Unauthorized create blocked, Create, Auth, Revoke, Auth Fail) verified OK")
