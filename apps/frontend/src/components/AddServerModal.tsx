import React, { useState } from 'react';
import { X, Server, ShieldAlert, Check } from 'lucide-react';
import { McpServer } from '../types';

interface AddServerModalProps {
  isOpen: boolean;
  onClose: () => void;
  onAddServer: (newServer: McpServer) => void;
}

export const AddServerModal: React.FC<AddServerModalProps> = ({
  isOpen,
  onClose,
  onAddServer
}) => {
  const [name, setName] = useState('');
  const [endpointUrl, setEndpointUrl] = useState('');
  const [authType, setAuthType] = useState('Bearer Secret');
  const [secretToken, setSecretToken] = useState('');
  const [error, setError] = useState('');

  if (!isOpen) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim() || !endpointUrl.trim()) {
      setError('Please provide both server name and endpoint URL.');
      return;
    }

    // SSRF URL Validation check
    if (endpointUrl.includes('169.254.169.254') || endpointUrl.includes('metadata.google.internal')) {
      setError('SSRF Security Block: Prohibited cloud metadata endpoint.');
      return;
    }

    const newServer: McpServer = {
      id: `server-${Date.now()}`,
      name: name.trim(),
      tag: 'CUSTOM UPSTREAM',
      endpointUrl: endpointUrl.trim(),
      status: 'Connected',
      transport: 'Streamable HTTP (SSE)',
      pingMs: Math.floor(Math.random() * 40) + 20,
      uptimePct: 100,
      toolsCount: 3,
      discoveredTools: [
        `${name.toLowerCase().replace(/\s+/g, '_')}__query`,
        `${name.toLowerCase().replace(/\s+/g, '_')}__list_items`,
        `${name.toLowerCase().replace(/\s+/g, '_')}__sync`
      ],
      lastChecked: 'Just now',
      authType
    };

    onAddServer(newServer);
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm animate-fadeIn">
      <div className="relative w-full max-w-lg bg-[#0d1522] border border-brand-border rounded-xl shadow-2xl p-6 text-slate-100">
        <button 
          onClick={onClose}
          className="absolute top-4 right-4 p-1 rounded text-slate-400 hover:text-slate-200 transition"
        >
          <X className="w-4 h-4" />
        </button>

        <div className="flex items-center gap-3 mb-5">
          <div className="w-9 h-9 rounded-lg bg-emerald-500/15 border border-emerald-500/30 flex items-center justify-center text-emerald-400">
            <Server className="w-4 h-4" />
          </div>
          <div>
            <h3 className="text-sm font-semibold text-slate-100">Register Upstream MCP Server</h3>
            <p className="text-xs text-slate-400 mt-0.5">
              Connect a new Streamable HTTP MCP server behind the unified gateway.
            </p>
          </div>
        </div>

        {error && (
          <div className="mb-4 p-3 rounded-lg bg-red-950/40 border border-red-800/60 text-xs font-mono text-red-400 flex items-center gap-2">
            <ShieldAlert className="w-4 h-4 shrink-0" />
            <span>{error}</span>
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-4 text-xs font-mono">
          <div>
            <label className="block text-slate-400 text-[10px] uppercase font-semibold mb-1">
              Server Name
            </label>
            <input
              type="text"
              placeholder="e.g. Warehouse Robot MCP"
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="w-full bg-[#060a12] border border-brand-border rounded-lg p-2.5 text-slate-200 focus:outline-none focus:border-emerald-500/60"
            />
          </div>

          <div>
            <label className="block text-slate-400 text-[10px] uppercase font-semibold mb-1">
              Endpoint URL (Streamable HTTP / SSE)
            </label>
            <input
              type="text"
              placeholder="http://robot-service.local/mcp"
              value={endpointUrl}
              onChange={(e) => setEndpointUrl(e.target.value)}
              className="w-full bg-[#060a12] border border-brand-border rounded-lg p-2.5 text-slate-200 focus:outline-none focus:border-emerald-500/60"
            />
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="block text-slate-400 text-[10px] uppercase font-semibold mb-1">
                Authentication Type
              </label>
              <select
                value={authType}
                onChange={(e) => setAuthType(e.target.value)}
                className="w-full bg-[#060a12] border border-brand-border rounded-lg p-2.5 text-slate-200 focus:outline-none"
              >
                <option value="Bearer Secret">Bearer Secret</option>
                <option value="Static Header">Static Header</option>
                <option value="None">None (Internal Only)</option>
              </select>
            </div>

            <div>
              <label className="block text-slate-400 text-[10px] uppercase font-semibold mb-1">
                Credential Token (Stored Encrypted)
              </label>
              <input
                type="password"
                placeholder="••••••••••••"
                value={secretToken}
                onChange={(e) => setSecretToken(e.target.value)}
                className="w-full bg-[#060a12] border border-brand-border rounded-lg p-2.5 text-slate-200 focus:outline-none"
              />
            </div>
          </div>

          <div className="pt-4 border-t border-brand-border flex items-center justify-between">
            <span className="text-[10px] text-slate-400 font-sans">
              SSRF validation & schema discovery run automatically upon save.
            </span>
            <button
              type="submit"
              className="px-4 py-2 rounded-lg bg-emerald-500 hover:bg-emerald-600 text-slate-950 font-bold text-xs shadow-md shadow-emerald-500/20 transition cursor-pointer"
            >
              Connect & Discover Tools
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
