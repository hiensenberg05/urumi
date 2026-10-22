"""
Enterprise OAuth 2.0 & RFC 7519 JSON Web Token (JWT) Engine for Urumi MCP Gateway.
Implements zero-dependency HS256 HMAC cryptographic token generation, verification,
and identity provider federation with support for simulated SSO personas and external IdPs.
"""

import hmac
import hashlib
import base64
import json
import time
import os
from typing import Dict, Any, Optional, List, Tuple

# Secret key for JWT signature verification (configurable via env)
JWT_SECRET = os.environ.get("GATEWAY_JWT_SECRET", "urumi-mcp-gateway-super-secret-jwt-signing-key-2026")
JWT_ALGORITHM = "HS256"
JWT_ISSUER = "urumi-mcp-gateway"
DEFAULT_TOKEN_EXPIRY_SECONDS = 3600  # 1 hour

# Pre-configured Enterprise SSO Personas for instant zero-friction OAuth login & role testing
ENTERPRISE_PERSONAS: Dict[str, Dict[str, Any]] = {
    "alice": {
        "id": "usr_alice_admin_001",
        "name": "Alice Chen",
        "email": "alice.chen@urumi.enterprise",
        "avatar": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80",
        "role": "admin",
        "title": "Principal Platform Architect",
        "department": "Platform Engineering",
        "scopes": [
            "mcp:tools:read",
            "mcp:tools:execute",
            "mcp:admin",
            "mcp:policies:write",
            "mcp:servers:manage",
            "mcp:stores:manage",
        ],
    },
    "bob": {
        "id": "usr_bob_inv_002",
        "name": "Bob Martinez",
        "email": "bob.martinez@urumi.enterprise",
        "avatar": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80",
        "role": "inventory_manager",
        "title": "Global Supply Chain Lead",
        "department": "Inventory & Logistics",
        "scopes": [
            "mcp:tools:read",
            "mcp:tools:execute:inventory",
            "mcp:tools:execute:catalog",
        ],
    },
    "charlie": {
        "id": "usr_charlie_analyst_003",
        "name": "Charlie Zhang",
        "email": "charlie.zhang@urumi.enterprise",
        "avatar": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80",
        "role": "analyst",
        "title": "Senior Financial Data Analyst",
        "department": "Revenue & Business Intelligence",
        "scopes": [
            "mcp:tools:read",
            "mcp:tools:execute:analytics",
        ],
    },
    "dana": {
        "id": "usr_dana_support_004",
        "name": "Dana Davis",
        "email": "dana.davis@urumi.enterprise",
        "avatar": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80",
        "role": "support_rep",
        "title": "Customer Success Specialist",
        "department": "Customer Operations",
        "scopes": [
            "mcp:tools:read",
            "mcp:tools:execute:orders",
            "mcp:tools:execute:stock:read",
        ],
    },
}

SUPPORTED_PROVIDERS = [
    {
        "id": "mock-sso",
        "name": "Enterprise Corporate SSO (Okta / SAML / OIDC)",
        "icon": "shield-check",
        "status": "active",
        "description": "Pre-federated identity personas with RBAC scopes",
    },
    {
        "id": "google",
        "name": "Google Workspace OIDC",
        "icon": "google",
        "status": "ready",
        "description": "Federated Single Sign-On via Google Cloud Identity",
    },
    {
        "id": "github",
        "name": "GitHub Enterprise OAuth",
        "icon": "github",
        "status": "ready",
        "description": "Developer organization authentication",
    },
]

def _b64url_encode(data: bytes) -> str:
    """Encode bytes to base64url string without padding."""
    return base64.urlsafe_b64encode(data).decode("utf-8").rstrip("=")

def _b64url_decode(s: str) -> bytes:
    """Decode base64url string with required padding."""
    padding = 4 - (len(s) % 4)
    if padding != 4:
        s += "=" * padding
    return base64.urlsafe_b64decode(s.encode("utf-8"))

def sign_jwt(payload: Dict[str, Any], secret: str = JWT_SECRET) -> str:
    """
    Generate an RFC 7519 compliant HS256 signed JSON Web Token.
    """
    header = {
        "alg": JWT_ALGORITHM,
        "typ": "JWT",
    }
    
    encoded_header = _b64url_encode(json.dumps(header, separators=(",", ":")).encode("utf-8"))
    encoded_payload = _b64url_encode(json.dumps(payload, separators=(",", ":")).encode("utf-8"))
    
    signing_input = f"{encoded_header}.{encoded_payload}".encode("utf-8")
    signature = hmac.new(secret.encode("utf-8"), signing_input, hashlib.sha256).digest()
    encoded_signature = _b64url_encode(signature)
    
    return f"{encoded_header}.{encoded_payload}.{encoded_signature}"

def verify_jwt(token: str, secret: str = JWT_SECRET) -> Tuple[bool, Optional[Dict[str, Any]], Optional[str]]:
    """
    Cryptographically verify an HS256 JWT.
    Returns: (is_valid, decoded_payload, error_message)
    """
    parts = token.strip().split(".")
    if len(parts) != 3:
        return False, None, "Invalid JWT format: Token must have exactly 3 parts (header.payload.signature)."
    
    header_b64, payload_b64, signature_b64 = parts
    
    try:
        signing_input = f"{header_b64}.{payload_b64}".encode("utf-8")
        expected_sig = hmac.new(secret.encode("utf-8"), signing_input, hashlib.sha256).digest()
        actual_sig = _b64url_decode(signature_b64)
        
        # Constant time comparison to prevent timing attacks
        if not hmac.compare_digest(expected_sig, actual_sig):
            return False, None, "Cryptographic signature mismatch: Token has been tampered with or signed with an unknown key."
        
        # Decode and inspect payload
        payload_bytes = _b64url_decode(payload_b64)
        payload = json.loads(payload_bytes.decode("utf-8"))
        
        # Expiration check
        exp = payload.get("exp")
        now = int(time.time())
        if exp and now > exp:
            return False, None, f"Token expired at timestamp {exp} (current time: {now})."
        
        # Issuer check if provided
        iss = payload.get("iss")
        if iss and iss != JWT_ISSUER:
            return False, None, f"Untrusted token issuer '{iss}'."
        
        return True, payload, None
    except Exception as e:
        return False, None, f"Malformed token: {str(e)}"

def issue_access_token_for_persona(persona_key: str, expires_in: int = DEFAULT_TOKEN_EXPIRY_SECONDS) -> Dict[str, Any]:
    """
    Issue a signed JWT access token for a pre-configured persona.
    """
    persona = ENTERPRISE_PERSONAS.get(persona_key.lower())
    if not persona:
        raise ValueError(f"Unknown persona '{persona_key}'. Supported: {list(ENTERPRISE_PERSONAS.keys())}")
    
    now = int(time.time())
    payload = {
        "iss": JWT_ISSUER,
        "sub": persona["id"],
        "name": persona["name"],
        "email": persona["email"],
        "avatar": persona["avatar"],
        "role": persona["role"],
        "title": persona["title"],
        "department": persona["department"],
        "scopes": persona["scopes"],
        "iat": now,
        "exp": now + expires_in,
        "token_type": "Bearer",
        "auth_method": "oauth2_oidc",
    }
    
    token = sign_jwt(payload)
    return {
        "access_token": token,
        "token_type": "Bearer",
        "expires_in": expires_in,
        "expires_at": now + expires_in,
        "user": persona,
        "claims": payload,
    }

def issue_custom_access_token(
    user_id: str,
    name: str,
    email: str,
    role: str,
    scopes: Optional[List[str]] = None,
    avatar: Optional[str] = None,
    expires_in: int = DEFAULT_TOKEN_EXPIRY_SECONDS,
) -> Dict[str, Any]:
    """
    Issue a signed JWT access token for a custom or external identity.
    """
    now = int(time.time())
    user_info = {
        "id": user_id,
        "name": name,
        "email": email,
        "avatar": avatar or f"https://api.dicebear.com/7.x/identicon/svg?seed={email}",
        "role": role,
        "title": "OAuth Authenticated User",
        "department": "External SSO",
        "scopes": scopes or ["mcp:tools:read", "mcp:tools:execute"],
    }
    
    payload = {
        "iss": JWT_ISSUER,
        "sub": user_id,
        "name": name,
        "email": email,
        "avatar": user_info["avatar"],
        "role": role,
        "title": user_info["title"],
        "department": user_info["department"],
        "scopes": user_info["scopes"],
        "iat": now,
        "exp": now + expires_in,
        "token_type": "Bearer",
        "auth_method": "oauth2_oidc",
    }
    
    token = sign_jwt(payload)
    return {
        "access_token": token,
        "token_type": "Bearer",
        "expires_in": expires_in,
        "expires_at": now + expires_in,
        "user": user_info,
        "claims": payload,
    }
