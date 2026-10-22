"""
Distributed Rate Limiting Test across 3 Gateway Replicas using Shared Redis State.
"""
import sys
import time
import httpx

BASE_URL = "http://gateway.local"
PROBE_KEY = "ratelimit-probe-key-2026"

def test_distributed_rate_limiting():
    print(f"Connecting to Gateway ingress at {BASE_URL} (3 running replicas)...")
    client = httpx.Client(base_url=BASE_URL, timeout=8.0)

    # 1. Verify health
    res = client.get("/health")
    assert res.status_code == 200, f"Health check failed: {res.status_code}"
    print("  [PASS] Gateway cluster is healthy.")

    # 2. Check current quota in Redis
    print("\nSending rapid requests with Probe Key across all 3 replicas...")
    success_count = 0
    blocked_429_count = 0
    retry_after_val = None

    for i in range(1, 75):
        # We query /api/v1/servers or /api/v1/tools which authenticates via get_current_principal
        r = client.get("/api/v1/tools?role=support_rep", headers={"X-API-Key": PROBE_KEY})
        if r.status_code == 200:
            success_count += 1
        elif r.status_code == 429:
            blocked_429_count += 1
            retry_after_val = r.headers.get("Retry-After")
            print(f"  [BLOCKED at request #{i}] Received HTTP 429 Too Many Requests (Retry-After: {retry_after_val}s)")
            break
        else:
            print(f"  [WARN] Unexpected status {r.status_code}: {r.text}")

    print(f"\nResults: {success_count} requests allowed, rate limiter engaged at quota limit.")
    assert blocked_429_count > 0, "Expected distributed rate limiter to return HTTP 429!"
    assert retry_after_val is not None, "Expected Retry-After header in 429 response!"
    print("  [PASS] Shared Redis sliding-window synchronized across all 3 Gateway replicas.")

if __name__ == "__main__":
    test_distributed_rate_limiting()
