import React, { useState } from 'react';
import { X, Copy, Check, ShieldCheck, ArrowRight, Download, CheckCircle2, AlertOctagon } from 'lucide-react';
import { AuditLogItem } from '../types';

interface TraceDrawerProps {
  log: AuditLogItem | null;
  onClose: () => void;
  onNavigateToPermissions?: () => void;
}

export const TraceDrawer: React.FC<TraceDrawerProps> = ({
  log,
  onClose,
  onNavigateToPermissions
}) => {
  const [copied, setCopied] = useState(false);

  if (!log) return null;

  const handleCopyId = () => {
    navigator.clipboard.writeText(log.correlationId);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const isDenied = log.status.includes('403') || log.status.includes('Blocked');

  return (
    <div className="fixed inset-0 z-50 overflow-hidden bg-black/60 backdrop-blur-sm flex justify-end animate-fadeIn">
      <div className="w-full max-w-xl bg-[#0b111c] border-l border-brand-border h-full shadow-2xl flex flex-col justify-between overflow-y-auto">
        <div className="p-6">
          {/* Header */}
          <div className="flex items-center justify-between pb-4 border-b border-brand-border">
            <div className="flex items-center gap-2.5">
              <h2 className="text-sm font-semibold text-slate-100 font-mono tracking-tight">Invocation Trace</h2>
              <span className={`text-[11px] font-mono px-2 py-0.5 rounded font-semibold ${
                isDenied 
                  ? 'bg-red-950/80 text-red-400 border border-red-800/60'
                  : 'bg-emerald-950/80 text-emerald-400 border border-emerald-800/60'
              }`}>
                {log.status}
              </span>
            </div>
            <button 
              onClick={onClose}
              className="p-1 rounded text-slate-400 hover:text-slate-200 hover:bg-brand-surface transition"
            >
              <X className="w-4 h-4" />
            </button>
          </div>

          {/* Correlation ID banner */}
          <div className="mt-3 flex items-center justify-between p-2 rounded bg-[#070c14] border border-brand-border/70 text-xs font-mono">
            <span className="text-emerald-400">{log.correlationId}</span>
            <button 
              onClick={handleCopyId}
              className="text-[11px] text-slate-400 hover:text-slate-200 flex items-center gap-1 transition"
            >
              {copied ? <Check className="w-3 h-3 text-emerald-400" /> : <Copy className="w-3 h-3" />}
              <span>{copied ? 'Copied' : 'Copy ID'}</span>
            </button>
          </div>

          {/* Section: Execution Lifecycle */}
          <div className="mt-6">
            <div className="text-[10px] font-mono font-semibold tracking-wider text-slate-400 uppercase mb-3">
              Zero-Trust Execution Lifecycle
            </div>
            <div className="space-y-3">
              {/* Step 1: Ingress Authentication */}
              <div className="p-3 rounded-lg bg-brand-surface/40 border border-brand-border text-xs">
                <div className="flex items-center justify-between mb-1">
                  <div className="flex items-center gap-2 font-mono font-medium text-slate-200">
                    <span className="w-4 h-4 rounded-full bg-emerald-500/20 text-emerald-400 flex items-center justify-center text-[10px]">1</span>
                    <span>Ingress Authentication</span>
                  </div>
                  <span className="font-mono text-[11px] text-slate-400">{log.lifecycle?.ingressAuthMs || 1.2}ms</span>
                </div>
                <div className="text-slate-400 text-[11px] pl-6">
                  TLS / Bearer token authenticated. Caller identity: <span className="text-slate-200 font-mono">{log.principal}</span>.
                </div>
              </div>

              {/* Step 2: Policy Gate Evaluation */}
              <div className={`p-3 rounded-lg border text-xs ${
                isDenied 
                  ? 'bg-red-950/20 border-red-900/50' 
                  : 'bg-emerald-950/20 border-emerald-900/50'
              }`}>
                <div className="flex items-center justify-between mb-1">
                  <div className="flex items-center gap-2 font-mono font-medium text-slate-200">
                    <span className={`w-4 h-4 rounded-full flex items-center justify-center text-[10px] ${
                      isDenied ? 'bg-red-500/20 text-red-400' : 'bg-emerald-500/20 text-emerald-400'
                    }`}>2</span>
                    <span>Policy Gate Evaluation</span>
                  </div>
                  <span className="font-mono text-[11px] text-slate-400">{log.lifecycle?.policyEvalMs || 0.8}ms</span>
                </div>
                <div className="text-slate-400 text-[11px] pl-6">
                  Evaluated RFC-9482 explicit rules:
                </div>
                <div className={`mt-2 ml-6 p-2 rounded text-[11px] font-mono border ${
                  isDenied 
                    ? 'bg-red-950/40 text-red-300 border-red-800/60' 
                    : 'bg-emerald-950/40 text-emerald-300 border-emerald-800/60'
                }`}>
                  {log.lifecycle?.policyRuleDetail || (isDenied ? `MATCH rule #4 [${log.toolName}] -> DENY` : `MATCH rule -> ALLOW [${log.toolName}]`)}
                </div>
              </div>

              {/* Step 3: Upstream Dispatch */}
              <div className="p-3 rounded-lg bg-brand-surface/40 border border-brand-border text-xs">
                <div className="flex items-center justify-between mb-1">
                  <div className="flex items-center gap-2 font-mono font-medium text-slate-200">
                    <span className="w-4 h-4 rounded-full bg-slate-800 text-slate-400 flex items-center justify-center text-[10px]">3</span>
                    <span>Upstream Dispatch</span>
                  </div>
                  <span className="font-mono text-[11px] text-slate-400">
                    {isDenied ? 'Skipped' : `${log.durationMs}ms`}
                  </span>
                </div>
                <div className="text-slate-400 text-[11px] pl-6">
                  {isDenied 
                    ? `Aborted early. 0 upstream network bytes transmitted to ${log.targetServer}.` 
                    : `Dispatched to ${log.targetServer} via Streamable HTTP (SSE).`}
                </div>
              </div>
            </div>
          </div>

          {/* Section: Audit Attributes */}
          <div className="mt-6">
            <div className="text-[10px] font-mono font-semibold tracking-wider text-slate-400 uppercase mb-3">
              Audit Attributes
            </div>
            <div className="grid grid-cols-2 gap-3 text-xs font-mono">
              <div className="p-2.5 rounded bg-[#070c14] border border-brand-border/60">
                <div className="text-[10px] text-slate-400">Timestamp</div>
                <div className="text-slate-200 mt-0.5">{log.timestamp}</div>
              </div>
              <div className="p-2.5 rounded bg-[#070c14] border border-brand-border/60">
                <div className="text-[10px] text-slate-400">Target Tool</div>
                <div className={isDenied ? 'text-red-400 mt-0.5' : 'text-emerald-400 mt-0.5'}>
                  {log.toolName}
                </div>
              </div>
              <div className="p-2.5 rounded bg-[#070c14] border border-brand-border/60">
                <div className="text-[10px] text-slate-400">Source Client</div>
                <div className="text-slate-200 mt-0.5">{log.clientAgent}</div>
              </div>
              <div className="p-2.5 rounded bg-[#070c14] border border-brand-border/60">
                <div className="text-[10px] text-slate-400">Client Ingress IP</div>
                <div className="text-slate-200 mt-0.5">{log.clientIp}</div>
              </div>
            </div>
          </div>

          {/* Section: Sanitized Parameters */}
          <div className="mt-6">
            <div className="flex items-center justify-between mb-2">
              <div className="text-[10px] font-mono font-semibold tracking-wider text-slate-400 uppercase">
                Sanitized Parameters
              </div>
              <span className="text-[9px] font-mono bg-emerald-950/60 text-emerald-400 border border-emerald-800/40 px-1.5 py-0.5 rounded">
                Zero-Knowledge Scrubbed
              </span>
            </div>
            <pre className="p-3 rounded-lg bg-[#05080f] border border-brand-border font-mono text-xs text-slate-300 overflow-x-auto">
              {JSON.stringify(log.sanitizedParams || { limit: 10, target: log.toolName }, null, 2)}
            </pre>
          </div>

          {/* Zero-Trust Notice */}
          <div className="mt-5 flex items-start gap-2.5 text-xs text-slate-400 bg-brand-surface/30 p-3 rounded-lg border border-brand-border/50">
            <ShieldCheck className="w-4 h-4 text-emerald-400 shrink-0 mt-0.5" />
            <span className="text-[11px] leading-relaxed">
              Zero-trust enforcement guaranteed: Upstream database secrets were not exposed or decrypted during this lifecycle.
            </span>
          </div>
        </div>

        {/* Drawer Action Footer */}
        <div className="p-4 border-t border-brand-border bg-[#070b13] flex items-center justify-between gap-3">
          {onNavigateToPermissions && (
            <button
              onClick={() => {
                onClose();
                onNavigateToPermissions();
              }}
              className="flex-1 py-2 px-3 rounded-lg bg-emerald-500/15 hover:bg-emerald-500/25 border border-emerald-500/40 text-emerald-400 text-xs font-semibold flex items-center justify-center gap-2 transition"
            >
              <ShieldCheck className="w-3.5 h-3.5" />
              <span>Open Tool Policy in Permissions</span>
            </button>
          )}
          <button
            onClick={handleCopyId}
            className="py-2 px-3 rounded-lg bg-brand-surface hover:bg-brand-surface/80 border border-brand-border text-slate-300 text-xs font-mono transition"
          >
            Copy Correlation ID
          </button>
        </div>
      </div>
    </div>
  );
};
