from collections import deque
from datetime import datetime, timezone
import time
from typing import Any, Dict, List, Optional
import uuid

class AuditLogger:
    def __init__(self, max_records: int = 500):
        self._logs: deque = deque(maxlen=max_records)

    def log_event(
        self,
        principal: str,
        user_role: str,
        tool_name: str,
        target_server: str,
        status: str,
        duration_ms: float,
        client_ip: str = "127.0.0.1",
        client_agent: str = "Gateway-Client/1.0",
        params: Optional[Dict[str, Any]] = None,
        ingress_auth_ms: float = 1.0,
        policy_eval_ms: float = 1.0,
        policy_rule_detail: Optional[str] = None,
        upstream_status: str = "Dispatched",
    ) -> Dict[str, Any]:
        log_id = f"aud_{uuid.uuid4().hex[:12]}"
        correlation_id = f"req-{uuid.uuid4().hex[:10]}"
        now = datetime.now(timezone.utc)
        timestamp_str = now.strftime("%Y-%m-%d %H:%M:%S UTC")

        # Sanitize sensitive fields (e.g. passwords, keys)
        sanitized = {}
        if params:
            for k, v in params.items():
                if any(sec in k.lower() for sec in ("key", "secret", "password", "token")):
                    sanitized[k] = "******"
                else:
                    sanitized[k] = v

        # Map role string to frontend UserRole format ('ADMIN' | 'MEMBER')
        frontend_role = "ADMIN" if user_role.lower() in ("admin", "root") else "MEMBER"

        item = {
            "id": log_id,
            "correlationId": correlation_id,
            "timestamp": timestamp_str,
            "timeAgo": "just now",
            "principal": principal,
            "userRole": frontend_role,
            "actualRole": user_role,
            "clientAgent": client_agent,
            "clientIp": client_ip,
            "targetServer": target_server,
            "toolName": tool_name,
            "durationMs": round(duration_ms, 1),
            "status": status,
            "lifecycle": {
                "ingressAuthMs": round(ingress_auth_ms, 2),
                "policyEvalMs": round(policy_eval_ms, 2),
                "policyRuleDetail": policy_rule_detail or f"Policy for role '{user_role}' evaluated",
                "upstreamStatus": upstream_status,
            },
            "sanitizedParams": sanitized,
        }
        self._logs.appendleft(item)
        return item

    def get_logs(
        self,
        limit: int = 50,
        role: Optional[str] = None,
        status: Optional[str] = None,
        tool: Optional[str] = None,
    ) -> List[Dict[str, Any]]:
        results = []
        for item in self._logs:
            if role and item.get("actualRole") != role:
                continue
            if status and item.get("status") != status:
                continue
            if tool and item.get("toolName") != tool:
                continue
            results.append(item)
            if len(results) >= limit:
                break
        return results

    def get_stats(self) -> Dict[str, Any]:
        total = len(self._logs)
        blocked = sum(1 for item in self._logs if "403" in item.get("status", ""))
        errors = sum(1 for item in self._logs if "500" in item.get("status", "") or "504" in item.get("status", ""))
        ok = total - blocked - errors
        avg_duration = sum(item.get("durationMs", 0) for item in self._logs) / total if total > 0 else 0.0

        return {
            "total_requests": total,
            "successful_requests": ok,
            "blocked_requests": blocked,
            "error_requests": errors,
            "avg_latency_ms": round(avg_duration, 2),
        }

audit_logger = AuditLogger()
