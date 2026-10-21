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
    },
    ROLE_INVENTORY_MANAGER: {
        "inventory__check_stock",
        "inventory__batch_check_stock",
        "inventory__list_low_stock",
        "inventory__update_stock",
        "inventory__adjust_stock",
        "woocommerce__list_products",
        "woocommerce__list_orders",
    },
    ROLE_ANALYST: {
        "analytics__get_daily_sales",
        "analytics__get_revenue_summary",
        "analytics__get_top_selling_products",
        "woocommerce__list_products",
        "woocommerce__list_orders",
    },
    ROLE_SUPPORT_REP: {
        "woocommerce__list_orders",
        "woocommerce__get_order",
        "woocommerce__update_order_status",
        "inventory__check_stock",
        "inventory__batch_check_stock",
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
}

def _normalize_tool_for_rbac(tool_name: str) -> str:
    """Normalize dynamic tenant tool names (e.g. store_fashion__list_orders) to base tool (woocommerce__list_orders)."""
    if tool_name.startswith("store_") and "__" in tool_name:
        action = tool_name.split("__", 1)[1]
        return f"woocommerce__{action}"
    return tool_name

def is_tool_allowed(role: str, tool_name: str) -> bool:
    """Check if the given role has permission to invoke the tool."""
    if role == ROLE_ADMIN:
        return True
    allowed = ROLE_PERMISSIONS.get(role, set())
    if tool_name in allowed:
        return True
    normalized = _normalize_tool_for_rbac(tool_name)
    return normalized in allowed

def filter_allowed_tools(role: str, all_tool_names: List[str]) -> List[str]:
    """Filter list of tools to only those permitted for the role."""
    if role == ROLE_ADMIN:
        return all_tool_names
    allowed = ROLE_PERMISSIONS.get(role, set())
    result = []
    for t in all_tool_names:
        if t in allowed:
            result.append(t)
        elif _normalize_tool_for_rbac(t) in allowed:
            result.append(t)
    return result

def get_tool_risk(tool_name: str) -> str:
    """Return risk profile category for a given tool."""
    normalized = _normalize_tool_for_rbac(tool_name)
    return TOOL_RISK_PROFILES.get(normalized, TOOL_RISK_PROFILES.get(tool_name, "Low (Read-only)"))
