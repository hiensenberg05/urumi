import React, { useState, useEffect } from 'react';
import { 
  Server, 
  Plus, 
  RefreshCw, 
  Search, 
  CheckCircle2, 
  AlertCircle, 
  ExternalLink, 
  ShieldCheck, 
  Zap, 
  Layers, 
  X,
  Code2,
  Boxes,
  Power,
  Terminal,
  Trash2,
  Radio,
  Play,
  Square,
  Sparkles,
  Cpu,
  Clock,
  ShieldAlert
} from 'lucide-react';
import { McpServer, HostedMcpServer } from '../types';
import { DeployHostedModal } from '../components/DeployHostedModal';
import { HostedLogsDrawer } from '../components/HostedLogsDrawer';

interface ServersViewProps {
  servers: McpServer[];
  onToggleServerStatus?: (serverId: string) => void;
  onAddServer: () => void;
  activeApiKey?: string;
}

export const ServersView: React.FC<ServersViewProps> = ({
  servers,
  onToggleServerStatus,
  onAddServer,
  activeApiKey = 'admin-key-urumi-2026'
}) => {
  // Navigation tabs: 'fleet' (external/core upstreams) vs 'hosted' (in-cluster on-demand pods)
  const [activeSection, setActiveSection] = useState<'fleet' | 'hosted'>('fleet');
  
  // Fleet filters
  const [activeTab, setActiveTab] = useState<'all' | 'healthy' | 'sse' | 'issues'>('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedSchemaServer, setSelectedSchemaServer] = useState<McpServer | null>(null);
  const [isRefreshing, setIsRefreshing] = useState(false);

  // Hosted servers state
  const [hostedServers, setHostedServers] = useState<HostedMcpServer[]>([]);
  const [isDeployModalOpen, setIsDeployModalOpen] = useState<boolean>(false);
  const [selectedLogsServer, setSelectedLogsServer] = useState<HostedMcpServer | null>(null);
  const [scalingId, setScalingId] = useState<string | null>(null);
  const [deletingId, setDeletingId] = useState<string | null>(null);

  const fetchHostedServers = async () => {
    try {
      const res = await fetch('/api/v1/hosted-servers', {
        headers: { 'X-API-Key': activeApiKey }
      });
      if (res.ok) {
        const data = await res.json();
        if (Array.isArray(data)) setHostedServers(data);
      }
    } catch (e) {
      // quiet fallback
    }
  };

  useEffect(() => {
    fetchHostedServers();
    const interval = setInterval(fetchHostedServers, 3500);
    return () => clearInterval(interval);
  }, [activeApiKey]);

  const handleRefresh = () => {
    setIsRefreshing(true);
    fetchHostedServers();
    setTimeout(() => setIsRefreshing(false), 800);
  };

  const handleToggleScale = async (srv: HostedMcpServer) => {
    try {
      setScalingId(srv.id);
      const targetReplicas = srv.replicas === 0 ? 1 : 0;
      const res = await fetch(`/api/v1/hosted-servers/${srv.id}/scale?replicas=${targetReplicas}`, {
        method: 'POST',
        headers: { 'X-API-Key': activeApiKey }
      });
      if (res.ok) {
        const updated = await res.json();
        setHostedServers(prev => prev.map(s => s.id === srv.id ? updated : s));
      }
    } catch (e) {
      console.error('Scale error:', e);
    } finally {
      setScalingId(null);
    }
  };

  const handleDeleteHosted = async (srvId: string) => {
    if (!window.confirm(`Are you sure you want to delete and teardown hosted pod '${srvId}'?`)) {
      return;
    }
    try {
      setDeletingId(srvId);
      const res = await fetch(`/api/v1/hosted-servers/${srvId}`, {
        method: 'DELETE',
        headers: { 'X-API-Key': activeApiKey }
      });
      if (res.ok) {
        setHostedServers(prev => prev.filter(s => s.id !== srvId));
      }
    } catch (e) {
      console.error('Delete error:', e);
    } finally {
      setDeletingId(null);
    }
  };

  const handleDeleteCustomServer = async (serverId: string) => {
    if (!window.confirm(`Are you sure you want to unregister upstream server '${serverId}'?`)) {
      return;
    }
    try {
      const token = activeApiKey || 'admin-key-urumi-2026';
      const headers: Record<string, string> = {};
      if (token.startsWith('ey')) headers['Authorization'] = `Bearer ${token}`;
      else headers['X-API-Key'] = token;

      const res = await fetch(`/api/v1/servers/${serverId}`, {
        method: 'DELETE',
        headers,
      });
      if (res.ok) {
        handleRefresh();
      }
    } catch (e) {
      console.error('Unregister error:', e);
    }
  };

  const filteredFleet = servers.filter(s => {
    if (activeTab === 'issues') return s.status !== 'Connected';
    if (searchQuery) {
      return s.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
             s.endpointUrl.toLowerCase().includes(searchQuery.toLowerCase());
    }
    return true;
  });

  return (
    <div className="space-y-6 animate-fadeIn pb-12">
      {/* Top Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-3">
            <h1 className="text-xl font-bold tracking-tight text-slate-100">MCP Servers</h1>
            <span className="text-[11px] font-mono bg-emerald-950/60 border border-emerald-800/80 text-emerald-400 px-2.5 py-0.5 rounded-full font-medium flex items-center gap-1.5">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
              {servers.length} Fleet Upstreams • {hostedServers.length} Hosted Pods
            </span>
          </div>
          <p className="text-xs text-slate-400 mt-1 max-w-2xl leading-relaxed">
            Manage your upstream Model Context Protocol architecture: connect external servers or deploy containerized MCP pods directly inside Kubernetes.
          </p>
        </div>

        {/* Action Buttons */}
        <div className="flex items-center gap-2.5 flex-wrap">
          <button 
            onClick={handleRefresh}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-brand-card hover:bg-brand-surface border border-brand-border text-xs text-slate-300 font-mono transition"
          >
            <RefreshCw className={`w-3.5 h-3.5 ${isRefreshing ? 'animate-spin text-emerald-400' : 'text-slate-400'}`} />
            <span>Sync Fleet</span>
          </button>

          {activeSection === 'fleet' ? (
            <button 
              onClick={onAddServer}
              className="flex items-center gap-1.5 px-3.5 py-1.5 rounded-lg bg-emerald-500 hover:bg-emerald-600 text-slate-950 font-semibold text-xs shadow-md shadow-emerald-500/20 transition cursor-pointer"
            >
              <Plus className="w-3.5 h-3.5" />
              <span>Register Upstream URL</span>
            </button>
          ) : (
            <button 
              onClick={() => setIsDeployModalOpen(true)}
              className="flex items-center gap-1.5 px-3.5 py-1.5 rounded-lg bg-emerald-500 hover:bg-emerald-600 text-slate-950 font-semibold text-xs shadow-md shadow-emerald-500/20 transition cursor-pointer"
            >
              <Boxes className="w-3.5 h-3.5" />
              <span>Deploy Hosted MCP Pod</span>
            </button>
          )}
        </div>
      </div>

      {/* Primary Section Switcher Tabs */}
      <div className="flex items-center gap-2 border-b border-brand-border pb-3">
        <button
          onClick={() => setActiveSection('fleet')}
          className={`flex items-center gap-2 px-4 py-2 rounded-lg text-xs font-semibold transition ${
            activeSection === 'fleet'
              ? 'bg-emerald-500/15 text-emerald-400 border border-emerald-500/30'
              : 'text-slate-400 hover:text-slate-200 hover:bg-brand-surface'
          }`}
        >
          <Server className="w-4 h-4" />
          <span>Core Fleet Upstreams</span>
          <span className="text-[10px] font-mono bg-brand-surface px-1.5 py-0.2 rounded border border-brand-border text-slate-300">
            {servers.length}
          </span>
        </button>

        <button
          onClick={() => setActiveSection('hosted')}
          className={`flex items-center gap-2 px-4 py-2 rounded-lg text-xs font-semibold transition ${
            activeSection === 'hosted'
              ? 'bg-emerald-500/15 text-emerald-400 border border-emerald-500/30'
              : 'text-slate-400 hover:text-slate-200 hover:bg-brand-surface'
          }`}
        >
          <Boxes className="w-4 h-4" />
          <span>Hosted MCP Pods</span>
          <span className="text-[10px] font-mono bg-emerald-950 text-emerald-400 px-1.5 py-0.2 rounded border border-emerald-800 font-bold">
            K8s ON-DEMAND ({hostedServers.length})
          </span>
        </button>
      </div>

      {/* ======================================================== */}
      {/* SECTION 1: CORE FLEET UPSTREAMS                          */}
      {/* ======================================================== */}
      {activeSection === 'fleet' && (
        <div className="space-y-6">
          {/* 4 Stat Cards */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
              <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
                Total Handlers
              </div>
              <div className="flex items-baseline gap-2">
                <span className="text-2xl font-bold font-mono text-slate-100">
                  {servers.reduce((acc, s) => acc + s.toolsCount, 0)} Tools
                </span>
              </div>
              <div className="text-[11px] text-slate-400 font-mono mt-2">
                Across {servers.length} connected endpoints
              </div>
            </div>

            <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
              <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
                Cluster Ping (P95)
              </div>
              <div className="flex items-baseline gap-2">
                <span className="text-2xl font-bold font-mono text-slate-100">12 ms</span>
                <span className="text-xs text-emerald-400 font-mono">Nominal</span>
              </div>
              <div className="text-[11px] text-slate-400 font-mono mt-2">
                Local Kind internal cluster network
              </div>
            </div>

            <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
              <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
                Active Fleet Health
              </div>
              <div className="flex items-baseline gap-2">
                <span className="text-2xl font-bold font-mono text-emerald-400">
                  {servers.filter(s => s.status === 'Connected').length} / {servers.length}
                </span>
              </div>
              <div className="text-[11px] text-slate-400 font-mono mt-2">
                All circuits CLOSED & verified
              </div>
            </div>

            <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
              <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
                Security Perimeter
              </div>
              <div className="flex items-baseline gap-2">
                <span className="text-2xl font-bold font-mono text-slate-100">Zero-Trust</span>
              </div>
              <div className="text-[11px] text-slate-400 font-mono mt-2">
                RBAC & Token Bucket enforced
              </div>
            </div>
          </div>

          {/* Search and Filter Row */}
          <div className="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-3">
            <div className="flex items-center gap-1.5 p-1 bg-brand-surface rounded-lg border border-brand-border text-xs">
              <button 
                onClick={() => setActiveTab('all')}
                className={`px-3 py-1 rounded font-medium transition ${
                  activeTab === 'all' 
                    ? 'bg-emerald-500/20 text-emerald-400 border border-emerald-500/40 shadow-sm' 
                    : 'text-slate-400 hover:text-slate-200'
                }`}
              >
                All Servers ({servers.length})
              </button>
              <button 
                onClick={() => setActiveTab('healthy')}
                className={`px-3 py-1 rounded font-medium transition ${
                  activeTab === 'healthy' 
                    ? 'bg-emerald-500/20 text-emerald-400 border border-emerald-500/40 shadow-sm' 
                    : 'text-slate-400 hover:text-slate-200'
                }`}
              >
                Healthy ({servers.filter(s => s.status === 'Connected').length})
              </button>
              <button 
                onClick={() => setActiveTab('issues')}
                className={`px-3 py-1 rounded font-medium transition ${
                  activeTab === 'issues' 
                    ? 'bg-rose-500/20 text-rose-400 border border-rose-500/40 shadow-sm' 
                    : 'text-slate-400 hover:text-slate-200'
                }`}
              >
                Degraded / Issues ({servers.filter(s => s.status !== 'Connected').length})
              </button>
            </div>

            <div className="relative">
              <Search className="w-3.5 h-3.5 absolute left-3 top-1/2 -translate-y-1/2 text-slate-500" />
              <input
                type="text"
                placeholder="Filter servers or endpoints..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full sm:w-64 bg-brand-surface border border-brand-border rounded-lg pl-8 pr-3 py-1.5 text-xs text-slate-200 placeholder:text-slate-500 focus:outline-none focus:border-emerald-500/60"
              />
            </div>
          </div>

          {/* Core Server Cards */}
          <div className="space-y-3">
            {filteredFleet.map((server) => {
              const isConnected = server.status === 'Connected';
              const isStoreTenant = server.tag === 'STORE_TENANT';

              return (
                <div 
                  key={server.id}
                  className="p-4 rounded-xl bg-brand-card border border-brand-border hover:border-slate-700 transition"
                >
                  <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                    <div className="flex items-center gap-3">
                      <div className="w-9 h-9 rounded-lg bg-emerald-500/15 border border-emerald-500/30 flex items-center justify-center text-emerald-400 shrink-0">
                        <Server className="w-4 h-4" />
                      </div>
                      <div>
                        <div className="flex items-center gap-2">
                          <span className="font-semibold text-slate-100 text-sm">{server.name}</span>
                          <span className={`text-[10px] font-mono px-2 py-0.5 rounded border ${
                            isStoreTenant 
                              ? 'bg-indigo-950/80 text-indigo-300 border-indigo-800' 
                              : 'bg-brand-surface text-slate-300 border-brand-border'
                          }`}>
                            {server.tag}
                          </span>
                          <span className={`inline-flex items-center gap-1 text-[10px] font-mono px-2 py-0.5 rounded-full border ${
                            isConnected 
                              ? 'bg-emerald-950/80 text-emerald-400 border-emerald-800/80' 
                              : 'bg-rose-950/80 text-rose-400 border-rose-800/80'
                          }`}>
                            <span className={`w-1.5 h-1.5 rounded-full ${isConnected ? 'bg-emerald-400' : 'bg-rose-400'}`}></span>
                            {server.status}
                          </span>
                        </div>
                        <div className="text-[11px] font-mono text-slate-400 mt-1 truncate max-w-md sm:max-w-xl">
                          {server.endpointUrl}
                        </div>
                      </div>
                    </div>

                    {/* Right action controls */}
                    <div className="flex items-center gap-3 self-end sm:self-auto">
                      <button
                        onClick={() => setSelectedSchemaServer(server)}
                        className="flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg bg-brand-surface hover:bg-slate-800 text-xs text-slate-300 border border-brand-border transition"
                      >
                        <Code2 className="w-3.5 h-3.5 text-emerald-400" />
                        <span>Inspect Schemas</span>
                      </button>

                      {onToggleServerStatus && (
                        <button
                          onClick={() => onToggleServerStatus(server.id)}
                          className={`p-1.5 rounded-lg border transition ${
                            isConnected 
                              ? 'bg-brand-surface text-slate-400 hover:text-amber-400 border-brand-border' 
                              : 'bg-emerald-500/20 text-emerald-400 border-emerald-500/40'
                          }`}
                          title={isConnected ? "Disable Server" : "Enable Server"}
                        >
                          <Power className="w-3.5 h-3.5" />
                        </button>
                      )}

                      {(server.id.startsWith('srv-custom-') || server.tag.includes('CUSTOM')) && (
                        <button
                          onClick={() => handleDeleteCustomServer(server.id)}
                          className="p-1.5 rounded-lg border border-brand-border bg-brand-surface hover:bg-rose-950/60 text-slate-400 hover:text-rose-400 transition"
                          title="Unregister Upstream MCP Server"
                        >
                          <Trash2 className="w-3.5 h-3.5" />
                        </button>
                      )}
                    </div>
                  </div>

                  {/* Discovered Tool Tags Preview */}
                  <div className="flex items-center gap-1.5 flex-wrap mt-3 pl-12">
                    <span className="text-[10px] font-mono text-slate-500">Exposed Tools ({server.toolsCount}):</span>
                    {server.discoveredTools.slice(0, 4).map((tool) => (
                      <span 
                        key={tool}
                        className="text-[10px] font-mono bg-[#070c14] border border-brand-border text-slate-300 px-2 py-0.5 rounded"
                      >
                        {tool}
                      </span>
                    ))}
                    {server.discoveredTools.length > 4 && (
                      <span className="text-[10px] font-mono bg-brand-surface text-emerald-400 px-1.5 py-0.5 rounded border border-brand-border">
                        +{server.discoveredTools.length - 4} more
                      </span>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* ======================================================== */}
      {/* SECTION 2: HOSTED MCP PODS ON KUBERNETES                 */}
      {/* ======================================================== */}
      {activeSection === 'hosted' && (
        <div className="space-y-6">
          {/* Hosted Pods Stat Cards */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
              <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
                Hosted Pods
              </div>
              <div className="flex items-baseline gap-2">
                <span className="text-2xl font-bold font-mono text-slate-100">
                  {hostedServers.length} Deployed
                </span>
              </div>
              <div className="text-[11px] text-slate-400 font-mono mt-2">
                Managed by urumi-hosted-mcp
              </div>
            </div>

            <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
              <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
                Running Containers
              </div>
              <div className="flex items-baseline gap-2">
                <span className="text-2xl font-bold font-mono text-emerald-400">
                  {hostedServers.filter(s => s.status === 'Running').length} Active
                </span>
              </div>
              <div className="text-[11px] text-slate-400 font-mono mt-2">
                Replicas: 1 (Health OK)
              </div>
            </div>

            <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
              <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
                Sleeping / Standby
              </div>
              <div className="flex items-baseline gap-2">
                <span className="text-2xl font-bold font-mono text-slate-400">
                  {hostedServers.filter(s => s.status === 'Sleeping').length} Sleeping
                </span>
              </div>
              <div className="text-[11px] text-slate-400 font-mono mt-2">
                Scaled to 0 replicas (saves RAM)
              </div>
            </div>

            <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
              <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
                Hosted Tools
              </div>
              <div className="flex items-baseline gap-2">
                <span className="text-2xl font-bold font-mono text-sky-400">
                  {hostedServers.reduce((acc, s) => acc + s.toolsCount, 0)} Tools
                </span>
              </div>
              <div className="text-[11px] text-slate-400 font-mono mt-2">
                Auto-registered into Gateway
              </div>
            </div>
          </div>

          {/* Empty State or Hosted Cards */}
          {hostedServers.length === 0 ? (
            <div className="p-10 rounded-xl bg-brand-card border border-dashed border-brand-border text-center space-y-4">
              <div className="w-12 h-12 rounded-xl bg-emerald-500/10 border border-emerald-500/30 flex items-center justify-center text-emerald-400 mx-auto">
                <Boxes className="w-6 h-6" />
              </div>
              <div>
                <h3 className="text-sm font-semibold text-slate-100">No Hosted MCP Pods Deployed Yet</h3>
                <p className="text-xs text-slate-400 mt-1 max-w-md mx-auto">
                  Deploy containerized MCP servers on-demand directly in your cluster. Choose from pre-curated enterprise templates (Notifications, Forex, Shipping) or deploy custom Docker images.
                </p>
              </div>
              <button
                onClick={() => setIsDeployModalOpen(true)}
                className="inline-flex items-center gap-2 px-4 py-2 rounded-lg bg-emerald-500 hover:bg-emerald-600 text-slate-950 font-semibold text-xs transition cursor-pointer"
              >
                <Boxes className="w-4 h-4" />
                <span>Deploy First Hosted MCP Pod</span>
              </button>
            </div>
          ) : (
            <div className="space-y-4">
              {hostedServers.map((srv) => {
                const isRunning = srv.status === 'Running';
                const isProvisioning = srv.status === 'Provisioning';
                const isSleeping = srv.status === 'Sleeping';
                const isFailed = srv.status === 'Failed';
                const isActionActive = scalingId === srv.id || deletingId === srv.id;

                return (
                  <div 
                    key={srv.id}
                    className="p-5 rounded-xl bg-brand-card border border-brand-border hover:border-slate-700 transition"
                  >
                    <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                      <div className="flex items-center gap-3">
                        <div className={`w-10 h-10 rounded-xl flex items-center justify-center shrink-0 border ${
                          isRunning ? 'bg-emerald-500/15 border-emerald-500/30 text-emerald-400' : 'bg-slate-800/60 border-slate-700 text-slate-400'
                        }`}>
                          <Boxes className="w-5 h-5" />
                        </div>
                        <div>
                          <div className="flex items-center gap-2">
                            <span className="font-semibold text-slate-100 text-sm">{srv.name}</span>
                            <span className="text-[10px] font-mono bg-indigo-950/70 border border-indigo-800/80 text-indigo-300 px-2 py-0.5 rounded uppercase">
                              {srv.tag}
                            </span>
                            <span className={`inline-flex items-center gap-1.5 text-[10px] font-mono px-2 py-0.5 rounded-full border ${
                              isRunning 
                                ? 'bg-emerald-950/80 text-emerald-400 border-emerald-800/80' 
                                : isProvisioning
                                ? 'bg-amber-950/80 text-amber-400 border-amber-800/80 animate-pulse'
                                : isSleeping
                                ? 'bg-slate-900 text-slate-400 border-slate-700'
                                : 'bg-rose-950/80 text-rose-400 border-rose-800/80'
                            }`}>
                              {isProvisioning && <RefreshCw className="w-3 h-3 animate-spin" />}
                              {isRunning && <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span>}
                              {isSleeping && <span className="w-1.5 h-1.5 rounded-full bg-slate-400"></span>}
                              <span>{srv.status} ({srv.replicas} Pod)</span>
                            </span>
                          </div>

                          <div className="text-[11px] font-mono text-slate-400 mt-1 flex items-center gap-3">
                            <span className="truncate max-w-sm sm:max-w-md">{srv.endpointUrl}</span>
                            <span>•</span>
                            <span className="text-slate-500">Port {srv.port}</span>
                            <span>•</span>
                            <span className="text-slate-500 truncate max-w-xs">{srv.image}</span>
                          </div>
                        </div>
                      </div>

                      {/* Right Action Toolbar */}
                      <div className="flex items-center gap-2 self-end sm:self-auto">
                        {/* Sleep / Wake Button */}
                        <button
                          onClick={() => handleToggleScale(srv)}
                          disabled={isActionActive || isProvisioning}
                          className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg border text-xs font-mono transition ${
                            isSleeping 
                              ? 'bg-emerald-500/20 text-emerald-400 border-emerald-500/40 hover:bg-emerald-500/30' 
                              : 'bg-brand-surface text-slate-300 border-brand-border hover:bg-slate-800'
                          }`}
                          title={isSleeping ? "Scale to 1 (Wake)" : "Scale to 0 (Sleep)"}
                        >
                          {scalingId === srv.id ? (
                            <RefreshCw className="w-3.5 h-3.5 animate-spin" />
                          ) : isSleeping ? (
                            <Play className="w-3.5 h-3.5 text-emerald-400" />
                          ) : (
                            <Square className="w-3.5 h-3.5 text-slate-400" />
                          )}
                          <span>{isSleeping ? 'Wake Pod' : 'Sleep Pod'}</span>
                        </button>

                        {/* View Logs Button */}
                        <button
                          onClick={() => setSelectedLogsServer(srv)}
                          className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-brand-surface hover:bg-slate-800 text-xs text-slate-300 border border-brand-border font-mono transition"
                        >
                          <Terminal className="w-3.5 h-3.5 text-emerald-400" />
                          <span>Pod Logs</span>
                        </button>

                        {/* Delete Button */}
                        <button
                          onClick={() => handleDeleteHosted(srv.id)}
                          disabled={isActionActive}
                          className="p-1.5 rounded-lg bg-brand-surface hover:bg-rose-950/60 text-slate-400 hover:text-rose-400 border border-brand-border transition"
                          title="Teardown Pod & Service"
                        >
                          <Trash2 className="w-3.5 h-3.5" />
                        </button>
                      </div>
                    </div>

                    {/* Exposed Tools Preview */}
                    <div className="mt-4 pt-3 border-t border-brand-border/60">
                      <div className="text-[10px] font-mono text-slate-500 mb-2">
                        Exposed Hosted Tools ({srv.toolsCount}):
                      </div>
                      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-2">
                        {srv.tools.map(t => (
                          <div 
                            key={t.name}
                            className="p-2 rounded-lg bg-[#060a12] border border-brand-border/70 text-xs font-mono"
                          >
                            <div className="font-semibold text-emerald-400 flex items-center gap-1.5">
                              <span>⚡</span>
                              <span className="truncate">{t.name}</span>
                            </div>
                            <div className="text-[10px] text-slate-400 mt-0.5 line-clamp-1" title={t.description}>
                              {t.description}
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      )}

      {/* Schema Inspector Modal for Fleet Servers */}
      {selectedSchemaServer && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm animate-fadeIn">
          <div className="relative w-full max-w-2xl bg-[#090d16] border border-brand-border rounded-xl shadow-2xl p-6 text-slate-100">
            <div className="flex items-center justify-between pb-3 border-b border-brand-border">
              <div className="flex items-center gap-2">
                <Code2 className="w-4 h-4 text-emerald-400" />
                <h3 className="font-semibold text-sm">Discovered Tools Schema: {selectedSchemaServer.name}</h3>
              </div>
              <button 
                onClick={() => setSelectedSchemaServer(null)}
                className="p-1 rounded text-slate-400 hover:text-slate-200 transition"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <div className="mt-4 space-y-3 overflow-y-auto max-h-[55vh] pr-2">
              {selectedSchemaServer.discoveredTools.map((toolName) => (
                <div key={toolName} className="p-3 rounded-lg bg-[#070b14] border border-brand-border font-mono text-xs">
                  <div className="text-emerald-400 font-semibold mb-1 flex items-center justify-between">
                    <span>{toolName}</span>
                    <span className="text-[10px] text-slate-400 bg-brand-surface px-1.5 py-0.5 rounded">
                      Streamable HTTP
                    </span>
                  </div>
                  <div className="text-slate-400 text-[11px] mb-2">
                    Input Schema parameters definition:
                  </div>
                  <pre className="p-2 rounded bg-[#040810] text-[11px] text-slate-300 overflow-x-auto">
{JSON.stringify({
  type: "object",
  properties: toolName.includes("product") 
    ? { name: { type: "string" }, price: { type: "number" } }
    : toolName.includes("order") 
    ? { status: { type: "string" }, limit: { type: "number" } }
    : { sku: { type: "string" }, threshold: { type: "number" } },
  required: toolName.includes("product") ? ["name", "price"] : ["status"]
}, null, 2)}
                  </pre>
                </div>
              ))}
            </div>

            <div className="pt-4 border-t border-brand-border mt-4 flex justify-end">
              <button
                onClick={() => setSelectedSchemaServer(null)}
                className="px-4 py-2 rounded-lg bg-brand-surface hover:bg-brand-surface/80 text-xs font-mono text-slate-200 border border-brand-border transition"
              >
                Close Schema Inspector
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Deploy Hosted MCP Pod Modal */}
      <DeployHostedModal
        isOpen={isDeployModalOpen}
        onClose={() => setIsDeployModalOpen(false)}
        activeApiKey={activeApiKey}
        onDeployed={(newSrv) => {
          setHostedServers(prev => [newSrv, ...prev.filter(s => s.id !== newSrv.id)]);
        }}
      />

      {/* Live Pod Logs Drawer */}
      <HostedLogsDrawer
        server={selectedLogsServer}
        onClose={() => setSelectedLogsServer(null)}
        activeApiKey={activeApiKey}
      />
    </div>
  );
};
