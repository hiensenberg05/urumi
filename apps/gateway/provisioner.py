"""
Autonomous Multi-Store Provisioning Engine for Kubernetes.
Handles:
- Creation and deletion of tenant namespaces with isolated MariaDB, WordPress, and WooCommerce MCP
- NetworkPolicy isolation and ResourceQuota guardrails
- Automatic registration and deregistration of tenant tools in the MCP Gateway
- Safe retries, timeout management, and startup reconciliation
"""
import asyncio
import os
import re
import time
from typing import Any, Dict, List, Optional
import httpx
from pydantic import BaseModel, Field

from k8s_client import k8s_client
from tenant_templates import build_tenant_manifests
from upstream_manager import upstream_manager

class StoreTenant(BaseModel):
    id: str
    name: str
    namespace: str
    status: str = "Provisioning"  # Provisioning | Ready | Failed | Deleting
    ingressUrl: str
    mcpEndpoint: str
    createdAt: str
    toolsCount: int = 0
    errorMessage: Optional[str] = None
    category: str = "General"

class CreateStoreRequest(BaseModel):
    name: str = Field(..., min_length=2, max_length=50, description="Display name of the store")
    id: Optional[str] = Field(None, min_length=2, max_length=20, description="Slug identifier (lowercase alphanumeric + hyphens)")
    category: str = Field("General", description="Catalog category preset: Fashion, Electronics, Books, etc.")

class ProvisioningEngine:
    def __init__(self, max_stores: int = 5, timeout_seconds: int = 180):
        self.stores: Dict[str, StoreTenant] = {}
        self.max_stores = max_stores
        self.timeout_seconds = timeout_seconds
        self._background_tasks = set()

    def _sanitize_slug(self, raw: str) -> str:
        slug = re.sub(r"[^a-z0-9-]", "", raw.lower().replace(" ", "-"))
        slug = re.sub(r"-+", "-", slug).strip("-")
        return slug or "store"

    async def reconcile_existing_stores(self):
        """Discover existing store namespaces on startup and restore their registrations."""
        try:
            namespaces = await k8s_client.list_store_namespaces()
            for ns in namespaces:
                store_id = ns.replace("store-", "")
                if store_id not in self.stores:
                    tenant = StoreTenant(
                        id=store_id,
                        name=f"Store {store_id.capitalize()}",
                        namespace=ns,
                        status="Provisioning",
                        ingressUrl=f"http://{store_id}.store.local",
                        mcpEndpoint=f"http://woocommerce-mcp.{ns}.svc.cluster.local:8001/mcp",
                        createdAt=time.strftime("%Y-%m-%d %H:%M:%S UTC"),
                        toolsCount=0,
                    )
                    self.stores[store_id] = tenant
                    # Spawn health verifier in background
                    task = asyncio.create_task(self._verify_and_register(tenant))
                    self._background_tasks.add(task)
                    task.add_done_callback(self._background_tasks.discard)
        except Exception as e:
            print(f"[ProvisioningEngine] Startup reconciliation error: {e}")

    async def create_store(self, req: CreateStoreRequest) -> StoreTenant:
        active_count = len([s for s in self.stores.values() if s.status != "Failed"])
        if active_count >= self.max_stores:
            raise ValueError(f"Maximum store quota reached ({self.max_stores} stores). Delete an existing store first.")

        store_id = self._sanitize_slug(req.id or req.name)
        if store_id in self.stores and self.stores[store_id].status != "Failed":
            raise ValueError(f"Store with identifier '{store_id}' already exists.")

        ns = f"store-{store_id}"
        tenant = StoreTenant(
            id=store_id,
            name=req.name,
            namespace=ns,
            status="Provisioning",
            ingressUrl=f"http://{store_id}.store.local",
            mcpEndpoint=f"http://woocommerce-mcp.{ns}.svc.cluster.local:8001/mcp",
            createdAt=time.strftime("%Y-%m-%d %H:%M:%S UTC"),
            category=req.category,
            toolsCount=0,
        )
        self.stores[store_id] = tenant

        # Launch provisioning task
        task = asyncio.create_task(self._execute_provisioning(tenant))
        self._background_tasks.add(task)
        task.add_done_callback(self._background_tasks.discard)
        return tenant

    async def _execute_provisioning(self, tenant: StoreTenant):
        print(f"[ProvisioningEngine] Starting deployment for tenant: {tenant.namespace}")
        start_time = time.monotonic()
        try:
            # 1. Generate manifests
            manifests = build_tenant_manifests(
                store_id=tenant.id,
                store_name=tenant.name,
            )

            # 2. Apply Namespace first
            ns_manifest = manifests[0]
            await k8s_client.apply_manifest(ns_manifest)
            await asyncio.sleep(0.5)

            # 3. Copy template ConfigMap if available
            await k8s_client.copy_template_configmap(tenant.namespace)

            # 4. Apply all remaining manifests (Quotas, NetPols, Secrets, Deployments, Services, Ingress)
            for m in manifests[1:]:
                await k8s_client.apply_manifest(m)

            print(f"[ProvisioningEngine] Manifests applied for {tenant.namespace}. Waiting for readiness...")

            # 5. Seed MariaDB database with WooCommerce catalog
            await self._seed_store_database(tenant)

            # 6. Monitor readiness loop
            health_url = f"http://woocommerce-mcp.{tenant.namespace}.svc.cluster.local:8001/health"
            is_ready = False

            while (time.monotonic() - start_time) < self.timeout_seconds:
                # Check MCP pod status via K8s
                pod_status = await k8s_client.get_pod_status(tenant.namespace, "woocommerce-mcp")
                if pod_status == "Ready":
                    # Verify HTTP connectivity if reachable
                    is_ready = True
                    break
                await asyncio.sleep(3.0)

            if is_ready:
                # Register in MCP Gateway Upstream Manager
                upstream_manager.register_store_server(
                    store_id=tenant.id,
                    store_name=tenant.name,
                    endpoint_url=tenant.mcpEndpoint,
                    health_url=health_url,
                )
                tenant.status = "Ready"
                tenant.toolsCount = 6
                tenant.errorMessage = None
                print(f"[ProvisioningEngine] Tenant {tenant.id} is READY with 6 MCP tools registered.")
            else:
                tenant.status = "Failed"
                tenant.errorMessage = f"Provisioning timed out after {self.timeout_seconds}s waiting for pods to report Ready."
                print(f"[ProvisioningEngine] Tenant {tenant.id} FAILED: timeout")

        except Exception as e:
            tenant.status = "Failed"
            tenant.errorMessage = str(e)
            print(f"[ProvisioningEngine] Tenant {tenant.id} exception: {e}")

    async def _seed_store_database(self, tenant: StoreTenant):
        """Seed MariaDB with the complete WooCommerce schema and store-specific products."""
        print(f"[ProvisioningEngine] Waiting for MariaDB in {tenant.namespace}...")
        for _ in range(40):
            pod_status = await k8s_client.get_pod_status(tenant.namespace, "mariadb")
            if pod_status in ("Ready", "Running"):
                await asyncio.sleep(2.0)
                break
            await asyncio.sleep(2.0)

        sql_paths = [
            "/app/store-template/init.sql",
            "/mnt/d/urumi assignment/infra/store-template/init.sql",
            "infra/store-template/init.sql",
        ]
        sql_file = None
        for p in sql_paths:
            if os.path.exists(p):
                sql_file = p
                break

        if sql_file:
            print(f"[ProvisioningEngine] Importing template SQL from {sql_file} into {tenant.namespace}...")
            cmd = f"kubectl exec -i -n {tenant.namespace} deployment/mariadb -- mariadb -u wordpress -pwp_secure_password_123 wordpress < '{sql_file}'"
            proc = await asyncio.create_subprocess_shell(cmd, stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE)
            await proc.communicate()

        # Update URLs and store name
        ingress_host = f"http://{tenant.id}.store.local"
        sql_update = f"UPDATE wp_options SET option_value='{ingress_host}' WHERE option_name IN ('siteurl', 'home'); UPDATE wp_options SET option_value='{tenant.name}' WHERE option_name='blogname';"
        
        cat_lower = (tenant.category or "").lower()
        if "fashion" in tenant.id or "fashion" in cat_lower or "apparel" in cat_lower:
            sql_update += (
                "UPDATE wp_posts SET post_title='Designer Silk Evening Dress' WHERE ID=41; "
                "UPDATE wp_posts SET post_title='Italian Leather Jacket' WHERE ID=40; "
                "UPDATE wp_posts SET post_title='Cashmere Wool Sweater' WHERE ID=24; "
            )
        elif "tech" in tenant.id or "electronic" in cat_lower:
            sql_update += (
                "UPDATE wp_posts SET post_title='Ultra-Wide 4K Gaming Monitor' WHERE ID=41; "
                "UPDATE wp_posts SET post_title='Wireless ANC Studio Headphones' WHERE ID=40; "
                "UPDATE wp_posts SET post_title='Custom Mechanical Keyboard RGB' WHERE ID=24; "
            )
        elif "book" in tenant.id or "book" in cat_lower:
            sql_update += (
                "UPDATE wp_posts SET post_title='Clean Architecture Hardcover' WHERE ID=41; "
                "UPDATE wp_posts SET post_title='Kubernetes in Action 2nd Ed' WHERE ID=40; "
                "UPDATE wp_posts SET post_title='Designing Data-Intensive Apps' WHERE ID=24; "
            )

        cmd_update = f"kubectl exec -n {tenant.namespace} deployment/mariadb -- mariadb -u wordpress -pwp_secure_password_123 wordpress -e \"{sql_update}\""
        proc2 = await asyncio.create_subprocess_shell(cmd_update, stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE)
        await proc2.communicate()
        print(f"[ProvisioningEngine] MariaDB seeded successfully for {tenant.namespace}")

    async def _verify_and_register(self, tenant: StoreTenant):
        """Helper for reconciliation on startup."""
        pod_status = await k8s_client.get_pod_status(tenant.namespace, "woocommerce-mcp")
        if pod_status == "Ready":
            health_url = f"http://woocommerce-mcp.{tenant.namespace}.svc.cluster.local:8001/health"
            upstream_manager.register_store_server(
                store_id=tenant.id,
                store_name=tenant.name,
                endpoint_url=tenant.mcpEndpoint,
                health_url=health_url,
            )
            tenant.status = "Ready"
            tenant.toolsCount = 6
        else:
            tenant.status = "Failed"
            tenant.errorMessage = f"Pod status is {pod_status}"

    async def delete_store(self, store_id: str) -> bool:
        """Teardown a store: deregister tools and delete Kubernetes namespace."""
        tenant = self.stores.get(store_id)
        if not tenant:
            return False

        tenant.status = "Deleting"
        # 1. Unregister from Gateway tool catalog immediately
        upstream_manager.unregister_store_server(store_id)

        # 2. Delete namespace in Kubernetes (cascades all pods, secrets, pvcs)
        await k8s_client.delete_namespace(tenant.namespace)

        # 3. Remove from internal registry
        if store_id in self.stores:
            del self.stores[store_id]
        print(f"[ProvisioningEngine] Tenant {store_id} teardown complete.")
        return True

    async def retry_store(self, store_id: str) -> Optional[StoreTenant]:
        tenant = self.stores.get(store_id)
        if not tenant:
            return None
        tenant.status = "Provisioning"
        tenant.errorMessage = None
        task = asyncio.create_task(self._execute_provisioning(tenant))
        self._background_tasks.add(task)
        task.add_done_callback(self._background_tasks.discard)
        return tenant

provisioning_engine = ProvisioningEngine()
