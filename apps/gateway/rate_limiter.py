import time
import asyncio
from typing import Dict, Tuple, Optional

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
    def __init__(self, requests_per_minute: int = 60, burst: int = 15):
        self.refill_rate = requests_per_minute / 60.0
        self.capacity = float(burst)
        self.buckets: Dict[str, TokenBucket] = {}
        self._lock = asyncio.Lock()

    async def check_rate_limit(self, key: str, tokens: float = 1.0) -> Tuple[bool, float]:
        async with self._lock:
            if key not in self.buckets:
                self.buckets[key] = TokenBucket(capacity=self.capacity, refill_rate=self.refill_rate)
            return self.buckets[key].consume(tokens)

    def reset(self, key: Optional[str] = None):
        if key:
            self.buckets.pop(key, None)
        else:
            self.buckets.clear()
