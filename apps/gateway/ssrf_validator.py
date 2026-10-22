"""
Enterprise Server-Side Request Forgery (SSRF) Protection Engine for Urumi MCP Gateway.
Protects against malicious URL injection, DNS rebinding, cloud metadata exfiltration
(AWS/GCP/Azure 169.254.169.254), loopback access, and prohibited internal address probing.
"""

import ipaddress
import socket
from urllib.parse import urlparse
from typing import Tuple, Optional, List

# Prohibited Cloud Metadata Hostnames & Domains
BLOCKED_METADATA_HOSTS = {
    "169.254.169.254",
    "metadata.google.internal",
    "metadata.goog",
    "metadata",
    "instance-data",
    "instance-data.ec2.internal",
    "100.100.100.200",  # Alibaba Cloud metadata
    "fd00:ec2::254",    # AWS IPv6 metadata
}

# Prohibited URL schemes (must only allow http and https)
ALLOWED_SCHEMES = {"http", "https"}

def validate_upstream_url(
    url: str,
    allow_cluster_internal: bool = True,
) -> Tuple[bool, Optional[str]]:
    """
    Validate an upstream URL against SSRF vulnerabilities.
    
    Returns:
        (is_safe: bool, error_reason: Optional[str])
    """
    if not url or not isinstance(url, str):
        return False, "Invalid URL: Must be a non-empty string."

    url = url.strip()

    # 1. Parse URL structure
    try:
        parsed = urlparse(url)
    except Exception as e:
        return False, f"Malformed URL format: {str(e)}"

    # 2. Scheme Enforcement (blocks file://, gopher://, ldap://, dict://)
    if not parsed.scheme or parsed.scheme.lower() not in ALLOWED_SCHEMES:
        return False, f"Prohibited URL scheme '{parsed.scheme}'. Only 'http://' and 'https://' are permitted."

    hostname = parsed.hostname
    if not hostname:
        return False, "Invalid URL: Missing hostname."

    hostname_lower = hostname.lower().strip("[]")

    # 3. Cloud Metadata Hostname Check
    if hostname_lower in BLOCKED_METADATA_HOSTS:
        return False, (
            f"SSRF Security Violation: Direct access to cloud metadata endpoint '{hostname}' "
            "is strictly forbidden (OWASP A10 / CWE-918)."
        )

    # 4. Check for Kubernetes Internal Control Plane IP
    if hostname_lower in ("kubernetes.default", "kubernetes.default.svc", "10.96.0.1"):
        return False, "SSRF Security Violation: Direct access to Kubernetes API server is prohibited."

    # 5. Check if hostname is an IP address
    try:
        ip = ipaddress.ip_address(hostname_lower)
        is_direct_ip = True
    except ValueError:
        ip = None
        is_direct_ip = False

    if is_direct_ip and ip is not None:
        # Block Link-Local (AWS/GCP metadata: 169.254.0.0/16)
        if ip.is_link_local:
            return False, f"SSRF Security Violation: Link-local address '{ip}' is blocked (Cloud Metadata Protection)."

        # Block Loopback (127.0.0.0/8, ::1)
        if ip.is_loopback:
            return False, f"SSRF Security Violation: Loopback address '{ip}' is blocked."

        # Block Unspecified (0.0.0.0, ::)
        if ip.is_unspecified:
            return False, f"SSRF Security Violation: Unspecified address '{ip}' is blocked."

        # Block Reserved / Multicast
        if ip.is_multicast or ip.is_reserved:
            return False, f"SSRF Security Violation: Multicast or reserved IP address '{ip}' is blocked."

        # If direct private IP and cluster-internal is restricted
        if not allow_cluster_internal and ip.is_private:
            return False, f"SSRF Security Violation: Private network target '{ip}' is blocked."

    # 6. DNS Resolution & Re-binding Defense
    # Resolve domain to IP addresses to prevent DNS rebinding attacks (e.g. evil.com -> 169.254.169.254)
    if not is_direct_ip:
        # Allow internal Kubernetes services (*.svc.cluster.local or local microservices) if permitted
        if allow_cluster_internal and (
            hostname_lower.endswith(".svc.cluster.local") or 
            hostname_lower.endswith(".internal") or 
            hostname_lower in ("woocommerce-mcp", "inventory-mcp", "analytics-mcp")
        ):
            return True, None

        try:
            # Resolve DNS records for hostname
            addr_info = socket.getaddrinfo(hostname_lower, parsed.port or 80, proto=socket.IPPROTO_TCP)
            resolved_ips: List[str] = [item[4][0] for item in addr_info]
            
            for resolved_ip_str in resolved_ips:
                resolved_ip = ipaddress.ip_address(resolved_ip_str)
                
                # Check if resolved IP is Link-Local or Loopback
                if resolved_ip.is_link_local:
                    return False, (
                        f"SSRF DNS Rebinding Violation: Hostname '{hostname}' resolved to prohibited "
                        f"cloud metadata address '{resolved_ip}'."
                    )
                if resolved_ip.is_loopback:
                    return False, (
                        f"SSRF DNS Rebinding Violation: Hostname '{hostname}' resolved to prohibited "
                        f"loopback address '{resolved_ip}'."
                    )
                if resolved_ip.is_unspecified or resolved_ip.is_multicast:
                    return False, (
                        f"SSRF Security Violation: Hostname '{hostname}' resolved to invalid address '{resolved_ip}'."
                    )
        except socket.gaierror:
            # If DNS fails to resolve during validation, warn but fail safely if it looks like a cloud address
            if "metadata" in hostname_lower or "169.254" in hostname_lower:
                return False, f"SSRF Security Violation: Suspicious cloud metadata pattern in '{hostname}'."
        except Exception:
            pass

    return True, None
