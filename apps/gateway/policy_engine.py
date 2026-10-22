"""
Dynamic Enterprise Policy Engine (ABAC & Runtime RBAC Matrix) for Urumi MCP Gateway.
Enables real-time modification of tool access policies across roles and users without
requiring gateway restarts or pod redeployments.
"""

from typing import Dict, List, Set, Optional, Any, Tuple
import copy
import json
import os
import time
import tempfile

from rbac import (
    ROLE_ADMIN,
    ROLE_INVENTORY_MANAGER,
    ROLE_ANALYST,
    ROLE_SUPPORT_REP,
    ALL_ROLES,
    ROLE_PERMISSIONS,
    TOOL_RISK_PROFILES,
    _normalize_tool_for_rbac,
)

POLICY_ALLOW = "ALLOW"
POLICY_DENY = "DENY"
POLICY_INHERIT = "INHERIT"

VALID_POLICIES = {POLICY_ALLOW, POLICY_DENY, POLICY_INHERIT}

class PolicyEngine:
    def __init__(self, persistence_file: Optional[str] = None):
        default_path = os.path.join(tempfile.gettempdir(), "urumi_dynamic_policies.json")
        self.persistence_file = persistence_file or os.environ.get(
            "GATEWAY_POLICY_FILE", default_path
        )
        # Dynamic overrides: role -> { tool_name: "ALLOW" | "DENY" }
        self.overrides: Dict[str, Dict[str, str]] = {role: {} for role in ALL_ROLES}
        # Dynamic user/principal overrides: principal_name/id -> { tool_name: "ALLOW" | "DENY" }
        self.user_overrides: Dict[str, Dict[str, str]] = {}
        # History of policy changes
        self.change_history: List[Dict[str, Any]] = []
        
        self._load_from_disk()

    def _load_from_disk(self):
        """Attempt to restore persisted overrides on startup."""
        if os.path.exists(self.persistence_file):
            try:
                with open(self.persistence_file, "r") as f:
                    data = json.load(f)
                    self.overrides = data.get("overrides", {role: {} for role in ALL_ROLES})
                    self.user_overrides = data.get("user_overrides", {})
                    self.change_history = data.get("change_history", [])
            except Exception as e:
                print(f"[PolicyEngine] Warning: Could not load persistence file: {e}")

    def _save_to_disk(self):
        """Persist current overrides to disk."""
        try:
            with open(self.persistence_file, "w") as f:
                json.dump({
                    "overrides": self.overrides,
                    "user_overrides": self.user_overrides,
                    "change_history": self.change_history[-100:],  # keep last 100 changes
                    "updated_at": time.time(),
                }, f, indent=2)
        except Exception as e:
            print(f"[PolicyEngine] Warning: Could not save persistence file: {e}")

    def is_tool_allowed(
        self,
        role: str,
        tool_name: str,
        principal_id: Optional[str] = None,
    ) -> bool:
        """
        Evaluate real-time authorization for a tool call.
        Precedence:
          1. Explicit User Override (if specified)
          2. Explicit Role Dynamic Override (ALLOW or DENY)
          3. Role Default Baseline from rbac.py (Admin default ALLOW)
        """
        normalized_name = _normalize_tool_for_rbac(tool_name)

        # 1. User/Principal override
        if principal_id and principal_id in self.user_overrides:
            u_ov = self.user_overrides[principal_id]
            if tool_name in u_ov:
                return u_ov[tool_name] == POLICY_ALLOW
            if normalized_name in u_ov:
                return u_ov[normalized_name] == POLICY_ALLOW

        # 2. Dynamic Role override
        if role in self.overrides:
            r_ov = self.overrides[role]
            # Check exact tool name override
            if tool_name in r_ov:
                return r_ov[tool_name] == POLICY_ALLOW
            # Check normalized tool name override
            if normalized_name in r_ov:
                return r_ov[normalized_name] == POLICY_ALLOW

        # 3. Admin default bypass (unless explicit DENY was found above)
        if role == ROLE_ADMIN:
            return True

        # 4. Fallback to baseline RBAC matrix
        allowed = ROLE_PERMISSIONS.get(role, set())
        return (tool_name in allowed) or (normalized_name in allowed)

    def get_effective_policy(self, role: str, tool_name: str) -> Tuple[str, bool]:
        """
        Returns (effective_policy_str, is_custom_override).
        effective_policy_str is 'ALLOW' or 'DENY'.
        """
        normalized_name = _normalize_tool_for_rbac(tool_name)
        
        # Check if dynamic override exists
        if role in self.overrides:
            r_ov = self.overrides[role]
            if tool_name in r_ov:
                return r_ov[tool_name], True
            if normalized_name in r_ov:
                return r_ov[normalized_name], True

        # Baseline
        if role == ROLE_ADMIN:
            return POLICY_ALLOW, False

        allowed = ROLE_PERMISSIONS.get(role, set())
        is_allowed = (tool_name in allowed) or (normalized_name in allowed)
        return POLICY_ALLOW if is_allowed else POLICY_DENY, False

    def get_policy_matrix(self, all_tools: List[Dict[str, Any]]) -> Dict[str, Any]:
        """
        Build the comprehensive policy matrix for the frontend studio.
        """
        matrix_rows = []
        for t in all_tools:
            tool_name = t.get("namespacedName", t.get("name", ""))
            server_name = t.get("serverName", "gateway")
            desc = t.get("description", "")
            risk = TOOL_RISK_PROFILES.get(tool_name, "Low (Standard)")
            
            role_policies = {}
            for r in ALL_ROLES:
                pol, is_custom = self.get_effective_policy(r, tool_name)
                role_policies[r] = {
                    "policy": pol,
                    "isCustomOverride": is_custom,
                    "defaultPolicy": POLICY_ALLOW if (r == ROLE_ADMIN or tool_name in ROLE_PERMISSIONS.get(r, set())) else POLICY_DENY,
                }
            
            matrix_rows.append({
                "namespacedName": tool_name,
                "serverName": server_name,
                "description": desc,
                "riskProfile": risk,
                "roles": role_policies,
            })

        return {
            "roles": [
                {"id": r, "name": r.replace("_", " ").title()} for r in ALL_ROLES
            ],
            "tools": matrix_rows,
            "totalTools": len(matrix_rows),
            "customOverridesCount": sum(
                len(overrides) for overrides in self.overrides.values()
            ),
            "lastUpdated": time.strftime("%Y-%m-%d %H:%M:%S UTC"),
        }

    def set_policy(
        self,
        role: str,
        tool_name: str,
        policy: str,
        modified_by: str = "Admin",
    ) -> bool:
        """
        Set or remove a dynamic policy override.
        If policy == 'INHERIT', the override is removed (reverting to baseline).
        """
        if role not in ALL_ROLES:
            raise ValueError(f"Unknown role '{role}'. Valid roles: {ALL_ROLES}")
        
        policy = policy.upper()
        if policy not in VALID_POLICIES:
            raise ValueError(f"Invalid policy '{policy}'. Must be one of: {list(VALID_POLICIES)}")

        if policy == POLICY_INHERIT:
            if tool_name in self.overrides[role]:
                del self.overrides[role][tool_name]
        else:
            self.overrides[role][tool_name] = policy

        self.change_history.append({
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S UTC"),
            "modifiedBy": modified_by,
            "role": role,
            "tool": tool_name,
            "newPolicy": policy,
        })
        self._save_to_disk()
        return True

    def batch_set_policies(
        self,
        updates: List[Dict[str, str]],
        modified_by: str = "Admin",
    ) -> int:
        """
        Apply a list of policy updates:
        [{"role": "analyst", "tool": "inventory__check_stock", "policy": "ALLOW"}]
        """
        count = 0
        for item in updates:
            role = item.get("role")
            tool = item.get("tool")
            policy = item.get("policy", "INHERIT")
            if role and tool:
                self.set_policy(role, tool, policy, modified_by=modified_by)
                count += 1
        return count

    def reset_policies(self, modified_by: str = "Admin") -> None:
        """Clear all dynamic overrides and revert to baseline."""
        self.overrides = {role: {} for role in ALL_ROLES}
        self.user_overrides = {}
        self.change_history.append({
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S UTC"),
            "modifiedBy": modified_by,
            "action": "RESET_TO_BASELINE",
        })
        self._save_to_disk()

# Global singleton policy engine instance
policy_engine = PolicyEngine()
