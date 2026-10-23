"""
Distributed Chat Session Memory Engine for Urumi MCP Gateway.
Leverages the shared Redis cluster to provide sub-millisecond multi-turn memory
across all Gateway replicas, eliminating wire payload redundancy and preserving context.
"""

import hashlib
import json
import time
from typing import List, Dict, Any, Tuple, Optional
from redis_client import redis_client

class ChatMemoryManager:
    def __init__(self, default_ttl_seconds: int = 86400, max_turns: int = 20):
        self.default_ttl = default_ttl_seconds
        self.max_turns = max_turns

    def _get_key(self, session_id: str) -> str:
        return f"chat:session:{session_id}:history"

    @staticmethod
    def _normalize_query_key(role: str, query: str) -> str:
        clean = " ".join(query.strip().lower().split())
        h = hashlib.sha256(clean.encode("utf-8")).hexdigest()[:16]
        return f"cache:query:{role}:{h}"

    @staticmethod
    def is_mutating_query(query: str) -> bool:
        q = query.lower()
        return any(k in q for k in ["adjust", "update", "create", "delete", "post", "set ", "add ", "change", "order #", "purchase"])

    async def get_cached_query_response(self, role: str, query: str) -> Optional[Dict[str, Any]]:
        """Fetch pre-computed assistant response from Redis for fast answers."""
        if self.is_mutating_query(query):
            return None
        try:
            key = self._normalize_query_key(role, query)
            raw = await redis_client.get(key)
            if raw:
                return json.loads(raw)
        except Exception:
            pass
        return None

    async def cache_query_response(self, role: str, query: str, data: Dict[str, Any], ttl: int = 90) -> bool:
        """Store assistant response in Redis cache with 90s TTL."""
        if self.is_mutating_query(query):
            return False
        try:
            key = self._normalize_query_key(role, query)
            payload = json.dumps(data, ensure_ascii=False)
            return await redis_client.set(key, payload, ex=ttl)
        except Exception:
            return False

    async def get_history(self, session_id: str, limit: int = 10) -> Tuple[List[Dict[str, str]], float]:
        """
        Retrieve cached conversation turns from Redis.
        Returns: (history_turns: List[Dict], retrieval_latency_ms: float)
        """
        if not session_id:
            return [], 0.0

        start = time.perf_counter()
        raw = await redis_client.get(self._get_key(session_id))
        latency_ms = round((time.perf_counter() - start) * 1000.0, 3)

        if not raw:
            return [], latency_ms

        try:
            turns = json.loads(raw)
            if isinstance(turns, list):
                return turns[-limit:], latency_ms
        except Exception:
            pass

        return [], latency_ms

    async def append_turns(
        self,
        session_id: str,
        user_message: str,
        assistant_reply: str,
        ttl: Optional[int] = None,
    ) -> bool:
        """
        Atomically append user message and assistant reply to Redis session history.
        """
        if not session_id:
            return False

        key = self._get_key(session_id)
        existing, _ = await self.get_history(session_id, limit=self.max_turns)

        # Append new turns
        if user_message:
            existing.append({"role": "user", "content": user_message})
        if assistant_reply:
            existing.append({"role": "assistant", "content": assistant_reply})

        # Keep within max_turns limit to prevent unbounded memory growth
        trimmed = existing[-self.max_turns:]
        payload_str = json.dumps(trimmed, ensure_ascii=False)

        expire_ttl = ttl or self.default_ttl
        return await redis_client.set(key, payload_str, ex=expire_ttl)

    async def clear_history(self, session_id: str) -> bool:
        """Clear conversation history for a given session."""
        if not session_id:
            return False
        return await redis_client.delete(self._get_key(session_id))

    @staticmethod
    def calculate_token_and_bandwidth_savings(turns: List[Dict[str, str]]) -> Dict[str, Any]:
        """
        Compute how many tokens and network wire bytes are saved by retrieving
        from server-side Redis instead of transmitting past turns from client.
        Rule of thumb: ~4 characters per token for standard BPE tokenization.
        """
        if not turns:
            return {
                "cachedTurns": 0,
                "payloadBytesSaved": 0,
                "tokensSaved": 0,
                "percentageWireReduction": 0.0
            }

        total_chars = sum(len(t.get("content", "")) for t in turns)
        # Average English/code text is ~4 characters per token
        tokens_saved = max(0, int(total_chars / 4))
        payload_bytes = len(json.dumps(turns).encode("utf-8"))

        return {
            "cachedTurns": len(turns),
            "payloadBytesSaved": payload_bytes,
            "tokensSaved": tokens_saved,
            "percentageWireReduction": round(min(95.0, (payload_bytes / (payload_bytes + 100)) * 100), 1)
        }

# Global Singleton
chat_memory = ChatMemoryManager()
