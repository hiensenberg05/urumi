import re
from typing import Any, Dict, List, Optional
from pydantic import BaseModel

class GuardrailResult(BaseModel):
    passed: bool
    check_name: str
    details: Optional[str] = None

class SafetyGuardrails:
    # Prompt injection and jailbreak signatures
    INJECTION_PATTERNS = [
        r"ignore\s+(all\s+)?(previous|prior)\s+instructions",
        r"bypass\s+(all\s+)?(guardrails|security|restrictions|filters)",
        r"you\s+are\s+now\s+in\s+developer\s+mode",
        r"disregard\s+system\s+prompt",
        r"pretend\s+you\s+have\s+root\s+access",
        r"pretend\s+to\s+be\s+admin",
        r"act\s+as\s+(dan|an?\s+unrestricted\s+ai|admin|system\s+administrator)",
        r"elevate\s+(my\s+)?(privileges|role)",
        r"override\s+(security|role|permission|rules)",
        r"disable\s+(rbac|guardrails|safety)",
        r"exfiltrate\s+(api\s+)?keys?",
        r"(print|reveal|show|dump)\s+your\s+(initial|system)\s+prompt",
        r"dump\s+(all\s+)?(database|credentials|tokens|keys)",
        r"drop\s+table\s+",
        r"delete\s+from\s+",
        r"format\s+drive\s+",
        r"rm\s+-rf\s+",
    ]

    # Non-business out-of-scope patterns
    NON_BUSINESS_PATTERNS = [
        r"write\s+(a\s+)?(poem|song|story|haiku|essay|joke|novel)",
        r"(tell\s+me|generate)\s+(a\s+)?(joke|riddle|bedtime\s+story)",
        r"(recipe|cooking\s+instructions)\s+for",
        r"how\s+to\s+(cook|bake|make\s+a\s+(cake|pizza|burger|pasta))",
        r"who\s+(won|is|was)\s+(the\s+)?(world\s+cup|super\s+bowl|president|prime\s+minister|oscar)",
        r"what\s+is\s+the\s+capital\s+of",
        r"meaning\s+of\s+life",
        r"horoscope|astrology|zodiac",
    ]

    VALID_ORDER_STATUSES = {
        "pending", "processing", "on-hold", "completed", "cancelled", "refunded", "failed"
    }

    SUPPORT_ALLOWED_TOOLS = {
        "woocommerce__list_orders",
        "woocommerce__get_order",
        "woocommerce__update_order_status",
        "inventory__check_stock",
        "inventory__batch_check_stock",
    }

    INVENTORY_ALLOWED_TOOLS = {
        "inventory__check_stock",
        "inventory__batch_check_stock",
        "inventory__list_low_stock",
        "inventory__update_stock",
        "inventory__adjust_stock",
        "woocommerce__list_products",
        "woocommerce__list_orders",
    }

    ANALYST_ALLOWED_TOOLS = {
        "analytics__get_daily_sales",
        "analytics__get_revenue_summary",
        "analytics__get_top_selling_products",
        "woocommerce__list_products",
        "woocommerce__list_orders",
    }

    def validate_prompt(self, user_prompt: str) -> GuardrailResult:
        """Check for adversarial prompt injection, jailbreaks, and destructive instructions."""
        prompt_lower = user_prompt.lower()

        for pattern in self.INJECTION_PATTERNS:
            if re.search(pattern, prompt_lower):
                return GuardrailResult(
                    passed=False,
                    check_name="Prompt Injection Defense",
                    details=f"Adversarial or security bypass pattern detected: '{pattern}'",
                )

        for pattern in self.NON_BUSINESS_PATTERNS:
            if re.search(pattern, prompt_lower):
                return GuardrailResult(
                    passed=False,
                    check_name="Enterprise Domain Guardrail",
                    details="Out-of-scope request. Urumi AI Agent is strictly restricted to enterprise e-commerce, inventory, orders, and business analytics operations.",
                )

        if len(user_prompt.strip()) == 0:
            return GuardrailResult(
                passed=False,
                check_name="Empty Prompt Check",
                details="Input prompt cannot be empty.",
            )

        return GuardrailResult(
            passed=True,
            check_name="Prompt Security Check",
            details="Passed prompt injection and safety filter.",
        )

    def validate_role_permissions(self, role: str, tool_name: str) -> GuardrailResult:
        """Enforce RBAC policy at the AI Guardrail layer."""
        if role in ("admin", "ROLE_ADMIN"):
            return GuardrailResult(
                passed=True,
                check_name="RBAC Authorization Guardrail",
                details="Administrator granted universal access.",
            )
        if role == "support_rep" and tool_name not in self.SUPPORT_ALLOWED_TOOLS:
            return GuardrailResult(
                passed=False,
                check_name="RBAC Authorization Guardrail",
                details=f"Permission Denied: Role 'support_rep' is not authorized to execute tool '{tool_name}'.",
            )
        if role == "inventory_manager" and tool_name not in self.INVENTORY_ALLOWED_TOOLS:
            return GuardrailResult(
                passed=False,
                check_name="RBAC Authorization Guardrail",
                details=f"Permission Denied: Role 'inventory_manager' is not authorized to execute tool '{tool_name}'.",
            )
        if role == "analyst" and tool_name not in self.ANALYST_ALLOWED_TOOLS:
            return GuardrailResult(
                passed=False,
                check_name="RBAC Authorization Guardrail",
                details=f"Permission Denied: Role 'analyst' is not authorized to execute tool '{tool_name}'.",
            )
        return GuardrailResult(
            passed=True,
            check_name="RBAC Authorization Guardrail",
            details=f"Tool '{tool_name}' verified permitted for role '{role}'.",
        )

    def validate_tool_arguments(self, tool_name: str, args: Dict[str, Any]) -> GuardrailResult:
        """Enforce business logic bounds and data sanitization before dispatching tool calls."""
        # Stock Update Bounds
        if "update_stock" in tool_name:
            qty = args.get("quantity")
            if qty is not None:
                if not isinstance(qty, (int, float)) or qty < 0:
                    return GuardrailResult(
                        passed=False,
                        check_name="Inventory Bounds Check",
                        details=f"Invalid inventory quantity: {qty}. Stock cannot be negative.",
                    )
                if qty > 500000:
                    return GuardrailResult(
                        passed=False,
                        check_name="Inventory Bounds Check",
                        details=f"Quantity {qty} exceeds maximum batch threshold (500,000 units).",
                    )

        # Stock Adjustment Bounds (Safe relative delta & reason length)
        if "adjust_stock" in tool_name:
            delta = args.get("delta")
            if delta is None:
                return GuardrailResult(
                    passed=False,
                    check_name="Stock Adjustment Check",
                    details="Missing required parameter 'delta' for stock adjustment.",
                )
            if not isinstance(delta, int):
                try:
                    delta = int(delta)
                except (ValueError, TypeError):
                    return GuardrailResult(
                        passed=False,
                        check_name="Stock Adjustment Check",
                        details=f"Invalid delta value '{delta}'. Delta must be an integer.",
                    )
            if delta == 0:
                return GuardrailResult(
                    passed=False,
                    check_name="Stock Adjustment Check",
                    details="Stock delta cannot be 0. Provide a non-zero positive or negative adjustment.",
                )
            if abs(delta) > 50000:
                return GuardrailResult(
                    passed=False,
                    check_name="Stock Adjustment Bounds",
                    details=f"Adjustment delta {delta} exceeds safe single-transaction threshold (±50,000 units).",
                )
            reason = args.get("reason")
            if reason and len(str(reason)) > 500:
                return GuardrailResult(
                    passed=False,
                    check_name="Audit Trail Check",
                    details="Reason parameter exceeds maximum length of 500 characters.",
                )

        # Batch Check Stock bounds
        if "batch_check_stock" in tool_name:
            skus = args.get("skus")
            if not isinstance(skus, list) or len(skus) == 0:
                return GuardrailResult(
                    passed=False,
                    check_name="Batch Lookup Check",
                    details="Parameter 'skus' must be a non-empty list of SKU strings.",
                )
            if len(skus) > 100:
                return GuardrailResult(
                    passed=False,
                    check_name="Batch Lookup Bounds",
                    details=f"Batch size {len(skus)} exceeds maximum limit of 100 SKUs per request.",
                )

        # Price Bounds on Product Creation
        if "create_product" in tool_name:
            price_val = args.get("regular_price")
            if price_val is not None:
                try:
                    price_float = float(price_val)
                    if price_float < 0:
                        return GuardrailResult(
                            passed=False,
                            check_name="Pricing Bounds Check",
                            details="Product price cannot be negative.",
                        )
                    if price_float > 1000000:
                        return GuardrailResult(
                            passed=False,
                            check_name="Pricing Bounds Check",
                            details="Product price exceeds single-item limit ($1,000,000).",
                        )
                except ValueError:
                    return GuardrailResult(
                        passed=False,
                        check_name="Pricing Format Check",
                        details=f"Invalid price value format: '{price_val}'.",
                    )

        # Order Status Validation
        if "update_order_status" in tool_name:
            target_status = str(args.get("status", "")).lower()
            if target_status not in self.VALID_ORDER_STATUSES:
                return GuardrailResult(
                    passed=False,
                    check_name="Order Lifecycle Validation",
                    details=f"Invalid order status '{target_status}'. Permitted: {sorted(list(self.VALID_ORDER_STATUSES))}",
                )

        return GuardrailResult(
            passed=True,
            check_name="Parameter Verification",
            details=f"Arguments for tool '{tool_name}' verified within operational bounds.",
        )

    def sanitize_output(self, text: str) -> str:
        """Post-execution redaction of PII, secrets, API keys, and sensitive tokens."""
        if not text:
            return ""

        # Redact Groq API Keys (gsk_...)
        sanitized = re.sub(r"gsk_[a-zA-Z0-9]{20,}", "gsk_********************", text)

        # Redact WooCommerce Consumer Keys/Secrets (ck_..., cs_...)
        sanitized = re.sub(r"ck_[a-zA-Z0-9]{20,}", "ck_********************", sanitized)
        sanitized = re.sub(r"cs_[a-zA-Z0-9]{20,}", "cs_********************", sanitized)

        # Redact Internal Gateway API Keys (admin-key-..., inv-key-..., support-key-..., adm-key-...)
        sanitized = re.sub(r"(?:admin|inv|support|adm)-key-[a-zA-Z0-9_-]{6,}", "[REDACTED_API_KEY]", sanitized)

        # Redact Bearer JWT tokens
        sanitized = re.sub(r"eyJ[a-zA-Z0-9-_=]+\.eyJ[a-zA-Z0-9-_=]+\.[a-zA-Z0-9-_.+/=]+", "[REDACTED_JWT_TOKEN]", sanitized)

        # Redact 16-digit credit cards
        sanitized = re.sub(r"\b(?:\d{4}[ -]?){3}\d{4}\b", "[REDACTED_CARD_NUMBER]", sanitized)

        return sanitized

guardrails = SafetyGuardrails()
