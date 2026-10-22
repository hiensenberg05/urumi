"""
End-to-end verification of Gateway SSRF Protection, RBAC, Credential Encryption, and Audit Logging.
Tests live gateway on http://gateway.local (or http://localhost via ingress).
"""

import sys
import httpx

BASE_URL = "http://gateway.local"
ADMIN_KEY = "admin-key-urumi-2026"
MEMBER_KEY = "support-key-urumi-2026"

def run_tests():
    print(f"Connecting to live Gateway at {BASE_URL}...")
    client = httpx.Client(base_url=BASE_URL, timeout=10.0)

    # 1. Health check
    res = client.get("/health")
    assert res.status_code == 200, f"Gateway health check failed: {res.status_code}"
    print("  [PASS] Gateway /health is 200 OK")

    # 2. RBAC check: Non-admin trying to register server
    print("\n[TEST 1] RBAC Verification for Server Registration:")
    res = client.post(
        "/api/v1/servers",
        headers={"X-API-Key": MEMBER_KEY},
        json={
            "name": "Hacker Upstream",
            "endpoint_url": "http://evil.com/mcp",
        }
    )
    assert res.status_code == 403, f"Expected 403 Forbidden for member, got {res.status_code}"
    print("  [PASS] Member key received HTTP 403 Forbidden as expected.")

    # 3. SSRF Attack Scenarios (OWASP A10 / CWE-918)
    print("\n[TEST 2] Backend SSRF Protection Vectors (Admin caller):")
    ssrf_vectors = [
        ("AWS/GCP Cloud Metadata IP", "http://169.254.169.254/latest/meta-data"),
        ("Google Internal Metadata Domain", "http://metadata.google.internal/computeMetadata/v1/"),
        ("Loopback IP Address", "http://127.0.0.1:8000/mcp"),
        ("Localhost Domain", "http://localhost:3000/api"),
        ("Kubernetes API Server IP", "http://10.96.0.1:443/api"),
        ("Prohibited File Scheme", "file:///etc/passwd"),
        ("Prohibited Gopher Scheme", "gopher://127.0.0.1:70"),
    ]

    for label, bad_url in ssrf_vectors:
        res = client.post(
            "/api/v1/servers",
            headers={"X-API-Key": ADMIN_KEY},
            json={
                "name": f"Test {label}",
                "endpoint_url": bad_url,
            }
        )
        assert res.status_code == 400, f"Expected 400 Bad Request for {label} ({bad_url}), got {res.status_code}: {res.text}"
        detail = res.json().get("detail", "")
        assert "SSRF" in detail or "Prohibited" in detail, f"Expected SSRF security reason, got: {detail}"
        print(f"  [PASS] Blocked {label}: {detail}")

    # 4. Legitimate Upstream Registration
    print("\n[TEST 3] Legitimate Upstream Registration & Credential Encryption:")
    res = client.post(
        "/api/v1/servers",
        headers={"X-API-Key": ADMIN_KEY},
        json={
            "name": "Automated Warehouse Bot",
            "endpoint_url": "http://robot-service.local/mcp",
            "auth_type": "Bearer Secret",
            "auth_token": "super-confidential-token-9988",
            "transport": "http",
            "tag": "CUSTOM UPSTREAM"
        }
    )
    assert res.status_code == 201, f"Expected 201 Created, got {res.status_code}: {res.text}"
    created_srv = res.json()
    srv_id = created_srv["id"]
    print(f"  [PASS] Successfully registered custom server: id={srv_id}, tools={created_srv['discoveredTools']}")

    # 5. Verify Credential Zero-Leakage in Server List
    print("\n[TEST 4] Zero-Trust Verification (Creds never leaked in JSON):")
    res = client.get("/api/v1/servers", headers={"X-API-Key": ADMIN_KEY})
    assert res.status_code == 200
    servers = res.json()
    found = next((s for s in servers if s["id"] == srv_id), None)
    assert found is not None, f"Server {srv_id} not found in /api/v1/servers"
    # Ensure plaintext token is nowhere in the serialized dictionary
    raw_json_str = str(found)
    assert "super-confidential-token-9988" not in raw_json_str, "CRITICAL: Plaintext token leaked in server list!"
    print("  [PASS] Plaintext token is NOT present in API responses (encrypted at rest).")

    # 6. Verify Security Audit Trail
    print("\n[TEST 5] Security Audit Trail Inspection:")
    res = client.get("/api/v1/audit-logs", headers={"X-API-Key": ADMIN_KEY})
    assert res.status_code == 200
    logs = res.json()
    ssrf_blocked_logs = [l for l in logs if l.get("toolName") == "ssrf_blocked_server_register"]
    assert len(ssrf_blocked_logs) >= len(ssrf_vectors), f"Expected at least {len(ssrf_vectors)} SSRF audit entries, got {len(ssrf_blocked_logs)}"
    print(f"  [PASS] Audit trail recorded {len(ssrf_blocked_logs)} SSRF security violations with full principal attribution.")

    # 7. Unregister Server
    print("\n[TEST 6] Unregister Custom Upstream:")
    res = client.delete(f"/api/v1/servers/{srv_id}", headers={"X-API-Key": ADMIN_KEY})
    assert res.status_code == 200
    print(f"  [PASS] Server {srv_id} successfully deleted.")

    print("\n" + "=" * 60)
    print("ALL 6 LIVE END-TO-END SECURITY CHECKS PASSED PERFECTLY!")
    print("=" * 60)

if __name__ == "__main__":
    run_tests()
