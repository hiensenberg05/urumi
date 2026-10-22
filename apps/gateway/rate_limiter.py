import os
import time
import asyncio
from typing import Dict, Tuple, Optional

from redis_client import redis_client

class TokenBucket:
    def __init__(self, capacity: float, refill_rate: float):
        self.capacity = capacity
        self.refill_rate = refill_rate
        self.tokens = capacity
        self.last_refill = time.monotonic()

    def consume(self, amount: float = 1.0) -> Tuple[bool, float]:
        now = time.monotonic()
        elapsed = now - self.last_refill
        self.last_refill = now
        
        # Add newly generated tokens up to maximum capacity
        self.tokens = min(self.capacity, self.tokens + elapsed * self.refill_rate)

        if self.tokens >= amount:
            self.tokens -= amount
            return True, 0.0
        else:
            missing = amount - self.tokens
            retry_after = missing / self.refill_rate if self.refill_rate > 0 else 1.0
            return False, round(retry_after, 2)

class SimpleRedisClient:
    """
    Zero-dependency pure asyncio Redis RESP client.
    Connects to Redis without needing pip packages, supporting clustering and sliding-window rate limiting.
    """
    def __init__(self, host: str = "redis.default.svc.cluster.local", port: int = 6379):
        self.host = host
        self.port = port
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

    async def incr(self, key: str) -> Optional[int]:
        async with self._lock:
            if not await self._ensure_connection():
                return None
            try:
                cmd = f"*2\r\n$4\r\nINCR\r\n${len(key)}\r\n{key}\r\n".encode()
                self._writer.write(cmd)
                await self._writer.drain()
                resp = await asyncio.wait_for(self._reader.readline(), timeout=0.5)
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
                cmd = f"*3\r\n$6\r\nEXPIRE\r\n${len(key)}\r\n{key}\r\n${len(str(seconds))}\r\n{seconds}\r\n".encode()
                self._writer.write(cmd)
                await self._writer.drain()
                resp = await asyncio.wait_for(self._reader.readline(), timeout=0.5)
                return resp.strip() == b":1"
            except Exception:
                self._writer = None
                return False

class RateLimiter:
    def __init__(self, requests_per_minute: int = 60, burst: int = 15):
        self.requests_per_minute = requests_per_minute
        self.refill_rate = requests_per_minute / 60.0
        self.capacity = float(burst)
        self.buckets: Dict[str, TokenBucket] = {}
        self._lock = asyncio.Lock()
        
        # Redis distributed backend
        self.redis = redis_client

    async def check_rate_limit(self, key: str, tokens: float = 1.0) -> Tuple[bool, float]:
        # 1. Distributed Redis Sliding Window Check across all Gateway replicas
        try:
            window = int(time.time() // 60)
            redis_key = f"ratelimit:{key}:{window}"
            count = await self.redis.incr(redis_key)
            if count is not None:
                if count == 1:
                    await self.redis.expire(redis_key, 65)
                # Rate limit threshold
                if count > self.requests_per_minute:
                    retry_after = max(1.0, float(60 - (int(time.time()) % 60)))
                    return False, retry_after
                return True, 0.0
        except Exception:
            pass

        # 2. Seamless local fallback to in-memory TokenBucket if Redis unavailable
        async with self._lock:
            if key not in self.buckets:
                self.buckets[key] = TokenBucket(capacity=self.capacity, refill_rate=self.refill_rate)
            return self.buckets[key].consume(tokens)

    def reset(self, key: Optional[str] = None):
        if key:
            self.buckets.pop(key, None)
        else:
            self.buckets.clear()
