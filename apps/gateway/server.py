import asyncio
import hashlib
import os
import time
import uuid
from typing import Any, Dict, List, Optional
import httpx
from fastapi import FastAPI, Depends, HTTPException, Header, Query, Request, Response, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, FileResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel, Field
import uvicorn

from config import settings
from rbac import (
    filter_allowed_tools,
    get_tool_risk,
    ROLE_PERMISSIONS,
    ALL_ROLES,
    ROLE_ADMIN,
)
from policy_engine import policy_engine
# Alias is_tool_allowed to the dynamic policy engine so all downstream calls use dynamic rules
is_tool_allowed = policy_engine.is_tool_allowed
import jwt_auth
from rate_limiter import RateLimiter
from audit_logger import audit_logger
from upstream_manager import upstream_manager
from provisioner import provisioning_engine, CreateStoreRequest
from hosted_manager import hosted_manager, HostedDeployRequest
from metrics import telemetry
from ssrf_validator import validate_upstream_url

app = FastAPI(
    title="Unified Team MCP Gateway",
    description="Enterprise Kubernetes Gateway with Authentication, RBAC, Rate Limiting, and MCP Tool Aggregation",
    version="1.0.0",
)

# Enable CORS for Frontend UI (localhost:3000, Ingress store.local, etc.)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

rate_limiter = RateLimiter(
    requests_per_minute=settings.rate_limit_per_minute,
    burst=settings.rate_limit_burst,
)

# In-memory API keys storage (dual-indexed by raw token & SHA-256 hash for secure zero-trust verification)
api_keys_db: Dict[str, Dict[str, Any]] = {}
for key, data in settings.default_api_keys.items():
    key_id = f"key_{uuid.uuid4().hex[:8]}"
    key_hash = hashlib.sha256(key.encode()).hexdigest()
    item = {
        "id": key_id,
        "name": data["name"],
        "keyPrefix": f"{key[:8]}...",
        "role": data["role"],
        "scope": data["scope"],
        "createdAt": time.strftime("%Y-%m-%d %H:%M:%S UTC"),
        "lastUsedAt": "never",
        "expiresAt": "Never",
        "isRevoked": False,
    }
    api_keys_db[key] = item
    api_keys_db[key_hash] = item

class Principal:
    def __init__(
        self,
        key: str,
        name: str,
        role: str,
        scope: str,
        user_id: str = "",
        auth_type: str = "API Key",
        email: str = "",
        avatar: str = "",
    ):
        self.key = key
        self.name = name
        self.role = role
        self.scope = scope
        self.user_id = user_id
        self.auth_type = auth_type
        self.email = email
        self.avatar = avatar

async def get_current_principal(
    request: Request,
    x_api_key: Optional[str] = Header(None, alias="X-API-Key"),
    authorization: Optional[str] = Header(None),
    api_key: Optional[str] = Query(None),
) -> Principal:
    token = None
    if x_api_key:
        token = x_api_key
    elif authorization and authorization.startswith("Bearer "):
        token = authorization[7:].strip()
    elif api_key:
        token = api_key

    if not token:
        # Check if caller is requesting health or public endpoint
        if request.url.path in ("/health", "/", "/docs", "/openapi.json", "/metrics", "/api/v1/auth/providers"):
            return Principal(key="anonymous", name="Anonymous", role="public", scope="none")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing authentication credentials. Provide 'X-API-Key' header or 'Bearer <token>'.",
        )

    # 1. First check if token is an RFC 7519 Cryptographic JWT (3 parts separated by '.')
    if token.count(".") == 2:
        is_valid, payload, err = jwt_auth.verify_jwt(token)
        if not is_valid or not payload:
            telemetry.record_rbac_violation("unknown", "jwt_auth_failure")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail=f"Cryptographic JWT authentication failed: {err}",
            )
        
        user_role = payload.get("role", "support_rep")
        user_name = payload.get("name", "OAuth User")
        user_id = payload.get("sub", f"usr_{uuid.uuid4().hex[:6]}")
        user_email = payload.get("email", f"{user_name.lower().replace(' ', '.')}@urumi.enterprise")
        user_avatar = payload.get("avatar", "")
        scopes_list = payload.get("scopes", [])
        scopes_str = ",".join(scopes_list) if isinstance(scopes_list, list) else str(scopes_list)

        # Enforce rate limiting on JWT user (exempt admin)
        if user_role != ROLE_ADMIN:
            allowed, retry_after = await rate_limiter.check_rate_limit(user_id)
            if not allowed:
                telemetry.record_rate_limit(user_id)
                audit_logger.log_event(
                    principal=user_name,
                    user_role=user_role,
                    tool_name="rate_limit_exceeded",
                    target_server="gateway",
                    status="429 Rate Limit",
                    duration_ms=0.5,
                    client_ip=request.client.host if request.client else "127.0.0.1",
                )
                raise HTTPException(
                    status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                    detail=f"Rate limit exceeded. Try again in {retry_after} seconds.",
                    headers={"Retry-After": str(int(retry_after) + 1)},
                )

        return Principal(
            key=token,
            name=user_name,
            role=user_role,
            scope=scopes_str,
            user_id=user_id,
            auth_type="OAuth 2.0 (JWT)",
            email=user_email,
            avatar=user_avatar,
        )

    # 2. Backward Compatibility: Check legacy API key via cryptographic lookup
    token_hash = hashlib.sha256(token.encode()).hexdigest()
    key_info = api_keys_db.get(token) or api_keys_db.get(token_hash)
    if not key_info or key_info.get("isRevoked"):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or revoked API key.",
        )

    # Update last used timestamp
    key_info["lastUsedAt"] = time.strftime("%Y-%m-%d %H:%M:%S UTC")

    # Enforce Rate Limiting (exempt admin from polling throttling)
    if key_info.get("role") != ROLE_ADMIN:
        allowed, retry_after = await rate_limiter.check_rate_limit(token)
        if not allowed:
            telemetry.record_rate_limit(token)
            audit_logger.log_event(
                principal=key_info["name"],
                user_role=key_info["role"],
                tool_name="rate_limit_exceeded",
                target_server="gateway",
                status="429 Rate Limit",
                duration_ms=0.5,
                client_ip=request.client.host if request.client else "127.0.0.1",
            )
            raise HTTPException(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                detail=f"Rate limit exceeded. Try again in {retry_after} seconds.",
                headers={"Retry-After": str(int(retry_after) + 1)},
            )

    return Principal(
        key=token,
        name=key_info["name"],
        role=key_info["role"],
        scope=key_info["scope"],
        user_id=key_info.get("id", "legacy_key"),
        auth_type="API Key",
        email=f"{key_info['role']}@urumi.enterprise",
        avatar="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80" if key_info["role"] != ROLE_ADMIN else "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80",
    )

# -------------------------------------------------------------
# Core Health & Status
# -------------------------------------------------------------
@app.get("/health")
async def health_check():
    servers = list(upstream_manager.servers.values())
    return {
        "status": "healthy",
        "service": "team-mcp-gateway",
        "timestamp": time.strftime("%Y-%m-%d %H:%M:%S UTC"),
        "upstreams": [
            {
                "id": s.id,
                "name": s.name,
                "status": s.status,
                "endpoint": s.endpoint_url,
                "ping_ms": s.ping_ms,
            }
            for s in servers
        ],
    }

# -------------------------------------------------------------
# Upstream Servers API
# -------------------------------------------------------------
@app.get("/api/v1/servers")
async def list_servers(principal: Principal = Depends(get_current_principal)):
    result = []
    for s in upstream_manager.servers.values():
        result.append({
            "id": s.id,
            "name": s.name,
            "tag": s.tag,
            "endpointUrl": s.endpoint_url,
            "status": s.status,
            "transport": s.transport,
            "pingMs": s.ping_ms,
            "uptimePct": s.uptime_pct,
            "toolsCount": len(s.tools),
            "discoveredTools": [t["namespacedName"] for t in s.tools],
            "lastChecked": s.last_checked,
            "authType": getattr(s, "auth_type", "API Key / RBAC"),
        })
    return result

@app.post("/api/v1/servers/{server_id}/toggle")
async def toggle_server(
    server_id: str,
    principal: Principal = Depends(get_current_principal),
):
    if principal.role != ROLE_ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only administrators can enable or disable upstream servers.",
        )
    srv = upstream_manager.toggle_server_status(server_id)
    if not srv:
        raise HTTPException(status_code=404, detail=f"Server '{server_id}' not found.")
    
    audit_logger.log_event(
        principal=principal.name,
        user_role=principal.role,
        tool_name=f"server_toggle_{srv.status.lower()}",
        target_server=srv.name,
        status=f"200 Server {srv.status}",
        duration_ms=1.0,
    )
    return {"id": srv.id, "name": srv.name, "status": srv.status}

class RegisterServerRequest(BaseModel):
    name: str
    endpoint_url: str
    auth_type: str = "none"
    auth_token: Optional[str] = None
    transport: str = "http"
    tag: Optional[str] = "CUSTOM_UPSTREAM"

@app.post("/api/v1/servers", status_code=status.HTTP_201_CREATED)
async def register_server(
    req: RegisterServerRequest,
    principal: Principal = Depends(get_current_principal),
):
    """Register an external upstream MCP server with Backend SSRF Protection."""
    if principal.role != ROLE_ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only administrators can register upstream MCP servers.",
        )

    # 1. Backend SSRF Validation (OWASP A10 / CWE-918)
    is_safe, error_reason = validate_upstream_url(req.endpoint_url)
    if not is_safe:
        audit_logger.log_event(
            principal=principal.name,
            user_role=principal.role,
            tool_name="ssrf_blocked_server_register",
            target_server="ssrf_perimeter",
            status="400 Bad Request",
            duration_ms=1.0,
            params={"endpoint_url": req.endpoint_url},
            policy_rule_detail=f"Backend SSRF Protection Blocked: {error_reason}",
        )
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=error_reason,
        )

    # 2. Register Server in upstream_manager
    srv = await upstream_manager.register_custom_server(
        name=req.name,
        endpoint_url=req.endpoint_url,
        auth_type=req.auth_type,
        auth_token=req.auth_token,
        transport=req.transport,
        tag=req.tag or "CUSTOM_UPSTREAM",
    )

    audit_logger.log_event(
        principal=principal.name,
        user_role=principal.role,
        tool_name="server_register",
        target_server=srv.name,
        status="201 Registered",
        duration_ms=2.0,
        params={"server_id": srv.id, "endpoint_url": srv.endpoint_url},
    )

    return {
        "id": srv.id,
        "name": srv.name,
        "tag": srv.tag,
        "endpointUrl": srv.endpoint_url,
        "status": srv.status,
        "transport": srv.transport,
        "toolsCount": len(srv.tools),
        "discoveredTools": [t["namespacedName"] for t in srv.tools],
    }

@app.delete("/api/v1/servers/{server_id}")
async def unregister_server_endpoint(
    server_id: str,
    principal: Principal = Depends(get_current_principal),
):
    """Unregister an upstream MCP server."""
    if principal.role != ROLE_ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only administrators can remove upstream servers.",
        )
    ok = upstream_manager.unregister_server(server_id)
    if not ok:
        raise HTTPException(status_code=404, detail=f"Server '{server_id}' not found.")
    
    audit_logger.log_event(
        principal=principal.name,
        user_role=principal.role,
        tool_name="server_unregister",
        target_server=server_id,
        status="200 Deleted",
        duration_ms=1.0,
    )
    return {"status": "deleted", "id": server_id}

@app.on_event("startup")
async def on_startup():
    asyncio.create_task(provisioning_engine.reconcile_existing_stores())
    asyncio.create_task(hosted_manager.reconcile_existing())

# -------------------------------------------------------------
# Multi-Store Tenant Management API
# -------------------------------------------------------------
@app.get("/api/v1/stores")
async def list_stores(principal: Principal = Depends(get_current_principal)):
    return list(provisioning_engine.stores.values())

@app.post("/api/v1/stores")
async def create_store(
    req: CreateStoreRequest,
    principal: Principal = Depends(get_current_principal),
):
    if principal.role != ROLE_ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only administrators can provision new store tenants.",
        )
    try:
        tenant = await provisioning_engine.create_store(req)
        audit_logger.log_event(
            principal=principal.name,
            user_role=principal.role,
            tool_name="store_provision",
            target_server="k8s_provisioner",
            status="202 Provisioning",
            duration_ms=5.0,
        )
        return tenant
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to start store provisioning: {str(e)}")

@app.delete("/api/v1/stores/{store_id}")
async def delete_store(
    store_id: str,
    principal: Principal = Depends(get_current_principal),
):
    if principal.role != ROLE_ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only administrators can delete store tenants.",
        )
    success = await provisioning_engine.delete_store(store_id)
    if not success:
        raise HTTPException(status_code=404, detail=f"Store '{store_id}' not found.")
    audit_logger.log_event(
        principal=principal.name,
        user_role=principal.role,
        tool_name="store_teardown",
        target_server="k8s_provisioner",
        status="200 Deleted",
        duration_ms=5.0,
    )
    return {"message": f"Store '{store_id}' teardown initiated."}

@app.post("/api/v1/stores/{store_id}/retry")
async def retry_store(
    store_id: str,
    principal: Principal = Depends(get_current_principal),
):
    if principal.role != ROLE_ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only administrators can retry store provisioning.",
        )
    tenant = await provisioning_engine.retry_store(store_id)
    if not tenant:
        raise HTTPException(status_code=404, detail=f"Store '{store_id}' not found.")
    return tenant

# -------------------------------------------------------------
# Hosted MCP Servers on Kubernetes (Differentiator #5)
# -------------------------------------------------------------
@app.get("/api/v1/hosted-servers/templates")
async def list_hosted_templates(principal: Principal = Depends(get_current_principal)):
    return hosted_manager.get_templates()

@app.get("/api/v1/hosted-servers")
async def list_hosted_servers(principal: Principal = Depends(get_current_principal)):
    return hosted_manager.list_hosted_servers()

@app.post("/api/v1/hosted-servers")
async def deploy_hosted_server(
    req: HostedDeployRequest,
    principal: Principal = Depends(get_current_principal),
):
    if principal.role != ROLE_ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only administrators can deploy hosted MCP server pods.",
        )
    try:
        rec = await hosted_manager.deploy_server(req)
        audit_logger.log_event(
            principal=principal.name,
            user_role=principal.role,
            tool_name="hosted_server_deploy",
            target_server=rec.name,
            status="202 Provisioning",
            duration_ms=1.0,
        )
        return rec
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Deployment error: {str(e)}")

@app.post("/api/v1/hosted-servers/{server_id}/scale")
async def scale_hosted_server(
    server_id: str,
    replicas: int = Query(..., ge=0, le=1),
    principal: Principal = Depends(get_current_principal),
):
    if principal.role != ROLE_ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only administrators can scale hosted MCP servers.",
        )
    try:
        rec = await hosted_manager.scale_server(server_id, replicas)
        action = "wake" if replicas > 0 else "sleep"
        audit_logger.log_event(
            principal=principal.name,
            user_role=principal.role,
            tool_name=f"hosted_server_{action}",
            target_server=rec.name,
            status=f"200 {rec.status}",
            duration_ms=1.0,
        )
        return rec
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/v1/hosted-servers/{server_id}/logs")
async def get_hosted_server_logs(
    server_id: str,
    tail: int = Query(100, ge=10, le=500),
    principal: Principal = Depends(get_current_principal),
):
    logs = await hosted_manager.get_logs(server_id, tail=tail)
    return {"id": server_id, "logs": logs}

@app.delete("/api/v1/hosted-servers/{server_id}")
async def delete_hosted_server(
    server_id: str,
    principal: Principal = Depends(get_current_principal),
):
    if principal.role != ROLE_ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only administrators can delete hosted MCP servers.",
        )
    try:
        await hosted_manager.delete_server(server_id)
        audit_logger.log_event(
            principal=principal.name,
            user_role=principal.role,
            tool_name="hosted_server_teardown",
            target_server=server_id,
            status="200 Deleted",
            duration_ms=1.0,
        )
        return {"status": "deleted", "id": server_id}
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# -------------------------------------------------------------
# Tools & RBAC Discovery API
# -------------------------------------------------------------
@app.get("/api/v1/tools")
async def list_tools(
    role: Optional[str] = Query(None),
    principal: Principal = Depends(get_current_principal),
):
    target_role = role or principal.role
    all_tools = upstream_manager.get_all_tools()
    
    # Enrich tools with caller's policy check
    enriched = []
    for t in all_tools:
        allowed = is_tool_allowed(target_role, t["namespacedName"])
        enriched.append({
            **t,
            "policy": "ALLOW" if allowed else "DENY",
            "isAllowed": allowed,
            "effectiveRule": f"Role '{target_role}': {'Permitted' if allowed else 'Blocked'}",
        })
    return enriched

@app.get("/api/v1/roles")
async def list_roles(principal: Principal = Depends(get_current_principal)):
    all_tools = [t["namespacedName"] for t in upstream_manager.get_all_tools()]
    return [
        {
            "role": r,
            "name": r.replace("_", " ").title(),
            "description": f"Role with {len(ROLE_PERMISSIONS.get(r, set()))} assigned capabilities",
            "allowedTools": list(ROLE_PERMISSIONS.get(r, set())),
            "totalTools": len(all_tools),
        }
        for r in ALL_ROLES
    ]

# -------------------------------------------------------------
# API Keys Management API
# -------------------------------------------------------------
class CreateApiKeyRequest(BaseModel):
    name: str
    role: str = Field(default="support_rep")
    scope: str = Field(default="read:write")

@app.get("/api/v1/api-keys")
async def get_api_keys(principal: Principal = Depends(get_current_principal)):
    if principal.role != ROLE_ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only administrators can view workspace API keys.",
        )
    # Mask full secrets to prevent token exfiltration, deduplicate by key ID
    unique_items = {k["id"]: k for k in api_keys_db.values()}.values()
    return [
        {
            **k,
            "key": f"{k.get('keyPrefix', 'key-****')[:8]}********",
        }
        for k in unique_items
    ]

@app.post("/api/v1/api-keys", status_code=status.HTTP_201_CREATED)
async def create_api_key(
    req: CreateApiKeyRequest,
    principal: Principal = Depends(get_current_principal),
):
    if principal.role != ROLE_ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only administrators can generate new API keys.",
        )
    if req.role not in ALL_ROLES:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid role '{req.role}'. Choose from {ALL_ROLES}.",
        )

    new_key = f"{req.role[:3]}-key-{uuid.uuid4().hex[:12]}"
    new_id = f"key_{uuid.uuid4().hex[:8]}"
    key_hash = hashlib.sha256(new_key.encode()).hexdigest()
    item = {
        "id": new_id,
        "name": req.name,
        "keyPrefix": f"{new_key[:8]}...",
        "role": req.role,
        "scope": req.scope,
        "createdAt": time.strftime("%Y-%m-%d %H:%M:%S UTC"),
        "lastUsedAt": "never",
        "expiresAt": "Never",
        "isRevoked": False,
    }
    api_keys_db[new_key] = item
    api_keys_db[key_hash] = item
    return {**item, "key": new_key}

@app.delete("/api/v1/api-keys/{key_id}")
async def revoke_api_key(
    key_id: str,
    principal: Principal = Depends(get_current_principal),
):
    if principal.role != ROLE_ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only administrators can revoke API keys.",
        )
    target_hash = hashlib.sha256(key_id.encode()).hexdigest()
    found = False
    for khash, v in api_keys_db.items():
        if v["id"] == key_id or khash == key_id or khash == target_hash:
            v["isRevoked"] = True
            found = True
    if found:
        return {"status": "success", "message": f"API Key '{key_id}' has been revoked."}
    raise HTTPException(status_code=404, detail="API Key not found.")

# -------------------------------------------------------------
# Enterprise OAuth 2.0 & Identity Management Endpoints
# -------------------------------------------------------------
class OAuthTokenRequest(BaseModel):
    grant_type: str = Field(default="persona", description="persona, authorization_code, or password")
    persona: Optional[str] = Field(default="alice", description="alice, bob, charlie, or dana")
    username: Optional[str] = None
    email: Optional[str] = None
    role: Optional[str] = Field(default="support_rep")
    code: Optional[str] = None
    provider: Optional[str] = Field(default="mock-sso")

class PolicyUpdateItem(BaseModel):
    role: str
    tool: str
    policy: str = Field(default="INHERIT", description="ALLOW, DENY, or INHERIT")

class BatchPolicyUpdateRequest(BaseModel):
    updates: List[PolicyUpdateItem]

@app.get("/api/v1/auth/providers")
async def list_auth_providers():
    """List supported enterprise OAuth 2.0 / OIDC identity providers and quick test personas."""
    return {
        "providers": jwt_auth.SUPPORTED_PROVIDERS,
        "personas": [
            {
                "key": k,
                "name": p["name"],
                "role": p["role"],
                "email": p["email"],
                "title": p["title"],
                "avatar": p["avatar"],
                "department": p["department"],
                "scopes": p["scopes"],
            }
            for k, p in jwt_auth.ENTERPRISE_PERSONAS.items()
        ]
    }

@app.post("/api/v1/auth/oauth/token")
async def issue_oauth_token(req: OAuthTokenRequest):
    """
    OAuth 2.0 Token Authority: Exchange credentials, authorization code, or test persona for an RFC 7519 signed JWT.
    """
    if req.grant_type == "persona" or (req.persona and req.persona in jwt_auth.ENTERPRISE_PERSONAS):
        persona_key = req.persona or "alice"
        try:
            token_response = jwt_auth.issue_access_token_for_persona(persona_key)
            audit_logger.log_event(
                principal=token_response["user"]["name"],
                user_role=token_response["user"]["role"],
                tool_name="oauth_token_issue",
                target_server="jwt_authority",
                status="200 Issued",
                duration_ms=1.0,
            )
            return token_response
        except Exception as e:
            raise HTTPException(status_code=400, detail=str(e))
    
    # Custom / Federated IdP login flow
    user_name = req.username or (req.email.split("@")[0].title() if req.email else "OAuth User")
    user_email = req.email or f"{user_name.lower().replace(' ', '.')}@urumi.enterprise"
    user_id = f"usr_{uuid.uuid4().hex[:8]}"
    role = req.role if req.role in ALL_ROLES else "support_rep"
    
    token_response = jwt_auth.issue_custom_access_token(
        user_id=user_id,
        name=user_name,
        email=user_email,
        role=role,
    )
    audit_logger.log_event(
        principal=user_name,
        user_role=role,
        tool_name="oauth_custom_login",
        target_server="jwt_authority",
        status="200 Issued",
        duration_ms=1.0,
    )
    return token_response

@app.get("/api/v1/auth/me")
async def get_current_user_profile(principal: Principal = Depends(get_current_principal)):
    """
    Introspect current authenticated caller identity, token type, and cryptographic claims.
    """
    is_jwt = principal.auth_type == "OAuth 2.0 (JWT)"
    claims = None
    if is_jwt:
        _, claims, _ = jwt_auth.verify_jwt(principal.key)
    
    return {
        "principal": {
            "id": principal.user_id,
            "name": principal.name,
            "email": principal.email,
            "role": principal.role,
            "avatar": principal.avatar,
            "authType": principal.auth_type,
            "scope": principal.scope,
            "scopes": [s.strip() for s in principal.scope.split(",") if s.strip()],
        },
        "token": {
            "type": principal.auth_type,
            "prefix": f"{principal.key[:10]}...",
            "isJwt": is_jwt,
            "claims": claims,
        }
    }

# -------------------------------------------------------------
# Dynamic Policy Studio Endpoints
# -------------------------------------------------------------
@app.get("/api/v1/policies")
async def get_dynamic_policies(principal: Principal = Depends(get_current_principal)):
    """Get the active dynamic policy matrix across all tools and roles."""
    tools = upstream_manager.get_all_tools()
    return policy_engine.get_policy_matrix(tools)

@app.put("/api/v1/policies")
async def update_dynamic_policies(
    req: BatchPolicyUpdateRequest,
    principal: Principal = Depends(get_current_principal),
):
    """Admin-only update of real-time role/tool permissions."""
    if principal.role != ROLE_ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only administrators can modify dynamic tool authorization policies.",
        )
    
    updates_dict = [u.model_dump() for u in req.updates]
    updated_count = policy_engine.batch_set_policies(updates_dict, modified_by=principal.name)
    
    audit_logger.log_event(
        principal=principal.name,
        user_role=principal.role,
        tool_name="policy_matrix_update",
        target_server="policy_engine",
        status=f"200 OK ({updated_count} updated)",
        duration_ms=2.0,
        params={"updatesCount": updated_count, "items": updates_dict[:5]},
        policy_rule_detail=f"Admin {principal.name} modified {updated_count} cluster policy rules",
    )
    
    tools = upstream_manager.get_all_tools()
    return {
        "status": "success",
        "updatedCount": updated_count,
        "matrix": policy_engine.get_policy_matrix(tools),
    }

@app.post("/api/v1/policies/reset")
async def reset_dynamic_policies(principal: Principal = Depends(get_current_principal)):
    """Admin-only reset of all policy overrides back to baseline defaults."""
    if principal.role != ROLE_ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only administrators can reset cluster authorization policies.",
        )
    
    policy_engine.reset_policies(modified_by=principal.name)
    audit_logger.log_event(
        principal=principal.name,
        user_role=principal.role,
        tool_name="policy_matrix_reset",
        target_server="policy_engine",
        status="200 Reset",
        duration_ms=1.0,
        policy_rule_detail=f"Admin {principal.name} restored factory baseline policies",
    )
    
    tools = upstream_manager.get_all_tools()
    return {
        "status": "reset",
        "message": "All cluster tool policies reverted to baseline defaults.",
        "matrix": policy_engine.get_policy_matrix(tools),
    }

# -------------------------------------------------------------
# Audit Logs & Telemetry API
# -------------------------------------------------------------
@app.get("/api/v1/audit-logs")
async def get_audit_logs(
    limit: int = Query(50, ge=1, le=200),
    role: Optional[str] = Query(None),
    status_filter: Optional[str] = Query(None, alias="status"),
    principal: Principal = Depends(get_current_principal),
):
    return audit_logger.get_logs(limit=limit, role=role, status=status_filter)

@app.get("/api/v1/stats")
async def get_stats(principal: Principal = Depends(get_current_principal)):
    stats = audit_logger.get_stats()
    stats["active_servers"] = sum(1 for s in upstream_manager.servers.values() if s.status == "Connected")
    stats["total_servers"] = len(upstream_manager.servers)
    stats["total_tools"] = len(upstream_manager.get_all_tools())
    stats["total_api_keys"] = len([k for k in api_keys_db.values() if not k["isRevoked"]])
    return stats

# -------------------------------------------------------------
# Enterprise Observability & Prometheus Metrics Endpoints
# -------------------------------------------------------------
@app.get("/metrics")
async def get_prometheus_metrics():
    """OpenMetrics / Prometheus exposition endpoint for cluster scraping."""
    content = telemetry.get_prometheus_metrics(
        upstream_manager.servers, upstream_manager.get_all_tools()
    )
    return Response(content=content, media_type="text/plain; version=0.0.4")

@app.get("/api/v1/telemetry")
async def get_telemetry_report(principal: Principal = Depends(get_current_principal)):
    """High-resolution SRE telemetry with per-server percentiles and circuit breakers."""
    return telemetry.get_telemetry_json(
        upstream_manager.servers, upstream_manager.get_all_tools()
    )

# -------------------------------------------------------------
# Tool Execution API with RBAC Enforcement & Telemetry
# -------------------------------------------------------------
def validate_tool_arguments(tool_name: str, args: Dict[str, Any]) -> Optional[str]:
    """Validate tool parameters at the Gateway perimeter."""
    if "update_stock" in tool_name:
        qty = args.get("quantity")
        if qty is None:
            return "Missing required parameter 'quantity'."
        if not isinstance(qty, (int, float)) or qty < 0:
            return f"Invalid inventory quantity: {qty}. Stock cannot be negative."
        if qty > 500000:
            return f"Quantity {qty} exceeds maximum batch threshold (500,000 units)."

    if "adjust_stock" in tool_name:
        delta = args.get("delta")
        if delta is None:
            return "Missing required parameter 'delta'."
        try:
            delta_int = int(delta)
        except (ValueError, TypeError):
            return f"Invalid delta value '{delta}'. Must be an integer."
        if delta_int == 0:
            return "Stock delta cannot be 0. Provide a non-zero positive or negative adjustment."
        if abs(delta_int) > 50000:
            return f"Adjustment delta {delta} exceeds safe threshold of ±50,000 units."

    if "create_product" in tool_name:
        price = args.get("regular_price")
        if price is not None:
            try:
                p = float(price)
                if p < 0:
                    return "Product price cannot be negative."
                if p > 1000000:
                    return "Product price exceeds ceiling of $1,000,000."
            except (ValueError, TypeError):
                return f"Invalid price format '{price}'."

    if "batch_check_stock" in tool_name:
        skus = args.get("skus")
        if not isinstance(skus, list) or len(skus) == 0:
            return "Parameter 'skus' must be a non-empty list of SKU strings."
        if len(skus) > 100:
            return f"Batch size {len(skus)} exceeds limit of 100 SKUs."

    return None

class ToolCallRequest(BaseModel):
    tool: str
    arguments: Dict[str, Any] = Field(default_factory=dict)

@app.post("/api/v1/tools/call")
async def call_tool(
    req: ToolCallRequest,
    request: Request,
    principal: Principal = Depends(get_current_principal),
):
    start_time = time.monotonic()
    client_ip = request.client.host if request.client else "127.0.0.1"
    client_agent = request.headers.get("User-Agent", "MCP-Client/1.0")

    # 1. Enforce RBAC
    if not is_tool_allowed(principal.role, req.tool):
        telemetry.record_rbac_violation(principal.role, req.tool)
        duration_ms = (time.monotonic() - start_time) * 1000
        audit_logger.log_event(
            principal=principal.name,
            user_role=principal.role,
            tool_name=req.tool,
            target_server="gateway",
            status="403 Blocked",
            duration_ms=duration_ms,
            client_ip=client_ip,
            client_agent=client_agent,
            params=req.arguments,
            policy_rule_detail=f"RBAC Policy Violation: Role '{principal.role}' is not authorized to invoke '{req.tool}'",
            upstream_status="Skipped",
        )
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=f"Permission Denied: Role '{principal.role}' is not authorized to execute tool '{req.tool}'.",
        )

    # 2. Enforce Tool Parameter Bounds Validation at Perimeter
    val_err = validate_tool_arguments(req.tool, req.arguments)
    if val_err:
        duration_ms = (time.monotonic() - start_time) * 1000
        audit_logger.log_event(
            principal=principal.name,
            user_role=principal.role,
            tool_name=req.tool,
            target_server="gateway",
            status="400 Bad Request",
            duration_ms=duration_ms,
            client_ip=client_ip,
            client_agent=client_agent,
            params=req.arguments,
            policy_rule_detail=f"Parameter Validation Error: {val_err}",
            upstream_status="Rejected",
        )
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid Tool Arguments: {val_err}",
        )

    # 3. Dispatch to Upstream MCP Server
    srv = upstream_manager.get_server_for_tool(req.tool)
    target_server_name = srv.name if srv else "unknown"

    try:
        result = await upstream_manager.execute_tool(req.tool, req.arguments, user_role=principal.role)
        duration_ms = (time.monotonic() - start_time) * 1000
        audit_logger.log_event(
            principal=principal.name,
            user_role=principal.role,
            tool_name=req.tool,
            target_server=target_server_name,
            status="200 OK",
            duration_ms=duration_ms,
            client_ip=client_ip,
            client_agent=client_agent,
            params=req.arguments,
            upstream_status="Dispatched",
        )
        return {
            "status": "success",
            "tool": req.tool,
            "duration_ms": round(duration_ms, 1),
            "result": result,
        }
    except Exception as e:
        duration_ms = (time.monotonic() - start_time) * 1000
        audit_logger.log_event(
            principal=principal.name,
            user_role=principal.role,
            tool_name=req.tool,
            target_server=target_server_name,
            status="500 Error",
            duration_ms=duration_ms,
            client_ip=client_ip,
            client_agent=client_agent,
            params=req.arguments,
            upstream_status="Dispatched",
        )
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Upstream tool execution error: {str(e)}",
        )

# -------------------------------------------------------------
# Natural Language Playground Execution API
# -------------------------------------------------------------
class ChatRequest(BaseModel):
    message: str
    role_override: Optional[str] = None
    history: Optional[List[Dict[str, str]]] = Field(default_factory=list)

@app.post("/api/v1/chat")
async def chat_execute(
    req: ChatRequest,
    principal: Principal = Depends(get_current_principal),
):
    """Simple agent runner endpoint for the frontend playground."""
    # Prevent privilege escalation: Non-admin principals cannot override role
    if req.role_override and req.role_override != principal.role:
        if principal.role != ROLE_ADMIN:
            audit_logger.log_event(
                principal=principal.name,
                user_role=principal.role,
                tool_name="role_escalation_attempt",
                target_server="gateway",
                status="403 Blocked",
                duration_ms=0.5,
                policy_rule_detail=f"Security Violation: Non-admin role '{principal.role}' attempted to override role to '{req.role_override}'",
                upstream_status="Rejected",
            )
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Privilege Escalation Blocked: Role '{principal.role}' is not authorized to override roles.",
            )
        effective_role = req.role_override
    else:
        effective_role = principal.role

    # 1. Forward to AI Service (Groq gpt-oss-120b ReAct Agent) if running
    ai_service_url = os.environ.get("AI_SERVICE_URL", "http://ai-service.default.svc.cluster.local:8004/api/v1/agent/chat")
    ai_error = None
    try:
        async with httpx.AsyncClient(timeout=90.0) as http:
            ai_resp = await http.post(
                ai_service_url,
                headers={
                    "X-API-Key": principal.key,
                    "Authorization": f"Bearer {principal.key}",
                },
                json={
                    "message": req.message,
                    "user_name": principal.name,
                    "role_override": effective_role,
                    "history": req.history,
                },
            )
            if ai_resp.status_code == 200:
                ai_data = ai_resp.json()
                return {
                    "role": "assistant",
                    "content": ai_data.get("content", ""),
                    "reasoning": ai_data.get("reasoning"),
                    "steps": ai_data.get("steps", []),
                    "guardrailsPassed": ai_data.get("guardrailsPassed", []),
                    "status": ai_data.get("status", "success"),
                }
    except Exception as e:
        import traceback
        traceback.print_exc()
        ai_error = str(e)
        print(f"[Gateway chat_execute] AI Service invocation failed: {e}", flush=True)

    # 2. Fallback local runner if AI service is starting up
    allowed_tools = [t for t in upstream_manager.get_all_tools() if is_tool_allowed(effective_role, t["namespacedName"])]
    msg_lower = req.message.lower()
    step = None
    assistant_content = ""

    if "adjust" in msg_lower or "returned" in msg_lower:
        tool_to_call = "inventory__adjust_stock"
        if not is_tool_allowed(effective_role, tool_to_call):
            audit_logger.log_event(
                principal=principal.name,
                user_role=effective_role,
                tool_name=tool_to_call,
                target_server="gateway",
                status="403 Blocked",
                duration_ms=10.0,
                client_ip="127.0.0.1",
                policy_rule_detail=f"RBAC Policy Violation: Role '{effective_role}' is not authorized to invoke '{tool_to_call}'",
                upstream_status="Skipped",
            )
            return {
                "role": "assistant",
                "content": f"⚠️ **Permission Denied**: Role '{effective_role}' is not authorized to execute tool '{tool_to_call}'. Stock mutation requires 'inventory_manager' or 'admin'.",
                "steps": [{
                    "stepNumber": 1,
                    "server": "Inventory Tracker Server",
                    "tool": tool_to_call,
                    "args": {"sku": "SKU-1001", "delta": 5, "reason": "Customer return"},
                    "result": {"error": f"Permission Denied: Role '{effective_role}' is not authorized to execute tool '{tool_to_call}'."},
                    "status": "403 Blocked",
                    "durationMs": 10.0,
                    "summaryNote": f"RBAC Policy Violation: Role '{effective_role}' is not authorized to invoke '{tool_to_call}'",
                }]
            }
        try:
            res = await upstream_manager.execute_tool(tool_to_call, {"sku": "SKU-1001", "delta": 5, "reason": "Customer return"}, user_role=effective_role)
            assistant_content = f"Successfully adjusted stock for SKU-1001 by +5. New stock: {res.get('new_quantity', 'updated')}."
            step = {
                "stepNumber": 1,
                "server": "Inventory Tracker Server",
                "tool": tool_to_call,
                "args": {"sku": "SKU-1001", "delta": 5, "reason": "Customer return"},
                "result": res,
                "status": "200 OK",
                "durationMs": 35.0,
            }
        except Exception as e:
            assistant_content = f"Error adjusting stock: {str(e)}"
    elif "update" in msg_lower and "stock" in msg_lower:
        tool_to_call = "inventory__update_stock"
        if not is_tool_allowed(effective_role, tool_to_call):
            audit_logger.log_event(
                principal=principal.name,
                user_role=effective_role,
                tool_name=tool_to_call,
                target_server="gateway",
                status="403 Blocked",
                duration_ms=10.0,
                client_ip="127.0.0.1",
                policy_rule_detail=f"RBAC Policy Violation: Role '{effective_role}' is not authorized to invoke '{tool_to_call}'",
                upstream_status="Skipped",
            )
            return {
                "role": "assistant",
                "content": f"⚠️ **Permission Denied**: Role '{effective_role}' is not authorized to execute tool '{tool_to_call}'. Absolute stock overrides require 'inventory_manager' or 'admin'.",
                "steps": [{
                    "stepNumber": 1,
                    "server": "Inventory Tracker Server",
                    "tool": tool_to_call,
                    "args": {"sku": "SKU-1004", "quantity": 500},
                    "result": {"error": f"Permission Denied: Role '{effective_role}' is not authorized to execute tool '{tool_to_call}'."},
                    "status": "403 Blocked",
                    "durationMs": 10.0,
                    "summaryNote": f"RBAC Policy Violation: Role '{effective_role}' is not authorized to invoke '{tool_to_call}'",
                }]
            }
        try:
            res = await upstream_manager.execute_tool(tool_to_call, {"sku": "SKU-1004", "quantity": 500}, user_role=effective_role)
            assistant_content = f"Successfully updated stock for SKU-1004 to 500 units."
            step = {
                "stepNumber": 1,
                "server": "Inventory Tracker Server",
                "tool": tool_to_call,
                "args": {"sku": "SKU-1004", "quantity": 500},
                "result": res,
                "status": "200 OK",
                "durationMs": 35.0,
            }
        except Exception as e:
            assistant_content = f"Error updating stock: {str(e)}"
    elif "product" in msg_lower or "catalog" in msg_lower:
        tool_to_call = "woocommerce__list_products"
        if not is_tool_allowed(effective_role, tool_to_call):
            return {
                "role": "assistant",
                "content": f"I attempted to list products, but your role ('{effective_role}') lacks permission for '{tool_to_call}'.",
                "steps": [{
                    "stepNumber": 1,
                    "server": "WooCommerce Store Server",
                    "tool": tool_to_call,
                    "args": {"per_page": 5},
                    "result": {"error": "Permission Denied: 403 Blocked"},
                    "status": "403 Blocked",
                    "durationMs": 12.0,
                }]
            }
        
        try:
            res = await upstream_manager.execute_tool(tool_to_call, {"per_page": 5}, user_role=effective_role)
            prod_names = ", ".join(p.get("name", "Unknown") for p in res[:4]) if isinstance(res, list) else str(res)
            assistant_content = f"Here are the latest catalog products: {prod_names}."
            step = {
                "stepNumber": 1,
                "server": "WooCommerce Store Server",
                "tool": tool_to_call,
                "args": {"per_page": 5},
                "result": res,
                "status": "200 OK",
                "durationMs": 45.0,
            }
        except Exception as e:
            assistant_content = f"Error querying products: {str(e)}"
    elif "low stock" in msg_lower or "inventory" in msg_lower:
        tool_to_call = "inventory__list_low_stock"
        if not is_tool_allowed(effective_role, tool_to_call):
            return {
                "role": "assistant",
                "content": f"Access denied: Role '{effective_role}' cannot access inventory tools.",
                "steps": [{
                    "stepNumber": 1,
                    "server": "Inventory Tracker Server",
                    "tool": tool_to_call,
                    "args": {"threshold": 10},
                    "result": {"error": "403 Forbidden"},
                    "status": "403 Blocked",
                    "durationMs": 8.0,
                }]
            }
        try:
            res = await upstream_manager.execute_tool(tool_to_call, {"threshold": 10}, user_role=effective_role)
            assistant_content = f"Found {len(res)} items at or below low stock threshold."
            step = {
                "stepNumber": 1,
                "server": "Inventory Tracker Server",
                "tool": tool_to_call,
                "args": {"threshold": 10},
                "result": res,
                "status": "200 OK",
                "durationMs": 35.0,
            }
        except Exception as e:
            assistant_content = f"Error checking stock: {str(e)}"
    elif "sale" in msg_lower or "revenue" in msg_lower or "analytics" in msg_lower:
        tool_to_call = "analytics__get_daily_sales"
        if not is_tool_allowed(effective_role, tool_to_call):
            return {
                "role": "assistant",
                "content": f"Access denied: Role '{effective_role}' is not authorized to view financial analytics.",
                "steps": [{
                    "stepNumber": 1,
                    "server": "Business Analytics Server",
                    "tool": tool_to_call,
                    "args": {},
                    "result": {"error": "403 Forbidden"},
                    "status": "403 Blocked",
                    "durationMs": 9.0,
                }]
            }
        try:
            res = await upstream_manager.execute_tool(tool_to_call, {}, user_role=effective_role)
            sales = res.get("gross_sales", 0)
            cnt = res.get("orders_count", 0)
            assistant_content = f"Today's total gross sales are ${sales} across {cnt} orders."
            step = {
                "stepNumber": 1,
                "server": "Business Analytics Server",
                "tool": tool_to_call,
                "args": {},
                "result": res,
                "status": "200 OK",
                "durationMs": 40.0,
            }
        except Exception as e:
            assistant_content = f"Error retrieving analytics: {str(e)}"
    else:
        if ai_error:
            assistant_content = f"⚠️ The AI Agent encountered an issue coordinating operations: {ai_error}. Please try again."
        else:
            assistant_content = f"I am your Urumi Team Agent with role '{effective_role}'. You can ask me to list products, check inventory, inspect orders, or summarize revenue."

    return {
        "role": "assistant",
        "content": assistant_content,
        "steps": [step] if step else [],
    }

# -------------------------------------------------------------
# Static Frontend Dashboard Serving (Single-Page Application)
# -------------------------------------------------------------
static_dir = os.path.join(os.path.dirname(__file__), "static")
if os.path.exists(static_dir):
    assets_dir = os.path.join(static_dir, "assets")
    if os.path.exists(assets_dir):
        app.mount("/assets", StaticFiles(directory=assets_dir), name="assets")

    @app.get("/{full_path:path}")
    async def serve_spa(full_path: str):
        # Don't intercept API routes or internal endpoints
        if full_path.startswith("api/") or full_path.startswith("health") or full_path.startswith("docs"):
            raise HTTPException(status_code=404, detail="Not Found")
        
        file_path = os.path.join(static_dir, full_path)
        if full_path and os.path.isfile(file_path):
            return FileResponse(file_path)
        
        index_file = os.path.join(static_dir, "index.html")
        if os.path.isfile(index_file):
            return FileResponse(index_file)
        raise HTTPException(status_code=404, detail="Dashboard index not found.")

if __name__ == "__main__":
    uvicorn.run("server:app", host=settings.host, port=settings.port, reload=False)
