"""
Comprehensive End-to-End Test Suite for Enterprise OAuth 2.0 (JWT) & Dynamic Policy Studio
"""
import sys
import httpx
import json
import time

BASE_URL = "http://127.0.0.1"
DEFAULT_HEADERS = {"Host": "gateway.local"}

def run_tests():
    print("=" * 70)
    print("  URUMI GATEWAY: E2E TEST SUITE FOR OAUTH 2.0 & DYNAMIC POLICY STUDIO")
    print("=" * 70)

    # 1. Test Providers Discovery
    print("\n[TEST 1] Testing OAuth 2.0 Providers & Personas Discovery...")
    with httpx.Client(base_url=BASE_URL, headers=DEFAULT_HEADERS, timeout=10.0) as client:
        r = client.get("/api/v1/auth/providers")
        assert r.status_code == 200, f"Expected 200, got {r.status_code}: {r.text}"
        data = r.json()
        assert "providers" in data and len(data["providers"]) >= 3
        assert "personas" in data and len(data["personas"]) >= 4
        print(f"  [PASS] Found {len(data['providers'])} identity providers and {len(data['personas'])} personas.")

    # 2. Test Issue OAuth JWT Token for Personas
    print("\n[TEST 2] Issuing Cryptographic RFC 7519 JWT Bearer Tokens...")
    with httpx.Client(base_url=BASE_URL, headers=DEFAULT_HEADERS, timeout=10.0) as client:
        # Alice Admin
        r_alice = client.post("/api/v1/auth/oauth/token", json={"grant_type": "persona", "persona": "alice"})
        assert r_alice.status_code == 200, f"Alice token issue failed: {r_alice.text}"
        alice_data = r_alice.json()
        alice_jwt = alice_data["access_token"]
        assert alice_jwt.count(".") == 2
        print(f"  [PASS] Issued Alice Admin JWT ({len(alice_jwt)} bytes, expires in {alice_data['expires_in']}s)")

        # Charlie Analyst
        r_charlie = client.post("/api/v1/auth/oauth/token", json={"grant_type": "persona", "persona": "charlie"})
        assert r_charlie.status_code == 200, f"Charlie token issue failed: {r_charlie.text}"
        charlie_data = r_charlie.json()
        charlie_jwt = charlie_data["access_token"]
        assert charlie_jwt.count(".") == 2
        print(f"  [PASS] Issued Charlie Analyst JWT ({len(charlie_jwt)} bytes)")

    # 3. Test JWT Introspection /me
    print("\n[TEST 3] Testing JWT Introspection (/api/v1/auth/me)...")
    with httpx.Client(base_url=BASE_URL, headers=DEFAULT_HEADERS, timeout=10.0) as client:
        r_me = client.get("/api/v1/auth/me", headers={"Authorization": f"Bearer {alice_jwt}"})
        assert r_me.status_code == 200, f"/me failed: {r_me.text}"
        me_data = r_me.json()
        assert me_data["principal"]["name"] == "Alice Chen"
        assert me_data["principal"]["role"] == "admin"
        assert me_data["principal"]["authType"] == "OAuth 2.0 (JWT)"
        assert me_data["token"]["isJwt"] is True
        print(f"  [PASS] Verified caller: {me_data['principal']['name']} | Role: {me_data['principal']['role']} | Auth: {me_data['principal']['authType']}")

    # 4. Test Backward Compatibility: Legacy API Keys
    print("\n[TEST 4] Testing 100% Backward Compatibility with Legacy API Keys...")
    with httpx.Client(base_url=BASE_URL, headers=DEFAULT_HEADERS, timeout=10.0) as client:
        r_legacy = client.get("/api/v1/auth/me", headers={"X-API-Key": "inv-key-urumi-2026"})
        assert r_legacy.status_code == 200, f"Legacy key failed: {r_legacy.text}"
        legacy_data = r_legacy.json()
        assert legacy_data["principal"]["role"] == "inventory_manager"
        assert legacy_data["principal"]["authType"] == "API Key"
        assert legacy_data["token"]["isJwt"] is False
        print(f"  [PASS] Legacy static API key accepted: Role '{legacy_data['principal']['role']}', AuthType '{legacy_data['principal']['authType']}'")

    # 5. Test Cryptographic Tampering Rejection
    print("\n[TEST 5] Testing Cryptographic Tamper Detection & Rejection...")
    with httpx.Client(base_url=BASE_URL, headers=DEFAULT_HEADERS, timeout=10.0) as client:
        tampered_jwt = alice_jwt[:-6] + "bad123"
        r_tamper = client.get("/api/v1/auth/me", headers={"Authorization": f"Bearer {tampered_jwt}"})
        assert r_tamper.status_code == 401, f"Expected 401 for tampered JWT, got {r_tamper.status_code}"
        print(f"  [PASS] Tampered JWT successfully rejected with HTTP 401: {r_tamper.json()['detail']}")

    # 6. Test Dynamic Policy Studio Matrix
    print("\n[TEST 6] Testing Dynamic Policy Matrix Retrieval (/api/v1/policies)...")
    with httpx.Client(base_url=BASE_URL, headers=DEFAULT_HEADERS, timeout=10.0) as client:
        r_pol = client.get("/api/v1/policies", headers={"Authorization": f"Bearer {alice_jwt}"})
        assert r_pol.status_code == 200
        pol_data = r_pol.json()
        assert "roles" in pol_data and "tools" in pol_data
        print(f"  [PASS] Policy matrix retrieved: {pol_data['totalTools']} tools across {len(pol_data['roles'])} roles.")

    # 7. Real-Time Dynamic Policy Modification & Zero-Restart Enforcement Test
    print("\n[TEST 7] Testing Real-Time Dynamic Policy Overrides on Live Cluster...")
    with httpx.Client(base_url=BASE_URL, headers=DEFAULT_HEADERS, timeout=10.0) as client:
        # Step 7a: Charlie (Analyst) attempts to call inventory__check_stock (Default: Blocked)
        r_blocked = client.post(
            "/api/v1/tools/call",
            headers={"Authorization": f"Bearer {charlie_jwt}"},
            json={"tool": "inventory__check_stock", "arguments": {"sku": "HOODIE-BLK-M"}}
        )
        assert r_blocked.status_code == 403, f"Expected 403, got {r_blocked.status_code}: {r_blocked.text}"
        print("  [PASS] Step 7a: Charlie Analyst initially BLOCKED (403 Forbidden) as per baseline RBAC.")

        # Step 7b: Alice Admin dynamically overrides policy to ALLOW inventory__check_stock for Analyst
        print("  [INFO] Step 7b: Alice Admin publishes dynamic override: Role 'analyst' -> ALLOW 'inventory__check_stock'...")
        r_update = client.put(
            "/api/v1/policies",
            headers={"Authorization": f"Bearer {alice_jwt}"},
            json={"updates": [{"role": "analyst", "tool": "inventory__check_stock", "policy": "ALLOW"}]}
        )
        assert r_update.status_code == 200, f"Policy update failed: {r_update.text}"
        print(f"  [PASS] Policy updated on cluster ({r_update.json()['updatedCount']} rule updated).")

        # Step 7c: Charlie retries calling inventory__check_stock with SAME JWT (Zero restart required!)
        r_allowed = client.post(
            "/api/v1/tools/call",
            headers={"Authorization": f"Bearer {charlie_jwt}"},
            json={"tool": "inventory__check_stock", "arguments": {"sku": "HOODIE-BLK-M"}}
        )
        assert r_allowed.status_code == 200, f"Expected 200, got {r_allowed.status_code}: {r_allowed.text}"
        call_res = r_allowed.json()
        print(f"  [PASS] Step 7c: Charlie Analyst IMMEDIATELY SUCCEEDS (200 OK)! Result: {str(call_res.get('result', call_res))[:50]}...")

        # Step 7d: Revert back to baseline via Reset API
        print("  [INFO] Step 7d: Alice Admin resets policy matrix to baseline defaults...")
        r_reset = client.post("/api/v1/policies/reset", headers={"Authorization": f"Bearer {alice_jwt}"})
        assert r_reset.status_code == 200

        # Step 7e: Verify Charlie is blocked again
        r_blocked_again = client.post(
            "/api/v1/tools/call",
            headers={"Authorization": f"Bearer {charlie_jwt}"},
            json={"tool": "inventory__check_stock", "arguments": {"sku": "HOODIE-BLK-M"}}
        )
        assert r_blocked_again.status_code == 403
        print("  [PASS] Step 7e: Baseline restored. Charlie Analyst is once again BLOCKED (403 Forbidden).")

    print("\n" + "=" * 70)
    print("  ALL TESTS PASSED! OAUTH 2.0 & DYNAMIC POLICY STUDIO ARE 100% VERIFIED!")
    print("=" * 70)

if __name__ == "__main__":
    run_tests()
