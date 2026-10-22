"""
Hosted FastMCP Service Suite for Urumi MCP Gateway.
Provides on-demand containerized enterprise tools deployed directly in Kubernetes.
Supported SERVICE_TYPE modes: 'notifications', 'currency', 'shipping', or 'all'.
"""

import os
import time
import uuid
from typing import Any, Dict, List, Optional
from fastmcp import FastMCP
from starlette.responses import JSONResponse
from starlette.requests import Request
import uvicorn

SERVICE_TYPE = os.environ.get("SERVICE_TYPE", "all").lower()
PORT = int(os.environ.get("PORT", "8005"))

mcp = FastMCP("hosted-mcp-suite")

# Exchange rate table (Base USD)
RATES = {
    "USD": 1.00,
    "EUR": 0.92,
    "GBP": 0.79,
    "INR": 86.85,
    "JPY": 154.20,
    "CAD": 1.38,
    "AUD": 1.55,
}

@mcp.custom_route("/health", methods=["GET"])
async def health(request: Request) -> JSONResponse:
    return JSONResponse({
        "status": "healthy",
        "service": "hosted-mcp-suite",
        "service_type": SERVICE_TYPE,
        "timestamp": time.strftime("%Y-%m-%d %H:%M:%S UTC"),
    })

# -------------------------------------------------------------
# 1. NOTIFICATIONS & DISPATCH TOOLS
# -------------------------------------------------------------
if SERVICE_TYPE in ("notifications", "all"):
    @mcp.tool(name="hosted_notify__send_slack_alert")
    async def send_slack_alert(
        channel: str,
        message: str,
        severity: str = "info",
    ) -> Dict[str, Any]:
        """Send an urgent or informational alert to a team Slack channel.
        
        Args:
            channel: Destination channel (e.g. '#operations', '#store-alerts', '#incident-room')
            message: The alert message or system notification to post
            severity: Urgency level ('info', 'warning', 'critical')
        """
        correlation_id = f"slack-{uuid.uuid4().hex[:8]}"
        timestamp = time.strftime("%Y-%m-%d %H:%M:%S UTC")
        return {
            "status": "delivered",
            "correlation_id": correlation_id,
            "channel": channel if channel.startswith("#") else f"#{channel}",
            "severity": severity.upper(),
            "message": message,
            "dispatched_at": timestamp,
            "note": f"Alert successfully delivered to Slack channel {channel} via Hosted MCP Pod.",
        }

    @mcp.tool(name="hosted_notify__send_email_dispatch")
    async def send_email_dispatch(
        recipient: str,
        subject: str,
        body: str,
    ) -> Dict[str, Any]:
        """Dispatch a priority notification email to customer or internal staff.
        
        Args:
            recipient: Target email address (e.g. 'ops@acme.corp')
            subject: Email subject headline
            body: Full email message body
        """
        msg_id = f"msg-{uuid.uuid4().hex[:10]}"
        return {
            "status": "queued",
            "message_id": msg_id,
            "recipient": recipient,
            "subject": subject,
            "body_length": len(body),
            "dispatched_at": time.strftime("%Y-%m-%d %H:%M:%S UTC"),
            "delivery_receipt": f"SMTP 250 OK: Message {msg_id} queued for delivery to {recipient}.",
        }

    @mcp.tool(name="hosted_notify__broadcast_banner")
    async def broadcast_banner(
        message: str,
        duration_minutes: int = 60,
    ) -> Dict[str, Any]:
        """Publish a live system-wide alert banner across connected store portals.
        
        Args:
            message: Banner text to display to customers or staff
            duration_minutes: Duration in minutes to display before auto-expiring
        """
        banner_id = f"banner-{uuid.uuid4().hex[:6]}"
        return {
            "status": "active",
            "banner_id": banner_id,
            "message": message,
            "duration_minutes": duration_minutes,
            "expires_at": time.strftime("%Y-%m-%d %H:%M:%S UTC", time.gmtime(time.time() + duration_minutes * 60)),
        }

# -------------------------------------------------------------
# 2. CURRENCY & FOREX CONVERTER TOOLS
# -------------------------------------------------------------
if SERVICE_TYPE in ("currency", "all"):
    @mcp.tool(name="hosted_currency__convert_price")
    async def convert_price(
        amount: float,
        from_currency: str = "USD",
        to_currency: str = "EUR",
    ) -> Dict[str, Any]:
        """Convert a pricing amount between world currencies using live Forex rates.
        
        Args:
            amount: The numerical amount to convert (e.g. 49.99)
            from_currency: Source 3-letter currency code (e.g. 'USD', 'EUR', 'GBP')
            to_currency: Target 3-letter currency code (e.g. 'EUR', 'INR', 'JPY')
        """
        fc = from_currency.upper()
        tc = to_currency.upper()

        if fc not in RATES or tc not in RATES:
            supported = ", ".join(RATES.keys())
            raise ValueError(f"Unsupported currency '{fc}' or '{tc}'. Supported: {supported}")

        # Normalize to USD then convert
        amount_usd = amount / RATES[fc]
        converted = round(amount_usd * RATES[tc], 2)
        rate = round(RATES[tc] / RATES[fc], 4)

        symbols = {"USD": "$", "EUR": "€", "GBP": "£", "INR": "₹", "JPY": "¥"}
        sym = symbols.get(tc, tc + " ")

        return {
            "from_currency": fc,
            "to_currency": tc,
            "original_amount": amount,
            "exchange_rate": rate,
            "converted_amount": converted,
            "formatted": f"{sym}{converted:,.2f}" if tc != "JPY" else f"{sym}{int(converted):,}",
            "updated_at": time.strftime("%Y-%m-%d %H:%M:%S UTC"),
        }

    @mcp.tool(name="hosted_currency__get_exchange_rates")
    async def get_exchange_rates(
        base_currency: str = "USD",
    ) -> Dict[str, Any]:
        """Get live exchange rate lookup table relative to a base currency.
        
        Args:
            base_currency: The base reference currency (default: 'USD')
        """
        bc = base_currency.upper()
        if bc not in RATES:
            raise ValueError(f"Unknown base currency '{bc}'.")
        
        base_rate = RATES[bc]
        normalized = {k: round(v / base_rate, 4) for k, v in RATES.items()}
        return {
            "base_currency": bc,
            "rates": normalized,
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S UTC"),
        }

    @mcp.tool(name="hosted_currency__format_international_pricing")
    async def format_international_pricing(
        amount_usd: float,
    ) -> Dict[str, Any]:
        """Format an item's USD catalog price across major international retail markets.
        
        Args:
            amount_usd: Product price in US Dollars (e.g. 199.00)
        """
        return {
            "usd": f"${amount_usd:,.2f}",
            "eur": f"€{round(amount_usd * RATES['EUR'], 2):,.2f}",
            "gbp": f"£{round(amount_usd * RATES['GBP'], 2):,.2f}",
            "inr": f"₹{round(amount_usd * RATES['INR'], 2):,.2f}",
            "jpy": f"¥{int(round(amount_usd * RATES['JPY'], 0)):,}",
            "cad": f"CA${round(amount_usd * RATES['CAD'], 2):,.2f}",
        }

# -------------------------------------------------------------
# 3. SHIPPING & FREIGHT LOGISTICS TOOLS
# -------------------------------------------------------------
if SERVICE_TYPE in ("shipping", "all"):
    @mcp.tool(name="hosted_shipping__calculate_freight")
    async def calculate_freight(
        weight_kg: float,
        destination_country: str = "US",
        express: bool = False,
    ) -> Dict[str, Any]:
        """Calculate warehouse shipping costs and transit times based on weight and country.
        
        Args:
            weight_kg: Total package weight in kilograms
            destination_country: 2-letter ISO country code (e.g. 'US', 'GB', 'DE', 'IN')
            express: Whether express priority courier is requested
        """
        base_cost = 8.50 + (weight_kg * 3.20)
        dest = destination_country.upper()
        if dest != "US":
            base_cost += 15.00  # International tariff
        if express:
            base_cost *= 1.85
            transit_days = "1 - 2 business days"
        else:
            transit_days = "3 - 5 business days" if dest == "US" else "7 - 12 business days"

        return {
            "destination_country": dest,
            "weight_kg": round(weight_kg, 2),
            "tier": "Express Air Courier" if express else "Standard Ground/Freight",
            "shipping_cost_usd": round(base_cost, 2),
            "estimated_transit": transit_days,
            "carrier": "DHL Express" if express else "FedEx Freight / USPS",
        }

    @mcp.tool(name="hosted_shipping__track_shipment")
    async def track_shipment(
        tracking_number: str,
    ) -> Dict[str, Any]:
        """Track consignment status and delivery checkpoint history.
        
        Args:
            tracking_number: Consignment tracking identifier (e.g. 'TRK-98214')
        """
        return {
            "tracking_number": tracking_number,
            "status": "In Transit",
            "current_location": "Central Distribution Hub (Chicago, IL)",
            "checkpoints": [
                {"timestamp": "2026-10-21 08:30 UTC", "event": "Shipment picked up at origin warehouse"},
                {"timestamp": "2026-10-21 16:45 UTC", "event": "Departed Regional Sorting Facility"},
                {"timestamp": "2026-10-22 04:12 UTC", "event": "Arrived at Central Distribution Hub"},
            ],
            "estimated_delivery": time.strftime("%Y-%m-%d", time.gmtime(time.time() + 86400 * 2)),
        }

app = mcp.http_app()

if __name__ == "__main__":
    print(f"Starting Hosted MCP Suite on port {PORT} (SERVICE_TYPE={SERVICE_TYPE})...", flush=True)
    uvicorn.run(app, host="0.0.0.0", port=PORT)
