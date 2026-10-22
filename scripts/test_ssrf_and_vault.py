"""
Test script for SSRF protection and cryptographic vault in Gateway.
"""
import sys
import os

# Add apps/gateway to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "apps", "gateway")))

from ssrf_validator import validate_upstream_url
from crypto_vault import vault

def test_ssrf():
    print("Testing SSRF validation vectors...")
    
    # Prohibited: Cloud metadata
    ok, err = validate_upstream_url("http://169.254.169.254/latest/meta-data")
    assert not ok, f"Expected 169.254.169.254 to be blocked! Got: {ok}"
    print(f"  [PASS] 169.254.169.254 blocked: {err}")

    ok, err = validate_upstream_url("http://metadata.google.internal/computeMetadata/v1/")
    assert not ok, f"Expected metadata.google.internal to be blocked! Got: {ok}"
    print(f"  [PASS] metadata.google.internal blocked: {err}")

    # Prohibited: Loopback
    ok, err = validate_upstream_url("http://127.0.0.1:8080/mcp")
    assert not ok, f"Expected 127.0.0.1 to be blocked! Got: {ok}"
    print(f"  [PASS] 127.0.0.1 blocked: {err}")

    ok, err = validate_upstream_url("http://localhost:3000")
    assert not ok, f"Expected localhost to be blocked! Got: {ok}"
    print(f"  [PASS] localhost blocked: {err}")

    # Prohibited: Kubernetes API Server
    ok, err = validate_upstream_url("http://10.96.0.1:443")
    assert not ok, f"Expected 10.96.0.1 to be blocked! Got: {ok}"
    print(f"  [PASS] 10.96.0.1 blocked: {err}")

    # Prohibited: Schemes
    ok, err = validate_upstream_url("file:///etc/passwd")
    assert not ok, f"Expected file:// scheme to be blocked! Got: {ok}"
    print(f"  [PASS] file:// blocked: {err}")

    ok, err = validate_upstream_url("gopher://127.0.0.1:70")
    assert not ok, f"Expected gopher:// to be blocked! Got: {ok}"
    print(f"  [PASS] gopher:// blocked: {err}")

    # Allowed: Normal external URL
    ok, err = validate_upstream_url("https://api.github.com/mcp")
    assert ok, f"Expected api.github.com to be allowed! Got err: {err}"
    print("  [PASS] api.github.com allowed.")

    # Allowed: Cluster internal service
    ok, err = validate_upstream_url("http://woocommerce-mcp.default.svc.cluster.local:8001/mcp")
    assert ok, f"Expected cluster-internal service to be allowed! Got err: {err}"
    print("  [PASS] woocommerce-mcp.default.svc.cluster.local allowed.")

def test_vault():
    print("\nTesting CredentialVault encryption at rest...")
    secret = "sk-live-super-secret-enterprise-mcp-key-12345"
    encrypted = vault.encrypt(secret)
    assert encrypted != secret, "Encrypted ciphertext should not match secret"
    assert "sk-live" not in encrypted, "Ciphertext should not contain plaintext fragment"
    decrypted = vault.decrypt(encrypted)
    assert decrypted == secret, "Decrypted secret should match original"
    masked = vault.mask(secret)
    assert masked.endswith("2345") and masked.startswith("••••"), f"Masked format unexpected: {masked}"
    print(f"  [PASS] Plaintext: {vault.mask(secret)}")
    print(f"  [PASS] Encrypted ciphertext: {encrypted[:35]}...")
    print(f"  [PASS] Decrypted matches plaintext successfully.")

if __name__ == "__main__":
    test_ssrf()
    test_vault()
    print("\nALL SSRF & CRYPTO VAULT TESTS PASSED!")
