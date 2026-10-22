import React, { useState, useEffect } from 'react';
import { 
  ShieldCheck, 
  Search, 
  RotateCcw, 
  Save, 
  AlertTriangle, 
  Check, 
  X, 
  Info,
  CheckCircle2,
  Lock,
  Layers,
  Sparkles,
  RefreshCw,
  Sliders,
  AlertCircle
} from 'lucide-react';
import { User, DynamicPolicyMatrix, DynamicPolicyItem } from '../types';

interface PermissionsViewProps {
  currentUser: User;
  activeApiKey: string;
  onPoliciesUpdated?: () => void;
}

export const PermissionsView: React.FC<PermissionsViewProps> = ({
  currentUser,
  activeApiKey,
  onPoliciesUpdated
}) => {
  const [matrix, setMatrix] = useState<DynamicPolicyMatrix | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedRole, setSelectedRole] = useState<string>('all');
  const [selectedServer, setSelectedServer] = useState<string>('all');
  const [pendingUpdates, setPendingUpdates] = useState<Record<string, { role: string; tool: string; policy: string }>>({});
  const [successMessage, setSuccessMessage] = useState<string | null>(null);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const isAdmin = currentUser.role === 'ADMIN';

  // Fetch policy matrix from gateway
  const fetchPolicies = async () => {
    setLoading(true);
    try {
      const res = await fetch('/api/v1/policies', {
        headers: {
          'Authorization': `Bearer ${activeApiKey}`,
          'X-API-Key': activeApiKey
        }
      });
      if (res.ok) {
        const data: DynamicPolicyMatrix = await res.json();
        setMatrix(data);
        setPendingUpdates({});
      } else {
        setErrorMessage(`Failed to load policies: HTTP ${res.status}`);
      }
    } catch (e: any) {
      setErrorMessage(`Network error fetching policies: ${e.message}`);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchPolicies();
  }, [activeApiKey]);

  // Handle stage change for a role/tool
  const handleTogglePolicy = (toolName: string, roleId: string, newPolicy: 'ALLOW' | 'DENY' | 'INHERIT') => {
    if (!isAdmin) return;
    const key = `${roleId}::${toolName}`;
    setPendingUpdates(prev => ({
      ...prev,
      [key]: { role: roleId, tool: toolName, policy: newPolicy }
    }));
  };

  // Discard pending changes
  const handleDiscard = () => {
    setPendingUpdates({});
  };

  // Publish changes to gateway
  const handlePublish = async () => {
    if (!isAdmin || Object.keys(pendingUpdates).length === 0) return;
    setSaving(true);
    setErrorMessage(null);

    const updates = Object.values(pendingUpdates);
    try {
      const res = await fetch('/api/v1/policies', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${activeApiKey}`,
          'X-API-Key': activeApiKey
        },
        body: JSON.stringify({ updates })
      });

      if (res.ok) {
        const data = await res.json();
        setMatrix(data.matrix);
        setPendingUpdates({});
        setSuccessMessage(`Successfully published ${updates.length} policy updates to cluster.`);
        setTimeout(() => setSuccessMessage(null), 4000);
        if (onPoliciesUpdated) onPoliciesUpdated();
      } else {
        const err = await res.json();
        setErrorMessage(err.detail || 'Failed to update policies.');
      }
    } catch (e: any) {
      setErrorMessage(`Failed to connect to gateway: ${e.message}`);
    } finally {
      setSaving(false);
    }
  };

  // Reset to factory baseline
  const handleResetBaseline = async () => {
    if (!isAdmin) return;
    if (!confirm('Are you sure you want to revert all custom policy overrides back to factory baseline?')) return;
    
    setSaving(true);
    try {
      const res = await fetch('/api/v1/policies/reset', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${activeApiKey}`,
          'X-API-Key': activeApiKey
        }
      });
      if (res.ok) {
        const data = await res.json();
        setMatrix(data.matrix);
        setPendingUpdates({});
        setSuccessMessage('All policies reverted to baseline defaults.');
        setTimeout(() => setSuccessMessage(null), 4000);
        if (onPoliciesUpdated) onPoliciesUpdated();
      }
    } catch (e: any) {
      setErrorMessage(`Failed to reset: ${e.message}`);
    } finally {
      setSaving(false);
    }
  };

  // Filter tools
  const tools = matrix?.tools || [];
  const servers = Array.from(new Set(tools.map(t => t.serverName)));

  const filteredTools = tools.filter(t => {
    if (selectedServer !== 'all' && t.serverName !== selectedServer) return false;
    if (searchQuery) {
      const q = searchQuery.toLowerCase();
      return t.namespacedName.toLowerCase().includes(q) || t.description.toLowerCase().includes(q);
    }
    return true;
  });

  const pendingCount = Object.keys(pendingUpdates).length;

  return (
    <div className="space-y-6">
      {/* Top Banner / Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-brand-surface border border-brand-border p-6 rounded-xl shadow-sm">
        <div>
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-emerald-500/10 border border-emerald-500/30 flex items-center justify-center text-emerald-400">
              <ShieldCheck className="w-6 h-6" />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h1 className="text-xl font-bold text-white tracking-tight">Dynamic Policy Studio</h1>
                <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-emerald-950/80 text-emerald-300 border border-emerald-800/60 font-semibold">
                  LIVE CLUSTER ENFORCEMENT
                </span>
              </div>
              <p className="text-xs text-slate-400 mt-0.5">
                Real-time RBAC matrix & ABAC policy overrides across all upstream MCP tools without pod restarts.
              </p>
            </div>
          </div>
        </div>

        {/* Global Action Bar */}
        <div className="flex items-center gap-2">
          {pendingCount > 0 && (
            <button
              onClick={handleDiscard}
              disabled={saving}
              className="px-3 py-2 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-300 text-xs font-medium border border-slate-700 transition flex items-center gap-1.5"
            >
              <RotateCcw className="w-3.5 h-3.5" />
              <span>Discard ({pendingCount})</span>
            </button>
          )}

          {isAdmin && (
            <button
              onClick={handleResetBaseline}
              disabled={saving || (matrix?.customOverridesCount === 0 && pendingCount === 0)}
              className="px-3 py-2 rounded-lg bg-slate-800/80 hover:bg-slate-700 text-slate-400 hover:text-slate-200 text-xs font-medium border border-slate-700/60 transition"
              title="Reset all dynamic overrides back to factory role defaults"
            >
              Reset Baseline
            </button>
          )}

          {isAdmin && (
            <button
              onClick={handlePublish}
              disabled={saving || pendingCount === 0}
              className={`px-4 py-2 rounded-lg text-xs font-semibold flex items-center gap-2 transition shadow-md ${
                pendingCount > 0
                  ? 'bg-emerald-600 hover:bg-emerald-500 text-white shadow-emerald-900/30 animate-pulse'
                  : 'bg-slate-800 text-slate-500 cursor-not-allowed'
              }`}
            >
              {saving ? <RefreshCw className="w-4 h-4 animate-spin" /> : <Save className="w-4 h-4" />}
              <span>Publish Changes ({pendingCount})</span>
            </button>
          )}
        </div>
      </div>

      {/* Non-Admin Security Notice */}
      {!isAdmin && (
        <div className="p-4 rounded-xl bg-amber-950/20 border border-amber-800/40 text-amber-300 text-xs flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <Lock className="w-4 h-4 shrink-0" />
            <span>
              <strong>Read-Only Mode:</strong> You are currently signed in with role <code>{currentUser.role}</code>. Modifying dynamic cluster policies requires Platform Administrator privileges.
            </span>
          </div>
          <span className="text-[11px] font-mono text-slate-400">Policy modifications locked</span>
        </div>
      )}

      {/* Notifications */}
      {successMessage && (
        <div className="p-3.5 rounded-xl bg-emerald-950/40 border border-emerald-600/50 text-emerald-300 text-xs flex items-center gap-2">
          <CheckCircle2 className="w-4 h-4 shrink-0" />
          <span>{successMessage}</span>
        </div>
      )}

      {errorMessage && (
        <div className="p-3.5 rounded-xl bg-rose-950/40 border border-rose-600/50 text-rose-300 text-xs flex items-center gap-2">
          <AlertCircle className="w-4 h-4 shrink-0" />
          <span>{errorMessage}</span>
        </div>
      )}

      {/* Filter and Search Bar */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-3 bg-brand-surface p-4 rounded-xl border border-brand-border text-xs">
        {/* Search */}
        <div className="relative md:col-span-2">
          <Search className="w-4 h-4 absolute left-3 top-2.5 text-slate-500" />
          <input
            type="text"
            placeholder="Search tools by capability or description..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-9 pr-3 py-2 bg-brand-card border border-brand-border rounded-lg text-slate-200 placeholder-slate-500 focus:outline-none focus:border-emerald-500/60"
          />
        </div>

        {/* Server filter */}
        <div>
          <select
            value={selectedServer}
            onChange={(e) => setSelectedServer(e.target.value)}
            className="w-full py-2 px-3 bg-brand-card border border-brand-border rounded-lg text-slate-200 focus:outline-none focus:border-emerald-500/60"
          >
            <option value="all">All Servers ({servers.length})</option>
            {servers.map(s => (
              <option key={s} value={s}>{s}</option>
            ))}
          </select>
        </div>

        {/* Role Column Filter */}
        <div>
          <select
            value={selectedRole}
            onChange={(e) => setSelectedRole(e.target.value)}
            className="w-full py-2 px-3 bg-brand-card border border-brand-border rounded-lg text-slate-200 focus:outline-none focus:border-emerald-500/60"
          >
            <option value="all">All Roles Matrix</option>
            <option value="admin">Admin Only</option>
            <option value="inventory_manager">Inventory Manager Only</option>
            <option value="analyst">Financial Analyst Only</option>
            <option value="support_rep">Support Rep Only</option>
          </select>
        </div>
      </div>

      {/* Main Policy Matrix Table */}
      <div className="bg-brand-surface border border-brand-border rounded-xl overflow-hidden shadow-sm">
        {loading ? (
          <div className="p-12 text-center text-slate-400 text-xs flex flex-col items-center gap-2">
            <RefreshCw className="w-6 h-6 animate-spin text-emerald-400" />
            <span>Loading live policy matrix from cluster...</span>
          </div>
        ) : filteredTools.length === 0 ? (
          <div className="p-12 text-center text-slate-400 text-xs">
            No tools found matching your search criteria.
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs border-collapse">
              <thead>
                <tr className="border-b border-brand-border bg-slate-900/50 text-slate-400 font-mono uppercase tracking-wider text-[11px]">
                  <th className="py-3 px-4 min-w-[260px]">Tool Capability</th>
                  <th className="py-3 px-3">Server</th>
                  <th className="py-3 px-3">Risk Level</th>
                  
                  {/* Role Columns */}
                  {(selectedRole === 'all' || selectedRole === 'admin') && (
                    <th className="py-3 px-4 min-w-[130px] text-center border-l border-brand-border">Admin</th>
                  )}
                  {(selectedRole === 'all' || selectedRole === 'inventory_manager') && (
                    <th className="py-3 px-4 min-w-[150px] text-center border-l border-brand-border">Inventory Mgr</th>
                  )}
                  {(selectedRole === 'all' || selectedRole === 'analyst') && (
                    <th className="py-3 px-4 min-w-[140px] text-center border-l border-brand-border">Analyst</th>
                  )}
                  {(selectedRole === 'all' || selectedRole === 'support_rep') && (
                    <th className="py-3 px-4 min-w-[140px] text-center border-l border-brand-border">Support Rep</th>
                  )}
                </tr>
              </thead>
              <tbody className="divide-y divide-brand-border/60">
                {filteredTools.map((t) => {
                  return (
                    <tr key={t.namespacedName} className="hover:bg-slate-900/30 transition">
                      {/* Capability Info */}
                      <td className="py-3 px-4">
                        <div className="font-semibold text-slate-200 font-mono text-xs">
                          {t.namespacedName}
                        </div>
                        <div className="text-[11px] text-slate-400 line-clamp-1 mt-0.5">
                          {t.description}
                        </div>
                      </td>

                      {/* Server Tag */}
                      <td className="py-3 px-3 whitespace-nowrap">
                        <span className="px-2 py-0.5 rounded bg-slate-800 text-slate-300 border border-slate-700/60 font-mono text-[10px]">
                          {t.serverName}
                        </span>
                      </td>

                      {/* Risk Level */}
                      <td className="py-3 px-3 whitespace-nowrap">
                        <span className={`px-2 py-0.5 rounded text-[10px] font-medium border ${
                          t.riskProfile.includes('Critical') 
                            ? 'bg-rose-950/60 text-rose-300 border-rose-800/60'
                            : t.riskProfile.includes('High')
                            ? 'bg-amber-950/60 text-amber-300 border-amber-800/60'
                            : 'bg-slate-800/80 text-slate-300 border-slate-700/60'
                        }`}>
                          {t.riskProfile}
                        </span>
                      </td>

                      {/* Role Cell: Admin */}
                      {(selectedRole === 'all' || selectedRole === 'admin') && (
                        <PolicyRoleCell
                          role="admin"
                          tool={t.namespacedName}
                          roleData={t.roles['admin']}
                          pendingUpdate={pendingUpdates[`admin::${t.namespacedName}`]}
                          isAdmin={isAdmin}
                          onToggle={handleTogglePolicy}
                        />
                      )}

                      {/* Role Cell: Inventory Manager */}
                      {(selectedRole === 'all' || selectedRole === 'inventory_manager') && (
                        <PolicyRoleCell
                          role="inventory_manager"
                          tool={t.namespacedName}
                          roleData={t.roles['inventory_manager']}
                          pendingUpdate={pendingUpdates[`inventory_manager::${t.namespacedName}`]}
                          isAdmin={isAdmin}
                          onToggle={handleTogglePolicy}
                        />
                      )}

                      {/* Role Cell: Analyst */}
                      {(selectedRole === 'all' || selectedRole === 'analyst') && (
                        <PolicyRoleCell
                          role="analyst"
                          tool={t.namespacedName}
                          roleData={t.roles['analyst']}
                          pendingUpdate={pendingUpdates[`analyst::${t.namespacedName}`]}
                          isAdmin={isAdmin}
                          onToggle={handleTogglePolicy}
                        />
                      )}

                      {/* Role Cell: Support Rep */}
                      {(selectedRole === 'all' || selectedRole === 'support_rep') && (
                        <PolicyRoleCell
                          role="support_rep"
                          tool={t.namespacedName}
                          roleData={t.roles['support_rep']}
                          pendingUpdate={pendingUpdates[`support_rep::${t.namespacedName}`]}
                          isAdmin={isAdmin}
                          onToggle={handleTogglePolicy}
                        />
                      )}
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Footer Info */}
      <div className="flex flex-col sm:flex-row items-center justify-between text-xs text-slate-500 gap-2">
        <div className="flex items-center gap-2">
          <span>Active Overrides: <strong className="text-emerald-400">{matrix?.customOverridesCount || 0}</strong></span>
          <span>•</span>
          <span>Total Tools: <strong className="text-slate-300">{matrix?.totalTools || 0}</strong></span>
          <span>•</span>
          <span>Last Reconciled: <strong className="text-slate-300">{matrix?.lastUpdated || 'Never'}</strong></span>
        </div>
        <div className="flex items-center gap-3">
          <span className="flex items-center gap-1.5">
            <span className="w-2.5 h-2.5 rounded bg-emerald-500/20 border border-emerald-500"></span>
            <span>Allow</span>
          </span>
          <span className="flex items-center gap-1.5">
            <span className="w-2.5 h-2.5 rounded bg-rose-500/20 border border-rose-500"></span>
            <span>Deny</span>
          </span>
          <span className="flex items-center gap-1.5">
            <span className="w-2.5 h-2.5 rounded bg-purple-500"></span>
            <span>Custom Override</span>
          </span>
        </div>
      </div>
    </div>
  );
};

interface PolicyRoleCellProps {
  role: string;
  tool: string;
  roleData?: {
    policy: 'ALLOW' | 'DENY';
    isCustomOverride: boolean;
    defaultPolicy: 'ALLOW' | 'DENY';
  };
  pendingUpdate?: { role: string; tool: string; policy: string };
  isAdmin: boolean;
  onToggle: (tool: string, role: string, policy: 'ALLOW' | 'DENY' | 'INHERIT') => void;
}

const PolicyRoleCell: React.FC<PolicyRoleCellProps> = ({
  role,
  tool,
  roleData,
  pendingUpdate,
  isAdmin,
  onToggle,
}) => {
  const currentEffective = pendingUpdate ? pendingUpdate.policy : (roleData?.policy || 'DENY');
  const isCustom = pendingUpdate ? (pendingUpdate.policy !== 'INHERIT') : (roleData?.isCustomOverride || false);
  const isPending = !!pendingUpdate;

  const isAllowed = currentEffective === 'ALLOW';

  const handleClickToggle = () => {
    if (!isAdmin) return;
    // Toggle cycle: ALLOW -> DENY -> INHERIT (revert)
    if (isAllowed) {
      onToggle(tool, role, 'DENY');
    } else {
      onToggle(tool, role, 'ALLOW');
    }
  };

  const handleRevert = (e: React.MouseEvent) => {
    e.stopPropagation();
    if (!isAdmin) return;
    onToggle(tool, role, 'INHERIT');
  };

  return (
    <td className="py-2.5 px-3 text-center border-l border-brand-border/60">
      <div className="inline-flex items-center gap-1.5">
        <button
          onClick={handleClickToggle}
          disabled={!isAdmin}
          title={isAdmin ? `Click to toggle: Currently ${isAllowed ? 'ALLOWED' : 'DENIED'}` : 'Locked: Admin required'}
          className={`px-2.5 py-1 rounded text-[11px] font-mono font-semibold flex items-center gap-1 transition border ${
            isAllowed
              ? 'bg-emerald-950/70 text-emerald-300 border-emerald-600/70 hover:bg-emerald-900/60'
              : 'bg-rose-950/70 text-rose-300 border-rose-800/70 hover:bg-rose-900/60'
          } ${isPending ? 'ring-2 ring-purple-500/80' : ''} ${!isAdmin ? 'cursor-default opacity-85' : 'cursor-pointer'}`}
        >
          {isAllowed ? <Check className="w-3 h-3 text-emerald-400" /> : <X className="w-3 h-3 text-rose-400" />}
          <span>{isAllowed ? 'ALLOW' : 'DENY'}</span>
          {isCustom && (
            <span className="w-1.5 h-1.5 rounded-full bg-purple-400" title="Custom dynamic override"></span>
          )}
        </button>

        {isCustom && isAdmin && (
          <button
            onClick={handleRevert}
            title="Revert override back to default role baseline"
            className="p-1 rounded text-slate-500 hover:text-slate-300 hover:bg-slate-800 transition"
          >
            <RotateCcw className="w-2.5 h-2.5" />
          </button>
        )}
      </div>
    </td>
  );
};
