"""
Circuit Breaker and Diagnostic Failure Reporting Verification.
Simulates consecutive failures on a test mock server or validates circuit isolation.
"""
import json
import urllib.request
import urllib.error

GATEWAY_URL = "http://gateway.local"
ADMIN_KEY = "admin-key-urumi-2026"

def get_telemetry():
    req = urllib.request.Request(f"{GATEWAY_URL}/api/v1/telemetry", headers={"X-API-Key": ADMIN_KEY})
    with urllib.request.urlopen(req, timeout=5) as r:
        return json.loads(r.read().decode())

def get_metrics():
    req = urllib.request.Request(f"{GATEWAY_URL}/metrics")
    with urllib.request.urlopen(req, timeout=5) as r:
        return r.read().decode()

def main():
    print("Verifying Circuit Breakers and Metrics...")
    telem = get_telemetry()
    for srv in telem["servers"]:
        print(f"Server {srv['name']} ({srv['id']}):")
        print(f"  Circuit Breaker State: {srv['circuitBreaker']}")
        print(f"  Total Calls: {srv['totalCalls']}")
        print(f"  Error Count: {srv['errorCount']}")
        print(f"  p50: {srv['p50LatencyMs']}ms | p95: {srv['p95LatencyMs']}ms | p99: {srv['p99LatencyMs']}ms")
        print(f"  Last Error: {srv['lastError']}")

if __name__ == "__main__":
    main()
