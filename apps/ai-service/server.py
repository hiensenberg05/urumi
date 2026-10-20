import time
from typing import Any, Dict, List, Optional
from fastapi import FastAPI, Header, HTTPException, Request, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import uvicorn

from ai_config import settings
from agent import agent_runner, AgentResponse

app = FastAPI(
    title="Urumi AI Operations Agent Service",
    description="Autonomous ReAct AI Agent with Groq openai/gpt-oss-120b, MCP Gateway Tool Execution, and Safety Guardrails",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class ChatRequest(BaseModel):
    message: str
    history: Optional[List[Dict[str, str]]] = Field(default_factory=list)
    user_name: Optional[str] = "Sarah Chen"
    role_override: Optional[str] = None

class DirectExecuteRequest(BaseModel):
    goal: str
    role: Optional[str] = "admin"

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "service": "urumi-ai-agent",
        "model": settings.llm_model,
        "fallback_model": settings.fallback_model,
        "gateway_url": settings.gateway_url,
        "timestamp": time.strftime("%Y-%m-%d %H:%M:%S UTC"),
    }

@app.post("/api/v1/agent/chat", response_model=AgentResponse)
async def chat_endpoint(
    req: ChatRequest,
    request: Request,
    x_api_key: Optional[str] = Header(None, alias="X-API-Key"),
):
    api_key = x_api_key or "support-key-urumi-2026"
    effective_role = req.role_override or ("admin" if "admin" in api_key.lower() else "support_rep")

    response = await agent_runner.run(
        user_message=req.message,
        api_key=api_key,
        user_name=req.user_name or "Operator",
        user_role=effective_role,
        conversation_history=req.history,
    )
    return response

@app.post("/api/v1/agent/execute", response_model=AgentResponse)
async def execute_task(
    req: DirectExecuteRequest,
    x_api_key: Optional[str] = Header(None, alias="X-API-Key"),
):
    api_key = x_api_key or "admin-key-urumi-2026"
    return await agent_runner.run(
        user_message=req.goal,
        api_key=api_key,
        user_name="Automated Task Runner",
        user_role=req.role or "admin",
    )

if __name__ == "__main__":
    uvicorn.run("server:app", host=settings.host, port=settings.port, reload=False)
