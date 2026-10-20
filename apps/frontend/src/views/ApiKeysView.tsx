import React, { useState } from 'react';
import { 
  KeyRound, 
  Plus, 
  Trash2, 
  UserPlus, 
  CheckCircle2, 
  AlertTriangle, 
  ShieldCheck, 
  Copy, 
  Check,
  User as UserIcon
} from 'lucide-react';
import { ApiKeyItem, User } from '../types';

interface ApiKeysViewProps {
  apiKeys: ApiKeyItem[];
  currentUser: User;
  onOpenGenerateModal: () => void;
  onRevokeKey: (keyId: string) => void;
}

export const ApiKeysView: React.FC<ApiKeysViewProps> = ({
  apiKeys,
  currentUser,
  onOpenGenerateModal,
  onRevokeKey
}) => {
  const [activeTab, setActiveTab] = useState<'keys' | 'team'>('keys');

  return (
    <div className="space-y-6 animate-fadeIn pb-16">
      {/* Top Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-3">
            <h1 className="text-xl font-bold tracking-tight text-slate-100">Team & API Keys</h1>
            <span className="text-[11px] font-mono bg-brand-surface border border-brand-border text-slate-300 px-2 py-0.5 rounded font-medium">
              Zero-Trust Auth Engine
            </span>
          </div>
          <p className="text-xs text-slate-400 mt-1 max-w-2xl leading-relaxed">
            Manage personal gateway tokens for IDE extensions, automated CI/CD runners, and invite team members into the workspace.
          </p>
        </div>

        <div className="flex items-center gap-2.5">
          {currentUser.role === 'ADMIN' ? (
            <button
              onClick={onOpenGenerateModal}
              className="flex items-center gap-1.5 px-4 py-2 rounded-lg bg-emerald-500 hover:bg-emerald-600 text-slate-950 font-bold text-xs font-mono shadow-md shadow-emerald-500/20 transition cursor-pointer"
            >
              <Plus className="w-3.5 h-3.5" />
              <span>Generate Gateway Token</span>
            </button>
          ) : (
            <div className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-red-950/30 border border-red-800/40 text-red-400 text-xs font-mono">
              <AlertTriangle className="w-3.5 h-3.5" />
              <span>Admin Privileges Required to Manage Keys</span>
            </div>
          )}
        </div>
      </div>

      {/* Navigation Switcher Tabs */}
      <div className="flex items-center gap-2 border-b border-brand-border pb-3">
        <button
          onClick={() => setActiveTab('keys')}
          className={`flex items-center gap-2 px-3 py-1.5 rounded-lg text-xs font-mono font-semibold transition ${
            activeTab === 'keys'
              ? 'bg-emerald-500/15 text-emerald-400 border border-emerald-500/30'
              : 'text-slate-400 hover:text-slate-200'
          }`}
        >
          <KeyRound className="w-3.5 h-3.5" />
          <span>Gateway Tokens ({apiKeys.length})</span>
        </button>
        <button
          onClick={() => setActiveTab('team')}
          className={`flex items-center gap-2 px-3 py-1.5 rounded-lg text-xs font-mono font-semibold transition ${
            activeTab === 'team'
              ? 'bg-emerald-500/15 text-emerald-400 border border-emerald-500/30'
              : 'text-slate-400 hover:text-slate-200'
          }`}
        >
          <UserIcon className="w-3.5 h-3.5" />
          <span>Team Members (2)</span>
        </button>
      </div>

      {activeTab === 'keys' ? (
        <div className="rounded-xl bg-brand-card border border-brand-border overflow-hidden">
          <div className="p-4 border-b border-brand-border flex items-center justify-between">
            <div>
              <h3 className="text-sm font-semibold text-slate-100">Registered Gateway Tokens</h3>
              <p className="text-xs text-slate-400 mt-0.5">
                Cryptographic tokens used by external MCP clients (Cursor, Claude Code, Cline) to connect to the unified gateway.
              </p>
            </div>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs font-mono">
              <thead>
                <tr className="border-b border-brand-border bg-brand-surface/30 text-slate-400 text-[10px] uppercase">
                  <th className="py-3 px-4 font-semibold">Token Label & Prefix</th>
                  <th className="py-3 px-4 font-semibold">Assigned Role</th>
                  <th className="py-3 px-4 font-semibold">Created / Last Used</th>
                  <th className="py-3 px-4 font-semibold">Expires</th>
                  <th className="py-3 px-4 font-semibold">Status</th>
                  <th className="py-3 px-4 font-semibold text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-brand-border/60">
                {apiKeys.map((k) => (
                  <tr key={k.id} className="hover:bg-brand-surface/30 transition">
                    <td className="py-3 px-4">
                      <div className="font-semibold text-slate-200">{k.name}</div>
                      <div className="text-[11px] text-emerald-400 mt-0.5">{k.keyPrefix}</div>
                    </td>
                    <td className="py-3 px-4">
                      <span className={`px-2 py-0.5 rounded text-[10px] font-semibold border ${
                        k.role === 'ADMIN'
                          ? 'bg-purple-950 text-purple-300 border-purple-800/60'
                          : 'bg-emerald-950 text-emerald-300 border-emerald-800/60'
                      }`}>
                        {k.role}
                      </span>
                    </td>
                    <td className="py-3 px-4 text-slate-400 text-[11px]">
                      <div>Created: {k.createdAt}</div>
                      <div>Last used: <span className="text-slate-200 font-semibold">{k.lastUsedAt}</span></div>
                    </td>
                    <td className="py-3 px-4 text-slate-400 text-[11px]">
                      {k.expiresAt}
                    </td>
                    <td className="py-3 px-4">
                      {k.isRevoked ? (
                        <span className="px-2 py-0.5 rounded text-[10px] font-semibold bg-red-950 text-red-400 border border-red-800/60">
                          REVOKED
                        </span>
                      ) : (
                        <span className="px-2 py-0.5 rounded text-[10px] font-semibold bg-emerald-950 text-emerald-400 border border-emerald-800/60">
                          ACTIVE
                        </span>
                      )}
                    </td>
                    <td className="py-3 px-4 text-right">
                      {!k.isRevoked ? (
                        currentUser.role === 'ADMIN' ? (
                          <button
                            onClick={() => onRevokeKey(k.id)}
                            className="px-2.5 py-1 rounded bg-red-950/40 hover:bg-red-950/80 border border-red-800/60 text-red-400 text-[11px] font-semibold transition cursor-pointer"
                          >
                            Revoke
                          </button>
                        ) : (
                          <span className="text-[10px] text-slate-400 font-mono px-2 py-0.5 rounded bg-brand-surface border border-brand-border">
                            Admin Only
                          </span>
                        )
                      ) : (
                        <span className="text-[11px] text-slate-400">Archived</span>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      ) : (
        /* Team Members List */
        <div className="rounded-xl bg-brand-card border border-brand-border p-5 space-y-4">
          <div className="flex items-center justify-between pb-3 border-b border-brand-border">
            <div>
              <h3 className="text-sm font-semibold text-slate-100">Workspace Members</h3>
              <p className="text-xs text-slate-400 mt-0.5">
                Team members with access to the dashboard and authorized MCP tools.
              </p>
            </div>
            <button className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-brand-surface hover:bg-brand-surface/80 border border-brand-border text-xs font-mono text-slate-200">
              <UserPlus className="w-3.5 h-3.5 text-emerald-400" />
              <span>Invite Member</span>
            </button>
          </div>

          <div className="space-y-3 font-mono text-xs">
            <div className="p-3.5 rounded-lg bg-brand-surface/40 border border-brand-border flex items-center justify-between">
              <div className="flex items-center gap-3">
                <img 
                  src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80" 
                  className="w-8 h-8 rounded-full object-cover border border-brand-border"
                />
                <div>
                  <div className="font-semibold text-slate-100">Sarah Chen</div>
                  <div className="text-[10px] text-slate-400">sarah@acme.corp</div>
                </div>
              </div>
              <span className="px-2 py-0.5 rounded bg-purple-950 text-purple-300 border border-purple-800/60 font-semibold text-[10px]">
                ADMIN
              </span>
            </div>

            <div className="p-3.5 rounded-lg bg-brand-surface/40 border border-brand-border flex items-center justify-between">
              <div className="flex items-center gap-3">
                <img 
                  src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80" 
                  className="w-8 h-8 rounded-full object-cover border border-brand-border"
                />
                <div>
                  <div className="font-semibold text-slate-100">Alex Rivera</div>
                  <div className="text-[10px] text-slate-400">alex@acme.corp</div>
                </div>
              </div>
              <span className="px-2 py-0.5 rounded bg-emerald-950 text-emerald-300 border border-emerald-800/60 font-semibold text-[10px]">
                MEMBER
              </span>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
