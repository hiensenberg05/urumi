import React, { useState } from 'react';
import { KeyRound, Copy, Check, ShieldCheck, X } from 'lucide-react';

interface ApiKeyModalProps {
  isOpen: boolean;
  onClose: () => void;
  keyDetails?: {
    name: string;
    scope: string;
    role: string;
    plaintextToken: string;
  };
}

export const ApiKeyModal: React.FC<ApiKeyModalProps> = ({
  isOpen,
  onClose,
  keyDetails = {
    name: 'claude-desktop-production',
    scope: 'Production Gateway',
    role: 'Member (Default)',
    plaintextToken: 'urumi_live_9a1b49f82d0e74b3a195e86bc0213f8a'
  }
}) => {
  const [copied, setCopied] = useState(false);

  if (!isOpen) return null;

  const handleCopy = () => {
    navigator.clipboard.writeText(keyDetails.plaintextToken);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm animate-fadeIn">
      <div className="relative w-full max-w-lg bg-[#0d1522] border border-brand-border rounded-xl shadow-2xl p-6 text-slate-100 overflow-hidden">
        {/* Close Button */}
        <button 
          onClick={onClose}
          className="absolute top-4 right-4 p-1.5 rounded-lg text-slate-400 hover:text-slate-200 hover:bg-brand-surface transition"
        >
          <X className="w-4 h-4" />
        </button>

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
          <div className="flex items-center gap-2">
            <span className="text-slate-400">Key:</span>
            <span className="text-slate-200 font-semibold">{keyDetails.name}</span>
            <span className="text-slate-400">•</span>
            <span className="text-slate-400">Scope:</span>
            <span className="text-emerald-400">{keyDetails.scope}</span>
            <span className="text-slate-400">•</span>
            <span className="text-slate-400">Role:</span>
            <span className="text-slate-200">{keyDetails.role}</span>
          </div>
        </div>

        {/* Plaintext Token Field */}
        <div className="mb-4">
          <label className="block text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1.5">
            Plaintext Secret Token
          </label>
          <div className="flex items-center gap-2 bg-[#060a10] border border-emerald-500/40 rounded-lg p-2.5 font-mono text-xs">
            <span className="text-emerald-400 font-semibold truncate flex-1 select-all">
              {keyDetails.plaintextToken}
            </span>
            <button
              onClick={handleCopy}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded text-xs font-medium transition ${
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
              Urumi only retains cryptographic SHA-256 hashes of gateway tokens. If lost, this key cannot be retrieved and must be revoked and regenerated.
            </div>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="flex items-center justify-between pt-2">
          <button 
            type="button"
            className="text-xs text-slate-400 hover:text-slate-200 underline underline-offset-4 transition"
          >
            View Integration Docs
          </button>
          <button
            onClick={onClose}
            className="px-5 py-2 rounded-lg bg-emerald-500 hover:bg-emerald-600 text-slate-950 font-semibold text-xs shadow-lg shadow-emerald-500/20 transition cursor-pointer"
          >
            Done / I have saved this key
          </button>
        </div>
      </div>
    </div>
  );
};
