"""
Persistent API Key Store for Urumi MCP Gateway.
Provides distributed, Redis-backed key persistence with local in-memory caching.
Ensures runtime-generated keys persist across pod restarts and remain consistent
across multi-replica Gateway deployments.
"""

import os
import json
import time
import uuid
import hashlib
from typing import Dict, Any, List, Optional, Tuple

from redis_client import redis_client

class ApiKeyStore:
    def __init__(self, cache_ttl_seconds: int = 30):
        self.redis = redis_client
        self.cache_ttl = cache_ttl_seconds
        
        # Local in-memory write-through / fallback cache
        # key_hash -> (key_record, expire_timestamp)
        self._local_cache: Dict[str, Tuple[Dict[str, Any], float]] = {}
        # key_id -> key_record
        self._local_keys_by_id: Dict[str, Dict[str, Any]] = {}
        
        # Pre-seed bootstrap keys into in-memory store so they are instantly valid
        self._bootstrap_in_memory()

    def _hash_key(self, token: str) -> str:
        return hashlib.sha256(token.strip().encode("utf-8")).hexdigest()

    def _bootstrap_in_memory(self):
        """Seed bootstrap keys locally at initialization time."""
        try:
            from config import settings
            default_keys = settings.get_initial_keys()
            now = time.time()
            for raw_token, data in default_keys.items():
                key_hash = self._hash_key(raw_token)
                key_id = f"seed_{key_hash[:8]}"
                stores = data.get("allowed_stores", (["*"] if data.get("role") == "admin" else ["default"]))
                record: Dict[str, Any] = {
                    "id": key_id,
                    "name": data.get("name", "Bootstrap Key"),
                    "keyPrefix": f"{raw_token[:8]}...",
                    "keyHash": key_hash,
                    "rawKey": raw_token,
                    "role": data.get("role", "support_rep"),
                    "scope": data.get("scope", "read"),
                    "allowedStores": stores,
                    "createdAt": time.strftime("%Y-%m-%d %H:%M:%S UTC"),
                    "lastUsedAt": "never",
                    "expiresAt": "Never",
                    "isRevoked": False,
                }
                # Cache locally with 10-year expiration
                self._local_cache[key_hash] = (record, now + 315360000.0)
                self._local_cache[raw_token] = (record, now + 315360000.0)
                self._local_keys_by_id[key_id] = record
        except Exception as e:
            print(f"[ApiKeyStore] Notice: In-memory bootstrap deferred: {e}")

    async def get_key(self, token: str) -> Optional[Dict[str, Any]]:
        """
        Validate token and retrieve its metadata.
        Checks local cache first, then distributed Redis store.
        """
        if not token:
            return None
            
        clean_token = token.strip()
        token_hash = self._hash_key(clean_token)
        now = time.time()

        # 1. Fast local cache & direct dict lookup
        if clean_token in self._local_keys_by_id and not self._local_keys_by_id[clean_token].get("isRevoked", False):
            return self._local_keys_by_id[clean_token]
        if token_hash in self._local_cache:
            record, exp = self._local_cache[token_hash]
            if now < exp and not record.get("isRevoked", False):
                return record
        if clean_token in self._local_cache:
            record, exp = self._local_cache[clean_token]
            if now < exp and not record.get("isRevoked", False):
                return record

        # 2. Distributed Redis lookup
        try:
            key_id = await self.redis.get(f"apikeys:lookup:{token_hash}")
            if not key_id:
                # Fallback for plain tokens (e.g. seeded keys during migration)
                key_id = await self.redis.get(f"apikeys:lookup:{clean_token}")
                
            if key_id:
                meta_json = await self.redis.get(f"apikeys:meta:{key_id}")
                if meta_json:
                    record = json.loads(meta_json)
                    if not record.get("isRevoked", False):
                        # Cache locally
                        self._local_cache[token_hash] = (record, now + self.cache_ttl)
                        self._local_keys_by_id[key_id] = record
                        return record
        except Exception:
            pass

        # 3. Fallback to local keys if Redis is unreachable
        for record in self._local_keys_by_id.values():
            if (record.get("keyHash") == token_hash or record.get("rawKey") == clean_token or record.get("key") == clean_token or record.get("id") == clean_token) and not record.get("isRevoked", False):
                return record

        return None

    async def create_key(
        self,
        name: str,
        role: str,
        scope: str = "read",
        allowed_stores: Optional[List[str]] = None,
        custom_token: Optional[str] = None,
    ) -> Tuple[str, Dict[str, Any]]:
        """
        Create and persist a new API key across all Gateway replicas via Redis.
        """
        raw_token = custom_token or f"key_{uuid.uuid4().hex}"
        key_hash = self._hash_key(raw_token)
        key_id = f"key_{uuid.uuid4().hex[:8]}"

        # Scoping defaults: admin has access to all stores, others default to standard catalog
        stores = allowed_stores if allowed_stores is not None else (["*"] if role == "admin" else ["default"])

        record: Dict[str, Any] = {
            "id": key_id,
            "name": name,
            "keyPrefix": f"{raw_token[:8]}...",
            "keyHash": key_hash,
            "rawKey": raw_token,  # Kept in memory only for seeded / generation return
            "role": role,
            "scope": scope,
            "allowedStores": stores,
            "createdAt": time.strftime("%Y-%m-%d %H:%M:%S UTC"),
            "lastUsedAt": "never",
            "expiresAt": "Never",
            "isRevoked": False,
        }

        # Safe record to store (omit rawKey in external JSON)
        stored_record = dict(record)
        stored_record.pop("rawKey", None)
        meta_json = json.dumps(stored_record)

        # 1. Persist to Redis
        try:
            await self.redis.set(f"apikeys:meta:{key_id}", meta_json)
            await self.redis.set(f"apikeys:lookup:{key_hash}", key_id)
            # Index raw token lookup as well for legacy seeded tokens
            await self.redis.set(f"apikeys:lookup:{raw_token}", key_id)
            await self.redis.sadd("apikeys:all", key_id)
        except Exception:
            pass

        # 2. Update local cache
        now = time.time()
        self._local_cache[key_hash] = (record, now + self.cache_ttl)
        self._local_cache[raw_token] = (record, now + self.cache_ttl)
        self._local_keys_by_id[key_id] = record

        return raw_token, record

    async def update_last_used(self, key_id: str):
        """Update lastUsedAt timestamp for the key."""
        now_str = time.strftime("%Y-%m-%d %H:%M:%S UTC")
        if key_id in self._local_keys_by_id:
            self._local_keys_by_id[key_id]["lastUsedAt"] = now_str
        try:
            meta_json = await self.redis.get(f"apikeys:meta:{key_id}")
            if meta_json:
                rec = json.loads(meta_json)
                rec["lastUsedAt"] = now_str
                await self.redis.set(f"apikeys:meta:{key_id}", json.dumps(rec))
        except Exception:
            pass

    async def revoke_key(self, key_id: str) -> bool:
        """
        Revoke an API key immediately across all replicas.
        """
        record: Optional[Dict[str, Any]] = None

        # Fetch record
        try:
            meta_json = await self.redis.get(f"apikeys:meta:{key_id}")
            if meta_json:
                record = json.loads(meta_json)
        except Exception:
            pass

        if not record and key_id in self._local_keys_by_id:
            record = self._local_keys_by_id[key_id]

        if not record:
            # Maybe key_id is a raw token or hash
            for r in self._local_keys_by_id.values():
                if r.get("id") == key_id or r.get("rawKey") == key_id or r.get("keyHash") == key_id:
                    record = r
                    key_id = r["id"]
                    break

        if not record:
            return False

        record["isRevoked"] = True
        key_hash = record.get("keyHash", "")

        # Update Redis
        try:
            await self.redis.set(f"apikeys:meta:{key_id}", json.dumps(record))
            if key_hash:
                await self.redis.delete(f"apikeys:lookup:{key_hash}")
            if "rawKey" in record:
                await self.redis.delete(f"apikeys:lookup:{record['rawKey']}")
        except Exception:
            pass

        # Invalidate local cache
        if key_hash in self._local_cache:
            del self._local_cache[key_hash]
        if "rawKey" in record and record["rawKey"] in self._local_cache:
            del self._local_cache[record["rawKey"]]
        self._local_keys_by_id[key_id] = record

        return True

    async def list_keys(self) -> List[Dict[str, Any]]:
        """
        List all active and revoked API keys across the platform.
        """
        results: Dict[str, Dict[str, Any]] = {}

        # 1. Fetch all keys from Redis
        try:
            key_ids = await self.redis.smembers("apikeys:all")
            for k_id in key_ids:
                meta_json = await self.redis.get(f"apikeys:meta:{k_id}")
                if meta_json:
                    rec = json.loads(meta_json)
                    results[rec["id"]] = rec
        except Exception:
            pass

        # 2. Merge local keys if Redis is missing items
        for k_id, rec in self._local_keys_by_id.items():
            if k_id not in results:
                safe_rec = dict(rec)
                safe_rec.pop("rawKey", None)
                results[k_id] = safe_rec

        return list(results.values())

    async def seed_default_keys(self, default_keys: Dict[str, Dict[str, Any]]):
        """Seed initial environment keys into Redis if not already initialized."""
        for token, data in default_keys.items():
            token_hash = self._hash_key(token)
            # Check if key already exists in Redis
            exists = False
            try:
                lookup = await self.redis.get(f"apikeys:lookup:{token_hash}")
                if lookup:
                    exists = True
            except Exception:
                pass

            if not exists:
                await self.create_key(
                    name=data.get("name", "Default Key"),
                    role=data.get("role", "support_rep"),
                    scope=data.get("scope", "read"),
                    allowed_stores=data.get("allowed_stores", (["*"] if data.get("role") == "admin" else ["default"])),
                    custom_token=token,
                )

# Global API Key Store Singleton
api_key_store = ApiKeyStore()
