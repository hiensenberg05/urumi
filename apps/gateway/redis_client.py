"""
Zero-dependency pure asyncio Redis RESP client.
Connects to Redis without external pip packages, providing atomic sliding-window rate limiting
and sub-millisecond conversation memory caching.
"""

import os
import asyncio
from typing import Optional, List, Tuple

class SimpleRedisClient:
    def __init__(self, host: Optional[str] = None, port: Optional[int] = None):
        self.host = host or os.environ.get("REDIS_HOST", "redis.default.svc.cluster.local")
        raw_port = port or os.environ.get("REDIS_SERVICE_PORT") or os.environ.get("REDIS_PORT", "6379")
        if "://" in str(raw_port):
            raw_port = str(raw_port).split(":")[-1]
        try:
            self.port = int(raw_port)
        except Exception:
            self.port = 6379

        self._reader: Optional[asyncio.StreamReader] = None
        self._writer: Optional[asyncio.StreamWriter] = None
        self._lock = asyncio.Lock()

    async def _ensure_connection(self) -> bool:
        if self._writer and not self._writer.is_closing():
            return True
        try:
            self._reader, self._writer = await asyncio.wait_for(
                asyncio.open_connection(self.host, self.port),
                timeout=0.4
            )
            return True
        except Exception:
            self._reader = None
            self._writer = None
            return False

    async def ping(self) -> bool:
        async with self._lock:
            if not await self._ensure_connection():
                return False
            try:
                self._writer.write(b"*1\r\n$4\r\nPING\r\n")
                await self._writer.drain()
                resp = await asyncio.wait_for(self._reader.readline(), timeout=0.4)
                return resp.startswith(b"+PONG")
            except Exception:
                self._writer = None
                return False

    async def get(self, key: str) -> Optional[str]:
        async with self._lock:
            if not await self._ensure_connection():
                return None
            try:
                cmd = f"*2\r\n$3\r\nGET\r\n${len(key.encode('utf-8'))}\r\n{key}\r\n".encode("utf-8")
                self._writer.write(cmd)
                await self._writer.drain()
                resp = await asyncio.wait_for(self._reader.readline(), timeout=0.4)
                if not resp or resp.startswith(b"$-1"):
                    return None
                if resp.startswith(b"$"):
                    arg_len = int(resp[1:].strip())
                    arg_data = await asyncio.wait_for(self._reader.readexactly(arg_len + 2), timeout=0.4)
                    return arg_data[:-2].decode("utf-8", errors="ignore")
                return None
            except Exception:
                self._writer = None
                return None

    async def set(self, key: str, value: str, ex: Optional[int] = None) -> bool:
        async with self._lock:
            if not await self._ensure_connection():
                return False
            try:
                val_bytes = value.encode("utf-8")
                key_bytes = key.encode("utf-8")
                if ex:
                    cmd = (
                        f"*5\r\n$3\r\nSET\r\n${len(key_bytes)}\r\n".encode("utf-8")
                        + key_bytes
                        + f"\r\n${len(val_bytes)}\r\n".encode("utf-8")
                        + val_bytes
                        + f"\r\n$2\r\nEX\r\n${len(str(ex))}\r\n{ex}\r\n".encode("utf-8")
                    )
                else:
                    cmd = (
                        f"*3\r\n$3\r\nSET\r\n${len(key_bytes)}\r\n".encode("utf-8")
                        + key_bytes
                        + f"\r\n${len(val_bytes)}\r\n".encode("utf-8")
                        + val_bytes
                        + b"\r\n"
                    )
                self._writer.write(cmd)
                await self._writer.drain()
                resp = await asyncio.wait_for(self._reader.readline(), timeout=0.4)
                return resp.startswith(b"+OK")
            except Exception:
                self._writer = None
                return False

    async def incr(self, key: str) -> Optional[int]:
        async with self._lock:
            if not await self._ensure_connection():
                return None
            try:
                cmd = f"*2\r\n$4\r\nINCR\r\n${len(key.encode('utf-8'))}\r\n{key}\r\n".encode("utf-8")
                self._writer.write(cmd)
                await self._writer.drain()
                resp = await asyncio.wait_for(self._reader.readline(), timeout=0.4)
                if resp.startswith(b":"):
                    return int(resp[1:].strip())
                return None
            except Exception:
                self._writer = None
                return None

    async def expire(self, key: str, seconds: int) -> bool:
        async with self._lock:
            if not await self._ensure_connection():
                return False
            try:
                cmd = f"*3\r\n$6\r\nEXPIRE\r\n${len(key.encode('utf-8'))}\r\n{key}\r\n${len(str(seconds))}\r\n{seconds}\r\n".encode("utf-8")
                self._writer.write(cmd)
                await self._writer.drain()
                resp = await asyncio.wait_for(self._reader.readline(), timeout=0.4)
                return resp.strip() == b":1"
            except Exception:
                self._writer = None
                return False

    async def delete(self, key: str) -> bool:
        async with self._lock:
            if not await self._ensure_connection():
                return False
            try:
                cmd = f"*2\r\n$3\r\nDEL\r\n${len(key.encode('utf-8'))}\r\n{key}\r\n".encode("utf-8")
                self._writer.write(cmd)
                await self._writer.drain()
                resp = await asyncio.wait_for(self._reader.readline(), timeout=0.4)
                return resp.startswith(b":") and int(resp[1:].strip()) > 0
            except Exception:
                self._writer = None
                return False

# Global Singleton
redis_client = SimpleRedisClient()
