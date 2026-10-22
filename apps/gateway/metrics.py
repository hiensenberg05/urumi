"""
Enterprise Observability, Metrics & Telemetry Engine for Urumi MCP Gateway.

Provides:
1. OpenMetrics / Prometheus Exposition format (`/metrics`) for Prometheus/Grafana scrapers.
2. High-resolution telemetry JSON (`/api/v1/telemetry`) with:
   - Per-server request throughput, success/error rates, and p50/p95/p99 latency distributions.
   - Circuit breaker tracking (CLOSED, OPEN, HALF_OPEN) with automatic trip recovery.
   - Comprehensive diagnostic failure reporting (clear explanation of why an upstream failed).
   - Tool-level frequency and performance profiling.
"""

import math
import time
from typing import Any, Dict, List, Optional, Tuple


class TelemetryCollector:
    """In-memory telemetry collector and Prometheus metric formatter."""

    def __init__(self, latency_window: int = 150):
        self.latency_window = latency_window
        self.start_time = time.time()

        # Global Counters
        self.total_invocations = 0
        self.successful_invocations = 0
        self.failed_invocations = 0
        self.rbac_violations = 0
        self.rate_limit_blocks = 0

        # Per-Server Tracking: server_id -> metrics
        self.server_calls: Dict[str, int] = {}
        self.server_success: Dict[str, int] = {}
        self.server_errors: Dict[str, int] = {}
        self.server_latencies: Dict[str, List[float]] = {}
        self.server_last_error: Dict[str, Dict[str, Any]] = {}
        self.server_consecutive_failures: Dict[str, int] = {}
        self.server_circuit_breaker: Dict[str, Dict[str, Any]] = {}

        # Per-Tool Tracking: tool_name -> metrics
        self.tool_calls: Dict[str, int] = {}
        self.tool_errors: Dict[str, int] = {}
        self.tool_latencies: Dict[str, List[float]] = {}

        # Role Distribution: role -> count
        self.role_calls: Dict[str, int] = {}

    def _get_percentiles(self, values: List[float]) -> Dict[str, float]:
        """Compute p50, p90, p95, p99 percentiles from a list of latencies in milliseconds."""
        if not values:
            return {"p50": 0.0, "p90": 0.0, "p95": 0.0, "p99": 0.0, "avg": 0.0, "min": 0.0, "max": 0.0}
        sorted_vals = sorted(values)
        n = len(sorted_vals)

        def percentile(p: float) -> float:
            idx = int(math.ceil(p * n)) - 1
            idx = max(0, min(idx, n - 1))
            return round(sorted_vals[idx], 1)

        return {
            "p50": percentile(0.50),
            "p90": percentile(0.90),
            "p95": percentile(0.95),
            "p99": percentile(0.99),
            "avg": round(sum(sorted_vals) / n, 1),
            "min": round(sorted_vals[0], 1),
            "max": round(sorted_vals[-1], 1),
        }

    def record_tool_call(
        self,
        server_id: str,
        tool_name: str,
        duration_ms: float,
        status: str,
        error_category: Optional[str] = None,
        error_detail: Optional[str] = None,
        user_role: Optional[str] = None,
    ):
        """Record a completed or failed tool invocation across Gateway telemetry dimensions."""
        self.total_invocations += 1
        is_success = status.startswith("200") or status.lower() == "success"

        if is_success:
            self.successful_invocations += 1
        else:
            self.failed_invocations += 1

        # Track per-server metrics
        self.server_calls[server_id] = self.server_calls.get(server_id, 0) + 1
        if is_success:
            self.server_success[server_id] = self.server_success.get(server_id, 0) + 1
            self.server_consecutive_failures[server_id] = 0
            # Reset circuit breaker if it was recovering
            if server_id in self.server_circuit_breaker:
                cb = self.server_circuit_breaker[server_id]
                if cb.get("state") in ("HALF_OPEN", "OPEN"):
                    cb["state"] = "CLOSED"
                    cb["tripped_count"] = cb.get("tripped_count", 0)
        else:
            self.server_errors[server_id] = self.server_errors.get(server_id, 0) + 1
            consec = self.server_consecutive_failures.get(server_id, 0) + 1
            self.server_consecutive_failures[server_id] = consec

            # Record clear diagnostic failure reason
            self.server_last_error[server_id] = {
                "timestamp": time.strftime("%Y-%m-%d %H:%M:%S UTC"),
                "tool": tool_name,
                "category": error_category or "EXECUTION_FAILURE",
                "detail": error_detail or "Tool returned an error or non-200 status code.",
                "status": status,
            }

            # Circuit Breaker Trip condition: 3 consecutive failures trips the breaker
            if consec >= 3:
                cb = self.server_circuit_breaker.setdefault(server_id, {"state": "CLOSED", "tripped_count": 0})
                cb["state"] = "OPEN"
                cb["tripped_count"] = cb.get("tripped_count", 0) + 1
                cb["tripped_at"] = time.time()
                cb["reason"] = f"3 consecutive upstream errors ({error_category or 'EXECUTION_FAILURE'})"

        # Record server latency
        if server_id not in self.server_latencies:
            self.server_latencies[server_id] = []
        self.server_latencies[server_id].append(duration_ms)
        if len(self.server_latencies[server_id]) > self.latency_window:
            self.server_latencies[server_id].pop(0)

        # Track per-tool metrics
        self.tool_calls[tool_name] = self.tool_calls.get(tool_name, 0) + 1
        if not is_success:
            self.tool_errors[tool_name] = self.tool_errors.get(tool_name, 0) + 1

        if tool_name not in self.tool_latencies:
            self.tool_latencies[tool_name] = []
        self.tool_latencies[tool_name].append(duration_ms)
        if len(self.tool_latencies[tool_name]) > self.latency_window:
            self.tool_latencies[tool_name].pop(0)

        # Track role distribution
        if user_role:
            self.role_calls[user_role] = self.role_calls.get(user_role, 0) + 1

    def record_rbac_violation(self, role: str, tool_name: str):
        """Track authorization policy blocks."""
        self.rbac_violations += 1
        self.total_invocations += 1
        self.failed_invocations += 1

    def record_rate_limit(self, api_key: str):
        """Track rate limiting rejections."""
        self.rate_limit_blocks += 1

    def get_circuit_breaker_status(self, server_id: str) -> Dict[str, Any]:
        """Check circuit breaker state with automatic half-open cool-down decay."""
        cb = self.server_circuit_breaker.get(server_id, {"state": "CLOSED", "tripped_count": 0})
        # If open for > 30 seconds, transition to HALF_OPEN (allow probe)
        if cb.get("state") == "OPEN":
            tripped_at = cb.get("tripped_at", 0)
            if (time.time() - tripped_at) > 30.0:
                cb["state"] = "HALF_OPEN"
                cb["reason"] = "Cooldown elapsed (30s). Allowing canary probe."
        return cb

    def get_telemetry_json(self, servers_map: Dict[str, Any], tools_list: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Generate structured high-resolution telemetry payload for dashboard."""
        uptime_seconds = round(time.time() - self.start_time, 1)

        # Global Latencies
        all_lats: List[float] = []
        for l_list in self.server_latencies.values():
            all_lats.extend(l_list)
        global_pcts = self._get_percentiles(all_lats)

        error_rate_pct = round((self.failed_invocations / max(self.total_invocations, 1)) * 100.0, 2)
        success_rate_pct = round((self.successful_invocations / max(self.total_invocations, 1)) * 100.0, 2)

        # Per-Server Telemetry Rows
        server_rows = []
        for s_id, srv in servers_map.items():
            calls = self.server_calls.get(s_id, 0)
            errs = self.server_errors.get(s_id, 0)
            srv_err_pct = round((errs / max(calls, 1)) * 100.0, 1)
            srv_pcts = self._get_percentiles(self.server_latencies.get(s_id, []))
            cb = self.get_circuit_breaker_status(s_id)
            last_err = self.server_last_error.get(s_id)

            server_rows.append({
                "id": s_id,
                "name": getattr(srv, "name", s_id),
                "tag": getattr(srv, "tag", "general"),
                "status": getattr(srv, "status", "Connected"),
                "endpointUrl": getattr(srv, "endpoint_url", ""),
                "circuitBreaker": cb.get("state", "CLOSED"),
                "circuitTrips": cb.get("tripped_count", 0),
                "totalCalls": calls,
                "errorCount": errs,
                "errorRatePct": srv_err_pct,
                "p50LatencyMs": srv_pcts["p50"],
                "p95LatencyMs": srv_pcts["p95"],
                "p99LatencyMs": srv_pcts["p99"],
                "avgLatencyMs": srv_pcts["avg"],
                "lastError": last_err,
            })

        # Per-Tool Telemetry Rows
        tool_rows = []
        for t in tools_list:
            t_name = t.get("namespacedName") or t.get("name", "")
            t_calls = self.tool_calls.get(t_name, 0)
            t_errs = self.tool_errors.get(t_name, 0)
            t_pcts = self._get_percentiles(self.tool_latencies.get(t_name, []))

            tool_rows.append({
                "name": t_name,
                "serverName": t.get("serverName", "Gateway"),
                "totalCalls": t_calls,
                "errorCount": t_errs,
                "errorRatePct": round((t_errs / max(t_calls, 1)) * 100.0, 1),
                "p50LatencyMs": t_pcts["p50"],
                "p95LatencyMs": t_pcts["p95"],
                "avgLatencyMs": t_pcts["avg"],
            })

        # Sort tools by highest call volume
        tool_rows.sort(key=lambda x: x["totalCalls"], reverse=True)

        return {
            "summary": {
                "uptimeSeconds": uptime_seconds,
                "totalInvocations": self.total_invocations,
                "successfulInvocations": self.successful_invocations,
                "failedInvocations": self.failed_invocations,
                "errorRatePct": error_rate_pct,
                "successRatePct": success_rate_pct,
                "rbacViolations": self.rbac_violations,
                "rateLimitBlocks": self.rate_limit_blocks,
                "activeServers": sum(1 for s in server_rows if s["status"] == "Connected"),
                "totalServers": len(server_rows),
                "totalTools": len(tools_list),
                "latency": global_pcts,
            },
            "servers": server_rows,
            "topTools": tool_rows[:10],
            "roleDistribution": self.role_calls,
        }

    def get_prometheus_metrics(self, servers_map: Dict[str, Any], tools_list: List[Dict[str, Any]]) -> str:
        """Export all operational counters and histograms in standard Prometheus exposition format."""
        lines = [
            "# HELP mcp_gateway_uptime_seconds Total runtime of the MCP Gateway service",
            "# TYPE mcp_gateway_uptime_seconds gauge",
            f"mcp_gateway_uptime_seconds {time.time() - self.start_time:.1f}",
            "",
            "# HELP mcp_tool_calls_total Cumulative count of MCP tool execution attempts",
            "# TYPE mcp_tool_calls_total counter",
            f'mcp_tool_calls_total{{status="success"}} {self.successful_invocations}',
            f'mcp_tool_calls_total{{status="error"}} {self.failed_invocations}',
            "",
            "# HELP mcp_rbac_violations_total Total number of RBAC policy authorization blocks",
            "# TYPE mcp_rbac_violations_total counter",
            f"mcp_rbac_violations_total {self.rbac_violations}",
            "",
            "# HELP mcp_rate_limit_blocks_total Total number of requests throttled by rate limiters",
            "# TYPE mcp_rate_limit_blocks_total counter",
            f"mcp_rate_limit_blocks_total {self.rate_limit_blocks}",
            "",
            "# HELP mcp_upstream_server_status Current connectivity state (1=Connected, 0=Degraded/Down)",
            "# TYPE mcp_upstream_server_status gauge",
        ]

        for s_id, srv in servers_map.items():
            is_conn = 1 if getattr(srv, "status", "") == "Connected" else 0
            lines.append(f'mcp_upstream_server_status{{server_id="{s_id}"}} {is_conn}')

        lines.extend([
            "",
            "# HELP mcp_circuit_breaker_state Current circuit breaker state (0=CLOSED, 1=OPEN, 2=HALF_OPEN)",
            "# TYPE mcp_circuit_breaker_state gauge",
        ])
        for s_id in servers_map.keys():
            cb = self.get_circuit_breaker_status(s_id)
            state_val = 0 if cb.get("state") == "CLOSED" else (1 if cb.get("state") == "OPEN" else 2)
            lines.append(f'mcp_circuit_breaker_state{{server_id="{s_id}"}} {state_val}')

        lines.extend([
            "",
            "# HELP mcp_server_requests_total Total invocations grouped by upstream server",
            "# TYPE mcp_server_requests_total counter",
        ])
        for s_id, count in self.server_calls.items():
            err_count = self.server_errors.get(s_id, 0)
            succ_count = count - err_count
            lines.append(f'mcp_server_requests_total{{server_id="{s_id}",status="success"}} {succ_count}')
            lines.append(f'mcp_server_requests_total{{server_id="{s_id}",status="error"}} {err_count}')

        lines.extend([
            "",
            "# HELP mcp_server_latency_seconds_p95 95th percentile latency per upstream server",
            "# TYPE mcp_server_latency_seconds_p95 gauge",
        ])
        for s_id, lats in self.server_latencies.items():
            pcts = self._get_percentiles(lats)
            lines.append(f'mcp_server_latency_seconds_p95{{server_id="{s_id}"}} {pcts["p95"] / 1000.0:.4f}')

        lines.extend([
            "",
            "# HELP mcp_tool_execution_count Number of times a specific tool was invoked",
            "# TYPE mcp_tool_execution_count counter",
        ])
        for t_name, count in self.tool_calls.items():
            lines.append(f'mcp_tool_execution_count{{tool="{t_name}"}} {count}')

        return "\n".join(lines) + "\n"


# Singleton Global Collector
telemetry = TelemetryCollector()
