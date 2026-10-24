"""
Zero-dependency pure asyncio Redis RESP client.
Connects to Redis without external pip packages, providing atomic sliding-window rate limiting,
persistent API key storage, and sub-millisecond conversation memory caching.
"""

import os
import asyncio
from typing import Optional, List, Tuple, Any, Dict

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
                timeout=0.5
            )
            return True
        except Exception:
            self._reader = None
            self._writer = None
            return False

    def _encode_cmd(self, *args: Any) -> bytes:
        parts = [f"*{len(args)}\r\n".encode("utf-8")]
        for arg in args:
            if isinstance(arg, bytes):
                b = arg
            else:
                b = str(arg).encode("utf-8")
            parts.append(f"${len(b)}\r\n".encode("utf-8") + b + b"\r\n")
        return b"".join(parts)

    async def _read_resp(self) -> Any:
        line = await asyncio.wait_for(self._reader.readline(), timeout=0.5)
        if not line:
            return None
        prefix = line[:1]
        payload = line[1:].rstrip(b"\r\n")

        if prefix == b"+":  # Simple string
            return payload.decode("utf-8", errors="ignore")
        elif prefix == b"-":  # Error
            return None
        elif prefix == b":":  # Integer
            try:
                return int(payload)
            except ValueError:
                return 0
        elif prefix == b"$":  # Bulk string
            try:
                length = int(payload)
            except ValueError:
                return None
            if length == -1:
                return None
            data = await asyncio.wait_for(self._reader.readexactly(length + 2), timeout=0.5)
            return data[:-2].decode("utf-8", errors="ignore")
        elif prefix == b"*":  # Array
            try:
                count = int(payload)
            except ValueError:
                return None
            if count == -1:
                return None
            items = []
            for _ in range(count):
                items.append(await self._read_resp())
            return items
        return None

    async def execute(self, *args: Any) -> Any:
        """Execute an arbitrary Redis command over RESP and return the parsed result."""
        async with self._lock:
            if not await self._ensure_connection():
                return None
            try:
                cmd_bytes = self._encode_cmd(*args)
                self._writer.write(cmd_bytes)
                await self._writer.drain()
                return await self._read_resp()
            except Exception:
                self._writer = None
                self._reader = None
                return None

    async def ping(self) -> bool:
        resp = await self.execute("PING")
        return resp == "PONG"

    async def get(self, key: str) -> Optional[str]:
        return await self.execute("GET", key)

    async def set(self, key: str, value: str, ex: Optional[int] = None) -> bool:
        if ex:
            resp = await self.execute("SET", key, value, "EX", ex)
        else:
            resp = await self.execute("SET", key, value)
        return resp == "OK"

    async def incr(self, key: str) -> Optional[int]:
        return await self.execute("INCR", key)

    async def expire(self, key: str, seconds: int) -> bool:
        resp = await self.execute("EXPIRE", key, seconds)
        return resp == 1

    async def delete(self, key: str) -> bool:
        resp = await self.execute("DEL", key)
        return bool(resp and resp > 0)

    # Sorted Set Primitives (for true Sliding Window Rate Limiting)
    async def zremrangebyscore(self, key: str, min_score: Any, max_score: Any) -> Optional[int]:
        return await self.execute("ZREMRANGEBYSCORE", key, min_score, max_score)

    async def zadd(self, key: str, score: float, member: str) -> Optional[int]:
        return await self.execute("ZADD", key, score, member)

    async def zcard(self, key: str) -> Optional[int]:
        return await self.execute("ZCARD", key)

    # Set Primitives (for API Key collections)
    async def sadd(self, key: str, *members: str) -> Optional[int]:
        if not members:
            return 0
        return await self.execute("SADD", key, *members)

    async def smembers(self, key: str) -> List[str]:
        res = await self.execute("SMEMBERS", key)
        return res if isinstance(res, list) else []

    async def srem(self, key: str, *members: str) -> Optional[int]:
        if not members:
            return 0
        return await self.execute("SREM", key, *members)

    # Hash Primitives (for structured entity persistence)
    async def hset(self, key: str, field: str, value: str) -> bool:
        res = await self.execute("HSET", key, field, value)
        return res is not None

    async def hget(self, key: str, field: str) -> Optional[str]:
        return await self.execute("HGET", key, field)

    async def hgetall(self, key: str) -> Dict[str, str]:
        res = await self.execute("HGETALL", key)
        if not res or not isinstance(res, list):
            return {}
        result = {}
        for i in range(0, len(res) - 1, 2):
            result[str(res[i])] = str(res[i+1])
        return result

    async def hdel(self, key: str, *fields: str) -> Optional[int]:
        if not fields:
            return 0
        return await self.execute("HDEL", key, *fields)

# Global Singleton
redis_client = SimpleRedisClient()
