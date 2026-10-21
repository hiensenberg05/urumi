"""
Kubernetes API Client for Multi-Store Provisioning.
Supports dual-mode execution:
1. In-cluster mode: directly speaks REST/JSON to https://kubernetes.default.svc using ServiceAccount tokens.
2. CLI mode: executes kubectl commands asynchronously via subprocess when running outside cluster.
"""
import asyncio
import json
import os
import shutil
from typing import Any, Dict, List, Optional
import httpx

class KubernetesClient:
    def __init__(self):
        self.in_cluster = os.path.exists("/var/run/secrets/kubernetes.io/serviceaccount/token")
        self.sa_token: Optional[str] = None
        self.api_base: str = "https://kubernetes.default.svc"
        self.kubectl_path = shutil.which("kubectl") or "/usr/local/bin/kubectl" or "/snap/bin/kubectl"

        if self.in_cluster:
            try:
                with open("/var/run/secrets/kubernetes.io/serviceaccount/token", "r") as f:
                    self.sa_token = f.read().strip()
            except Exception:
                self.in_cluster = False

    def _headers(self) -> Dict[str, str]:
        headers = {"Content-Type": "application/json"}
        if self.sa_token:
            headers["Authorization"] = f"Bearer {self.sa_token}"
        return headers

    async def list_store_namespaces(self) -> List[str]:
        """List all namespaces matching 'store-'."""
        if self.in_cluster:
            try:
                async with httpx.AsyncClient(verify=False, timeout=5.0) as client:
                    resp = await client.get(f"{self.api_base}/api/v1/namespaces", headers=self._headers())
                    if resp.status_code == 200:
                        items = resp.json().get("items", [])
                        return [
                            item["metadata"]["name"]
                            for item in items
                            if item["metadata"]["name"].startswith("store-")
                            and item["status"]["phase"] != "Terminating"
                        ]
            except Exception as e:
                print(f"[K8sClient] Error listing namespaces in-cluster: {e}")

        # Fallback to kubectl
        try:
            proc = await asyncio.create_subprocess_exec(
                "kubectl", "get", "namespaces", "-o", "json",
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
            )
            stdout, _ = await proc.communicate()
            if proc.returncode == 0:
                data = json.loads(stdout.decode())
                return [
                    item["metadata"]["name"]
                    for item in data.get("items", [])
                    if item["metadata"]["name"].startswith("store-")
                    and item["status"]["phase"] != "Terminating"
                ]
        except Exception:
            pass
        return []

    async def apply_manifest(self, manifest: Dict[str, Any]) -> bool:
        """Apply a single Kubernetes manifest resource."""
        kind = manifest.get("kind", "")
        api_version = manifest.get("apiVersion", "v1")
        namespace = manifest.get("metadata", {}).get("namespace")
        name = manifest.get("metadata", {}).get("name", "")

        if self.in_cluster:
            try:
                # Map API version to endpoint path
                if "/" in api_version:
                    prefix = f"/apis/{api_version}"
                else:
                    prefix = f"/api/{api_version}"

                if namespace:
                    path = f"{prefix}/namespaces/{namespace}/{self._kind_to_plural(kind)}"
                else:
                    path = f"{prefix}/{self._kind_to_plural(kind)}"

                async with httpx.AsyncClient(verify=False, timeout=8.0) as client:
                    # Try POST (create)
                    resp = await client.post(
                        f"{self.api_base}{path}",
                        headers=self._headers(),
                        json=manifest,
                    )
                    if resp.status_code in (200, 201):
                        return True
                    elif resp.status_code == 409:
                        # Already exists, do PUT/PATCH
                        item_url = f"{self.api_base}{path}/{name}"
                        patch_resp = await client.put(
                            item_url,
                            headers=self._headers(),
                            json=manifest,
                        )
                        return patch_resp.status_code in (200, 201)
                    else:
                        print(f"[K8sClient] Warning: POST {path} returned {resp.status_code}: {resp.text}")
            except Exception as e:
                print(f"[K8sClient] In-cluster apply error: {e}")

        # Fallback to kubectl apply -f -
        try:
            proc = await asyncio.create_subprocess_exec(
                "kubectl", "apply", "-f", "-",
                stdin=asyncio.subprocess.PIPE,
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
            )
            stdout, stderr = await proc.communicate(json.dumps(manifest).encode())
            return proc.returncode == 0
        except Exception as e:
            print(f"[K8sClient] Kubectl apply error: {e}")
            return False

    async def delete_namespace(self, namespace: str) -> bool:
        """Cascade delete a tenant namespace."""
        if self.in_cluster:
            try:
                async with httpx.AsyncClient(verify=False, timeout=8.0) as client:
                    resp = await client.delete(
                        f"{self.api_base}/api/v1/namespaces/{namespace}",
                        headers=self._headers(),
                    )
                    if resp.status_code in (200, 202, 404):
                        return True
            except Exception as e:
                print(f"[K8sClient] In-cluster delete error: {e}")

        # Fallback to kubectl delete namespace --wait=false
        try:
            proc = await asyncio.create_subprocess_exec(
                "kubectl", "delete", "namespace", namespace, "--wait=false",
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
            )
            await proc.communicate()
            return proc.returncode in (0, 1)
        except Exception:
            return False

    async def copy_template_configmap(self, target_ns: str) -> bool:
        """Copy the store-template-sql ConfigMap into the target namespace if it exists."""
        if self.in_cluster:
            try:
                async with httpx.AsyncClient(verify=False, timeout=8.0) as client:
                    # Get from default namespace
                    resp = await client.get(
                        f"{self.api_base}/api/v1/namespaces/default/configmaps/store-template-sql",
                        headers=self._headers(),
                    )
                    if resp.status_code == 200:
                        cm_data = resp.json()
                        cm_data["metadata"] = {
                            "name": "store-template-sql",
                            "namespace": target_ns,
                        }
                        post_resp = await client.post(
                            f"{self.api_base}/api/v1/namespaces/{target_ns}/configmaps",
                            headers=self._headers(),
                            json=cm_data,
                        )
                        return post_resp.status_code in (200, 201, 409)
            except Exception as e:
                print(f"[K8sClient] Copy configmap in-cluster error: {e}")

        # Fallback to kubectl
        try:
            cmd = f"kubectl get configmap store-template-sql -n default -o json | jq '.metadata.namespace=\"{target_ns}\"' | kubectl apply -n {target_ns} -f -"
            proc = await asyncio.create_subprocess_shell(
                cmd,
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
            )
            await proc.communicate()
            return True
        except Exception:
            return False

    async def get_pod_status(self, namespace: str, app_name: str) -> str:
        """Check status of pod with label app.kubernetes.io/name=<app_name>."""
        if self.in_cluster:
            try:
                async with httpx.AsyncClient(verify=False, timeout=4.0) as client:
                    resp = await client.get(
                        f"{self.api_base}/api/v1/namespaces/{namespace}/pods?labelSelector=app.kubernetes.io/name={app_name}",
                        headers=self._headers(),
                    )
                    if resp.status_code == 200:
                        items = resp.json().get("items", [])
                        if not items:
                            return "Pending"
                        phase = items[0]["status"].get("phase", "Pending")
                        conditions = items[0]["status"].get("conditions", [])
                        is_ready = any(c.get("type") == "Ready" and c.get("status") == "True" for c in conditions)
                        return "Ready" if is_ready else phase
            except Exception:
                pass

        # Fallback to kubectl
        try:
            proc = await asyncio.create_subprocess_exec(
                "kubectl", "get", "pods", "-n", namespace, "-l", f"app.kubernetes.io/name={app_name}", "-o", "json",
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
            )
            stdout, _ = await proc.communicate()
            if proc.returncode == 0:
                data = json.loads(stdout.decode())
                items = data.get("items", [])
                if not items:
                    return "Pending"
                phase = items[0]["status"].get("phase", "Pending")
                conditions = items[0]["status"].get("conditions", [])
                is_ready = any(c.get("type") == "Ready" and c.get("status") == "True" for c in conditions)
                return "Ready" if is_ready else phase
        except Exception:
            pass
        return "Unknown"

    def _kind_to_plural(self, kind: str) -> str:
        mapping = {
            "Namespace": "namespaces",
            "ResourceQuota": "resourcequotas",
            "LimitRange": "limitranges",
            "NetworkPolicy": "networkpolicies",
            "Secret": "secrets",
            "ConfigMap": "configmaps",
            "PersistentVolumeClaim": "persistentvolumeclaims",
            "Service": "services",
            "Deployment": "deployments",
            "Ingress": "ingresses",
            "Pod": "pods",
        }
        return mapping.get(kind, kind.lower() + "s")

k8s_client = KubernetesClient()
