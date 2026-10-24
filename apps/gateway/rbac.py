from typing import Dict, List, Set, Optional

ROLE_ADMIN = "admin"
ROLE_INVENTORY_MANAGER = "inventory_manager"
ROLE_ANALYST = "analyst"
ROLE_SUPPORT_REP = "support_rep"

ALL_ROLES = [ROLE_ADMIN, ROLE_INVENTORY_MANAGER, ROLE_ANALYST, ROLE_SUPPORT_REP]

# Mapping of roles to permitted tool name sets
ROLE_PERMISSIONS: Dict[str, Set[str]] = {
    ROLE_ADMIN: {
        "woocommerce__list_products",
        "woocommerce__create_product",
        "woocommerce__list_orders",
        "woocommerce__get_order",
        "woocommerce__create_order",
        "woocommerce__update_order_status",
        "inventory__check_stock",
        "inventory__batch_check_stock",
        "inventory__list_low_stock",
        "inventory__update_stock",
        "inventory__adjust_stock",
        "analytics__get_daily_sales",
        "analytics__get_revenue_summary",
        "analytics__get_top_selling_products",
        "hosted_currency__convert_price",
        "hosted_currency__get_exchange_rates",
        "hosted_currency__format_international_pricing",
        "hosted_notify__send_slack_alert",
        "hosted_notify__send_email_dispatch",
        "hosted_notify__broadcast_banner",
        "hosted_shipping__calculate_freight",
        "hosted_shipping__track_shipment",
        "custom__discount_calculator",
    },
    ROLE_INVENTORY_MANAGER: {
        "inventory__check_stock",
        "inventory__batch_check_stock",
        "inventory__list_low_stock",
        "inventory__update_stock",
        "inventory__adjust_stock",
        "woocommerce__list_products",
        "woocommerce__list_orders",
        "hosted_currency__convert_price",
        "hosted_currency__get_exchange_rates",
        "hosted_currency__format_international_pricing",
        "hosted_notify__send_slack_alert",
        "custom__discount_calculator",
    },
    ROLE_ANALYST: {
        "analytics__get_daily_sales",
        "analytics__get_revenue_summary",
        "analytics__get_top_selling_products",
        "woocommerce__list_products",
        "woocommerce__list_orders",
        "hosted_currency__convert_price",
        "hosted_currency__get_exchange_rates",
        "hosted_currency__format_international_pricing",
        "custom__discount_calculator",
    },
    ROLE_SUPPORT_REP: {
        "woocommerce__list_products",
        "woocommerce__list_orders",
        "woocommerce__get_order",
        "woocommerce__create_order",
        "woocommerce__update_order_status",
        "inventory__check_stock",
        "hosted_currency__convert_price",
        "hosted_currency__get_exchange_rates",
        "hosted_currency__format_international_pricing",
    },
}

TOOL_RISK_PROFILES: Dict[str, str] = {
    "woocommerce__list_products": "Low (Read-only)",
    "woocommerce__create_product": "High (Write Mutation)",
    "woocommerce__list_orders": "Medium (Customer PII)",
    "woocommerce__get_order": "Medium (Customer PII)",
    "woocommerce__create_order": "High (Financial Mutation)",
    "woocommerce__update_order_status": "Critical (Financial Impact)",
    "inventory__check_stock": "Low (Read-only)",
    "inventory__batch_check_stock": "Low (Read-only)",
    "inventory__list_low_stock": "Low (Read-only)",
    "inventory__update_stock": "Critical (Stock Discrepancy)",
    "inventory__adjust_stock": "Critical (Stock Mutation)",
    "analytics__get_daily_sales": "Medium (Read Aggregate)",
    "analytics__get_revenue_summary": "Critical (Financial Impact)",
    "analytics__get_top_selling_products": "Medium (Read Aggregate)",
    "hosted_currency__convert_price": "Low (Read-only)",
    "hosted_currency__get_exchange_rates": "Low (Read-only)",
    "hosted_currency__format_international_pricing": "Low (Read-only)",
    "hosted_notify__send_slack_alert": "Medium (Alert Dispatch)",
    "hosted_notify__send_email_dispatch": "Medium (Notification)",
    "hosted_notify__broadcast_banner": "High (Platform-wide)",
    "hosted_shipping__calculate_freight": "Low (Read-only)",
    "hosted_shipping__track_shipment": "Low (Read-only)",
    "custom__discount_calculator": "Low (Compute)",
}

def extract_tenant_from_tool(tool_name: str) -> Optional[str]:
    """
    Extract tenant store slug from a namespaced tool name.
    Example: 'store_tech__list_orders' -> 'tech'
             'woocommerce__list_orders' -> None (default store)
    """
    if tool_name.startswith("store_") and "__" in tool_name:
        prefix = tool_name.split("__", 1)[0]
        return prefix.replace("store_", "", 1)
    return None

def is_tenant_authorized(allowed_stores: Optional[List[str]], role: str, tenant_slug: Optional[str]) -> bool:
    """
    Verify whether the caller is entitled to access the specific store tenant.
    Enforces multi-tenant ownership boundaries independently of base role permissions.
    """
    if not tenant_slug:
        # Standard default store tools (woocommerce__*)
        return True
    if role == ROLE_ADMIN:
        return True
    if not allowed_stores:
        return False
    if "*" in allowed_stores:
        return True
    return tenant_slug.lower() in [s.lower() for s in allowed_stores]

def _normalize_tool_for_rbac(tool_name: str) -> str:
    """Normalize dynamic tenant tool names (e.g. store_fashion__list_orders) to base tool (woocommerce__list_orders)."""
    if tool_name.startswith("store_") and "__" in tool_name:
        action = tool_name.split("__", 1)[1]
        return f"woocommerce__{action}"
    return tool_name

def is_tool_allowed(
    role: str,
    tool_name: str,
    allowed_stores: Optional[List[str]] = None,
) -> bool:
    """
    Check if the given role and tenant permissions permit invoking the tool.
    Enforces BOTH:
    1. Tenant store ownership / entitlement.
    2. Granular role-based capability for the action.
    """
    # 1. Tenant ownership verification
    tenant = extract_tenant_from_tool(tool_name)
    if tenant and not is_tenant_authorized(allowed_stores, role, tenant):
        return False

    # 2. Base role capability verification
    if role == ROLE_ADMIN:
        return True
    allowed = ROLE_PERMISSIONS.get(role, set())
    if tool_name in allowed:
        return True
    normalized = _normalize_tool_for_rbac(tool_name)
    return normalized in allowed

def filter_allowed_tools(
    role: str,
    all_tool_names: List[str],
    allowed_stores: Optional[List[str]] = None,
) -> List[str]:
    """
    Filter list of tools to only those permitted for the role AND authorized for the caller's tenant stores.
    """
    result = []
    for t in all_tool_names:
        if is_tool_allowed(role, t, allowed_stores):
            result.append(t)
    return result

def get_tool_risk(tool_name: str) -> str:
    """Return risk profile category for a given tool."""
    normalized = _normalize_tool_for_rbac(tool_name)
    return TOOL_RISK_PROFILES.get(normalized, TOOL_RISK_PROFILES.get(tool_name, "Low (Read-only)"))
