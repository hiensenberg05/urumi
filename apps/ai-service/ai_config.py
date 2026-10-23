import os
from typing import Optional
from pydantic_settings import BaseSettings, SettingsConfigDict

class AISettings(BaseSettings):
    model_config = SettingsConfigDict(env_prefix="AI_", case_sensitive=False)

    groq_api_key: str = os.environ.get("GROQ_API_KEY", "")
    llm_model: str = os.environ.get("LLM_MODEL", "openai/gpt-oss-120b")
    fallback_model: str = os.environ.get("FALLBACK_MODEL", "qwen/qwen3.8-27b")
    
    # Gateway Endpoint for Tool Calling & Discovery
    gateway_url: str = os.environ.get(
        "GATEWAY_URL", "http://gateway.default.svc.cluster.local:8000"
    )
    gateway_host_header: Optional[str] = os.environ.get("GATEWAY_HOST_HEADER", None)

    port: int = int(os.environ.get("AI_SERVICE_PORT", os.environ.get("PORT", "8004")))
    host: str = os.environ.get("AI_SERVICE_HOST", "0.0.0.0")

    max_agent_loops: int = 6
    temperature: float = 0.2

settings = AISettings()
