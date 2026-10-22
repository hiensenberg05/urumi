import asyncio
import time
from typing import Any, Dict, List, Optional
import httpx
from fastmcp import Client
from config import settings
from rbac import get_tool_risk
from metrics import telemetry

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
        self.last_error_reason: Optional[str] = None

    async def check_health(self) -> bool:
        start = time.monotonic()
        try:
            async with httpx.AsyncClient(timeout=3.0) as http:
                resp = await http.get(self.health_url)
                self.ping_ms = round((time.monotonic() - start) * 1000, 1)
                self.last_checked = time.strftime("%Y-%m-%d %H:%M:%S UTC")
                if resp.status_code == 200:
                    self.status = "Connected"
                    self.last_error_reason = None
                    return True
                else:
                    self.status = "Degraded"
                    self.last_error_reason = f"Health probe returned HTTP {resp.status_code}."
                    return False
        except Exception as e:
            self.ping_ms = round((time.monotonic() - start) * 1000, 1)
            self.last_checked = time.strftime("%Y-%m-%d %H:%M:%S UTC")
            self.status = "Unreachable"
            err_str = str(e).lower()
            if "timeout" in err_str:
                self.last_error_reason = f"CONNECTION_TIMEOUT: Health check exceeded 3.0s timeout to {self.health_url}"
            elif "connect" in err_str or "refused" in err_str:
                self.last_error_reason = f"CONNECTION_REFUSED: Unable to reach {self.health_url}. Pod or port offline."
            elif "dns" in err_str or "name or service not known" in err_str:
                self.last_error_reason = f"DNS_RESOLUTION_FAILED: Host in {self.health_url} could not be resolved by cluster CoreDNS."
            else:
                self.last_error_reason = f"UNREACHABLE: {str(e)}"
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

    def register_store_server(
        self,
        store_id: str,
        store_name: str,
        endpoint_url: str,
        health_url: str,
    ) -> UpstreamServer:
        server_id = f"srv-store-{store_id}"
        prefix = f"store_{store_id}__"
        server = UpstreamServer(
            server_id=server_id,
            name=f"{store_name} ({store_id})",
            tag="STORE_TENANT",
            endpoint_url=endpoint_url,
            health_url=health_url,
            prefix=prefix,
        )
        wc_tools = [
            ("list_products", f"List products from {store_name} catalog with pagination"),
            ("create_product", f"Add new product to {store_name} catalog"),
            ("list_orders", f"List recent orders from {store_name} with status filter"),
            ("get_order", f"Retrieve single order details from {store_name} by ID"),
            ("create_order", f"Create new customer order in {store_name}"),
            ("update_order_status", f"Modify order status in {store_name}"),
        ]
        server.tools = [
            {
                "id": f"tool_{prefix}{suffix}",
                "namespacedName": f"{prefix}{suffix}",
                "originalName": f"woocommerce__{suffix}",
                "serverId": server_id,
                "serverName": server.name,
                "description": desc,
                "riskProfile": get_tool_risk(suffix),
                "rateLimit": "60/min",
                "policy": "ALLOW",
                "effectiveRule": "Dynamic Multi-Store Tenant",
                "isAllowed": True,
            }
            for suffix, desc in wc_tools
        ]
        self.servers[server_id] = server
        return server

    def unregister_store_server(self, store_id: str) -> bool:
        server_id = f"srv-store-{store_id}"
        if server_id in self.servers:
            del self.servers[server_id]
            return True
        return False

    def register_hosted_server(
        self,
        server_id: str,
        name: str,
        tag: str,
        endpoint_url: str,
        health_url: str,
        tools_list: List[Dict[str, str]],
    ) -> UpstreamServer:
        """Register a dynamic on-demand hosted MCP server pod."""
        server = UpstreamServer(
            server_id=server_id,
            name=name,
            tag=tag,
            endpoint_url=endpoint_url,
            health_url=health_url,
            prefix=f"{server_id}__",
        )
        server.tools = [
            {
                "id": f"tool_{t['name']}",
                "namespacedName": t["name"],
                "originalName": t["name"],
                "serverId": server_id,
                "serverName": name,
                "description": t.get("description", "Hosted on-demand MCP tool"),
                "riskProfile": (
                    "Low (Read-only)" if any(k in t["name"] for k in ["get", "list", "track", "convert"])
                    else "High (Operational write)"
                ),
                "rateLimit": "60/min",
                "policy": "ALLOW",
                "effectiveRule": "Hosted Pod Default",
                "isAllowed": True,
            }
            for t in tools_list
        ]
        self.servers[server_id] = server
        return server

    def unregister_hosted_server(self, server_id: str) -> bool:
        """Remove a hosted MCP server pod from active gateway registry."""
        if server_id in self.servers:
            del self.servers[server_id]
            return True
        return False

    def toggle_server_status(self, server_id: str) -> Optional[UpstreamServer]:
        srv = self.servers.get(server_id)
        if not srv:
            return None
        srv.status = "Disabled" if srv.status != "Disabled" else "Connected"
        return srv

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
            if srv.status != "Disabled":
                all_tools.extend(srv.tools)
        return all_tools

    async def execute_tool(self, tool_name: str, arguments: Dict[str, Any], user_role: Optional[str] = None) -> Any:
        srv = self.get_server_for_tool(tool_name)
        if not srv:
            raise ValueError(f"No upstream MCP server found for tool '{tool_name}'")
        if srv.status == "Disabled":
            raise ValueError(f"Upstream server '{srv.name}' is currently disabled by administrator.")

        # Circuit Breaker Check
        cb = telemetry.get_circuit_breaker_status(srv.id)
        if cb.get("state") == "OPEN":
            reason = cb.get("reason", "repeated upstream failures")
            raise ConnectionError(f"CIRCUIT_BREAKER_OPEN: Server '{srv.name}' is temporarily isolated ({reason}). Cooldown active.")

        target_tool = tool_name
        for t in srv.tools:
            if t.get("namespacedName") == tool_name:
                target_tool = t.get("originalName", tool_name)
                break

        start = time.monotonic()
        try:
            async with Client(srv.endpoint_url, timeout=15.0) as client:
                res = await client.call_tool(target_tool, arguments)
                duration_ms = round((time.monotonic() - start) * 1000, 1)
                telemetry.record_tool_call(
                    server_id=srv.id,
                    tool_name=tool_name,
                    duration_ms=duration_ms,
                    status="200 OK",
                    user_role=user_role,
                )
                if hasattr(res, "data"):
                    return res.data
                elif hasattr(res, "content"):
                    return res.content
                return res
        except Exception as e:
            duration_ms = round((time.monotonic() - start) * 1000, 1)
            err_str = str(e).lower()
            category = "UPSTREAM_FAILURE"
            detail = str(e)
            if "timeout" in err_str:
                category = "CONNECTION_TIMEOUT"
                detail = f"Upstream service '{srv.name}' exceeded 15.0s execution timeout."
            elif "connect" in err_str or "refused" in err_str:
                category = "CONNECTION_REFUSED"
                detail = f"TCP Connection refused at '{srv.endpoint_url}'. Pod or port is unreachable."
            elif "dns" in err_str or "name or service not known" in err_str:
                category = "DNS_RESOLUTION_FAILED"
                detail = f"Cluster CoreDNS failed to resolve hostname for '{srv.endpoint_url}'."
            elif "500" in err_str:
                category = "UPSTREAM_500_ERROR"
                detail = f"Upstream service '{srv.name}' returned HTTP 500 Internal Error."

            telemetry.record_tool_call(
                server_id=srv.id,
                tool_name=tool_name,
                duration_ms=duration_ms,
                status="500 Error",
                error_category=category,
                error_detail=detail,
                user_role=user_role,
            )
            raise e

upstream_manager = UpstreamManager()
