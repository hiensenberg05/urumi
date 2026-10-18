import React, { useState } from 'react';
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
  Code2
} from 'lucide-react';
import { McpServer } from '../types';

interface ServersViewProps {
  servers: McpServer[];
  onToggleServerStatus?: (serverId: string) => void;
  onAddServer: () => void;
}

export const ServersView: React.FC<ServersViewProps> = ({
  servers,
  onToggleServerStatus,
  onAddServer
}) => {
  const [activeTab, setActiveTab] = useState<'all' | 'healthy' | 'sse' | 'issues'>('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedSchemaServer, setSelectedSchemaServer] = useState<McpServer | null>(null);
  const [isRefreshing, setIsRefreshing] = useState(false);

  const handleRefresh = () => {
    setIsRefreshing(true);
    setTimeout(() => setIsRefreshing(false), 800);
  };

  const filteredServers = servers.filter(s => {
    if (activeTab === 'issues') return s.status !== 'Connected';
    if (searchQuery) {
      return s.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
             s.endpointUrl.toLowerCase().includes(searchQuery.toLowerCase());
    }
    return true;
  });

  return (
    <div className="space-y-6 animate-fadeIn">
      {/* Top Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-3">
            <h1 className="text-xl font-bold tracking-tight text-slate-100">MCP Servers</h1>
            <span className="text-[11px] font-mono bg-emerald-950/60 border border-emerald-800/80 text-emerald-400 px-2 py-0.5 rounded-full font-medium flex items-center gap-1.5">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
              3 Active Upstreams
            </span>
          </div>
          <p className="text-xs text-slate-400 mt-1 max-w-2xl leading-relaxed">
            Register and manage upstream Model Context Protocol servers, discover remote tool schemas, and monitor endpoint health in real time.
          </p>
        </div>

        {/* Action Buttons */}
        <div className="flex items-center gap-2.5">
          <button 
            onClick={handleRefresh}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-brand-card hover:bg-brand-surface border border-brand-border text-xs text-slate-300 font-mono transition"
          >
            <RefreshCw className={`w-3.5 h-3.5 ${isRefreshing ? 'animate-spin text-emerald-400' : 'text-slate-400'}`} />
            <span>Refresh Tool Schemas</span>
          </button>
          <button 
            onClick={onAddServer}
            className="flex items-center gap-1.5 px-3.5 py-1.5 rounded-lg bg-emerald-500 hover:bg-emerald-600 text-slate-950 font-semibold text-xs shadow-md shadow-emerald-500/20 transition cursor-pointer"
          >
            <Plus className="w-3.5 h-3.5" />
            <span>Add MCP Server</span>
          </button>
        </div>
      </div>

      {/* 4 Stat Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
          <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
            Total Handlers
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold font-mono text-slate-100">18 Tools</span>
          </div>
          <div className="text-[11px] text-slate-400 font-mono mt-2">
            Across 3 endpoints
          </div>
        </div>

        <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
          <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
            Cluster Ping (P95)
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold font-mono text-slate-100">52 ms</span>
            <span className="text-xs text-emerald-400 font-mono">-8ms vs yesterday</span>
          </div>
          <div className="text-[11px] text-slate-400 font-mono mt-2">
            Local Kind internal network
          </div>
        </div>

        <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
          <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
            Aggregated SLA
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold font-mono text-slate-100">99.98%</span>
          </div>
          <div className="text-[11px] text-slate-400 font-mono mt-2">
            Zero outages (30d)
          </div>
        </div>

        <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
          <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
            Active Transport
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold font-mono text-emerald-400">SSE HTTP</span>
          </div>
          <div className="text-[11px] text-slate-400 font-mono mt-2">
            Spec: MCP 2024-11-05
          </div>
        </div>
      </div>

      {/* Filter Tabs and Search Bar */}
      <div className="p-4 rounded-xl bg-brand-card border border-brand-border space-y-4">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <div className="flex items-center gap-1 p-1 rounded-lg bg-brand-surface/60 border border-brand-border/70 text-xs font-mono">
            <button
              onClick={() => setActiveTab('all')}
              className={`px-3 py-1.5 rounded-md transition ${activeTab === 'all' ? 'bg-emerald-500 text-slate-950 font-bold' : 'text-slate-400 hover:text-slate-200'}`}
            >
              All Servers (3)
            </button>
            <button
              onClick={() => setActiveTab('healthy')}
              className={`px-3 py-1.5 rounded-md transition ${activeTab === 'healthy' ? 'bg-emerald-500 text-slate-950 font-bold' : 'text-slate-400 hover:text-slate-200'}`}
            >
              Healthy (3)
            </button>
            <button
              onClick={() => setActiveTab('sse')}
              className={`px-3 py-1.5 rounded-md transition ${activeTab === 'sse' ? 'bg-emerald-500 text-slate-950 font-bold' : 'text-slate-400 hover:text-slate-200'}`}
            >
              Streamable HTTP (3)
            </button>
            <button
              onClick={() => setActiveTab('issues')}
              className={`px-3 py-1.5 rounded-md transition ${activeTab === 'issues' ? 'bg-emerald-500 text-slate-950 font-bold' : 'text-slate-400 hover:text-slate-200'}`}
            >
              Degraded / Issues (0)
            </button>
          </div>

          <div className="relative">
            <Search className="w-3.5 h-3.5 text-slate-400 absolute left-3 top-2.5 pointer-events-none" />
            <input 
              type="text"
              placeholder="Filter by server name..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="bg-brand-surface border border-brand-border text-xs text-slate-200 placeholder-slate-400 pl-8 pr-4 py-1.5 rounded-lg focus:outline-none focus:border-emerald-500/50 w-full sm:w-64"
            />
          </div>
        </div>

        {/* Servers List Table / Cards */}
        <div className="space-y-3 pt-2">
          {filteredServers.map((server) => {
            const isConnected = server.status === 'Connected';
            return (
              <div 
                key={server.id}
                className="p-4 rounded-xl bg-brand-surface/30 border border-brand-border hover:border-brand-borderLight transition"
              >
                <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
                  {/* Left: Server Name & Endpoint */}
                  <div className="flex items-start gap-3.5">
                    <div className="w-10 h-10 rounded-lg bg-[#070d17] border border-brand-border flex items-center justify-center font-mono font-bold text-sm text-emerald-400 shrink-0">
                      {server.name.substring(0, 2).toUpperCase()}
                    </div>
                    <div>
                      <div className="flex items-center gap-2.5">
                        <h3 className="text-sm font-semibold text-slate-100">{server.name}</h3>
                        <span className="text-[10px] font-mono bg-brand-surface text-slate-300 border border-brand-border px-1.5 py-0.2 rounded uppercase">
                          {server.tag}
                        </span>
                      </div>
                      <div className="flex items-center gap-2 mt-1 text-xs font-mono text-slate-400">
                        <span className="text-slate-400">🔗</span>
                        <span className="text-slate-300 truncate max-w-sm sm:max-w-md">{server.endpointUrl}</span>
                      </div>
                    </div>
                  </div>

                  {/* Middle: Transport & Tool Schemas */}
                  <div className="flex flex-col sm:flex-row sm:items-center gap-6 text-xs font-mono">
                    <div>
                      <div className="text-[10px] text-slate-400 uppercase">Transport / Spec</div>
                      <div className="text-slate-200 font-semibold mt-0.5">{server.transport}</div>
                      <div className="text-[10px] text-slate-400">Spec 2024-11-05</div>
                    </div>

                    <div>
                      <div className="flex items-center gap-2">
                        <span className="text-slate-200 font-semibold">{server.toolsCount} Tools Registered</span>
                        <button
                          onClick={() => setSelectedSchemaServer(server)}
                          className="text-[10px] text-emerald-400 hover:text-emerald-300 underline underline-offset-2 flex items-center gap-0.5"
                        >
                          <Code2 className="w-3 h-3" />
                          <span>View Schema</span>
                        </button>
                      </div>
                      <div className="flex items-center gap-1.5 mt-1">
                        {server.discoveredTools.slice(0, 2).map((tool) => (
                          <span 
                            key={tool}
                            className="text-[10px] bg-[#070c14] border border-brand-border text-slate-300 px-1.5 py-0.5 rounded"
                          >
                            {tool}
                          </span>
                        ))}
                        {server.discoveredTools.length > 2 && (
                          <span className="text-[10px] bg-brand-surface text-emerald-400 px-1.5 py-0.5 rounded border border-brand-border">
                            +{server.discoveredTools.length - 2} more
                          </span>
                        )}
                      </div>
                    </div>
                  </div>

                  {/* Right: Health & Ping */}
                  <div className="flex items-center justify-between lg:justify-end gap-4 border-t lg:border-t-0 pt-3 lg:pt-0 border-brand-border/60">
                    <div className="text-right">
                      <div className="flex items-center gap-1.5 text-xs font-mono font-semibold text-emerald-400 justify-end">
                        <span className="w-2 h-2 rounded-full bg-emerald-400"></span>
                        <span>Operational {server.pingMs}ms</span>
                      </div>
                      <div className="text-[10px] font-mono text-slate-400 mt-0.5">
                        Checked {server.lastChecked} • {server.uptimePct}% up
                      </div>
                    </div>

                    {/* Disable/Enable Toggle */}
                    {onToggleServerStatus && (
                      <button
                        onClick={() => onToggleServerStatus(server.id)}
                        className={`text-[11px] font-mono px-2.5 py-1 rounded border transition ${
                          isConnected 
                            ? 'bg-red-950/40 border-red-800/60 text-red-400 hover:bg-red-950/80' 
                            : 'bg-emerald-950/40 border-emerald-800/60 text-emerald-400 hover:bg-emerald-950/80'
                        }`}
                      >
                        {isConnected ? 'Disable' : 'Enable'}
                      </button>
                    )}
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* 3 Bottom Architectural Protocol Cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        {/* Card 1: KMS Protocol */}
        <div className="p-4 rounded-xl bg-brand-card border border-brand-border space-y-2">
          <div className="flex items-center gap-2 text-xs font-mono font-semibold text-emerald-400 uppercase tracking-wider">
            <ShieldCheck className="w-4 h-4" />
            <span>Workspace KMS Protocol</span>
          </div>
          <h4 className="text-sm font-semibold text-slate-200">Zero-Trust Credential Isolation</h4>
          <p className="text-xs text-slate-400 leading-relaxed">
            Each upstream endpoint is proxied through Urumi's ingress mesh. LLM agents never receive raw tokens or backend credentials—headers are enriched JIT within the private gateway boundary.
          </p>
          <div className="pt-2 flex items-center justify-between text-xs font-mono text-slate-400">
            <span className="text-emerald-400">mTLS Enforced</span>
            <span className="hover:text-slate-200 cursor-pointer">Audit Key Vault →</span>
          </div>
        </div>

        {/* Card 2: Unified Tool Manifest */}
        <div className="p-4 rounded-xl bg-brand-card border border-brand-border space-y-2">
          <div className="flex items-center gap-2 text-xs font-mono font-semibold text-emerald-400 uppercase tracking-wider">
            <Layers className="w-4 h-4" />
            <span>Dynamic Schema Aggregation</span>
          </div>
          <h4 className="text-sm font-semibold text-slate-200">Unified Tool Manifest</h4>
          <p className="text-xs text-slate-400 leading-relaxed">
            When client chat tools invoke <code className="text-emerald-400 font-mono">/tools/list</code>, Urumi transparently de-duplicates namespaces and injects active team rate limits.
          </p>
          <div className="pt-2 flex items-center justify-between text-xs font-mono text-slate-400">
            <span>Cache TTL: 120s</span>
            <span className="text-emerald-400 hover:underline cursor-pointer">Purge Global Cache ⟳</span>
          </div>
        </div>

        {/* Card 3: Circuit Breaker Policy */}
        <div className="p-4 rounded-xl bg-brand-card border border-brand-border space-y-2">
          <div className="flex items-center gap-2 text-xs font-mono font-semibold text-emerald-400 uppercase tracking-wider">
            <Zap className="w-4 h-4" />
            <span>High Availability Fallbacks</span>
          </div>
          <h4 className="text-sm font-semibold text-slate-200">Circuit Breaker Policy</h4>
          <p className="text-xs text-slate-400 leading-relaxed">
            Endpoints failing 3 consecutive health checks are automatically isolated to prevent cascading timeouts inside agent execution loops.
          </p>
          <div className="pt-2 flex items-center justify-between text-xs font-mono text-slate-400">
            <span className="text-emerald-400 font-semibold">All 3 Circuits Closed</span>
            <span className="hover:text-slate-200 cursor-pointer">Edit Thresholds ⚙</span>
          </div>
        </div>
      </div>

      {/* View Schema Modal */}
      {selectedSchemaServer && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm animate-fadeIn">
          <div className="w-full max-w-2xl bg-[#0d1522] border border-brand-border rounded-xl shadow-2xl p-6 text-slate-100 max-h-[85vh] flex flex-col justify-between">
            <div>
              <div className="flex items-center justify-between pb-3 border-b border-brand-border">
                <div className="flex items-center gap-2 font-mono">
                  <Code2 className="w-4 h-4 text-emerald-400" />
                  <span className="font-semibold text-sm">{selectedSchemaServer.name} — Discovered Schemas</span>
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
    </div>
  );
};
