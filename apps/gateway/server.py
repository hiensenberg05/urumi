import asyncio
import os
import time
import uuid
from typing import Any, Dict, List, Optional
import httpx
from fastapi import FastAPI, Depends, HTTPException, Header, Query, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field
import uvicorn

from config import settings
from rbac import (
    is_tool_allowed,
    filter_allowed_tools,
    get_tool_risk,
    ROLE_PERMISSIONS,
    ALL_ROLES,
    ROLE_ADMIN,
)
from rate_limiter import RateLimiter
from audit_logger import audit_logger
from upstream_manager import upstream_manager

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

# In-memory API keys storage (initialized with defaults)
api_keys_db: Dict[str, Dict[str, Any]] = {}
for key, data in settings.default_api_keys.items():
    key_id = f"key_{uuid.uuid4().hex[:8]}"
    api_keys_db[key] = {
        "id": key_id,
        "name": data["name"],
        "key": key,
        "keyPrefix": f"{key[:8]}...",
        "role": data["role"],
        "scope": data["scope"],
        "createdAt": time.strftime("%Y-%m-%d %H:%M:%S UTC"),
        "lastUsedAt": "never",
        "expiresAt": "Never",
        "isRevoked": False,
    }

class Principal:
    def __init__(self, key: str, name: str, role: str, scope: str):
        self.key = key
        self.name = name
        self.role = role
        self.scope = scope

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
        if request.url.path in ("/health", "/", "/docs", "/openapi.json"):
            return Principal(key="anonymous", name="Anonymous", role="public", scope="none")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing authentication credentials. Provide 'X-API-Key' header or 'Bearer <token>'.",
        )

    # Check key validity
    key_info = api_keys_db.get(token)
    if not key_info or key_info.get("isRevoked"):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or revoked API key.",
        )

    # Update last used timestamp
    key_info["lastUsedAt"] = time.strftime("%Y-%m-%d %H:%M:%S UTC")

    # Enforce Rate Limiting
    allowed, retry_after = await rate_limiter.check_rate_limit(token)
    if not allowed:
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
            "authType": "API Key / RBAC",
        })
    return result

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
    return list(api_keys_db.values())

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
    item = {
        "id": new_id,
        "name": req.name,
        "key": new_key,
        "keyPrefix": f"{new_key[:8]}...",
        "role": req.role,
        "scope": req.scope,
        "createdAt": time.strftime("%Y-%m-%d %H:%M:%S UTC"),
        "lastUsedAt": "never",
        "expiresAt": "Never",
        "isRevoked": False,
    }
    api_keys_db[new_key] = item
    return item

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
    for k, v in api_keys_db.items():
        if v["id"] == key_id or v["key"] == key_id:
            v["isRevoked"] = True
            return {"status": "success", "message": f"API Key '{v['name']}' has been revoked."}
    raise HTTPException(status_code=404, detail="API Key not found.")

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
# Tool Execution API with RBAC Enforcement & Telemetry
# -------------------------------------------------------------
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

    # 2. Dispatch to Upstream MCP Server
    srv = upstream_manager.get_server_for_tool(req.tool)
    target_server_name = srv.name if srv else "unknown"

    try:
        result = await upstream_manager.execute_tool(req.tool, req.arguments)
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
    effective_role = req.role_override or principal.role

    # 1. Forward to AI Service (Groq gpt-oss-120b ReAct Agent) if running
    ai_service_url = os.environ.get("AI_SERVICE_URL", "http://ai-service.default.svc.cluster.local:8004/api/v1/agent/chat")
    try:
        async with httpx.AsyncClient(timeout=35.0) as http:
            ai_resp = await http.post(
                ai_service_url,
                headers={"X-API-Key": principal.key},
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
        print(f"[Gateway chat_execute] AI Service invocation failed: {e}", flush=True)

    # 2. Fallback local runner if AI service is starting up
    allowed_tools = [t for t in upstream_manager.get_all_tools() if is_tool_allowed(effective_role, t["namespacedName"])]
    msg_lower = req.message.lower()
    step = None
    assistant_content = ""

    if "product" in msg_lower or "catalog" in msg_lower:
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
            res = await upstream_manager.execute_tool(tool_to_call, {"per_page": 5})
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
            res = await upstream_manager.execute_tool(tool_to_call, {"threshold": 10})
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
            res = await upstream_manager.execute_tool(tool_to_call, {})
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
        assistant_content = f"I am your Urumi Team Agent with role '{effective_role}'. You can ask me to list products, check inventory, inspect orders, or summarize revenue."

    return {
        "role": "assistant",
        "content": assistant_content,
        "steps": [step] if step else [],
    }

if __name__ == "__main__":
    uvicorn.run("server:app", host=settings.host, port=settings.port, reload=False)
