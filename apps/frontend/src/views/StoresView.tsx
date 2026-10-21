import React, { useState, useEffect } from 'react';
import { 
  Store, 
  Plus, 
  RefreshCw, 
  ExternalLink, 
  Trash2, 
  ShieldCheck, 
  CheckCircle2, 
  AlertCircle, 
  Clock, 
  Layers, 
  Zap,
  Cpu,
  Lock,
  X
} from 'lucide-react';
import { StoreTenant, User } from '../types';

interface StoresViewProps {
  currentUser: User;
  activeApiKey: string;
}

export const StoresView: React.FC<StoresViewProps> = ({ currentUser, activeApiKey }) => {
  const [stores, setStores] = useState<StoreTenant[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [isModalOpen, setIsModalOpen] = useState<boolean>(false);
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false);
  const [deletingId, setDeletingId] = useState<string | null>(null);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  // Modal form state
  const [storeName, setStoreName] = useState<string>('');
  const [storeId, setStoreId] = useState<string>('');
  const [category, setCategory] = useState<string>('Fashion & Apparel');

  const fetchStores = async () => {
    try {
      const res = await fetch('/api/v1/stores', {
        headers: { 'X-API-Key': activeApiKey }
      });
      if (res.ok) {
        const data = await res.json();
        setStores(data);
      }
    } catch (e) {
      console.error('Failed to fetch stores:', e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchStores();
    const interval = setInterval(fetchStores, 3000);
    return () => clearInterval(interval);
  }, [activeApiKey]);

  const handleNameChange = (val: string) => {
    setStoreName(val);
    const slug = val
      .toLowerCase()
      .replace(/[^a-z0-9]/g, '-')
      .replace(/-+/g, '-')
      .replace(/^-|-$/g, '');
    setStoreId(slug);
  };

  const handleCreateStore = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!storeName.trim() || !storeId.trim()) return;

    setIsSubmitting(true);
    setErrorMessage(null);
    try {
      const res = await fetch('/api/v1/stores', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': activeApiKey,
        },
        body: JSON.stringify({
          name: storeName.trim(),
          id: storeId.trim(),
          category,
        }),
      });

      if (!res.ok) {
        const err = await res.json();
        throw new Error(err.detail || 'Failed to provision store');
      }

      setIsModalOpen(false);
      setStoreName('');
      setStoreId('');
      await fetchStores();
    } catch (e: any) {
      setErrorMessage(e.message || 'Error creating store');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDeleteStore = async (id: string) => {
    if (!window.confirm(`Are you sure you want to delete store '${id}' and tear down its Kubernetes namespace, MariaDB database, and MCP tools?`)) {
      return;
    }

    setDeletingId(id);
    try {
      const res = await fetch(`/api/v1/stores/${id}`, {
        method: 'DELETE',
        headers: { 'X-API-Key': activeApiKey }
      });
      if (!res.ok) {
        const err = await res.json();
        alert(err.detail || 'Failed to delete store');
      }
      await fetchStores();
    } catch (e: any) {
      alert(e.message || 'Error deleting store');
    } finally {
      setDeletingId(null);
    }
  };

  const handleRetryStore = async (id: string) => {
    try {
      await fetch(`/api/v1/stores/${id}/retry`, {
        method: 'POST',
        headers: { 'X-API-Key': activeApiKey }
      });
      await fetchStores();
    } catch (e: any) {
      alert('Error retrying provisioning: ' + e.message);
    }
  };

  const activeStoresCount = stores.filter(s => s.status === 'Ready' || s.status === 'Provisioning').length;

  return (
    <div className="space-y-6 animate-fadeIn">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-3">
            <h1 className="text-xl font-bold tracking-tight text-slate-100 flex items-center gap-2">
              <Store className="w-5 h-5 text-emerald-400" />
              Multi-Store Tenants
            </h1>
            <span className="text-[11px] font-mono bg-emerald-950/60 border border-emerald-800/80 text-emerald-400 px-2.5 py-0.5 rounded-full font-medium flex items-center gap-1.5">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
              {activeStoresCount} / 5 Stores Active
            </span>
          </div>
          <p className="text-xs text-slate-400 mt-1 max-w-2xl leading-relaxed">
            Autonomous multi-tenant store provisioning platform. Each store receives its own dedicated Kubernetes namespace, MariaDB database, WordPress instance, NetworkPolicy isolation, and auto-registered WooCommerce MCP tools.
          </p>
        </div>

        <div className="flex items-center gap-2.5">
          <button
            onClick={() => fetchStores()}
            className="p-2 rounded-lg bg-brand-card/90 border border-brand-border text-slate-400 hover:text-slate-200 hover:border-slate-600 transition"
            title="Refresh stores"
          >
            <RefreshCw className="w-4 h-4" />
          </button>
          {currentUser.role === 'ADMIN' && (
            <button
              onClick={() => setIsModalOpen(true)}
              disabled={activeStoresCount >= 5}
              className={`px-3.5 py-2 rounded-lg text-xs font-semibold flex items-center gap-1.5 transition shadow-sm ${
                activeStoresCount >= 5
                  ? 'bg-slate-800 text-slate-500 cursor-not-allowed border border-slate-700'
                  : 'bg-emerald-500 hover:bg-emerald-400 text-slate-950 font-medium'
              }`}
            >
              <Plus className="w-4 h-4 stroke-[2.5]" />
              Provision Store
            </button>
          )}
        </div>
      </div>

      {/* Guardrails & Architecture Summary Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="p-4 rounded-xl bg-brand-card/90 border border-brand-border/70 flex items-start gap-3">
          <div className="w-9 h-9 rounded-lg bg-emerald-500/10 border border-emerald-500/20 flex items-center justify-center text-emerald-400 shrink-0">
            <Lock className="w-4 h-4" />
          </div>
          <div>
            <div className="text-xs font-semibold text-slate-200">NetworkPolicy Isolation</div>
            <div className="text-[11px] text-slate-400 mt-0.5 leading-relaxed">
              Strict pod-to-pod filtering. Stores cannot reach other tenants' MariaDB or WordPress pods.
            </div>
          </div>
        </div>

        <div className="p-4 rounded-xl bg-brand-card/90 border border-brand-border/70 flex items-start gap-3">
          <div className="w-9 h-9 rounded-lg bg-sky-500/10 border border-sky-500/20 flex items-center justify-center text-sky-400 shrink-0">
            <Cpu className="w-4 h-4" />
          </div>
          <div>
            <div className="text-xs font-semibold text-slate-200">ResourceQuota Guardrails</div>
            <div className="text-[11px] text-slate-400 mt-0.5 leading-relaxed">
              Max 2 CPU, 2Gi RAM, 2 PVCs per namespace. Enforces hardware limits and prevents starvation.
            </div>
          </div>
        </div>

        <div className="p-4 rounded-xl bg-brand-card/90 border border-brand-border/70 flex items-start gap-3">
          <div className="w-9 h-9 rounded-lg bg-amber-500/10 border border-amber-500/20 flex items-center justify-center text-amber-400 shrink-0">
            <Zap className="w-4 h-4" />
          </div>
          <div>
            <div className="text-xs font-semibold text-slate-200">Automatic MCP Registration</div>
            <div className="text-[11px] text-slate-400 mt-0.5 leading-relaxed">
              Dynamic discovery mounts namespaced tools (e.g. <code className="text-amber-300 font-mono text-[10px]">store_fashion__list_orders</code>) directly into the AI agent.
            </div>
          </div>
        </div>
      </div>

      {/* Stores Table */}
      <div className="rounded-xl bg-brand-card/90 border border-brand-border/70 overflow-hidden shadow-sm">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse text-xs">
            <thead>
              <tr className="border-b border-brand-border/80 bg-slate-900/60 text-slate-400 font-medium uppercase tracking-wider text-[10px]">
                <th className="py-3 px-4">Store & Category</th>
                <th className="py-3 px-4">Namespace</th>
                <th className="py-3 px-4">Status</th>
                <th className="py-3 px-4">Ingress URL</th>
                <th className="py-3 px-4">MCP Tools</th>
                <th className="py-3 px-4">Created</th>
                <th className="py-3 px-4 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-brand-border/40 text-slate-300">
              {loading ? (
                <tr>
                  <td colSpan={7} className="py-8 text-center text-slate-500">
                    <RefreshCw className="w-5 h-5 animate-spin mx-auto mb-2 text-slate-400" />
                    Loading stores...
                  </td>
                </tr>
              ) : stores.length === 0 ? (
                <tr>
                  <td colSpan={7} className="py-10 text-center">
                    <Store className="w-8 h-8 text-slate-600 mx-auto mb-2" />
                    <div className="text-slate-300 font-medium">No store tenants provisioned</div>
                    <div className="text-[11px] text-slate-500 mt-1">
                      Click "Provision Store" to create an isolated store namespace with dedicated MariaDB and WooCommerce MCP.
                    </div>
                  </td>
                </tr>
              ) : (
                stores.map((store) => (
                  <tr key={store.id} className="hover:bg-slate-800/30 transition">
                    <td className="py-3.5 px-4">
                      <div className="font-semibold text-slate-200">{store.name}</div>
                      <div className="text-[10px] text-emerald-400 font-mono mt-0.5">
                        {store.category || 'General'}
                      </div>
                    </td>
                    <td className="py-3.5 px-4 font-mono text-[11px] text-slate-400">
                      <span className="bg-slate-800 px-1.5 py-0.5 rounded border border-slate-700/60">
                        {store.namespace}
                      </span>
                    </td>
                    <td className="py-3.5 px-4">
                      {store.status === 'Ready' && (
                        <span className="inline-flex items-center gap-1.5 px-2 py-0.5 rounded-full text-[10px] font-medium bg-emerald-950/70 text-emerald-400 border border-emerald-800/60">
                          <CheckCircle2 className="w-3 h-3 text-emerald-400" />
                          Ready
                        </span>
                      )}
                      {store.status === 'Provisioning' && (
                        <span className="inline-flex items-center gap-1.5 px-2 py-0.5 rounded-full text-[10px] font-medium bg-amber-950/70 text-amber-400 border border-amber-800/60">
                          <RefreshCw className="w-3 h-3 animate-spin text-amber-400" />
                          Provisioning...
                        </span>
                      )}
                      {store.status === 'Deleting' && (
                        <span className="inline-flex items-center gap-1.5 px-2 py-0.5 rounded-full text-[10px] font-medium bg-slate-800 text-slate-400 border border-slate-700">
                          <RefreshCw className="w-3 h-3 animate-spin text-slate-400" />
                          Deleting...
                        </span>
                      )}
                      {store.status === 'Failed' && (
                        <span 
                          className="inline-flex items-center gap-1.5 px-2 py-0.5 rounded-full text-[10px] font-medium bg-rose-950/70 text-rose-400 border border-rose-800/60 cursor-pointer"
                          title={store.errorMessage || 'Provisioning failed'}
                        >
                          <AlertCircle className="w-3 h-3 text-rose-400" />
                          Failed
                        </span>
                      )}
                    </td>
                    <td className="py-3.5 px-4 font-mono text-[11px]">
                      <a 
                        href={store.ingressUrl} 
                        target="_blank" 
                        rel="noreferrer"
                        className="text-sky-400 hover:text-sky-300 hover:underline flex items-center gap-1"
                      >
                        {store.ingressUrl.replace('http://', '')}
                        <ExternalLink className="w-3 h-3" />
                      </a>
                    </td>
                    <td className="py-3.5 px-4">
                      <span className="font-mono text-emerald-400 bg-emerald-950/40 border border-emerald-900/50 px-2 py-0.5 rounded text-[11px]">
                        {store.toolsCount} tools registered
                      </span>
                    </td>
                    <td className="py-3.5 px-4 text-slate-400 text-[11px]">
                      {store.createdAt.replace(' UTC', '')}
                    </td>
                    <td className="py-3.5 px-4 text-right">
                      <div className="flex items-center justify-end gap-2">
                        {store.status === 'Failed' && currentUser.role === 'ADMIN' && (
                          <button
                            onClick={() => handleRetryStore(store.id)}
                            className="px-2 py-1 rounded bg-amber-500/10 text-amber-400 border border-amber-500/30 hover:bg-amber-500/20 text-[10px] font-semibold transition"
                          >
                            Retry
                          </button>
                        )}
                        {currentUser.role === 'ADMIN' && (
                          <button
                            onClick={() => handleDeleteStore(store.id)}
                            disabled={deletingId === store.id || store.status === 'Deleting'}
                            className="p-1.5 rounded bg-rose-500/10 text-rose-400 border border-rose-500/30 hover:bg-rose-500/20 transition disabled:opacity-50"
                            title="Delete store namespace"
                          >
                            <Trash2 className="w-3.5 h-3.5" />
                          </button>
                        )}
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Provision Store Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-950/80 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-brand-sidebar border border-brand-border rounded-xl w-full max-w-md shadow-2xl overflow-hidden animate-fadeIn">
            <div className="flex items-center justify-between p-4 border-b border-brand-border/80">
              <div className="flex items-center gap-2">
                <Store className="w-4 h-4 text-emerald-400" />
                <h3 className="font-bold text-sm text-slate-100">Provision New Store Tenant</h3>
              </div>
              <button 
                onClick={() => setIsModalOpen(false)}
                className="text-slate-400 hover:text-slate-200 transition"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <form onSubmit={handleCreateStore} className="p-4 space-y-4">
              {errorMessage && (
                <div className="p-2.5 rounded-lg bg-rose-950/60 border border-rose-800/80 text-rose-300 text-xs flex items-start gap-2">
                  <AlertCircle className="w-4 h-4 shrink-0 mt-0.5 text-rose-400" />
                  <span>{errorMessage}</span>
                </div>
              )}

              <div>
                <label className="block text-xs font-medium text-slate-300 mb-1">Store Display Name</label>
                <input
                  type="text"
                  required
                  placeholder="e.g. Fashion Boutique"
                  value={storeName}
                  onChange={(e) => handleNameChange(e.target.value)}
                  className="w-full bg-slate-900 border border-brand-border rounded-lg px-3 py-2 text-xs text-slate-200 placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition"
                />
              </div>

              <div>
                <label className="block text-xs font-medium text-slate-300 mb-1">
                  Tenant Slug Identifier (Namespace: <span className="font-mono text-emerald-400">store-{storeId || '...'}</span>)
                </label>
                <input
                  type="text"
                  required
                  pattern="[a-z0-9-]+"
                  placeholder="e.g. fashion"
                  value={storeId}
                  onChange={(e) => setStoreId(e.target.value.toLowerCase().replace(/[^a-z0-9-]/g, ''))}
                  className="w-full bg-slate-900 border border-brand-border rounded-lg px-3 py-2 text-xs text-slate-200 font-mono placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition"
                />
                <div className="text-[10px] text-slate-500 mt-1">
                  Ingress Host: <span className="text-slate-400 font-mono">http://{storeId || 'store'}.store.local</span>
                </div>
              </div>

              <div>
                <label className="block text-xs font-medium text-slate-300 mb-1">Catalog Preset</label>
                <select
                  value={category}
                  onChange={(e) => setCategory(e.target.value)}
                  className="w-full bg-slate-900 border border-brand-border rounded-lg px-3 py-2 text-xs text-slate-200 focus:outline-none focus:border-emerald-500 transition"
                >
                  <option value="Fashion & Apparel">Fashion & Apparel</option>
                  <option value="Consumer Electronics">Consumer Electronics</option>
                  <option value="Books & Media">Books & Media</option>
                  <option value="Home & Living">Home & Living</option>
                  <option value="General Merchandise">General Merchandise</option>
                </select>
              </div>

              <div className="p-3 rounded-lg bg-slate-900/80 border border-brand-border/60 text-[11px] text-slate-400 space-y-1.5">
                <div className="text-slate-200 font-semibold flex items-center gap-1.5">
                  <ShieldCheck className="w-3.5 h-3.5 text-emerald-400" />
                  Automatic Tenant Provisioning
                </div>
                <div>• Creates namespace <code className="text-emerald-400">store-{storeId || '...'}</code></div>
                <div>• Deploys dedicated MariaDB + WordPress + WooCommerce MCP</div>
                <div>• Applies NetworkPolicy isolation & ResourceQuotas</div>
                <div>• Registers tools <code className="text-emerald-400">store_{storeId || '...' }__*</code> in AI Agent</div>
              </div>

              <div className="flex items-center justify-end gap-2 pt-2 border-t border-brand-border/80">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="px-3 py-1.5 rounded-lg text-xs font-medium text-slate-400 hover:text-slate-200 hover:bg-slate-800 transition"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={isSubmitting || !storeId.trim()}
                  className="px-4 py-1.5 rounded-lg text-xs font-semibold bg-emerald-500 hover:bg-emerald-400 text-slate-950 transition flex items-center gap-1.5 disabled:opacity-50"
                >
                  {isSubmitting && <RefreshCw className="w-3.5 h-3.5 animate-spin" />}
                  {isSubmitting ? 'Provisioning...' : 'Confirm & Deploy'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
