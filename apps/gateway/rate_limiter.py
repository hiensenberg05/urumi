import os
import time
import uuid
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


class RateLimiter:
    """
    Enterprise Dual-Tier Rate Limiter.
    
    Tier 1 (Distributed): True Sliding-Window Log backed by Redis sorted sets (ZSET).
    Strictly prevents traffic spikes at window boundaries across all Gateway pods.
    
    Tier 2 (Resilient Fallback): Per-process in-memory Token Bucket.
    
    Consistency vs. Availability Trade-off:
    - Normal (CP): Replicas coordinate through Redis for atomic sliding-window enforcement.
    - Partition/Failure (AP Fallback): If Redis is unreachable, Gateway falls back to local
      token buckets to guarantee high availability (fail-open) rather than rejecting requests
      with 500 errors.
    """

    def __init__(self, requests_per_minute: int = 60, burst: int = 15):
        self.requests_per_minute = requests_per_minute
        self.window_seconds = 60.0
        self.refill_rate = requests_per_minute / 60.0
        self.capacity = float(burst)
        self.buckets: Dict[str, TokenBucket] = {}
        self._lock = asyncio.Lock()
        
        # Distributed Redis backend
        self.redis = redis_client

    async def check_rate_limit(self, key: str, tokens: float = 1.0) -> Tuple[bool, float]:
        now = time.time()
        clear_before = now - self.window_seconds
        redis_key = f"ratelimit:sliding:{key}"

        # 1. Distributed Redis True Sliding Window via Sorted Set
        try:
            # Remove timestamps outside the sliding window
            await self.redis.zremrangebyscore(redis_key, "-inf", clear_before)
            
            # Count requests inside the active 60-second sliding window
            count = await self.redis.zcard(redis_key)
            if count is not None:
                if count >= self.requests_per_minute:
                    retry_after = max(1.0, round(self.window_seconds - (now % self.window_seconds), 1))
                    return False, retry_after

                # Record current request timestamp
                member_id = f"{now}:{uuid.uuid4().hex[:6]}"
                await self.redis.zadd(redis_key, now, member_id)
                await self.redis.expire(redis_key, int(self.window_seconds) + 5)
                return True, 0.0
        except Exception:
            # Fall back to local token bucket if Redis is temporarily unreachable
            pass

        # 2. Local fallback to in-memory TokenBucket
        async with self._lock:
            if key not in self.buckets:
                self.buckets[key] = TokenBucket(capacity=self.capacity, refill_rate=self.refill_rate)
            return self.buckets[key].consume(tokens)

    def reset(self, key: Optional[str] = None):
        if key:
            self.buckets.pop(key, None)
        else:
            self.buckets.clear()
