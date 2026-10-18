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
        r"exfiltrate\s+(api\s+)?keys?",
        r"print\s+your\s+(initial|system)\s+prompt",
        r"drop\s+table\s+",
        r"delete\s+from\s+",
        r"format\s+drive\s+",
    ]

    VALID_ORDER_STATUSES = {
        "pending", "processing", "on-hold", "completed", "cancelled", "refunded", "failed"
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

        # Redact Bearer JWT tokens
        sanitized = re.sub(r"eyJ[a-zA-Z0-9-_=]+\.eyJ[a-zA-Z0-9-_=]+\.[a-zA-Z0-9-_.+/=]+", "[REDACTED_JWT_TOKEN]", sanitized)

        # Redact 16-digit credit cards
        sanitized = re.sub(r"\b(?:\d{4}[ -]?){3}\d{4}\b", "[REDACTED_CARD_NUMBER]", sanitized)

        return sanitized

guardrails = SafetyGuardrails()
