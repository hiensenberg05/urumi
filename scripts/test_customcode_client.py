import asyncio
from fastmcp import Client

async def main():
    async with Client('http://hosted-mcp-customcode.default.svc.cluster.local:8008/mcp') as c:
        tools = await c.list_tools()
        print("Tools on customcode:", [t.name for t in tools])
        res = await c.call_tool("custom__discount_calculator", {"price": 189.99, "quantity": 25})
        print("Result:", res)

if __name__ == "__main__":
    asyncio.run(main())
