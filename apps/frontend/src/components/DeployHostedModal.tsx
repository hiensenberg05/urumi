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
  Terminal,
  Code2,
  Wrench
} from 'lucide-react';
import { HostedMcpServer, HostedTemplate } from '../types';

interface DeployHostedModalProps {
  isOpen: boolean;
  onClose: () => void;
  activeApiKey: string;
  onDeployed: (newServer: HostedMcpServer) => void;
}

const DEFAULT_PYTHON_TEMPLATE = `@mcp.tool(name="custom__discount_calculator")
async def calculate_bulk_discount(price: float, quantity: int) -> dict:
    """Calculate tiered wholesale discount for large customer orders."""
    discount_pct = 20 if quantity >= 50 else (10 if quantity >= 10 else 5)
    discount_amount = round(price * quantity * (discount_pct / 100), 2)
    final_total = round((price * quantity) - discount_amount, 2)
    return {
        "unit_price": price,
        "quantity": quantity,
        "discount_pct": f"{discount_pct}%",
        "savings_usd": discount_amount,
        "final_total": final_total,
        "status": "Discount Applied Successfully"
    }`;

export const DeployHostedModal: React.FC<DeployHostedModalProps> = ({
  isOpen,
  onClose,
  activeApiKey,
  onDeployed
}) => {
  const [templates, setTemplates] = useState<HostedTemplate[]>([]);
  const [selectedTemplateId, setSelectedTemplateId] = useState<string>('notifications');
  const [customMode, setCustomMode] = useState<'code' | 'image'>('code');
  const [name, setName] = useState<string>('Notification Dispatcher');
  const [customImage, setCustomImage] = useState<string>('urumi/hosted-mcp-suite:v1.0.0');
  const [customPort, setCustomPort] = useState<number>(8005);
  const [customCode, setCustomCode] = useState<string>(DEFAULT_PYTHON_TEMPLATE);
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
    setName('Custom Discount MCP');
    setCustomPort(8008);
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

      let payload: any = {
        name: name.trim(),
        template: selectedTemplateId === 'custom' ? (customMode === 'code' ? 'custom_code' : 'custom_image') : selectedTemplateId,
        port: Number(customPort) || 8008,
      };

      if (selectedTemplateId === 'custom') {
        if (customMode === 'code') {
          payload.custom_code = customCode;
          payload.image = 'urumi/hosted-mcp-suite:v1.0.0';
        } else {
          payload.image = customImage.trim() || 'urumi/hosted-mcp-suite:v1.0.0';
        }
      } else {
        const found = templates.find(t => t.id === selectedTemplateId);
        payload.image = customImage.trim() || found?.image || 'urumi/hosted-mcp-suite:v1.0.0';
        payload.env = found?.env || {};
      }

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
  const isCustomSelected = selectedTemplateId === 'custom';

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm animate-fadeIn">
      <div className="relative w-full max-w-3xl bg-[#0c1422] border border-brand-border rounded-xl shadow-2xl p-6 text-slate-100 max-h-[90vh] overflow-y-auto">
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
          {/* Template Selection Grid (4 Cards: 3 Catalog + 1 Custom!) */}
          <div>
            <label className="block text-slate-300 text-xs font-semibold mb-2 flex items-center justify-between">
              <span>Select MCP Server Type</span>
              <span className="text-[10px] font-mono text-slate-500">Choose preset or author custom code</span>
            </label>

            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-2.5">
              {templates.map((tpl) => {
                const isSelected = selectedTemplateId === tpl.id;
                const Icon = tpl.id === 'notifications' ? Bell : (tpl.id === 'currency' ? Coins : Truck);

                return (
                  <div
                    key={tpl.id}
                    onClick={() => handleSelectTemplate(tpl)}
                    className={`p-3 rounded-xl border cursor-pointer transition flex flex-col justify-between ${
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
                      <p className="text-[10px] text-slate-400 mt-1 line-clamp-2 leading-relaxed">
                        {tpl.description}
                      </p>
                    </div>

                    <div className="mt-2.5 pt-2 border-t border-brand-border/60 text-[10px] font-mono text-emerald-400">
                      ✓ {tpl.tools.length} Tools
                    </div>
                  </div>
                );
              })}

              {/* CARD 4: CUSTOM MCP (Author your own!) */}
              <div
                onClick={handleSelectCustom}
                className={`p-3 rounded-xl border cursor-pointer transition flex flex-col justify-between ${
                  isCustomSelected 
                    ? 'bg-emerald-950/30 border-emerald-500/80 text-emerald-300 shadow-sm ring-1 ring-emerald-500/50' 
                    : 'bg-brand-surface/60 border-brand-border hover:border-emerald-500/50 text-slate-300'
                }`}
              >
                <div>
                  <div className="flex items-center justify-between mb-2">
                    <div className={`w-7 h-7 rounded-lg flex items-center justify-center ${
                      isCustomSelected ? 'bg-emerald-500/20 text-emerald-400' : 'bg-brand-card text-slate-400'
                    }`}>
                      <Code2 className="w-4 h-4 text-emerald-400" />
                    </div>
                    <span className="text-[9px] font-mono uppercase bg-emerald-950 text-emerald-400 px-1.5 py-0.5 rounded border border-emerald-800 font-bold">
                      BUILD YOUR OWN
                    </span>
                  </div>
                  <div className="font-semibold text-xs text-slate-100 flex items-center gap-1">
                    <span>Custom MCP Pod</span>
                    <Sparkles className="w-3 h-3 text-emerald-400" />
                  </div>
                  <p className="text-[10px] text-slate-400 mt-1 line-clamp-2 leading-relaxed">
                    Write your own Python FastMCP tool code in the browser or deploy any Docker image.
                  </p>
                </div>

                <div className="mt-2.5 pt-2 border-t border-brand-border/60 text-[10px] font-mono text-emerald-400">
                  ✨ Interactive Studio
                </div>
              </div>
            </div>
          </div>

          {/* CUSTOM BUILDER SECTION (Visible only when Card 4 is clicked!) */}
          {isCustomSelected && (
            <div className="p-4 rounded-xl bg-brand-surface/70 border border-emerald-500/30 space-y-3 animate-fadeIn">
              <div className="flex items-center justify-between pb-2 border-b border-brand-border">
                <div className="flex items-center gap-2">
                  <Wrench className="w-4 h-4 text-emerald-400" />
                  <span className="text-xs font-semibold text-slate-100">Custom MCP Authoring Studio</span>
                </div>

                {/* Mode Selector */}
                <div className="flex items-center gap-1 p-1 bg-brand-card rounded-lg border border-brand-border text-xs">
                  <button
                    type="button"
                    onClick={() => setCustomMode('code')}
                    className={`px-3 py-1 rounded font-mono transition ${
                      customMode === 'code' ? 'bg-emerald-500/20 text-emerald-400 font-semibold' : 'text-slate-400 hover:text-slate-200'
                    }`}
                  >
                    🐍 Python FastMCP Code
                  </button>
                  <button
                    type="button"
                    onClick={() => setCustomMode('image')}
                    className={`px-3 py-1 rounded font-mono transition ${
                      customMode === 'image' ? 'bg-emerald-500/20 text-emerald-400 font-semibold' : 'text-slate-400 hover:text-slate-200'
                    }`}
                  >
                    🐳 Custom Docker Image
                  </button>
                </div>
              </div>

              {customMode === 'code' ? (
                <div>
                  <div className="flex items-center justify-between text-[11px] font-mono text-slate-400 mb-1.5">
                    <span>Python FastMCP Script (mounted directly into Kubernetes Pod via ConfigMap):</span>
                    <span className="text-emerald-400">@mcp.tool decorated</span>
                  </div>
                  <textarea
                    rows={8}
                    value={customCode}
                    onChange={(e) => setCustomCode(e.target.value)}
                    className="w-full bg-[#040810] border border-brand-border rounded-lg p-3 text-xs font-mono text-emerald-400/90 leading-relaxed focus:outline-none focus:border-emerald-500/60 selection:bg-emerald-900"
                    placeholder="Write your custom @mcp.tool function here..."
                  />
                  <p className="text-[10px] text-slate-400 mt-1">
                    Tip: Any function decorated with <code className="text-emerald-400">@mcp.tool</code> will be automatically extracted, registered into the Gateway routing table, and callable by the AI Copilot.
                  </p>
                </div>
              ) : (
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <div>
                    <label className="block text-slate-400 text-[10px] font-mono uppercase font-semibold mb-1">
                      Container Image Tag
                    </label>
                    <input
                      type="text"
                      value={customImage}
                      onChange={(e) => setCustomImage(e.target.value)}
                      placeholder="e.g. my-dockerhub-user/custom-mcp:v1.0"
                      className="w-full bg-[#060a12] border border-brand-border rounded-lg p-2 text-xs font-mono text-slate-200 focus:outline-none focus:border-emerald-500/60"
                    />
                  </div>
                  <div>
                    <label className="block text-slate-400 text-[10px] font-mono uppercase font-semibold mb-1">
                      Container Exposed Port
                    </label>
                    <input
                      type="number"
                      value={customPort}
                      onChange={(e) => setCustomPort(Number(e.target.value))}
                      placeholder="8080"
                      className="w-full bg-[#060a12] border border-brand-border rounded-lg p-2 text-xs font-mono text-slate-200 focus:outline-none focus:border-emerald-500/60"
                    />
                  </div>
                </div>
              )}
            </div>
          )}

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
                placeholder="e.g. My Custom MCP"
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

          {/* Tool Schemas Preview for Standard Templates */}
          {currentTemplate && !isCustomSelected && (
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
              <span>{isSubmitting ? 'Deploying Pod...' : (isCustomSelected ? 'Deploy Custom MCP Pod' : 'Deploy to Kubernetes')}</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
