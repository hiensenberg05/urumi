import asyncio
import time
from typing import Any, Dict, List, Optional
import httpx
from fastmcp import Client
from config import settings
from rbac import get_tool_risk

class UpstreamServer:
    def __init__(
        self,
        server_id: str,
        name: str,
        tag: str,
        endpoint_url: str,
        health_url: str,
        prefix: str,
    ):
        self.id = server_id
        self.name = name
        self.tag = tag
        self.endpoint_url = endpoint_url
        self.health_url = health_url
        self.prefix = prefix
        self.status = "Connected"
        self.transport = "Streamable HTTP"
        self.tools: List[Dict[str, Any]] = []
        self.last_checked = time.strftime("%Y-%m-%d %H:%M:%S UTC")
        self.ping_ms = 12.0
        self.uptime_pct = 99.9

    async def check_health(self) -> bool:
        start = time.monotonic()
        try:
            async with httpx.AsyncClient(timeout=3.0) as http:
                resp = await http.get(self.health_url)
                self.ping_ms = round((time.monotonic() - start) * 1000, 1)
                if resp.status_code == 200:
                    self.status = "Connected"
                    self.last_checked = time.strftime("%Y-%m-%d %H:%M:%S UTC")
                    return True
                else:
                    self.status = "Unreachable"
                    return False
        except Exception:
            self.status = "Unreachable"
            return False

    async def refresh_tools(self) -> List[Dict[str, Any]]:
        try:
            async with Client(self.endpoint_url, timeout=5.0) as client:
                mcp_tools = await client.list_tools()
                self.tools = [
                    {
                        "id": f"tool_{t.name}",
                        "namespacedName": t.name,
                        "originalName": t.name,
                        "serverId": self.id,
                        "serverName": self.name,
                        "description": t.description or f"Tool provided by {self.name}",
                        "riskProfile": get_tool_risk(t.name),
                        "rateLimit": "60/min",
                        "policy": "ALLOW",
                        "effectiveRule": "Inherited from RBAC Role",
                        "isAllowed": True,
                        "schema": getattr(t, "parameters", {}) or getattr(t, "inputSchema", {}),
                    }
                    for t in mcp_tools
                ]
                self.status = "Connected"
                return self.tools
        except Exception as e:
            # Fallback to predefined schema if server temporarily warming up
            return self.tools

class UpstreamManager:
    def __init__(self):
        self.servers: Dict[str, UpstreamServer] = {
            "srv-woocommerce": UpstreamServer(
                server_id="srv-woocommerce",
                name="WooCommerce Store Server",
                tag="STOREFRONT",
                endpoint_url=settings.upstream_woocommerce_url,
                health_url=settings.upstream_woocommerce_url.replace("/mcp", "/health"),
                prefix="woocommerce__",
            ),
            "srv-inventory": UpstreamServer(
                server_id="srv-inventory",
                name="Inventory Tracker Server",
                tag="INVENTORY",
                endpoint_url=settings.upstream_inventory_url,
                health_url=settings.upstream_inventory_url.replace("/mcp", "/health"),
                prefix="inventory__",
            ),
            "srv-analytics": UpstreamServer(
                server_id="srv-analytics",
                name="Business Analytics Server",
                tag="ANALYTICS",
                endpoint_url=settings.upstream_analytics_url,
                health_url=settings.upstream_analytics_url.replace("/mcp", "/health"),
                prefix="analytics__",
            ),
        }
        self._static_seed_tools()

    def _static_seed_tools(self):
        """Seed known tool metadata so dashboard and listing work immediately before first probe."""
        wc_tools = [
            ("woocommerce__list_products", "List catalog products with pagination"),
            ("woocommerce__create_product", "Add new product to store catalog"),
            ("woocommerce__list_orders", "List recent orders with status filter"),
            ("woocommerce__get_order", "Retrieve single order details by ID"),
            ("woocommerce__create_order", "Create new customer order with test payment"),
            ("woocommerce__update_order_status", "Modify order status in WooCommerce"),
        ]
        self.servers["srv-woocommerce"].tools = [
            {
                "id": f"tool_{name}",
                "namespacedName": name,
                "originalName": name,
                "serverId": "srv-woocommerce",
                "serverName": "WooCommerce Store Server",
                "description": desc,
                "riskProfile": get_tool_risk(name),
                "rateLimit": "60/min",
                "policy": "ALLOW",
                "effectiveRule": "Default RBAC",
                "isAllowed": True,
            }
            for name, desc in wc_tools
        ]

        inv_tools = [
            ("inventory__check_stock", "Check stock level and availability by SKU"),
            ("inventory__batch_check_stock", "Check stock levels for multiple SKUs in batch"),
            ("inventory__list_low_stock", "Find items below reorder threshold"),
            ("inventory__update_stock", "Update stock quantity for a given SKU"),
            ("inventory__adjust_stock", "Safely adjust stock by relative delta with audit reason"),
        ]
        self.servers["srv-inventory"].tools = [
            {
                "id": f"tool_{name}",
                "namespacedName": name,
                "originalName": name,
                "serverId": "srv-inventory",
                "serverName": "Inventory Tracker Server",
                "description": desc,
                "riskProfile": get_tool_risk(name),
                "rateLimit": "60/min",
                "policy": "ALLOW",
                "effectiveRule": "Default RBAC",
                "isAllowed": True,
            }
            for name, desc in inv_tools
        ]

        ana_tools = [
            ("analytics__get_daily_sales", "Get gross revenue and order metrics today"),
            ("analytics__get_revenue_summary", "Rolling revenue and average order value"),
            ("analytics__get_top_selling_products", "Top products ranked by sales volume"),
        ]
        self.servers["srv-analytics"].tools = [
            {
                "id": f"tool_{name}",
                "namespacedName": name,
                "originalName": name,
                "serverId": "srv-analytics",
                "serverName": "Business Analytics Server",
                "description": desc,
                "riskProfile": get_tool_risk(name),
                "rateLimit": "60/min",
                "policy": "ALLOW",
                "effectiveRule": "Default RBAC",
                "isAllowed": True,
            }
            for name, desc in ana_tools
        ]

    def get_server_for_tool(self, tool_name: str) -> Optional[UpstreamServer]:
        for srv in self.servers.values():
            if tool_name.startswith(srv.prefix):
                return srv
        # Fallback check by tool list
        for srv in self.servers.values():
            if any(t["namespacedName"] == tool_name for t in srv.tools):
                return srv
        return None

    def get_all_tools(self) -> List[Dict[str, Any]]:
        all_tools = []
        for srv in self.servers.values():
            all_tools.extend(srv.tools)
        return all_tools

    async def execute_tool(self, tool_name: str, arguments: Dict[str, Any]) -> Any:
        srv = self.get_server_for_tool(tool_name)
        if not srv:
            raise ValueError(f"No upstream MCP server found for tool '{tool_name}'")

        async with Client(srv.endpoint_url, timeout=15.0) as client:
            res = await client.call_tool(tool_name, arguments)
            if hasattr(res, "data"):
                return res.data
            elif hasattr(res, "content"):
                return res.content
            return res

upstream_manager = UpstreamManager()
