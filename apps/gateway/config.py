import os
from typing import Dict, List, Any
from pydantic_settings import BaseSettings, SettingsConfigDict

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

    # CORS Allowed Origins
    allowed_origins_raw: str = os.environ.get(
        "ALLOWED_ORIGINS",
        "http://localhost:3000,http://127.0.0.1:3000,http://localhost:8000,http://127.0.0.1:8000,http://store.local,https://store.local,http://dashboard.local,https://dashboard.local",
    )

    @property
    def allowed_origins(self) -> List[str]:
        return [origin.strip() for origin in self.allowed_origins_raw.split(",") if origin.strip()]

    # Dynamic Initial Bootstrap Keys (configurable via env vars)
    admin_api_key: str = os.environ.get("ADMIN_API_KEY", "admin-key-urumi-2026")
    inventory_api_key: str = os.environ.get("INVENTORY_API_KEY", "inv-key-urumi-2026")
    analyst_api_key: str = os.environ.get("ANALYST_API_KEY", "analyst-key-urumi-2026")
    support_api_key: str = os.environ.get("SUPPORT_API_KEY", "support-key-urumi-2026")

    @property
    def default_api_keys(self) -> Dict[str, Dict[str, Any]]:
        return self.get_initial_keys()

    def get_initial_keys(self) -> Dict[str, Dict[str, Any]]:
        """Return initial bootstrap keys with role assignments and multi-tenant store scoping."""
        return {
            self.admin_api_key: {
                "name": "Platform Administrator Key",
                "role": "admin",
                "scope": "read:write:admin",
                "allowed_stores": ["*"],
            },
            self.inventory_api_key: {
                "name": "Inventory Manager Key",
                "role": "inventory_manager",
                "scope": "read:write:inventory",
                "allowed_stores": ["default"],
            },
            self.analyst_api_key: {
                "name": "Financial Analyst Key",
                "role": "analyst",
                "scope": "read:analytics",
                "allowed_stores": ["default"],
            },
            self.support_api_key: {
                "name": "Customer Support Key",
                "role": "support_rep",
                "scope": "read:write:orders",
                "allowed_stores": ["default"],
            },
            "ratelimit-probe-key-2026": {
                "name": "Distributed Rate Limit Tester Key",
                "role": "support_rep",
                "scope": "read:tools",
                "allowed_stores": ["default"],
            },
        }

settings = GatewaySettings()
