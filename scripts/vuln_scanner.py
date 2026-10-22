import urllib.request
import urllib.error
import json
import sys

BASE_URL = "http://127.0.0.1"
GW_HEADERS = {"Host": "gateway.local"}

findings = []

def record(test_id, category, severity, title, passed, details):
    findings.append({
        "id": test_id,
        "category": category,
        "severity": severity,
        "title": title,
        "status": "PASS" if passed else "FAIL (VULNERABILITY)",
        "details": details
    })

def make_req(path, method="GET", headers=None, body=None):
    h = dict(GW_HEADERS)
    if headers:
        h.update(headers)
    data = None
    if body is not None:
        data = json.dumps(body).encode()
        h["Content-Type"] = "application/json"
    
    req = urllib.request.Request(f"{BASE_URL}{path}", data=data, headers=h, method=method)
    try:
        with urllib.request.urlopen(req) as resp:
            return resp.status, json.loads(resp.read().decode())
    except urllib.error.HTTPError as e:
        try:
            err_body = json.loads(e.read().decode())
        except Exception:
            err_body = e.reason
        return e.code, err_body
    except Exception as e:
        return 0, str(e)

print("Starting Vulnerability Scan against Urumi MCP Gateway on Kubernetes...\n")

# VULN-01: Can a non-admin call GET /api/v1/api-keys and read all keys?
st, body = make_req("/api/v1/api-keys", headers={"X-API-Key": "support-key-urumi-2026"})
if st == 403:
    record("VULN-01a", "Access Control", "CRITICAL", 
           "Non-admin role 'support_rep' blocked from listing API keys",
           True, "Returned 403 Forbidden as expected")
else:
    record("VULN-01a", "Access Control", "CRITICAL", 
           "Non-admin role 'support_rep' allowed to list API keys",
           False, f"Status: {st}")

# VULN-01b: Does admin listing mask full secret keys?
st_adm, body_adm = make_req("/api/v1/api-keys", headers={"X-API-Key": "admin-key-urumi-2026"})
if st_adm == 200:
    has_unmasked = any(len(k.get("key", "")) > 10 and not k.get("key", "").endswith("********") for k in body_adm)
    if not has_unmasked:
        record("VULN-01b", "Credential Protection", "HIGH",
               "Admin key listing masks secret key tokens (e.g. admin-ke********)",
               True, f"All {len(body_adm)} keys properly masked")
    else:
        record("VULN-01b", "Credential Protection", "HIGH",
               "Admin key listing exposes raw unmasked key tokens",
               False, "Found unmasked keys in response")
else:
    record("VULN-01b", "Credential Protection", "HIGH",
           "Admin key listing failed",
           False, f"Status: {st_adm}")

# VULN-02: Privilege Escalation via role_override in /api/v1/chat
st, body = make_req("/api/v1/chat", method="POST",
                    headers={"X-API-Key": "support-key-urumi-2026"},
                    body={"message": "Adjust warehouse stock for SKU-1001 by +5", "role_override": "admin"})
# Check if it allowed stock adjustment because of role_override="admin"
has_blocked = False
if isinstance(body, dict):
    steps = body.get("steps", [])
    for s in steps:
        if s.get("status") == "403 Blocked":
            has_blocked = True
        elif s.get("status") == "200 OK" and "adjust_stock" in s.get("tool", ""):
            has_blocked = False
            break

if st == 200 and not has_blocked and "adjusted stock" in str(body).lower():
    record("VULN-02", "Privilege Escalation", "CRITICAL",
           "Support rep can escalate privileges by supplying role_override='admin' in /api/v1/chat",
           False, f"Response: {body.get('content', '')[:100]}")
else:
    record("VULN-02", "Privilege Escalation", "CRITICAL",
           "Support rep role_override='admin' is safely blocked or ignored",
           True, "Privilege escalation rejected")

# VULN-03: Unauthenticated Access to Protected Endpoints
endpoints_to_test = [
    ("/api/v1/tools", "GET"),
    ("/api/v1/servers", "GET"),
    ("/api/v1/audit-logs", "GET"),
    ("/api/v1/api-keys", "GET"),
    ("/api/v1/stats", "GET"),
    ("/api/v1/tools/call", "POST"),
    ("/api/v1/chat", "POST"),
]

for ep, method in endpoints_to_test:
    st, body = make_req(ep, method=method, body={} if method == "POST" else None)
    if st == 401:
        record(f"VULN-03-{ep}", "Authentication", "HIGH", f"Unauthenticated {method} {ep} properly rejected (401)", True, "401 Unauthorized")
    else:
        record(f"VULN-03-{ep}", "Authentication", "HIGH", f"Unauthenticated {method} {ep} allowed through without credentials", False, f"HTTP {st}: {body}")

# VULN-04: Non-admin creating API Keys
st, body = make_req("/api/v1/api-keys", method="POST",
                    headers={"X-API-Key": "support-key-urumi-2026"},
                    body={"name": "Attacker Admin Key", "role": "admin"})
if st == 403:
    record("VULN-04", "Authorization", "CRITICAL", "Non-admin blocked from creating API keys", True, "403 Forbidden")
else:
    record("VULN-04", "Authorization", "CRITICAL", "Non-admin allowed to create API keys", False, f"HTTP {st}: {body}")

# VULN-05: Non-admin revoking API Keys
st, body = make_req("/api/v1/api-keys/key_admin_test", method="DELETE",
                    headers={"X-API-Key": "support-key-urumi-2026"})
if st == 403:
    record("VULN-05", "Authorization", "HIGH", "Non-admin blocked from revoking API keys", True, "403 Forbidden")
else:
    record("VULN-05", "Authorization", "HIGH", "Non-admin allowed to revoke API keys", False, f"HTTP {st}: {body}")

# VULN-06: Direct Tool Call RBAC enforcement
rbac_tests = [
    ("support-key-urumi-2026", "inventory__adjust_stock", {"sku": "SKU-1001", "delta": 5}, 403, "Support rep cannot adjust stock"),
    ("support-key-urumi-2026", "inventory__update_stock", {"sku": "SKU-1001", "quantity": 100}, 403, "Support rep cannot update stock"),
    ("support-key-urumi-2026", "analytics__get_revenue_summary", {}, 403, "Support rep cannot access revenue"),
    ("support-key-urumi-2026", "woocommerce__create_product", {"name": "Hacked", "regular_price": "10"}, 403, "Support rep cannot create products"),
    ("support-key-urumi-2026", "inventory__check_stock", {"sku": "SKU-1001"}, 200, "Support rep can check stock"),
    ("inv-key-urumi-2026", "analytics__get_revenue_summary", {}, 403, "Inventory manager cannot access revenue"),
    ("inv-key-urumi-2026", "inventory__check_stock", {"sku": "SKU-1001"}, 200, "Inventory manager can check stock"),
    ("analyst-key-urumi-2026", "inventory__adjust_stock", {"sku": "SKU-1001", "delta": 5}, 403, "Analyst cannot adjust stock"),
]

for idx, (key, tool, args, exp_status, desc) in enumerate(rbac_tests):
    st, body = make_req("/api/v1/tools/call", method="POST",
                        headers={"X-API-Key": key},
                        body={"tool": tool, "arguments": args})
    passed = (st == exp_status)
    record(f"VULN-06-{idx}", "RBAC Enforcement", "HIGH", desc, passed, f"Expected {exp_status}, got {st}")

# VULN-07: Parameter Tampering & Bounds Checks at Tool Execution
bounds_tests = [
    ("admin-key-urumi-2026", "inventory__adjust_stock", {"sku": "SKU-1001", "delta": 0}, "Zero delta adjustment should be rejected"),
    ("admin-key-urumi-2026", "inventory__adjust_stock", {"sku": "SKU-1001", "delta": 99999999}, "Extreme delta adjustment should be rejected"),
    ("admin-key-urumi-2026", "inventory__update_stock", {"sku": "SKU-1001", "quantity": -50}, "Negative quantity should be rejected"),
]

for idx, (key, tool, args, desc) in enumerate(bounds_tests):
    st, body = make_req("/api/v1/tools/call", method="POST",
                        headers={"X-API-Key": key},
                        body={"tool": tool, "arguments": args})
    # If upstream returns error or 400 or rejects, it is protected
    err_msg = str(body)
    is_rejected = st in (400, 422, 500) or "error" in err_msg.lower() or "invalid" in err_msg.lower() or "cannot" in err_msg.lower()
    record(f"VULN-07-{idx}", "Input Validation", "MEDIUM", desc, is_rejected, f"Status: {st}, Body: {err_msg[:80]}")

# Print Findings Table
print("=" * 80)
print(f"{'ID':<12} {'SEVERITY':<10} {'CATEGORY':<20} {'STATUS':<20} {'TITLE'}")
print("=" * 80)
vuln_count = 0
for f in findings:
    icon = "[OK]" if "PASS" in f["status"] else "[!!]"
    if "FAIL" in f["status"]:
        vuln_count += 1
    print(f"{f['id']:<12} {f['severity']:<10} {f['category']:<20} {icon + ' ' + f['status']:<20} {f['title'][:60]}")

print("=" * 80)
print(f"Total Tests: {len(findings)} | Passed: {len(findings) - vuln_count} | Vulnerabilities: {vuln_count}")
if vuln_count > 0:
    print("\nDETAILED VULNERABILITIES FOUND:")
    for f in findings:
        if "FAIL" in f["status"]:
            print(f"\n[!] {f['id']} - {f['severity']} - {f['title']}")
            print(f"    Details: {f['details']}")
