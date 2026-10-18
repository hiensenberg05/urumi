import os
from typing import Dict, List
from pydantic_settings import BaseSettings, SettingsConfigDict

class ApiKeyConfig:
    def __init__(self, key: str, role: str, name: str, scope: str = "all"):
        self.key = key
        self.role = role
        self.name = name
        self.scope = scope

class GatewaySettings(BaseSettings):
    model_config = SettingsConfigDict(env_prefix="GATEWAY_", case_sensitive=False)

    port: int = int(os.environ.get("GATEWAY_PORT", os.environ.get("PORT", "8000")))
    host: str = os.environ.get("GATEWAY_HOST", "0.0.0.0")

    # Upstream MCP Server Endpoints
    upstream_woocommerce_url: str = os.environ.get(
        "UPSTREAM_WOOCOMMERCE_URL", "http://woocommerce-mcp.default.svc.cluster.local:8001/mcp"
    )
    upstream_inventory_url: str = os.environ.get(
        "UPSTREAM_INVENTORY_URL", "http://inventory-mcp.default.svc.cluster.local:8002/mcp"
    )
    upstream_analytics_url: str = os.environ.get(
        "UPSTREAM_ANALYTICS_URL", "http://analytics-mcp.default.svc.cluster.local:8003/mcp"
    )

    # Rate Limiting
    rate_limit_per_minute: int = int(os.environ.get("RATE_LIMIT_PER_MINUTE", "60"))
    rate_limit_burst: int = int(os.environ.get("RATE_LIMIT_BURST", "15"))

    # Default Seeded API Keys with Preassigned Roles
    default_api_keys: Dict[str, Dict[str, str]] = {
        "admin-key-urumi-2026": {
            "name": "Platform Administrator Key",
            "role": "admin",
            "scope": "read:write:admin",
        },
        "inv-key-urumi-2026": {
            "name": "Inventory Manager Key",
            "role": "inventory_manager",
            "scope": "read:write:inventory",
        },
        "analyst-key-urumi-2026": {
            "name": "Financial Analyst Key",
            "role": "analyst",
            "scope": "read:analytics",
        },
        "support-key-urumi-2026": {
            "name": "Customer Support Key",
            "role": "support_rep",
            "scope": "read:write:orders",
        },
    }

settings = GatewaySettings()
