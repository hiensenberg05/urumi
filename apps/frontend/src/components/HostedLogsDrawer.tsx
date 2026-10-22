import React, { useState, useEffect } from 'react';
import { 
  X, 
  Terminal, 
  RefreshCw, 
  Copy, 
  Check, 
  Server, 
  Cpu, 
  ExternalLink 
} from 'lucide-react';
import { HostedMcpServer } from '../types';

interface HostedLogsDrawerProps {
  server: HostedMcpServer | null;
  onClose: () => void;
  activeApiKey: string;
}

export const HostedLogsDrawer: React.FC<HostedLogsDrawerProps> = ({
  server,
  onClose,
  activeApiKey
}) => {
  const [logs, setLogs] = useState<string>('');
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [copied, setCopied] = useState<boolean>(false);

  const fetchLogs = async () => {
    if (!server) return;
    try {
      setIsLoading(true);
      const res = await fetch(`/api/v1/hosted-servers/${server.id}/logs?tail=150`, {
        headers: { 'X-API-Key': activeApiKey }
      });
      if (res.ok) {
        const data = await res.json();
        setLogs(data.logs || '--- No logs output yet ---');
      } else {
        setLogs(`Error fetching logs (HTTP ${res.status})`);
      }
    } catch (e: any) {
      setLogs(`Connection error: ${e.message}`);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    if (server) {
      fetchLogs();
      const interval = setInterval(fetchLogs, 4000);
      return () => clearInterval(interval);
    }
  }, [server]);

  if (!server) return null;

  const handleCopy = () => {
    navigator.clipboard.writeText(logs);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="fixed inset-0 z-50 flex justify-end bg-black/60 backdrop-blur-sm animate-fadeIn">
      <div className="w-full max-w-2xl bg-[#090d16] border-l border-brand-border h-full flex flex-col shadow-2xl text-slate-100 animate-slideLeft">
        {/* Header */}
        <div className="p-4 border-b border-brand-border flex items-center justify-between bg-brand-surface/80">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 rounded-lg bg-emerald-500/15 border border-emerald-500/30 flex items-center justify-center text-emerald-400">
              <Terminal className="w-4 h-4" />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h3 className="font-semibold text-sm text-slate-100">{server.name}</h3>
                <span className="text-[10px] font-mono bg-emerald-950/70 border border-emerald-800/80 text-emerald-400 px-1.5 py-0.2 rounded">
                  POD LOGS
                </span>
              </div>
              <p className="text-[11px] font-mono text-slate-400 mt-0.5">
                Target: hosted-mcp-{server.id} (default namespace)
              </p>
            </div>
          </div>

          <div className="flex items-center gap-2">
            <button
              onClick={fetchLogs}
              disabled={isLoading}
              className="p-1.5 rounded-lg bg-brand-card hover:bg-brand-surface border border-brand-border text-slate-400 hover:text-slate-200 transition"
              title="Refresh logs"
            >
              <RefreshCw className={`w-3.5 h-3.5 ${isLoading ? 'animate-spin text-emerald-400' : ''}`} />
            </button>
            <button
              onClick={handleCopy}
              className="flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg bg-brand-card hover:bg-brand-surface border border-brand-border text-xs text-slate-300 transition"
            >
              {copied ? <Check className="w-3.5 h-3.5 text-emerald-400" /> : <Copy className="w-3.5 h-3.5" />}
              <span>{copied ? 'Copied' : 'Copy'}</span>
            </button>
            <button
              onClick={onClose}
              className="p-1.5 rounded-lg text-slate-400 hover:text-slate-200 hover:bg-brand-surface transition"
            >
              <X className="w-4 h-4" />
            </button>
          </div>
        </div>

        {/* Terminal Log Screen */}
        <div className="flex-1 p-4 overflow-y-auto font-mono text-xs bg-black/90 text-emerald-400 leading-relaxed selection:bg-emerald-900">
          <pre className="whitespace-pre-wrap">{logs}</pre>
        </div>

        {/* Footer info bar */}
        <div className="p-3 border-t border-brand-border bg-brand-surface/60 flex items-center justify-between text-xs font-mono text-slate-400">
          <span>Endpoint: {server.endpointUrl}</span>
          <span className="text-emerald-400">Status: {server.status}</span>
        </div>
      </div>
    </div>
  );
};
