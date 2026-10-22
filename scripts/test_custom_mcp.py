"""
Test deployment of a Custom FastMCP server using in-browser custom Python code.
"""
import urllib.request
import json
import time

custom_code = '''@mcp.tool(name="custom__discount_calculator")
async def calculate_bulk_discount(price: float, quantity: int) -> dict:
    """Calculate tiered wholesale discount for large customer orders."""
    discount_pct = 20 if quantity >= 50 else (10 if quantity >= 10 else 5)
    discount_amount = round(price * quantity * (discount_pct / 100), 2)
    final_total = round((price * quantity) - discount_amount, 2)
    return {
        "unit_price": price,
        "quantity": quantity,
        "discount_pct": f"{discount_pct}%",
        "savings_usd": discount_amount,
        "final_total": final_total,
        "status": "Tier Discount Applied Successfully"
    }
'''

payload = {
    "name": "Custom Discount Calculator",
    "template": "custom_code",
    "port": 8008,
    "custom_code": custom_code
}

req = urllib.request.Request(
    "http://gateway.local/api/v1/hosted-servers",
    data=json.dumps(payload).encode("utf-8"),
    headers={"Content-Type": "application/json", "X-API-Key": "admin-key-urumi-2026"},
    method="POST"
)

res = urllib.request.urlopen(req)
rec = json.loads(res.read())
print(f"Deployed custom MCP server: {rec['id']} - Status: {rec['status']}")
print(f"Discovered Tools: {[t['name'] for t in rec['tools']]}")
