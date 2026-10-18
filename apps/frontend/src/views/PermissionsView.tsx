import React, { useState } from 'react';
import { 
  ShieldCheck, 
  Search, 
  RotateCcw, 
  Save, 
  ExternalLink, 
  AlertTriangle, 
  Check, 
  X, 
  Info,
  CheckCircle2
} from 'lucide-react';
import { ServerTool, PolicyAssignment, RiskProfile } from '../types';

interface PermissionsViewProps {
  tools: ServerTool[];
  onSavePolicies?: (updatedTools: ServerTool[]) => void;
}

export const PermissionsView: React.FC<PermissionsViewProps> = ({
  tools: initialTools,
  onSavePolicies
}) => {
  const [tools, setTools] = useState<ServerTool[]>(initialTools);
  const [modifiedTools, setModifiedTools] = useState<Record<string, PolicyAssignment>>({});
  const [selectedServer, setSelectedServer] = useState<string>('all');
  const [filterMode, setFilterMode] = useState<'all' | 'allowed' | 'denied' | 'inherit'>('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [savedSuccess, setSavedSuccess] = useState(false);

  // Handle policy toggle for a tool
  const handlePolicyChange = (toolId: string, newPolicy: PolicyAssignment) => {
    setTools(prev => prev.map(t => {
      if (t.id === toolId) {
        return {
          ...t,
          policy: newPolicy,
          effectiveRule: newPolicy === 'ALLOW' 
            ? 'Allowed via Role: Member' 
            : newPolicy === 'DENY' 
            ? 'Explicitly Denied (Overriding All)' 
            : 'Inherited Default (Denied)',
          isAllowed: newPolicy === 'ALLOW'
        };
      }
      return t;
    }));

    setModifiedTools(prev => ({
      ...prev,
      [toolId]: newPolicy
    }));
  };

  const handleDiscard = () => {
    setTools(initialTools);
    setModifiedTools({});
  };

  const handlePublish = () => {
    if (onSavePolicies) {
      onSavePolicies(tools);
    }
    setModifiedTools({});
    setSavedSuccess(true);
    setTimeout(() => setSavedSuccess(false), 3000);
  };

  const modifiedCount = Object.keys(modifiedTools).length;

  const filteredTools = tools.filter(t => {
    if (selectedServer !== 'all' && t.serverId !== selectedServer) return false;
    if (filterMode === 'allowed' && t.policy !== 'ALLOW') return false;
    if (filterMode === 'denied' && t.policy !== 'DENY') return false;
    if (filterMode === 'inherit' && t.policy !== 'INHERIT') return false;
    if (searchQuery) {
      return t.namespacedName.toLowerCase().includes(searchQuery.toLowerCase()) ||
             t.description.toLowerCase().includes(searchQuery.toLowerCase());
    }
    return true;
  });

  const getRiskBadge = (risk: RiskProfile) => {
    if (risk.includes('Low')) {
      return <span className="px-2 py-0.5 rounded text-[10px] font-mono font-medium bg-emerald-950/60 text-emerald-400 border border-emerald-800/40">• {risk}</span>;
    }
    if (risk.includes('Medium')) {
      return <span className="px-2 py-0.5 rounded text-[10px] font-mono font-medium bg-amber-950/60 text-amber-400 border border-amber-800/40">• {risk}</span>;
    }
    return <span className="px-2 py-0.5 rounded text-[10px] font-mono font-medium bg-red-950/60 text-red-400 border border-red-800/40">• {risk}</span>;
  };

  return (
    <div className="space-y-6 pb-24 animate-fadeIn">
      {/* Top Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-3">
            <h1 className="text-xl font-bold tracking-tight text-slate-100">Tool Permissions</h1>
            <span className="text-[11px] font-mono bg-emerald-950/60 border border-emerald-800/80 text-emerald-400 px-2 py-0.5 rounded-full font-medium flex items-center gap-1.5">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
              Zero-Trust Enforcement Active
            </span>
          </div>
          <p className="text-xs text-slate-400 mt-1">
            Control which users, service accounts, and roles can invoke tools across registered upstream MCP servers.
          </p>
        </div>

        {/* Top Action Buttons */}
        <div className="flex items-center gap-2.5">
          <button 
            onClick={handleDiscard}
            disabled={modifiedCount === 0}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-brand-card hover:bg-brand-surface border border-brand-border text-xs text-slate-400 hover:text-slate-200 disabled:opacity-40 transition font-mono"
          >
            <RotateCcw className="w-3.5 h-3.5" />
            <span>Reset to Role Defaults</span>
          </button>
          <button 
            onClick={handlePublish}
            disabled={modifiedCount === 0}
            className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-lg text-xs font-semibold shadow-md transition font-mono ${
              modifiedCount > 0 
                ? 'bg-emerald-500 hover:bg-emerald-600 text-slate-950 cursor-pointer shadow-emerald-500/20' 
                : 'bg-brand-surface text-slate-500 border border-brand-border cursor-not-allowed'
            }`}
          >
            <Save className="w-3.5 h-3.5" />
            <span>{savedSuccess ? 'Saved & Synced!' : `Save Policy Changes (${modifiedCount} Unsaved)`}</span>
          </button>
        </div>
      </div>

      {/* Security Architecture Banner (RFC-9482) */}
      <div className="p-4 rounded-xl bg-brand-card border border-brand-border relative overflow-hidden">
        <div className="flex items-start gap-3">
          <div className="w-8 h-8 rounded-lg bg-emerald-500/10 border border-emerald-500/30 flex items-center justify-center text-emerald-400 shrink-0 mt-0.5">
            <ShieldCheck className="w-4 h-4" />
          </div>
          <div className="flex-1">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <h3 className="text-sm font-semibold text-slate-100">
                  Security Architecture: Default-Deny with Explicit-Deny Precedence
                </h3>
                <span className="text-[10px] font-mono bg-brand-surface text-slate-400 px-1.5 py-0.2 rounded border border-brand-border">
                  RFC-9482
                </span>
              </div>
              <a href="#iam-spec" onClick={(e) => e.preventDefault()} className="text-xs text-emerald-400 hover:text-emerald-300 flex items-center gap-1 font-mono">
                <span>Read IAM & Policy Spec</span>
                <ExternalLink className="w-3 h-3" />
              </a>
            </div>
            <p className="text-xs text-slate-400 mt-1 max-w-4xl leading-relaxed">
              Urumi applies a strict least-privilege zero-trust gateway model. Unless an upstream tool is explicitly marked <strong className="text-emerald-400">ALLOW</strong> for an authenticated role or user token, execution requests will return HTTP 403 (Policy Denied). Explicit <strong className="text-red-400">DENY</strong> rules permanently override any inherited group or wildcard allowances.
            </p>

            {/* Evaluation Stack pills */}
            <div className="mt-3 flex items-center gap-2 text-[10px] font-mono flex-wrap">
              <span className="text-slate-400">Evaluation Stack:</span>
              <span className="px-2 py-0.5 rounded bg-red-950/60 text-red-300 border border-red-800/60 font-semibold">
                1. Explicit Deny (Overrides All)
              </span>
              <span className="text-slate-600">→</span>
              <span className="px-2 py-0.5 rounded bg-brand-surface text-slate-300 border border-brand-border">
                2. User-Specific Allow
              </span>
              <span className="text-slate-600">→</span>
              <span className="px-2 py-0.5 rounded bg-brand-surface text-slate-300 border border-brand-border">
                3. Role-Based Allow
              </span>
              <span className="text-slate-600">→</span>
              <span className="px-2 py-0.5 rounded bg-[#060a12] text-slate-400 border border-brand-border">
                4. Default: Gateway Deny
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Scope Selector and Filter Controls */}
      <div className="p-4 rounded-xl bg-brand-card border border-brand-border space-y-4">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          {/* Policy Scope */}
          <div className="flex items-center gap-2.5">
            <span className="text-[10px] font-mono uppercase text-slate-400 font-semibold">Policy Scope:</span>
            <div className="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-brand-surface border border-brand-border text-xs font-mono">
              <span className="text-emerald-400 font-semibold">Role: Member (Default Developer)</span>
              <span className="text-slate-400">•</span>
              <span className="text-slate-400 text-[11px]">12 Members inherit this policy</span>
            </div>
          </div>

          {/* Search Box */}
          <div className="relative">
            <Search className="w-3.5 h-3.5 text-slate-400 absolute left-3 top-2.5 pointer-events-none" />
            <input 
              type="text"
              placeholder="Search tools by name or description..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="bg-brand-surface border border-brand-border text-xs text-slate-200 placeholder-slate-400 pl-8 pr-4 py-1.5 rounded-lg focus:outline-none focus:border-emerald-500/50 w-full sm:w-72 font-mono"
            />
          </div>
        </div>

        {/* Server and Filter Mode Tabs */}
        <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-3 pt-2 border-t border-brand-border/60">
          {/* Server tabs */}
          <div className="flex items-center gap-1.5 text-xs font-mono overflow-x-auto pb-1 sm:pb-0">
            <button
              onClick={() => setSelectedServer('all')}
              className={`px-3 py-1 rounded-md transition ${selectedServer === 'all' ? 'bg-emerald-500 text-slate-950 font-bold' : 'text-slate-400 hover:text-slate-200 bg-brand-surface/40'}`}
            >
              All Servers (18)
            </button>
            <button
              onClick={() => setSelectedServer('server-wc')}
              className={`px-3 py-1 rounded-md transition ${selectedServer === 'server-wc' ? 'bg-emerald-500 text-slate-950 font-bold' : 'text-slate-400 hover:text-slate-200 bg-brand-surface/40'}`}
            >
              WooCommerce (5)
            </button>
            <button
              onClick={() => setSelectedServer('server-inv')}
              className={`px-3 py-1 rounded-md transition ${selectedServer === 'server-inv' ? 'bg-emerald-500 text-slate-950 font-bold' : 'text-slate-400 hover:text-slate-200 bg-brand-surface/40'}`}
            >
              Inventory (7)
            </button>
            <button
              onClick={() => setSelectedServer('server-an')}
              className={`px-3 py-1 rounded-md transition ${selectedServer === 'server-an' ? 'bg-emerald-500 text-slate-950 font-bold' : 'text-slate-400 hover:text-slate-200 bg-brand-surface/40'}`}
            >
              Analytics & BI (6)
            </button>
          </div>

          {/* Policy Filter status */}
          <div className="flex items-center gap-1 text-[11px] font-mono">
            <button
              onClick={() => setFilterMode('all')}
              className={`px-2.5 py-1 rounded transition ${filterMode === 'all' ? 'text-slate-100 font-bold bg-brand-surface' : 'text-slate-400 hover:text-slate-200'}`}
            >
              All Tools
            </button>
            <button
              onClick={() => setFilterMode('allowed')}
              className={`px-2.5 py-1 rounded transition ${filterMode === 'allowed' ? 'text-emerald-400 font-bold bg-emerald-950/60' : 'text-slate-400 hover:text-slate-200'}`}
            >
              Allowed Only (12)
            </button>
            <button
              onClick={() => setFilterMode('denied')}
              className={`px-2.5 py-1 rounded transition ${filterMode === 'denied' ? 'text-red-400 font-bold bg-red-950/60' : 'text-slate-400 hover:text-slate-200'}`}
            >
              Explicitly Denied (4)
            </button>
            <button
              onClick={() => setFilterMode('inherit')}
              className={`px-2.5 py-1 rounded transition ${filterMode === 'inherit' ? 'text-slate-300 font-bold bg-brand-surface' : 'text-slate-400 hover:text-slate-200'}`}
            >
              Inherited Default (2)
            </button>
          </div>
        </div>
      </div>

      {/* Permissions Matrix Table */}
      <div className="rounded-xl bg-brand-card border border-brand-border overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs font-mono">
            <thead>
              <tr className="border-b border-brand-border bg-brand-surface/30 text-slate-400 text-[10px] uppercase">
                <th className="py-3 px-4 font-semibold">Tool Namespace & Identifier</th>
                <th className="py-3 px-4 font-semibold">Capability & Risk Profile</th>
                <th className="py-3 px-4 font-semibold">Policy Assignment</th>
                <th className="py-3 px-4 font-semibold">Effective Evaluation Rule</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-brand-border/60">
              {filteredTools.map((tool) => {
                const isModified = !!modifiedTools[tool.id];
                const isAllowed = tool.policy === 'ALLOW';
                const isDenied = tool.policy === 'DENY';

                return (
                  <tr key={tool.id} className="hover:bg-brand-surface/30 transition">
                    {/* Tool Identifier & Description */}
                    <td className="py-3.5 px-4">
                      <div className="flex items-center gap-2">
                        {isModified && (
                          <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse" title="Unsaved modification"></span>
                        )}
                        <span className="font-semibold text-slate-100">{tool.namespacedName}</span>
                        {isModified && (
                          <span className="text-[9px] font-mono bg-emerald-950 text-emerald-400 border border-emerald-800/60 px-1 rounded">
                            UNSAVED
                          </span>
                        )}
                      </div>
                      <div className="text-[11px] text-slate-400 mt-1 max-w-md font-sans">
                        {tool.description}
                      </div>
                    </td>

                    {/* Risk Profile Badge */}
                    <td className="py-3.5 px-4 whitespace-nowrap">
                      {getRiskBadge(tool.riskProfile)}
                    </td>

                    {/* Tri-State Policy Toggle */}
                    <td className="py-3.5 px-4 whitespace-nowrap">
                      <div className="inline-flex rounded-lg bg-[#070b12] p-1 border border-brand-border">
                        <button
                          onClick={() => handlePolicyChange(tool.id, 'ALLOW')}
                          className={`px-2.5 py-1 rounded text-[10px] font-bold transition ${
                            tool.policy === 'ALLOW' 
                              ? 'bg-emerald-500 text-slate-950 shadow-sm' 
                              : 'text-slate-400 hover:text-slate-200'
                          }`}
                        >
                          ALLOW
                        </button>
                        <button
                          onClick={() => handlePolicyChange(tool.id, 'DENY')}
                          className={`px-2.5 py-1 rounded text-[10px] font-bold transition ${
                            tool.policy === 'DENY' 
                              ? 'bg-red-500 text-white shadow-sm' 
                              : 'text-slate-400 hover:text-slate-200'
                          }`}
                        >
                          DENY
                        </button>
                        <button
                          onClick={() => handlePolicyChange(tool.id, 'INHERIT')}
                          className={`px-2.5 py-1 rounded text-[10px] font-bold transition ${
                            tool.policy === 'INHERIT' 
                              ? 'bg-slate-700 text-slate-200 shadow-sm' 
                              : 'text-slate-400 hover:text-slate-200'
                          }`}
                        >
                          INHERIT
                        </button>
                      </div>
                    </td>

                    {/* Effective Evaluation Rule */}
                    <td className="py-3.5 px-4 whitespace-nowrap text-xs">
                      <div className="flex items-center gap-1.5">
                        {isAllowed ? (
                          <>
                            <CheckCircle2 className="w-3.5 h-3.5 text-emerald-400 shrink-0" />
                            <span className="text-slate-300 font-semibold">{tool.effectiveRule}</span>
                          </>
                        ) : isDenied ? (
                          <>
                            <X className="w-3.5 h-3.5 text-red-400 shrink-0" />
                            <span className="text-red-400 font-semibold">{tool.effectiveRule}</span>
                          </>
                        ) : (
                          <>
                            <Info className="w-3.5 h-3.5 text-slate-400 shrink-0" />
                            <span className="text-slate-400">{tool.effectiveRule}</span>
                          </>
                        )}
                      </div>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>

      {/* Floating Bottom Action Bar (Shows when modifications exist) */}
      {modifiedCount > 0 && (
        <div className="fixed bottom-6 left-1/2 -translate-x-1/2 z-40 w-full max-w-2xl bg-[#090f19] border border-emerald-500/50 rounded-xl shadow-2xl p-4 flex items-center justify-between gap-4 animate-slideUp">
          <div className="flex items-center gap-3">
            <span className="w-2.5 h-2.5 rounded-full bg-emerald-400 animate-pulse"></span>
            <div>
              <div className="text-xs font-mono font-semibold text-slate-100">
                {modifiedCount} policy rules modified for Role: Member
              </div>
              <div className="text-[10px] font-mono text-slate-400">
                Will be logged as Policy Revision #v18 • Author: sarah@acme.corp
              </div>
            </div>
          </div>

          <div className="flex items-center gap-2">
            <button
              onClick={handleDiscard}
              className="px-3 py-1.5 rounded-lg text-xs font-mono text-slate-400 hover:text-slate-200 transition"
            >
              Discard Changes
            </button>
            <button
              onClick={handlePublish}
              className="px-4 py-1.5 rounded-lg bg-emerald-500 hover:bg-emerald-600 text-slate-950 font-bold text-xs font-mono shadow-md shadow-emerald-500/20 transition cursor-pointer"
            >
              Publish & Sync Gateways ({modifiedCount})
            </button>
          </div>
        </div>
      )}
    </div>
  );
};
