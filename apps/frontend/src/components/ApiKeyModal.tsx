import React, { useState } from 'react';
import { KeyRound, Copy, Check, ShieldCheck, X, Loader2, Sparkles } from 'lucide-react';
import { ApiKeyItem } from '../types';

interface ApiKeyModalProps {
  isOpen: boolean;
  onClose: () => void;
  onKeyCreated?: (newKey: ApiKeyItem) => void;
}

export const ApiKeyModal: React.FC<ApiKeyModalProps> = ({
  isOpen,
  onClose,
  onKeyCreated
}) => {
  const [step, setStep] = useState<'create' | 'success'>('create');
  const [name, setName] = useState('');
  const [role, setRole] = useState('inventory_manager');
  const [scope, setScope] = useState('read:write');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [copied, setCopied] = useState(false);

  const [createdKey, setCreatedKey] = useState<{
    name: string;
    scope: string;
    role: string;
    plaintextToken: string;
  } | null>(null);

  if (!isOpen) return null;

  const handleReset = () => {
    setStep('create');
    setName('');
    setRole('inventory_manager');
    setScope('read:write');
    setLoading(false);
    setError(null);
    setCopied(false);
    setCreatedKey(null);
    onClose();
  };

  const handleCreateKey = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) {
      setError('Please provide a descriptive key label.');
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const res = await fetch('/api/v1/api-keys', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer admin-key-urumi-2026',
        },
        body: JSON.stringify({
          name: name.trim(),
          role: role,
          scope: scope,
        }),
      });

      if (!res.ok) {
        const errData = await res.json().catch(() => ({}));
        throw new Error(errData.detail || `Failed to create API key (HTTP ${res.status})`);
      }

      const keyData = await res.json();
      setCreatedKey({
        name: keyData.name,
        role: keyData.role,
        scope: keyData.scope,
        plaintextToken: keyData.key,
      });

      if (onKeyCreated) {
        onKeyCreated(keyData);
      }

      setStep('success');
    } catch (err: any) {
      setError(err.message || 'Error communicating with Gateway auth engine.');
    } finally {
      setLoading(false);
    }
  };

  const handleCopy = () => {
    if (createdKey) {
      navigator.clipboard.writeText(createdKey.plaintextToken);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm animate-fadeIn">
      <div className="relative w-full max-w-lg bg-[#0d1522] border border-brand-border rounded-xl shadow-2xl p-6 text-slate-100 overflow-hidden">
        {/* Close Button */}
        <button 
          onClick={handleReset}
          className="absolute top-4 right-4 p-1.5 rounded-lg text-slate-400 hover:text-slate-200 hover:bg-brand-surface transition cursor-pointer"
        >
          <X className="w-4 h-4" />
        </button>

        {step === 'create' ? (
          <div>
            {/* Modal Header */}
            <div className="flex items-start gap-3.5 mb-5">
              <div className="w-10 h-10 rounded-lg bg-emerald-500/15 border border-emerald-500/30 flex items-center justify-center text-emerald-400 shrink-0">
                <Sparkles className="w-5 h-5" />
              </div>
              <div>
                <h3 className="text-base font-semibold text-slate-100">Generate Gateway Token</h3>
                <p className="text-xs text-slate-400 mt-1 leading-relaxed">
                  Issue a scoped cryptographic API key with RBAC policy bounds for MCP clients (Cursor, Claude, Antigravity, CI/CD).
                </p>
              </div>
            </div>

            {error && (
              <div className="mb-4 p-3 rounded-lg bg-rose-950/40 border border-rose-500/40 text-rose-300 text-xs">
                {error}
              </div>
            )}

            <form onSubmit={handleCreateKey} className="space-y-4">
              <div>
                <label className="block text-xs font-mono font-semibold text-slate-300 mb-1.5">
                  Token Label / Name
                </label>
                <input
                  type="text"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  placeholder="e.g. Antigravity Assistant Key, Warehouse Scanner"
                  className="w-full bg-[#060a10] border border-brand-border focus:border-emerald-500 rounded-lg px-3.5 py-2 text-xs text-slate-100 placeholder-slate-500 focus:outline-none"
                  autoFocus
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-xs font-mono font-semibold text-slate-300 mb-1.5">
                    Assigned Role
                  </label>
                  <select
                    value={role}
                    onChange={(e) => setRole(e.target.value)}
                    className="w-full bg-[#060a10] border border-brand-border focus:border-emerald-500 rounded-lg px-3 py-2 text-xs text-slate-200 focus:outline-none"
                  >
                    <option value="admin">Admin (All 12 Tools)</option>
                    <option value="inventory_manager">Inventory Manager (Stock & Catalog)</option>
                    <option value="analyst">Analyst (Revenue & Analytics)</option>
                    <option value="support_rep">Support Rep (Orders & Stock)</option>
                  </select>
                </div>

                <div>
                  <label className="block text-xs font-mono font-semibold text-slate-300 mb-1.5">
                    Scope
                  </label>
                  <select
                    value={scope}
                    onChange={(e) => setScope(e.target.value)}
                    className="w-full bg-[#060a10] border border-brand-border focus:border-emerald-500 rounded-lg px-3 py-2 text-xs text-slate-200 focus:outline-none"
                  >
                    <option value="read:write">read:write (Full Permissions)</option>
                    <option value="read:only">read:only (Safe Inspection)</option>
                    <option value="read:analytics">read:analytics (BI Telemetry)</option>
                  </select>
                </div>
              </div>

              <div className="p-3 rounded-lg bg-brand-surface/40 border border-brand-border text-[11px] text-slate-400 leading-relaxed">
                Tokens inherit zero-trust rate limits (60 req/min, 15 burst) and write-actions are logged in real-time Gateway Audit telemetry.
              </div>

              <div className="flex items-center justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={handleReset}
                  className="px-4 py-2 rounded-lg text-xs text-slate-400 hover:text-slate-200 hover:bg-brand-surface transition cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={loading}
                  className="flex items-center gap-2 px-5 py-2 rounded-lg bg-emerald-500 hover:bg-emerald-600 disabled:opacity-50 text-slate-950 font-bold text-xs shadow-lg shadow-emerald-500/20 transition cursor-pointer"
                >
                  {loading && <Loader2 className="w-3.5 h-3.5 animate-spin" />}
                  <span>{loading ? 'Generating...' : 'Create Key'}</span>
                </button>
              </div>
            </form>
          </div>
        ) : (
          <div>
            {/* Modal Header */}
            <div className="flex items-start gap-3.5 mb-5">
              <div className="w-10 h-10 rounded-lg bg-emerald-500/15 border border-emerald-500/30 flex items-center justify-center text-emerald-400 shrink-0">
                <KeyRound className="w-5 h-5" />
              </div>
              <div>
                <h3 className="text-base font-semibold text-slate-100">API Key Created Successfully</h3>
                <p className="text-xs text-slate-400 mt-1 leading-relaxed">
                  Make sure to copy your gateway token now. For security purposes, this plaintext secret will never be displayed again.
                </p>
              </div>
            </div>

            {/* Key Metadata Card */}
            <div className="p-3 rounded-lg bg-[#070b12] border border-brand-border/80 text-xs font-mono space-y-1.5 mb-4 text-slate-400">
              <div className="flex items-center gap-2 flex-wrap">
                <span className="text-slate-400">Key:</span>
                <span className="text-slate-200 font-semibold">{createdKey?.name}</span>
                <span className="text-slate-400">•</span>
                <span className="text-slate-400">Scope:</span>
                <span className="text-emerald-400">{createdKey?.scope}</span>
                <span className="text-slate-400">•</span>
                <span className="text-slate-400">Role:</span>
                <span className="text-slate-200">{createdKey?.role}</span>
              </div>
            </div>

            {/* Plaintext Token Field */}
            <div className="mb-4">
              <label className="block text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1.5">
                Plaintext Secret Token
              </label>
              <div className="flex items-center gap-2 bg-[#060a10] border border-emerald-500/40 rounded-lg p-2.5 font-mono text-xs">
                <span className="text-emerald-400 font-semibold truncate flex-1 select-all">
                  {createdKey?.plaintextToken}
                </span>
                <button
                  onClick={handleCopy}
                  className={`flex items-center gap-1.5 px-3 py-1.5 rounded text-xs font-medium transition cursor-pointer ${
                    copied 
                      ? 'bg-emerald-500 text-slate-950 font-bold' 
                      : 'bg-emerald-500/20 text-emerald-400 hover:bg-emerald-500/30 border border-emerald-500/40'
                  }`}
                >
                  {copied ? <Check className="w-3.5 h-3.5" /> : <Copy className="w-3.5 h-3.5" />}
                  <span>{copied ? 'Copied' : 'Copy Key'}</span>
                </button>
              </div>
            </div>

            {/* Zero-Trust Storage Guarantee Box */}
            <div className="flex items-start gap-3 p-3.5 rounded-lg bg-emerald-950/20 border border-emerald-900/40 mb-6">
              <ShieldCheck className="w-4 h-4 text-emerald-400 shrink-0 mt-0.5" />
              <div className="text-xs">
                <div className="font-semibold text-emerald-400">Zero-Trust Storage Guarantee</div>
                <div className="text-slate-400 text-[11px] mt-0.5 leading-relaxed">
                  Urumi Gateway stores cryptographic hashes of tokens. This key is live on Kubernetes and can be revoked dynamically from the console at any time.
                </div>
              </div>
            </div>

            {/* Action Buttons */}
            <div className="flex items-center justify-end pt-2">
              <button
                onClick={handleReset}
                className="px-5 py-2 rounded-lg bg-emerald-500 hover:bg-emerald-600 text-slate-950 font-semibold text-xs shadow-lg shadow-emerald-500/20 transition cursor-pointer"
              >
                Done / I have saved this key
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
