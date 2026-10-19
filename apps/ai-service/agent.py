import asyncio
import json
import time
from typing import Any, Dict, List, Optional, Tuple
from groq import AsyncGroq
import httpx
from pydantic import BaseModel, Field

from ai_config import settings
from guardrails import guardrails, GuardrailResult
from prompts import build_system_prompt

# Standard schemas for upstream MCP tools so LLM function calling is guaranteed accurate
TOOL_SCHEMAS: Dict[str, Dict[str, Any]] = {
    "inventory__check_stock": {
        "type": "object",
        "properties": {
            "sku": {
                "type": "string",
                "description": "The SKU code of the product, e.g. SKU-1001",
            }
        },
        "required": ["sku"],
    },
    "inventory__list_low_stock": {
        "type": "object",
        "properties": {
            "threshold": {
                "type": "integer",
                "description": "Stock threshold below which items are flagged as low stock (default 10)",
                "default": 10,
            }
        },
    },
    "inventory__update_stock": {
        "type": "object",
        "properties": {
            "sku": {
                "type": "string",
                "description": "Product SKU identifier, e.g. SKU-1001",
            },
            "quantity": {
                "type": "integer",
                "description": "New total quantity on hand",
            },
            "expected_previous_quantity": {
                "type": "integer",
                "description": "Optional optimistic concurrency check. Rejects if current stock does not match.",
            },
            "reason": {
                "type": "string",
                "description": "Audit trail reason for the stock change",
            },
        },
        "required": ["sku", "quantity"],
    },
    "inventory__adjust_stock": {
        "type": "object",
        "properties": {
            "sku": {
                "type": "string",
                "description": "Product SKU identifier, e.g. SKU-1001",
            },
            "delta": {
                "type": "integer",
                "description": "Relative delta stock adjustment, e.g. +5 or -20",
            },
            "reason": {
                "type": "string",
                "description": "Audit trail reason for adjustment (e.g. 'Customer return', 'Damaged goods')",
            },
        },
        "required": ["sku", "delta"],
    },
    "inventory__batch_check_stock": {
        "type": "object",
        "properties": {
            "skus": {
                "type": "array",
                "items": {"type": "string"},
                "description": "List of SKU codes to check, e.g. ['SKU-1001', 'SKU-1002']",
            }
        },
        "required": ["skus"],
    },
    "woocommerce__list_products": {
        "type": "object",
        "properties": {
            "page": {
                "type": "integer",
                "description": "Page number (default 1)",
                "default": 1,
            },
            "per_page": {
                "type": "integer",
                "description": "Number of products per page (default 10)",
                "default": 10,
            },
        },
    },
    "woocommerce__create_product": {
        "type": "object",
        "properties": {
            "name": {
                "type": "string",
                "description": "Product title / name",
            },
            "regular_price": {
                "type": "string",
                "description": "Price in standard currency string, e.g. '19.99'",
            },
            "sku": {
                "type": "string",
                "description": "Optional SKU identifier",
            },
            "stock_quantity": {
                "type": "integer",
                "description": "Initial stock quantity (default 0)",
            },
            "description": {
                "type": "string",
                "description": "Product description",
            },
        },
        "required": ["name", "regular_price"],
    },
    "woocommerce__list_orders": {
        "type": "object",
        "properties": {
            "status": {
                "type": "string",
                "description": "Filter by order status (e.g. 'processing', 'completed', 'pending')",
            },
            "per_page": {
                "type": "integer",
                "description": "Number of orders to retrieve (default 10)",
                "default": 10,
            },
        },
    },
    "woocommerce__get_order": {
        "type": "object",
        "properties": {
            "order_id": {
                "type": "integer",
                "description": "Unique numeric WooCommerce order ID",
            }
        },
        "required": ["order_id"],
    },
    "woocommerce__create_order": {
        "type": "object",
        "properties": {
            "product_id": {
                "type": "integer",
                "description": "WooCommerce numeric product ID to purchase",
            },
            "quantity": {
                "type": "integer",
                "description": "Quantity to purchase (default 1)",
                "default": 1,
            },
            "customer_name": {
                "type": "string",
                "description": "Full name of the customer placing order",
                "default": "Sarah Chen",
            },
            "customer_email": {
                "type": "string",
                "description": "Billing email address",
                "default": "sarah.chen@example.com",
            },
            "status": {
                "type": "string",
                "description": "Initial order status: processing or pending",
                "default": "processing",
            },
        },
        "required": ["product_id"],
    },
    "woocommerce__update_order_status": {
        "type": "object",
        "properties": {
            "order_id": {
                "type": "integer",
                "description": "Order ID to update",
            },
            "status": {
                "type": "string",
                "description": "New status: pending, processing, on-hold, completed, cancelled, refunded, failed",
            },
        },
        "required": ["order_id", "status"],
    },
    "analytics__get_daily_sales": {
        "type": "object",
        "properties": {},
    },
    "analytics__get_revenue_summary": {
        "type": "object",
        "properties": {},
    },
    "analytics__get_top_selling_products": {
        "type": "object",
        "properties": {
            "limit": {
                "type": "integer",
                "description": "Maximum number of top products to return (default 5)",
                "default": 5,
            }
        },
    },
}

class ToolStep(BaseModel):
    stepNumber: int
    server: str
    tool: str
    args: Dict[str, Any]
    result: Any
    status: str  # '200 OK' | '403 Blocked' | 'Error'
    durationMs: float
    summaryNote: Optional[str] = None

class AgentResponse(BaseModel):
    content: str
    reasoning: Optional[str] = None
    steps: List[ToolStep] = Field(default_factory=list)
    guardrailsPassed: List[GuardrailResult] = Field(default_factory=list)
    status: str  # 'success' | 'blocked' | 'error'

class AgentRunner:
    def __init__(
        self,
        groq_api_key: Optional[str] = None,
        model: Optional[str] = None,
        gateway_url: Optional[str] = None,
    ):
        self.api_key = groq_api_key or settings.groq_api_key
        self.model = model or settings.llm_model
        self.fallback_model = settings.fallback_model
        self.gateway_url = (gateway_url or settings.gateway_url).rstrip("/")
        self.client = AsyncGroq(api_key=self.api_key)

    def _gateway_headers(self, api_key: str) -> Dict[str, str]:
        headers = {"X-API-Key": api_key}
        if settings.gateway_host_header:
            headers["Host"] = settings.gateway_host_header
        elif any(h in self.gateway_url for h in ["172.18.", "localhost", "127.0.0.1"]):
            headers["Host"] = "gateway.local"
        return headers

    async def _fetch_tools(self, api_key: str) -> List[Dict[str, Any]]:
        """Query the Gateway for all available tools across registered upstream MCP servers."""
        try:
            async with httpx.AsyncClient(timeout=10.0) as http:
                resp = await http.get(
                    f"{self.gateway_url}/api/v1/tools",
                    headers=self._gateway_headers(api_key),
                )
                if resp.status_code == 200:
                    return resp.json()
        except Exception as e:
            print(f"[AgentRunner] Warning: tool discovery warning: {e}")
        return []

    def _convert_to_groq_tools(self, tools: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Convert MCP tool specifications into OpenAI/Groq function calling format."""
        groq_tools = []
        for t in tools:
            name = t["namespacedName"]
            desc = t.get("description", f"Tool {name}")
            schema = t.get("schema")
            if not schema or not schema.get("properties"):
                schema = TOOL_SCHEMAS.get(name, {"type": "object", "properties": {}})

            groq_tools.append({
                "type": "function",
                "function": {
                    "name": name,
                    "description": desc,
                    "parameters": schema,
                },
            })
        return groq_tools

    async def _execute_tool_via_gateway(
        self, tool_name: str, arguments: Dict[str, Any], api_key: str
    ) -> Tuple[Any, float, str, str]:
        """Dispatch a tool call to the MCP Gateway and measure latency."""
        start = time.monotonic()
        target_server = "Gateway"
        if "woocommerce" in tool_name:
            target_server = "WooCommerce Store Server"
        elif "inventory" in tool_name:
            target_server = "Inventory Tracker Server"
        elif "analytics" in tool_name:
            target_server = "Business Analytics Server"

        try:
            headers = self._gateway_headers(api_key)
            headers["Content-Type"] = "application/json"
            async with httpx.AsyncClient(timeout=25.0) as http:
                resp = await http.post(
                    f"{self.gateway_url}/api/v1/tools/call",
                    headers=headers,
                    json={"tool": tool_name, "arguments": arguments},
                )
                duration_ms = round((time.monotonic() - start) * 1000, 1)

                if resp.status_code == 200:
                    data = resp.json()
                    return data.get("result", data), duration_ms, "200 OK", target_server
                elif resp.status_code == 403:
                    detail = resp.json().get("detail", "Permission Denied: 403 Forbidden")
                    return {"error": detail}, duration_ms, "403 Blocked", target_server
                else:
                    detail = resp.json().get("detail", f"Error {resp.status_code}")
                    return {"error": detail}, duration_ms, "Error", target_server
        except Exception as e:
            duration_ms = round((time.monotonic() - start) * 1000, 1)
            return {"error": str(e)}, duration_ms, "Error", target_server

    async def run(
        self,
        user_message: str,
        api_key: str,
        user_name: str = "Operator",
        user_role: str = "admin",
        conversation_history: Optional[List[Dict[str, str]]] = None,
    ) -> AgentResponse:
        guardrail_reports: List[GuardrailResult] = []

        # 1. Pre-execution Prompt Guardrail
        prompt_check = guardrails.validate_prompt(user_message)
        guardrail_reports.append(prompt_check)
        if not prompt_check.passed:
            return AgentResponse(
                content=f"⚠️ **Security Policy Violation:** {prompt_check.details}",
                reasoning="The prompt was blocked by input security guardrails.",
                steps=[],
                guardrailsPassed=guardrail_reports,
                status="blocked",
            )

        # 2. Tool Discovery from Gateway
        raw_tools = await self._fetch_tools(api_key=api_key)
        allowed_tool_names = [t["namespacedName"] for t in raw_tools if t.get("isAllowed", True)]
        groq_tools = self._convert_to_groq_tools(raw_tools)

        # 3. System Prompt Construction
        system_content = build_system_prompt(
            user_name=user_name,
            user_role=user_role,
            allowed_tools=allowed_tool_names,
        )

        messages: List[Dict[str, Any]] = [{"role": "system", "content": system_content}]
        if conversation_history:
            messages.extend(conversation_history)
        messages.append({"role": "user", "content": user_message})

        executed_steps: List[ToolStep] = []
        final_reasoning: Optional[str] = None
        final_content: str = ""

        # 4. Multi-Turn ReAct Loop
        for loop_idx in range(settings.max_agent_loops):
            try:
                response = await self.client.chat.completions.create(
                    model=self.model,
                    messages=messages,
                    tools=groq_tools if groq_tools else None,
                    temperature=settings.temperature,
                )
            except Exception as e:
                # Automatic fallback if primary 120b model hits rate limits
                try:
                    response = await self.client.chat.completions.create(
                        model=self.fallback_model,
                        messages=messages,
                        tools=groq_tools if groq_tools else None,
                        temperature=settings.temperature,
                    )
                except Exception as fallback_err:
                    return AgentResponse(
                        content=f"Model invocation failed: {str(e)} (Fallback: {str(fallback_err)})",
                        steps=executed_steps,
                        guardrailsPassed=guardrail_reports,
                        status="error",
                    )

            choice = response.choices[0]
            msg = choice.message

            # Capture model reasoning if provided
            if getattr(msg, "reasoning", None):
                final_reasoning = msg.reasoning

            # If model issued tool calls:
            if msg.tool_calls:
                # Serialize assistant message with tool calls to list
                assistant_dict = {
                    "role": "assistant",
                    "content": msg.content or None,
                    "tool_calls": [
                        {
                            "id": tc.id,
                            "type": "function",
                            "function": {
                                "name": tc.function.name,
                                "arguments": tc.function.arguments,
                            },
                        }
                        for tc in msg.tool_calls
                    ],
                }
                messages.append(assistant_dict)

                for tc in msg.tool_calls:
                    fn_name = tc.function.name
                    try:
                        fn_args = json.loads(tc.function.arguments) if tc.function.arguments else {}
                    except Exception:
                        fn_args = {}

                    # Guardrail: Tool Argument Bounds Check
                    arg_check = guardrails.validate_tool_arguments(fn_name, fn_args)
                    guardrail_reports.append(arg_check)

                    if not arg_check.passed:
                        tool_result = {"error": f"Guardrail Rejected: {arg_check.details}"}
                        step = ToolStep(
                            stepNumber=len(executed_steps) + 1,
                            server="Safety Guardrail Engine",
                            tool=fn_name,
                            args=fn_args,
                            result=tool_result,
                            status="403 Blocked",
                            durationMs=0.5,
                            summaryNote=arg_check.details,
                        )
                        executed_steps.append(step)
                    else:
                        # Execute via Gateway
                        tool_result, duration_ms, status_str, srv_name = await self._execute_tool_via_gateway(
                            tool_name=fn_name,
                            arguments=fn_args,
                            api_key=api_key,
                        )
                        step = ToolStep(
                            stepNumber=len(executed_steps) + 1,
                            server=srv_name,
                            tool=fn_name,
                            args=fn_args,
                            result=tool_result,
                            status=status_str,
                            durationMs=duration_ms,
                            summaryNote=f"Executed on {srv_name} with status {status_str}",
                        )
                        executed_steps.append(step)

                    # Append tool result to messages for next reasoning turn
                    messages.append({
                        "role": "tool",
                        "tool_call_id": tc.id,
                        "name": fn_name,
                        "content": json.dumps(tool_result),
                    })
            else:
                # No tool calls; final answer generated
                final_content = msg.content or ""
                break

        # 5. Post-execution Output Sanitization Guardrail
        sanitized_content = guardrails.sanitize_output(final_content)

        return AgentResponse(
            content=sanitized_content,
            reasoning=final_reasoning,
            steps=executed_steps,
            guardrailsPassed=guardrail_reports,
            status="success",
        )

agent_runner = AgentRunner()
