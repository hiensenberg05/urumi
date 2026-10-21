"""
Tenant Kubernetes manifest generator for isolated multi-store provisioning.
Includes:
- Namespace with tenant labels
- ResourceQuota (CPU, memory, pods, PVCs)
- LimitRange (default requests & limits)
- NetworkPolicy (tenant isolation - ingress from nginx/gateway only, egress restricted)
- Secrets (MariaDB, WordPress, WooCommerce API keys)
- PVCs (1Gi MariaDB, 1Gi WordPress)
- MariaDB Deployment & Service (auto-initialized from template ConfigMap)
- WordPress Deployment, Service & Ingress (with WooCommerce)
- WooCommerce MCP Server Deployment & Service
"""
from typing import Any, Dict, List

def build_tenant_manifests(
    store_id: str,
    store_name: str,
    admin_password: str = "AdminPassword123!",
    db_password: str = "wp_secure_password_123",
    consumer_key: str = "ck_98fbc18596f264871d8717904e5d61483acfb0a1",
    consumer_secret: str = "cs_12cda47b1981cb02720b08051a8bc8f895f3b7d1",
) -> List[Dict[str, Any]]:
    ns = f"store-{store_id}"
    ingress_host = f"{store_id}.store.local"

    manifests = [
        # 1. Namespace
        {
            "apiVersion": "v1",
            "kind": "Namespace",
            "metadata": {
                "name": ns,
                "labels": {
                    "app.kubernetes.io/managed-by": "urumi-gateway",
                    "urumi.io/store-id": store_id,
                    "urumi.io/tenant": "storefront",
                    "kubernetes.io/metadata.name": ns,
                },
            },
        },
        # 2. ResourceQuota (Guardrail)
        {
            "apiVersion": "v1",
            "kind": "ResourceQuota",
            "metadata": {
                "name": "store-quota",
                "namespace": ns,
            },
            "spec": {
                "hard": {
                    "requests.cpu": "600m",
                    "requests.memory": "800Mi",
                    "limits.cpu": "2000m",
                    "limits.memory": "2048Mi",
                    "persistentvolumeclaims": "2",
                    "pods": "6",
                },
            },
        },
        # 3. LimitRange (Guardrail)
        {
            "apiVersion": "v1",
            "kind": "LimitRange",
            "metadata": {
                "name": "store-limits",
                "namespace": ns,
            },
            "spec": {
                "limits": [
                    {
                        "type": "Container",
                        "default": {"cpu": "400m", "memory": "400Mi"},
                        "defaultRequest": {"cpu": "50m", "memory": "128Mi"},
                    }
                ],
            },
        },
        # 4. NetworkPolicy (Tenant Isolation)
        {
            "apiVersion": "networking.k8s.io/v1",
            "kind": "NetworkPolicy",
            "metadata": {
                "name": "tenant-isolation",
                "namespace": ns,
            },
            "spec": {
                "podSelector": {},
                "policyTypes": ["Ingress", "Egress"],
                "ingress": [
                    # Allow internal traffic from pods in the same namespace
                    {"from": [{"podSelector": {}}]},
                    # Allow traffic from NGINX ingress controller
                    {
                        "from": [
                            {
                                "namespaceSelector": {
                                    "matchLabels": {"kubernetes.io/metadata.name": "ingress-nginx"}
                                }
                            }
                        ]
                    },
                    # Allow traffic from MCP Gateway in default namespace
                    {
                        "from": [
                            {
                                "namespaceSelector": {
                                    "matchLabels": {"kubernetes.io/metadata.name": "default"}
                                },
                                "podSelector": {
                                    "matchLabels": {"app.kubernetes.io/name": "gateway"}
                                },
                            }
                        ]
                    },
                ],
                "egress": [
                    # Allow pod-to-pod inside this tenant
                    {"to": [{"podSelector": {}}]},
                    # Allow CoreDNS
                    {
                        "to": [
                            {
                                "namespaceSelector": {},
                                "podSelector": {"matchLabels": {"k8s-app": "kube-dns"}},
                            }
                        ],
                        "ports": [
                            {"protocol": "UDP", "port": 53},
                            {"protocol": "TCP", "port": 53},
                        ],
                    },
                    # Allow TCP response egress to Gateway in default namespace
                    {
                        "to": [
                            {
                                "namespaceSelector": {
                                    "matchLabels": {"kubernetes.io/metadata.name": "default"}
                                },
                                "podSelector": {
                                    "matchLabels": {"app.kubernetes.io/name": "gateway"}
                                },
                            }
                        ]
                    },
                    # Allow TCP response egress to Ingress controller
                    {
                        "to": [
                            {
                                "namespaceSelector": {
                                    "matchLabels": {"kubernetes.io/metadata.name": "ingress-nginx"}
                                }
                            }
                        ]
                    },
                    # Allow external outbound internet, BLOCK other store namespaces
                    {
                        "to": [
                            {
                                "ipBlock": {
                                    "cidr": "0.0.0.0/0",
                                    "except": [
                                        "10.0.0.0/8",
                                        "172.16.0.0/12",
                                        "192.168.0.0/16",
                                    ],
                                }
                            }
                        ]
                    },
                ],
            },
        },
        # 5. Secrets
        {
            "apiVersion": "v1",
            "kind": "Secret",
            "metadata": {
                "name": "mariadb-secret",
                "namespace": ns,
            },
            "type": "Opaque",
            "stringData": {
                "mariadb-root-password": "mariadb_root_password_123",
                "mariadb-password": db_password,
            },
        },
        {
            "apiVersion": "v1",
            "kind": "Secret",
            "metadata": {
                "name": "wordpress-secret",
                "namespace": ns,
            },
            "type": "Opaque",
            "stringData": {
                "db-password": db_password,
                "admin-password": admin_password,
            },
        },
        {
            "apiVersion": "v1",
            "kind": "Secret",
            "metadata": {
                "name": "woocommerce-api-keys",
                "namespace": ns,
            },
            "type": "Opaque",
            "stringData": {
                "WC_CONSUMER_KEY": consumer_key,
                "WC_CONSUMER_SECRET": consumer_secret,
            },
        },
        # 6. Persistent Volume Claims
        {
            "apiVersion": "v1",
            "kind": "PersistentVolumeClaim",
            "metadata": {
                "name": "mariadb-pvc",
                "namespace": ns,
            },
            "spec": {
                "accessModes": ["ReadWriteOnce"],
                "resources": {"requests": {"storage": "1Gi"}},
            },
        },
        {
            "apiVersion": "v1",
            "kind": "PersistentVolumeClaim",
            "metadata": {
                "name": "wordpress-pvc",
                "namespace": ns,
            },
            "spec": {
                "accessModes": ["ReadWriteOnce"],
                "resources": {"requests": {"storage": "1Gi"}},
            },
        },
        # 7. MariaDB Service & Deployment
        {
            "apiVersion": "v1",
            "kind": "Service",
            "metadata": {
                "name": "mariadb",
                "namespace": ns,
            },
            "spec": {
                "type": "ClusterIP",
                "ports": [{"port": 3306, "targetPort": 3306, "name": "mysql"}],
                "selector": {"app.kubernetes.io/name": "mariadb"},
            },
        },
        {
            "apiVersion": "apps/v1",
            "kind": "Deployment",
            "metadata": {
                "name": "mariadb",
                "namespace": ns,
            },
            "spec": {
                "replicas": 1,
                "selector": {"matchLabels": {"app.kubernetes.io/name": "mariadb"}},
                "template": {
                    "metadata": {"labels": {"app.kubernetes.io/name": "mariadb"}},
                    "spec": {
                        "containers": [
                            {
                                "name": "mariadb",
                                "image": "mariadb:11.4",
                                "imagePullPolicy": "IfNotPresent",
                                "env": [
                                    {"name": "MARIADB_ROOT_PASSWORD", "value": "mariadb_root_password_123"},
                                    {"name": "MARIADB_DATABASE", "value": "wordpress"},
                                    {"name": "MARIADB_USER", "value": "wordpress"},
                                    {"name": "MARIADB_PASSWORD", "value": db_password},
                                ],
                                "ports": [{"containerPort": 3306, "name": "mysql"}],
                                "volumeMounts": [
                                    {"name": "data", "mountPath": "/var/lib/mysql"},
                                    {"name": "init-sql", "mountPath": "/docker-entrypoint-initdb.d"},
                                ],
                                "resources": {
                                    "requests": {"cpu": "50m", "memory": "128Mi"},
                                    "limits": {"cpu": "500m", "memory": "512Mi"},
                                },
                            }
                        ],
                        "volumes": [
                            {"name": "data", "persistentVolumeClaim": {"claimName": "mariadb-pvc"}},
                            {
                                "name": "init-sql",
                                "configMap": {"name": "store-template-sql", "optional": True},
                            },
                        ],
                    },
                },
            },
        },
        # 8. WordPress Service, Deployment & Ingress
        {
            "apiVersion": "v1",
            "kind": "Service",
            "metadata": {
                "name": "wordpress",
                "namespace": ns,
            },
            "spec": {
                "type": "ClusterIP",
                "ports": [{"port": 80, "targetPort": 80, "name": "http"}],
                "selector": {"app.kubernetes.io/name": "wordpress"},
            },
        },
        {
            "apiVersion": "apps/v1",
            "kind": "Deployment",
            "metadata": {
                "name": "wordpress",
                "namespace": ns,
            },
            "spec": {
                "replicas": 1,
                "strategy": {"type": "Recreate"},
                "selector": {"matchLabels": {"app.kubernetes.io/name": "wordpress"}},
                "template": {
                    "metadata": {"labels": {"app.kubernetes.io/name": "wordpress"}},
                    "spec": {
                        "initContainers": [
                            {
                                "name": "copy-template",
                                "image": "wordpress:6.7-php8.2-apache",
                                "imagePullPolicy": "IfNotPresent",
                                "command": [
                                    "sh",
                                    "-c",
                                    "if [ ! -f /var/www/html/wp-config.php ] && [ -d /template-wp ]; then cp -a /template-wp/. /var/www/html/; fi",
                                ],
                                "volumeMounts": [
                                    {"name": "html", "mountPath": "/var/www/html"},
                                    {"name": "template-wp", "mountPath": "/template-wp", "readOnly": True},
                                ],
                            }
                        ],
                        "containers": [
                            {
                                "name": "wordpress",
                                "image": "wordpress:6.7-php8.2-apache",
                                "imagePullPolicy": "IfNotPresent",
                                "env": [
                                    {"name": "WORDPRESS_DB_HOST", "value": "mariadb:3306"},
                                    {"name": "WORDPRESS_DB_NAME", "value": "wordpress"},
                                    {"name": "WORDPRESS_DB_USER", "value": "wordpress"},
                                    {"name": "WORDPRESS_DB_PASSWORD", "value": db_password},
                                    {
                                        "name": "WORDPRESS_CONFIG_EXTRA",
                                        "value": f"define('WP_HOME', 'http://{ingress_host}');\ndefine('WP_SITEURL', 'http://{ingress_host}');\n",
                                    },
                                ],
                                "ports": [{"containerPort": 80, "name": "http"}],
                                "volumeMounts": [{"name": "html", "mountPath": "/var/www/html"}],
                                "resources": {
                                    "requests": {"cpu": "100m", "memory": "256Mi"},
                                    "limits": {"cpu": "800m", "memory": "768Mi"},
                                },
                            }
                        ],
                        "volumes": [
                            {"name": "html", "persistentVolumeClaim": {"claimName": "wordpress-pvc"}},
                            {"name": "template-wp", "hostPath": {"path": "/var/urumi-template-wp", "type": "DirectoryOrCreate"}},
                        ],
                    },
                },
            },
        },
        {
            "apiVersion": "networking.k8s.io/v1",
            "kind": "Ingress",
            "metadata": {
                "name": "wordpress-ingress",
                "namespace": ns,
                "annotations": {
                    "kubernetes.io/ingress.class": "nginx",
                    "nginx.ingress.kubernetes.io/proxy-read-timeout": "300",
                },
            },
            "spec": {
                "ingressClassName": "nginx",
                "rules": [
                    {
                        "host": ingress_host,
                        "http": {
                            "paths": [
                                {
                                    "path": "/",
                                    "pathType": "Prefix",
                                    "backend": {
                                        "service": {"name": "wordpress", "port": {"number": 80}}
                                    },
                                }
                            ]
                        },
                    }
                ],
            },
        },
        # 9. WooCommerce MCP Server Service & Deployment
        {
            "apiVersion": "v1",
            "kind": "Service",
            "metadata": {
                "name": "woocommerce-mcp",
                "namespace": ns,
            },
            "spec": {
                "type": "ClusterIP",
                "ports": [{"port": 8001, "targetPort": 8001, "name": "http"}],
                "selector": {"app.kubernetes.io/name": "woocommerce-mcp"},
            },
        },
        {
            "apiVersion": "apps/v1",
            "kind": "Deployment",
            "metadata": {
                "name": "woocommerce-mcp",
                "namespace": ns,
            },
            "spec": {
                "replicas": 1,
                "selector": {"matchLabels": {"app.kubernetes.io/name": "woocommerce-mcp"}},
                "template": {
                    "metadata": {"labels": {"app.kubernetes.io/name": "woocommerce-mcp"}},
                    "spec": {
                        "containers": [
                            {
                                "name": "woocommerce-mcp",
                                "image": "urumi/woocommerce-mcp:v1.1.0",
                                "imagePullPolicy": "IfNotPresent",
                                "ports": [{"containerPort": 8001, "name": "http"}],
                                "env": [
                                    {"name": "PORT", "value": "8001"},
                                    {"name": "WC_URL", "value": f"http://wordpress.{ns}.svc.cluster.local"},
                                    {"name": "WC_HOST_HEADER", "value": ingress_host},
                                    {"name": "WC_VERIFY_SSL", "value": "false"},
                                    {
                                        "name": "WC_CONSUMER_KEY",
                                        "valueFrom": {
                                            "secretKeyRef": {
                                                "name": "woocommerce-api-keys",
                                                "key": "WC_CONSUMER_KEY",
                                            }
                                        },
                                    },
                                    {
                                        "name": "WC_CONSUMER_SECRET",
                                        "valueFrom": {
                                            "secretKeyRef": {
                                                "name": "woocommerce-api-keys",
                                                "key": "WC_CONSUMER_SECRET",
                                            }
                                        },
                                    },
                                ],
                                "resources": {
                                    "requests": {"cpu": "50m", "memory": "100Mi"},
                                    "limits": {"cpu": "250m", "memory": "256Mi"},
                                },
                            }
                        ],
                    },
                },
            },
        },
    ]
    return manifests
