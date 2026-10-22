import React, { useState, useEffect } from 'react';
import { 
  X, 
  Server, 
  Cpu, 
  Boxes, 
  Bell, 
  Coins, 
  Truck, 
  Sparkles, 
  ShieldAlert, 
  Check, 
  Layers,
  ArrowRight,
  Terminal
} from 'lucide-react';
import { HostedMcpServer, HostedTemplate } from '../types';

interface DeployHostedModalProps {
  isOpen: boolean;
  onClose: () => void;
  activeApiKey: string;
  onDeployed: (newServer: HostedMcpServer) => void;
}

export const DeployHostedModal: React.FC<DeployHostedModalProps> = ({
  isOpen,
  onClose,
  activeApiKey,
  onDeployed
}) => {
  const [templates, setTemplates] = useState<HostedTemplate[]>([]);
  const [selectedTemplateId, setSelectedTemplateId] = useState<string>('notifications');
  const [name, setName] = useState<string>('Notification Dispatcher');
  const [customImage, setCustomImage] = useState<string>('urumi/hosted-mcp-suite:v1.0.0');
  const [customPort, setCustomPort] = useState<number>(8005);
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false);
  const [error, setError] = useState<string | null>(null);

  // Fetch templates from Gateway
  useEffect(() => {
    if (!isOpen) return;
    fetch('/api/v1/hosted-servers/templates', {
      headers: { 'X-API-Key': activeApiKey }
    })
      .then(res => res.json())
      .then(data => {
        if (Array.isArray(data)) setTemplates(data);
      })
      .catch(() => {});
  }, [isOpen, activeApiKey]);

  if (!isOpen) return null;

  const handleSelectTemplate = (tpl: HostedTemplate) => {
    setSelectedTemplateId(tpl.id);
    setName(tpl.name);
    setCustomImage(tpl.image);
    setCustomPort(tpl.port);
  };

  const handleSelectCustom = () => {
    setSelectedTemplateId('custom');
    setName('Custom FastMCP Pod');
    setCustomImage('my-repo/mcp-tool:v1.0.0');
    setCustomPort(8080);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) {
      setError('Please provide a server name.');
      return;
    }

    try {
      setIsSubmitting(true);
      setError(null);

      const payload = {
        name: name.trim(),
        template: selectedTemplateId,
        image: customImage.trim(),
        port: Number(customPort),
        env: selectedTemplateId === 'custom' ? {} : (templates.find(t => t.id === selectedTemplateId)?.env || {})
      };

      const res = await fetch('/api/v1/hosted-servers', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': activeApiKey
        },
        body: JSON.stringify(payload)
      });

      if (!res.ok) {
        const errData = await res.json().catch(() => ({ detail: 'Deployment failed.' }));
        throw new Error(errData.detail || `Server returned HTTP ${res.status}`);
      }

      const newServer: HostedMcpServer = await res.json();
      onDeployed(newServer);
      onClose();
    } catch (err: any) {
      setError(err.message || 'Error deploying hosted MCP pod.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const currentTemplate = templates.find(t => t.id === selectedTemplateId);

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm animate-fadeIn">
      <div className="relative w-full max-w-2xl bg-[#0c1422] border border-brand-border rounded-xl shadow-2xl p-6 text-slate-100 overflow-hidden">
        {/* Close Button */}
        <button 
          onClick={onClose}
          className="absolute top-4 right-4 p-1.5 rounded-lg text-slate-400 hover:text-slate-200 hover:bg-brand-surface transition"
        >
          <X className="w-4 h-4" />
        </button>

        {/* Modal Header */}
        <div className="flex items-center gap-3 mb-5">
          <div className="w-10 h-10 rounded-lg bg-emerald-500/15 border border-emerald-500/30 flex items-center justify-center text-emerald-400 shadow-sm">
            <Boxes className="w-5 h-5" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h3 className="text-base font-bold text-slate-100">Deploy Hosted MCP Pod</h3>
              <span className="text-[10px] font-mono bg-emerald-950/80 text-emerald-400 border border-emerald-800/80 px-2 py-0.5 rounded font-semibold">
                KUBERNETES-NATIVE
              </span>
            </div>
            <p className="text-xs text-slate-400 mt-0.5">
              Launch on-demand containerized MCP servers directly inside the cluster with automatic gateway registration.
            </p>
          </div>
        </div>

        {error && (
          <div className="mb-4 p-3 rounded-lg bg-rose-950/40 border border-rose-800/60 text-xs font-mono text-rose-300 flex items-center gap-2">
            <ShieldAlert className="w-4 h-4 shrink-0 text-rose-400" />
            <span>{error}</span>
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-4">
          {/* Template Selection Cards */}
          <div>
            <label className="block text-slate-300 text-xs font-semibold mb-2 flex items-center justify-between">
              <span>Select MCP Server Template</span>
              <span className="text-[10px] font-mono text-slate-500">FastMCP Python 3.12</span>
            </label>

            <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
              {templates.map((tpl) => {
                const isSelected = selectedTemplateId === tpl.id;
                const Icon = tpl.id === 'notifications' ? Bell : (tpl.id === 'currency' ? Coins : Truck);

                return (
                  <div
                    key={tpl.id}
                    onClick={() => handleSelectTemplate(tpl)}
                    className={`p-3.5 rounded-xl border cursor-pointer transition flex flex-col justify-between ${
                      isSelected 
                        ? 'bg-emerald-950/30 border-emerald-500/60 text-emerald-300 shadow-sm' 
                        : 'bg-brand-surface/60 border-brand-border hover:border-slate-700 text-slate-300'
                    }`}
                  >
                    <div>
                      <div className="flex items-center justify-between mb-2">
                        <div className={`w-7 h-7 rounded-lg flex items-center justify-center ${
                          isSelected ? 'bg-emerald-500/20 text-emerald-400' : 'bg-brand-card text-slate-400'
                        }`}>
                          <Icon className="w-4 h-4" />
                        </div>
                        <span className="text-[9px] font-mono uppercase bg-brand-card px-1.5 py-0.5 rounded border border-brand-border text-slate-400">
                          {tpl.tag}
                        </span>
                      </div>
                      <div className="font-semibold text-xs text-slate-100">{tpl.name}</div>
                      <p className="text-[11px] text-slate-400 mt-1 line-clamp-2 leading-relaxed">
                        {tpl.description}
                      </p>
                    </div>

                    <div className="mt-3 pt-2 border-t border-brand-border/60 text-[10px] font-mono text-emerald-400">
                      ✓ {tpl.tools.length} Tools Included
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Server Name & Config */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-slate-400 text-[11px] font-mono uppercase font-semibold mb-1">
                Server Display Name
              </label>
              <input
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="e.g. Notification Dispatcher"
                className="w-full bg-[#060a12] border border-brand-border rounded-lg p-2.5 text-xs font-mono text-slate-200 focus:outline-none focus:border-emerald-500/60"
              />
            </div>

            <div>
              <label className="block text-slate-400 text-[11px] font-mono uppercase font-semibold mb-1">
                Cluster Container Port
              </label>
              <input
                type="number"
                value={customPort}
                onChange={(e) => setCustomPort(Number(e.target.value))}
                placeholder="8005"
                className="w-full bg-[#060a12] border border-brand-border rounded-lg p-2.5 text-xs font-mono text-slate-200 focus:outline-none focus:border-emerald-500/60"
              />
            </div>
          </div>

          {/* Tool Schemas Preview */}
          {currentTemplate && (
            <div className="p-3 rounded-lg bg-[#060a12] border border-brand-border">
              <div className="text-[11px] font-mono text-slate-400 mb-1.5 flex items-center justify-between">
                <span>Tools to be registered in Gateway:</span>
                <span className="text-emerald-400">{currentTemplate.tools.length} tools</span>
              </div>
              <div className="space-y-1">
                {currentTemplate.tools.map(t => (
                  <div key={t.name} className="flex items-center gap-2 text-[11px] font-mono text-slate-300">
                    <span className="text-emerald-400">⚡</span>
                    <span className="font-semibold text-slate-200">{t.name}</span>
                    <span className="text-slate-500 text-[10px] truncate max-w-sm">({t.description})</span>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Action Buttons */}
          <div className="flex items-center justify-end gap-3 pt-3 border-t border-brand-border">
            <button
              type="button"
              onClick={onClose}
              disabled={isSubmitting}
              className="px-4 py-2 rounded-lg bg-brand-surface hover:bg-brand-card text-xs text-slate-400 transition"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={isSubmitting}
              className="flex items-center gap-2 px-5 py-2 rounded-lg bg-emerald-500 hover:bg-emerald-600 text-slate-950 font-semibold text-xs shadow-lg shadow-emerald-500/20 transition cursor-pointer"
            >
              <Sparkles className="w-3.5 h-3.5" />
              <span>{isSubmitting ? 'Deploying Pod...' : 'Deploy to Kubernetes'}</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
