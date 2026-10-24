"""
Enterprise Cryptographic Vault for Urumi MCP Gateway.
Provides authenticated symmetric encryption (Fernet / AES-128-CBC + HMAC-SHA256)
for upstream MCP credentials (bearer tokens, API keys, basic auth secrets) stored at rest.
"""

import os
import base64
import hashlib
import secrets
from typing import Optional
from cryptography.fernet import Fernet
from config import settings

def _derive_fernet_key(secret: str) -> bytes:
    """Derive a URL-safe base64-encoded 32-byte key from gateway secret."""
    digest = hashlib.sha256(secret.encode("utf-8")).digest()
    return base64.urlsafe_b64encode(digest)

class CredentialVault:
    def __init__(self, master_key: Optional[str] = None):
        key_source = master_key or os.environ.get("GATEWAY_MASTER_KEY") or os.environ.get("JWT_SECRET") or secrets.token_hex(32)
        self._fernet = Fernet(_derive_fernet_key(key_source))

    def encrypt(self, plaintext: str) -> str:
        """Encrypt secret plaintext into authenticated ciphertext string."""
        if not plaintext:
            return ""
        return self._fernet.encrypt(plaintext.encode("utf-8")).decode("utf-8")

    def decrypt(self, ciphertext: str) -> str:
        """Decrypt ciphertext back to plaintext secret."""
        if not ciphertext:
            return ""
        try:
            return self._fernet.decrypt(ciphertext.encode("utf-8")).decode("utf-8")
        except Exception as e:
            raise ValueError(f"Failed to decrypt credential: {str(e)}")

    @staticmethod
    def mask(secret: Optional[str]) -> str:
        """Return a masked preview of a secret token for safe UI display."""
        if not secret:
            return "None"
        if len(secret) <= 6:
            return "••••••"
        return f"••••••••{secret[-4:]}"

# Singleton instance
vault = CredentialVault()
