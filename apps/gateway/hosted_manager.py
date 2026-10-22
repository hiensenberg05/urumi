"""
Hosted MCP Server Manager for Urumi MCP Gateway.
Implements Differentiator #5: Hosted MCP servers inside Kubernetes.
Allows admins to launch, scale (sleep/wake), inspect logs, and teardown
on-demand containerized MCP server Pods directly from the dashboard.
"""

import asyncio
import json
import os
import re
import shutil
import time
from typing import Any, Dict, List, Optional
import httpx
from pydantic import BaseModel, Field

from upstream_manager import upstream_manager


class HostedDeployRequest(BaseModel):
    id: Optional[str] = Field(None, description="Slug identifier (e.g. 'notifications', 'currency')")
    name: str = Field(..., min_length=2, max_length=50, description="Display name of the hosted server")
    template: str = Field("notifications", description="Template preset: 'notifications', 'currency', 'shipping', or 'custom'")
    image: Optional[str] = Field(None, description="Container image (defaults to urumi/hosted-mcp-suite:v1.0.0)")
    port: Optional[int] = Field(None, description="Service container port (8005-8099)")
    env: Dict[str, str] = Field(default_factory=dict, description="Custom environment variables")


class HostedServerRecord(BaseModel):
    id: str
    name: str
    template: str
    tag: str
    image: str
    port: int
    replicas: int = 1
    status: str = "Provisioning"  # Provisioning | Running | Sleeping | Failed
    endpointUrl: str
    healthUrl: str
    toolsCount: int = 0
    tools: List[Dict[str, str]] = Field(default_factory=list)
    createdAt: str
    errorMessage: Optional[str] = None


# Pre-Curated Enterprise Templates Catalog
TEMPLATES_CATALOG: Dict[str, Dict[str, Any]] = {
    "notifications": {
        "id": "notifications",
        "name": "Notification & Alert Dispatcher",
        "tag": "NOTIFICATIONS",
        "description": "High-priority Slack channel alerts, email dispatches, and real-time banner broadcasts.",
        "image": "urumi/hosted-mcp-suite:v1.0.0",
        "port": 8005,
        "env": {"SERVICE_TYPE": "notifications", "PORT": "8005"},
        "tools": [
            {
                "name": "hosted_notify__send_slack_alert",
                "description": "Send urgent or informational alert to a team Slack channel (#operations, #alerts)",
            },
            {
                "name": "hosted_notify__send_email_dispatch",
                "description": "Dispatch notification email to staff or customer with delivery receipt",
            },
            {
                "name": "hosted_notify__broadcast_banner",
                "description": "Publish live system-wide alert banner across connected store portals",
            },
        ],
    },
    "currency": {
        "id": "currency",
        "name": "Global Currency & Forex Converter",
        "tag": "FOREX",
        "description": "Live currency conversions, Forex exchange rates, and international retail price matrix formatting.",
        "image": "urumi/hosted-mcp-suite:v1.0.0",
        "port": 8006,
        "env": {"SERVICE_TYPE": "currency", "PORT": "8006"},
        "tools": [
            {
                "name": "hosted_currency__convert_price",
                "description": "Convert pricing amount between world currencies (USD, EUR, GBP, INR, JPY)",
            },
            {
                "name": "hosted_currency__get_exchange_rates",
                "description": "Get live exchange rate lookup table relative to base currency",
            },
            {
                "name": "hosted_currency__format_international_pricing",
                "description": "Format USD price across major international retail markets with local currency symbols",
            },
        ],
    },
    "shipping": {
        "id": "shipping",
        "name": "Freight & Shipping Logistics",
        "tag": "LOGISTICS",
        "description": "Warehouse freight calculator, consignment tracking, and delivery checkpoint estimator.",
        "image": "urumi/hosted-mcp-suite:v1.0.0",
        "port": 8007,
        "env": {"SERVICE_TYPE": "shipping", "PORT": "8007"},
        "tools": [
            {
                "name": "hosted_shipping__calculate_freight",
                "description": "Calculate package shipping cost and transit days based on weight and country",
            },
            {
                "name": "hosted_shipping__track_shipment",
                "description": "Track consignment status and delivery checkpoint history",
            },
        ],
    },
}


class HostedManager:
    def __init__(self):
        self.hosted_servers: Dict[str, HostedServerRecord] = {}
        self._background_tasks = set()
        self.kubectl_cmd = shutil.which("kubectl") or "/usr/local/bin/kubectl" or "kubectl"

    def _sanitize_slug(self, raw: str) -> str:
        slug = re.sub(r"[^a-z0-9-]", "", raw.lower().replace(" ", "-"))
        slug = re.sub(r"-+", "-", slug).strip("-")
        return slug or "hosted"

    async def _run_kubectl(self, args: List[str], input_data: Optional[str] = None) -> tuple[int, str, str]:
        """Execute a kubectl command asynchronously."""
        try:
            proc = await asyncio.create_subprocess_exec(
                self.kubectl_cmd,
                *args,
                stdin=asyncio.subprocess.PIPE if input_data else None,
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
            )
            stdout, stderr = await proc.communicate(input=input_data.encode("utf-8") if input_data else None)
            return proc.returncode, stdout.decode("utf-8", errors="ignore"), stderr.decode("utf-8", errors="ignore")
        except Exception as e:
            return 1, "", str(e)

    def get_templates(self) -> List[Dict[str, Any]]:
        return list(TEMPLATES_CATALOG.values())

    def list_hosted_servers(self) -> List[HostedServerRecord]:
        return list(self.hosted_servers.values())

    async def reconcile_existing(self):
        """Discover existing hosted MCP pods on cluster startup."""
        code, out, _ = await self._run_kubectl([
            "get", "deployment", "-l", "app.kubernetes.io/managed-by=urumi-hosted-mcp", "-o", "json"
        ])
        if code != 0 or not out.strip():
            return

        try:
            data = json.loads(out)
            for item in data.get("items", []):
                dep_name = item["metadata"]["name"]
                h_id = item["metadata"].get("labels", {}).get("hosted-mcp-id") or dep_name.replace("hosted-mcp-", "")
                
                template_name = "custom"
                if h_id in TEMPLATES_CATALOG:
                    template_name = h_id

                spec_tpl = TEMPLATES_CATALOG.get(template_name, {})
                port = spec_tpl.get("port", 8005)
                name = spec_tpl.get("name", f"Hosted MCP {h_id.capitalize()}")
                tag = spec_tpl.get("tag", "HOSTED")
                tools = spec_tpl.get("tools", [])

                rec = HostedServerRecord(
                    id=h_id,
                    name=name,
                    template=template_name,
                    tag=tag,
                    image=spec_tpl.get("image", "urumi/hosted-mcp-suite:v1.0.0"),
                    port=port,
                    replicas=item["spec"].get("replicas", 1),
                    status="Provisioning",
                    endpointUrl=f"http://hosted-mcp-{h_id}.default.svc.cluster.local:{port}/mcp",
                    healthUrl=f"http://hosted-mcp-{h_id}.default.svc.cluster.local:{port}/health",
                    toolsCount=len(tools),
                    tools=tools,
                    createdAt=time.strftime("%Y-%m-%d %H:%M:%S UTC"),
                )
                self.hosted_servers[h_id] = rec

                # Verify health & register
                task = asyncio.create_task(self._verify_and_register(rec))
                self._background_tasks.add(task)
                task.add_done_callback(self._background_tasks.discard)
        except Exception as e:
            print(f"[HostedManager] Reconcile error: {e}", flush=True)

    async def deploy_server(self, req: HostedDeployRequest) -> HostedServerRecord:
        """Launch a new on-demand hosted MCP Pod & Service in Kubernetes."""
        h_id = self._sanitize_slug(req.id or req.template or req.name)
        if h_id in self.hosted_servers and self.hosted_servers[h_id].status != "Failed":
            raise ValueError(f"Hosted MCP server with identifier '{h_id}' is already deployed.")

        # Preset resolution
        template_info = TEMPLATES_CATALOG.get(req.template, {})
        image = req.image or template_info.get("image", "urumi/hosted-mcp-suite:v1.0.0")
        port = req.port or template_info.get("port", 8005)
        tag = template_info.get("tag", "HOSTED")
        tools = template_info.get("tools", [])

        # Merge environment variables
        env_vars = dict(template_info.get("env", {}))
        env_vars.update(req.env)

        endpoint_url = f"http://hosted-mcp-{h_id}.default.svc.cluster.local:{port}/mcp"
        health_url = f"http://hosted-mcp-{h_id}.default.svc.cluster.local:{port}/health"

        rec = HostedServerRecord(
            id=h_id,
            name=req.name,
            template=req.template,
            tag=tag,
            image=image,
            port=port,
            replicas=1,
            status="Provisioning",
            endpointUrl=endpoint_url,
            healthUrl=health_url,
            toolsCount=len(tools),
            tools=tools,
            createdAt=time.strftime("%Y-%m-%d %H:%M:%S UTC"),
        )
        self.hosted_servers[h_id] = rec

        # Generate K8s YAML manifest
        env_yaml = "\n".join([f"        - name: {k}\n          value: \"{v}\"" for k, v in env_vars.items()])
        manifest = f"""
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hosted-mcp-{h_id}
  namespace: default
  labels:
    app: hosted-mcp-{h_id}
    app.kubernetes.io/managed-by: urumi-hosted-mcp
    hosted-mcp-id: {h_id}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hosted-mcp-{h_id}
  template:
    metadata:
      labels:
        app: hosted-mcp-{h_id}
        app.kubernetes.io/managed-by: urumi-hosted-mcp
        hosted-mcp-id: {h_id}
    spec:
      containers:
      - name: hosted-mcp
        image: {image}
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: {port}
        env:
{env_yaml}
        resources:
          requests:
            cpu: 30m
            memory: 64Mi
          limits:
            cpu: 250m
            memory: 256Mi
        readinessProbe:
          httpGet:
            path: /health
            port: {port}
          initialDelaySeconds: 3
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: hosted-mcp-{h_id}
  namespace: default
  labels:
    app: hosted-mcp-{h_id}
    app.kubernetes.io/managed-by: urumi-hosted-mcp
spec:
  selector:
    app: hosted-mcp-{h_id}
  ports:
  - port: {port}
    targetPort: {port}
"""

        # Apply via kubectl
        code, _, err = await self._run_kubectl(["apply", "-f", "-"], input_data=manifest)
        if code != 0:
            rec.status = "Failed"
            rec.errorMessage = f"Kubectl manifest application failed: {err}"
            raise RuntimeError(rec.errorMessage)

        # Background task to wait for healthy readiness & register with Gateway
        task = asyncio.create_task(self._verify_and_register(rec))
        self._background_tasks.add(task)
        task.add_done_callback(self._background_tasks.discard)

        return rec

    async def _verify_and_register(self, rec: HostedServerRecord, max_wait: int = 90):
        """Wait for the hosted pod to pass readiness probe, then auto-register in gateway."""
        start = time.time()
        while time.time() - start < max_wait:
            await asyncio.sleep(3.0)
            try:
                async with httpx.AsyncClient(timeout=3.0) as client:
                    resp = await client.get(rec.healthUrl)
                    if resp.status_code == 200:
                        rec.status = "Running"
                        rec.errorMessage = None
                        
                        # Register in Gateway upstream manager!
                        srv_id = f"srv-hosted-{rec.id}"
                        upstream_manager.register_hosted_server(
                            server_id=srv_id,
                            name=f"{rec.name} (Hosted)",
                            tag=rec.tag,
                            endpoint_url=rec.endpointUrl,
                            health_url=rec.healthUrl,
                            tools_list=rec.tools,
                        )
                        print(f"[HostedManager] Successfully registered hosted server '{rec.name}' with {rec.toolsCount} tools.", flush=True)
                        return
            except Exception:
                pass

        if rec.status == "Provisioning":
            rec.status = "Failed"
            rec.errorMessage = "Timed out waiting for hosted pod health check."

    async def scale_server(self, h_id: str, replicas: int) -> HostedServerRecord:
        """Scale pod replicas to 0 (sleep) or 1 (wake/resume)."""
        rec = self.hosted_servers.get(h_id)
        if not rec:
            raise ValueError(f"Hosted server '{h_id}' not found.")

        code, _, err = await self._run_kubectl([
            "scale", f"deployment/hosted-mcp-{h_id}", f"--replicas={replicas}"
        ])
        if code != 0:
            raise RuntimeError(f"Scale command failed: {err}")

        rec.replicas = replicas
        srv_id = f"srv-hosted-{h_id}"

        if replicas == 0:
            rec.status = "Sleeping"
            # Disable server in upstream manager to prevent routing
            srv = upstream_manager.servers.get(srv_id)
            if srv:
                srv.status = "Disabled"
        else:
            rec.status = "Provisioning"
            # Launch verifier to re-activate once healthy
            task = asyncio.create_task(self._verify_and_register(rec))
            self._background_tasks.add(task)
            task.add_done_callback(self._background_tasks.discard)

        return rec

    async def get_logs(self, h_id: str, tail: int = 100) -> str:
        """Stream container logs directly from Kubernetes."""
        code, stdout, stderr = await self._run_kubectl([
            "logs", "-l", f"app=hosted-mcp-{h_id}", f"--tail={tail}"
        ])
        if code != 0:
            return f"Error retrieving logs: {stderr or 'Pod may not be running yet.'}"
        return stdout or "--- No logs produced yet ---"

    async def delete_server(self, h_id: str) -> bool:
        """Teardown deployment and service, unregistering from gateway."""
        rec = self.hosted_servers.get(h_id)
        if not rec:
            raise ValueError(f"Hosted server '{h_id}' not found.")

        srv_id = f"srv-hosted-{h_id}"
        upstream_manager.unregister_hosted_server(srv_id)

        code, _, err = await self._run_kubectl([
            "delete", "deployment,service", f"hosted-mcp-{h_id}", "--ignore-not-found=true"
        ])
        if h_id in self.hosted_servers:
            del self.hosted_servers[h_id]
        return True


hosted_manager = HostedManager()
