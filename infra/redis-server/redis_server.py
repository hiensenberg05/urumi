"""
Lightweight Redis RESP Server for Distributed Rate Limiting.
Speaks standard Redis RESP2 protocol over TCP port 6379.
"""

import asyncio
import time
from typing import Dict, Tuple, Optional

# Key-value memory store: key -> (value, expire_timestamp)
DATA: Dict[str, Tuple[int, Optional[float]]] = {}

def clean_expired(key: str) -> None:
    if key in DATA:
        val, exp = DATA[key]
        if exp is not None and time.time() > exp:
            del DATA[key]

async def handle_client(reader: asyncio.StreamReader, writer: asyncio.StreamWriter):
    try:
        while True:
            line = await reader.readline()
            if not line:
                break
            
            line_str = line.decode("utf-8", errors="ignore").strip()
            if not line_str.startswith("*"):
                # Inline command (e.g., PING)
                parts = line_str.split()
            else:
                # RESP array
                num_args = int(line_str[1:])
                parts = []
                for _ in range(num_args):
                    len_line = await reader.readline()
                    arg_len = int(len_line.decode().strip()[1:])
                    arg_data = await reader.readexactly(arg_len + 2) # include \r\n
                    parts.append(arg_data[:-2].decode("utf-8", errors="ignore"))

            if not parts:
                continue

            cmd = parts[0].upper()
            args = parts[1:]

            if cmd == "PING":
                msg = args[0] if args else "PONG"
                writer.write(f"+{msg}\r\n".encode())
            elif cmd == "INCR":
                key = args[0]
                clean_expired(key)
                val, exp = DATA.get(key, (0, None))
                val += 1
                DATA[key] = (val, exp)
                writer.write(f":{val}\r\n".encode())
            elif cmd == "EXPIRE":
                key = args[0]
                ttl = int(args[1])
                if key in DATA:
                    val, _ = DATA[key]
                    DATA[key] = (val, time.time() + ttl)
                    writer.write(b":1\r\n")
                else:
                    writer.write(b":0\r\n")
            elif cmd == "GET":
                key = args[0]
                clean_expired(key)
                if key in DATA:
                    val = str(DATA[key][0])
                    writer.write(f"${len(val)}\r\n{val}\r\n".encode())
                else:
                    writer.write(b"$-1\r\n")
            elif cmd == "SET":
                key = args[0]
                val = int(args[1]) if args[1].isdigit() else 1
                DATA[key] = (val, None)
                writer.write(b"+OK\r\n")
            elif cmd == "DEL":
                key = args[0]
                existed = 1 if DATA.pop(key, None) is not None else 0
                writer.write(f":{existed}\r\n".encode())
            else:
                writer.write(b"+OK\r\n")

            await writer.drain()
    except Exception:
        pass
    finally:
        writer.close()
        await writer.wait_closed()

async def main():
    server = await asyncio.start_server(handle_client, "0.0.0.0", 6379)
    print("Redis RESP Distributed Cache Server running on port 6379...")
    async with server:
        await server.serve_forever()

if __name__ == "__main__":
    asyncio.run(main())
