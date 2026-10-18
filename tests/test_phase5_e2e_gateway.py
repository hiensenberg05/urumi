import httpx
import pytest

GATEWAY_URL = "http://127.0.0.1"
HEADERS_BASE = {"Host": "gateway.local"}

def test_rbac_user_b_allowed_tools():
    """Verify User B (Inventory Manager) sees only authorized tools."""
    headers = {**HEADERS_BASE, "Authorization": "Bearer inv-key-urumi-2026"}
    with httpx.Client(base_url=GATEWAY_URL, headers=headers) as client:
        resp = client.get("/api/v1/tools")
        assert resp.status_code == 200
        tools = resp.json()
        
        # Verify allowed tools
        allowed_names = [t["namespacedName"] for t in tools if t["isAllowed"]]
        assert "inventory__check_stock" in allowed_names
        assert "inventory__list_low_stock" in allowed_names
        assert "inventory__update_stock" in allowed_names
        assert "woocommerce__list_products" in allowed_names
        
        # Verify forbidden tools are blocked
        assert "woocommerce__create_order" not in allowed_names
        assert "analytics__get_revenue_summary" not in allowed_names

def test_rbac_user_b_execution_and_enforcement():
    """Verify User B can execute permitted tools and gets 403 on denied tools."""
    headers = {**HEADERS_BASE, "Authorization": "Bearer inv-key-urumi-2026"}
    with httpx.Client(base_url=GATEWAY_URL, headers=headers) as client:
        # 1. Allowed tool execution
        resp_allowed = client.post("/api/v1/tools/call", json={
            "tool": "inventory__list_low_stock",
            "arguments": {"threshold": 10}
        })
        assert resp_allowed.status_code == 200
        data = resp_allowed.json()
        assert data["status"] == "success"
        assert isinstance(data["result"], list)

        # 2. Denied tool execution (RBAC Block)
        resp_denied = client.post("/api/v1/tools/call", json={
            "tool": "analytics__get_revenue_summary",
            "arguments": {}
        })
        assert resp_denied.status_code == 403
        assert "Permission Denied" in resp_denied.json()["detail"]

def test_dynamic_key_lifecycle_and_revocation():
    """Verify dynamic key creation, usage, revocation, and 401 rejection."""
    admin_headers = {**HEADERS_BASE, "Authorization": "Bearer admin-key-urumi-2026"}
    with httpx.Client(base_url=GATEWAY_URL) as client:
        # 1. Admin generates new API key for Analyst
        create_resp = client.post(
            "/api/v1/api-keys",
            headers=admin_headers,
            json={"name": "Temporary Automated Test Key", "role": "analyst", "scope": "read:analytics"}
        )
        assert create_resp.status_code == 201
        key_info = create_resp.json()
        new_key = key_info["key"]
        key_id = key_info["id"]

        # 2. Test active key
        new_headers = {**HEADERS_BASE, "Authorization": f"Bearer {new_key}"}
        active_resp = client.get("/api/v1/tools", headers=new_headers)
        assert active_resp.status_code == 200

        # 3. Admin revokes the key
        revoke_resp = client.delete(f"/api/v1/api-keys/{key_id}", headers=admin_headers)
        assert revoke_resp.status_code == 200

        # 4. Revoked key must fail authentication with 401
        revoked_resp = client.get("/api/v1/tools", headers=new_headers)
        assert revoked_resp.status_code == 401

def test_audit_log_captures_events():
    """Verify all invocations and RBAC denials are recorded in the audit trail."""
    admin_headers = {**HEADERS_BASE, "Authorization": "Bearer admin-key-urumi-2026"}
    with httpx.Client(base_url=GATEWAY_URL, headers=admin_headers) as client:
        resp = client.get("/api/v1/audit-logs?limit=10")
        assert resp.status_code == 200
        logs = resp.json()
        assert len(logs) > 0
        
        statuses = [l["status"] for l in logs]
        assert any("200 OK" in s for s in statuses)
        assert any("403 Blocked" in s for s in statuses)

if __name__ == "__main__":
    pytest.main(["-v", __file__])
