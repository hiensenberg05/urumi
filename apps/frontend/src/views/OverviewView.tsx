import React, { useState } from 'react';
import { 
  Server, 
  Activity, 
  Layers, 
  CheckCircle2, 
  AlertTriangle, 
  Clock, 
  RefreshCw, 
  Plus, 
  ExternalLink, 
  ShieldAlert,
  ArrowUpRight,
  Terminal,
  Zap
} from 'lucide-react';
import { McpServer, AuditLogItem, ClientSession } from '../types';

interface OverviewViewProps {
  servers: McpServer[];
  auditLogs: AuditLogItem[];
  clientSessions: ClientSession[];
  onOpenTrace: (log: AuditLogItem) => void;
  onNavigateToServers: () => void;
  onNavigateToAudit: () => void;
  onAddServer: () => void;
}

export const OverviewView: React.FC<OverviewViewProps> = ({
  servers,
  auditLogs,
  clientSessions,
  onOpenTrace,
  onNavigateToServers,
  onNavigateToAudit,
  onAddServer
}) => {
  const [isSyncing, setIsSyncing] = useState(false);
  const [syncSuccess, setSyncSuccess] = useState(false);

  const handleForceSync = () => {
    setIsSyncing(true);
    setTimeout(() => {
      setIsSyncing(false);
      setSyncSuccess(true);
      setTimeout(() => setSyncSuccess(false), 2500);
    }, 1000);
  };

  // 24h rolling histogram hourly heights
  const hourlyBars = [
    { hour: '00', success: 12, fail: 0 },
    { hour: '02', success: 8, fail: 0 },
    { hour: '04', success: 5, fail: 0 },
    { hour: '06', success: 14, fail: 0 },
    { hour: '08', success: 38, fail: 0 },
    { hour: '10', success: 62, fail: 0 },
    { hour: '12', success: 48, fail: 0 },
    { hour: '14', success: 75, fail: 4 }, // spike
    { hour: '16', success: 52, fail: 0 },
    { hour: '18', success: 36, fail: 0 },
    { hour: '20', success: 22, fail: 0 },
    { hour: '22', success: 18, fail: 0 },
  ];

  return (
    <div className="space-y-6 animate-fadeIn">
      {/* Top Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-3">
            <h1 className="text-xl font-bold tracking-tight text-slate-100">Overview</h1>
            <span className="text-[11px] font-mono bg-emerald-950/60 border border-emerald-800/80 text-emerald-400 px-2 py-0.5 rounded-full font-medium flex items-center gap-1.5">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
              Cluster: local-kind (urumi-local)
            </span>
          </div>
          <p className="text-xs text-slate-400 mt-1">
            Monitor your MCP infrastructure, tools, and team activity in real time.
          </p>
        </div>

        {/* Action Buttons */}
        <div className="flex items-center gap-2.5">
          <button 
            onClick={handleForceSync}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-brand-card hover:bg-brand-surface border border-brand-border text-xs text-slate-300 transition"
          >
            <RefreshCw className={`w-3.5 h-3.5 ${isSyncing ? 'animate-spin text-emerald-400' : 'text-slate-400'}`} />
            <span>{isSyncing ? 'Probing...' : 'Quick Test'}</span>
          </button>
          <button 
            onClick={onNavigateToAudit}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-brand-card hover:bg-brand-surface border border-brand-border text-xs text-slate-300 transition"
          >
            <Activity className="w-3.5 h-3.5 text-slate-400" />
            <span>Export Telemetry</span>
          </button>
          <button 
            onClick={onAddServer}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-emerald-500 hover:bg-emerald-600 text-slate-950 font-semibold text-xs shadow-md shadow-emerald-500/20 transition cursor-pointer"
          >
            <Plus className="w-3.5 h-3.5" />
            <span>Add MCP Server</span>
          </button>
        </div>
      </div>

      {/* 4 Key Metric Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Card 1: Registered Servers */}
        <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80 relative overflow-hidden">
          <div className="flex items-center justify-between text-slate-400 mb-2">
            <span className="text-[10px] font-mono uppercase tracking-wider font-semibold">Registered Servers</span>
            <span className="text-[10px] font-mono text-emerald-400 bg-emerald-950/60 border border-emerald-800/40 px-1.5 py-0.2 rounded">
              Active
            </span>
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold font-mono text-slate-100">{servers.length}</span>
            <span className="text-xs text-emerald-400 font-mono">100% active</span>
          </div>
          <div className="mt-3 flex items-center gap-1.5 text-[11px] text-slate-400">
            <CheckCircle2 className="w-3.5 h-3.5 text-emerald-400 shrink-0" />
            <span>Zero unassigned upstream targets</span>
          </div>
        </div>

        {/* Card 2: Healthy Servers */}
        <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80 relative overflow-hidden">
          <div className="flex items-center justify-between text-slate-400 mb-2">
            <span className="text-[10px] font-mono uppercase tracking-wider font-semibold">Healthy Servers</span>
            <span className="text-[10px] font-mono text-emerald-400 bg-emerald-950/60 border border-emerald-800/40 px-1.5 py-0.2 rounded flex items-center gap-1">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-ping"></span>
              Operational
            </span>
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold font-mono text-slate-100">3 / 3</span>
            <span className="text-xs text-slate-400 font-mono">Last probe 12s ago</span>
          </div>
          <div className="mt-3 text-[11px] font-mono text-slate-400">
            <span className="text-emerald-400 font-semibold">p99</span> Roundtrip latency: <span className="text-slate-200">58ms</span>
          </div>
        </div>

        {/* Card 3: Available Tools */}
        <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80 relative overflow-hidden">
          <div className="flex items-center justify-between text-slate-400 mb-2">
            <span className="text-[10px] font-mono uppercase tracking-wider font-semibold">Available Tools</span>
            <span className="text-[10px] font-mono text-slate-400 bg-brand-surface px-1.5 py-0.2 rounded border border-brand-border">
              Synced
            </span>
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold font-mono text-slate-100">18</span>
            <span className="text-xs text-emerald-400 font-mono">+4 added this week</span>
          </div>
          <div className="mt-3 flex items-center gap-1.5 text-[11px] text-slate-400">
            <Zap className="w-3.5 h-3.5 text-emerald-400 shrink-0" />
            <span>All schemas validated by gateway</span>
          </div>
        </div>

        {/* Card 4: Tool Calls Today */}
        <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80 relative overflow-hidden">
          <div className="flex items-center justify-between text-slate-400 mb-2">
            <span className="text-[10px] font-mono uppercase tracking-wider font-semibold">Tool Calls Today</span>
            <span className="text-[10px] font-mono text-emerald-400 bg-emerald-950/60 border border-emerald-800/40 px-1.5 py-0.2 rounded">
              +14.2% vs yesterday
            </span>
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold font-mono text-slate-100">248</span>
            <span className="text-xs text-emerald-400 font-mono">99.2% success</span>
          </div>
          <div className="mt-3 flex items-center gap-3 text-[11px] font-mono text-slate-400">
            <span className="flex items-center gap-1">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
              246 success
            </span>
            <span className="flex items-center gap-1">
              <span className="w-1.5 h-1.5 rounded-full bg-red-400"></span>
              2 blocked
            </span>
          </div>
        </div>
      </div>

      {/* Main Grid: 2 Columns */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left Column (2 spans): Connected Servers & Charts */}
        <div className="lg:col-span-2 space-y-6">
          {/* Connected MCP Servers List */}
          <div className="p-5 rounded-xl bg-brand-card border border-brand-border">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2">
                <Server className="w-4 h-4 text-emerald-400" />
                <h3 className="text-sm font-semibold text-slate-100">Connected MCP Servers</h3>
              </div>
              <button 
                onClick={onNavigateToServers}
                className="text-xs text-emerald-400 hover:text-emerald-300 font-mono flex items-center gap-1 transition"
              >
                <span>Manage All (3)</span>
                <ArrowUpRight className="w-3.5 h-3.5" />
              </button>
            </div>

            <div className="space-y-3">
              {servers.map((server) => (
                <div 
                  key={server.id}
                  className="p-3.5 rounded-lg bg-brand-surface/40 border border-brand-border/70 hover:border-brand-borderLight transition"
                >
                  <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 mb-2">
                    <div className="flex items-center gap-2.5">
                      <div className="w-7 h-7 rounded bg-[#0a121e] border border-brand-border flex items-center justify-center font-mono font-bold text-xs text-emerald-400">
                        {server.name.substring(0, 2).toUpperCase()}
                      </div>
                      <div>
                        <div className="flex items-center gap-2">
                          <span className="text-xs font-semibold text-slate-200">{server.name}</span>
                          <span className="text-[10px] font-mono bg-emerald-950/70 text-emerald-400 border border-emerald-800/60 px-1.5 py-0.2 rounded font-medium">
                            Connected
                          </span>
                        </div>
                        <div className="text-[10px] font-mono text-slate-400 truncate max-w-xs sm:max-w-md">
                          {server.endpointUrl}
                        </div>
                      </div>
                    </div>
                    <div className="flex items-center gap-4 text-xs font-mono text-slate-400 self-end sm:self-auto">
                      <span className="text-slate-300 font-semibold">{server.toolsCount} tools</span>
                      <span className="text-[11px] text-slate-400">Checked {server.lastChecked}</span>
                    </div>
                  </div>

                  {/* Discovered Tool Tags Preview */}
                  <div className="flex items-center gap-1.5 flex-wrap mt-2 pl-9">
                    <span className="text-[10px] font-mono text-slate-400">Discovered:</span>
                    {server.discoveredTools.slice(0, 3).map((tool) => (
                      <span 
                        key={tool}
                        className="text-[10px] font-mono bg-[#070c14] border border-brand-border text-slate-300 px-2 py-0.5 rounded"
                      >
                        {tool}
                      </span>
                    ))}
                    {server.discoveredTools.length > 3 && (
                      <span className="text-[10px] font-mono bg-brand-surface text-emerald-400 px-1.5 py-0.5 rounded border border-brand-border">
                        +{server.discoveredTools.length - 3} more
                      </span>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Tool Invocation Activity (24h Rolling Bar Chart) */}
          <div className="p-5 rounded-xl bg-brand-card border border-brand-border">
            <div className="flex items-center justify-between mb-4">
              <div>
                <h3 className="text-sm font-semibold text-slate-100 flex items-center gap-2">
                  <span>Tool Invocation Activity</span>
                  <span className="text-[10px] font-mono bg-brand-surface text-slate-400 px-1.5 py-0.2 rounded border border-brand-border font-normal">
                    24h rolling
                  </span>
                </h3>
                <p className="text-xs text-slate-400 mt-0.5">
                  Hourly breakdown of requests passing through gateway policy checks
                </p>
              </div>
              <div className="flex items-center gap-3 text-xs font-mono">
                <span className="flex items-center gap-1.5 text-emerald-400">
                  <span className="w-2 h-2 rounded-full bg-emerald-400"></span>
                  246 Success
                </span>
                <span className="flex items-center gap-1.5 text-red-400">
                  <span className="w-2 h-2 rounded-full bg-red-400"></span>
                  2 Denied/Fail
                </span>
                <span className="text-slate-400 font-semibold bg-brand-surface px-2 py-0.5 rounded border border-brand-border">
                  Avg 142ms
                </span>
              </div>
            </div>

            {/* Custom SVG Bar Chart */}
            <div className="pt-4 pb-2">
              <div className="h-28 flex items-end justify-between gap-1.5 px-2">
                {hourlyBars.map((bar, i) => {
                  const maxVal = 80;
                  const successHeight = (bar.success / maxVal) * 100;
                  const failHeight = (bar.fail / maxVal) * 100;

                  return (
                    <div key={i} className="flex-1 flex flex-col items-center gap-1 group relative cursor-pointer">
                      {/* Tooltip on hover */}
                      <div className="opacity-0 group-hover:opacity-100 transition absolute -top-9 bg-[#040810] border border-brand-border text-[10px] font-mono text-slate-200 px-2 py-1 rounded shadow-lg pointer-events-none z-10 whitespace-nowrap">
                        {bar.hour}:00 UTC — {bar.success} OK, {bar.fail} Denied
                      </div>
                      
                      <div className="w-full flex flex-col items-center justify-end h-24">
                        {bar.fail > 0 && (
                          <div 
                            style={{ height: `${failHeight}%` }} 
                            className="w-full rounded-t bg-red-400/90 transition hover:bg-red-400"
                          />
                        )}
                        <div 
                          style={{ height: `${successHeight}%` }} 
                          className="w-full rounded-t bg-emerald-400/80 hover:bg-emerald-400 transition"
                        />
                      </div>
                      <span className="text-[10px] font-mono text-slate-400 mt-1">{bar.hour}:00</span>
                    </div>
                  );
                })}
              </div>
            </div>
          </div>

          {/* Recent Tool Activity Table */}
          <div className="p-5 rounded-xl bg-brand-card border border-brand-border">
            <div className="flex items-center justify-between mb-4">
              <div>
                <h3 className="text-sm font-semibold text-slate-100 flex items-center gap-2">
                  <span>Recent Tool Activity</span>
                  <span className="text-[10px] font-mono bg-emerald-950/60 text-emerald-400 border border-emerald-800/40 px-1.5 py-0.2 rounded font-normal">
                    Realtime telemetry
                  </span>
                </h3>
              </div>
              <button 
                onClick={onNavigateToAudit}
                className="text-xs text-emerald-400 hover:text-emerald-300 font-mono flex items-center gap-1 transition"
              >
                <span>View All Audit Logs</span>
                <ArrowUpRight className="w-3.5 h-3.5" />
              </button>
            </div>

            <div className="overflow-x-auto">
              <table className="w-full text-left text-xs font-mono">
                <thead>
                  <tr className="border-b border-brand-border text-slate-400 text-[10px] uppercase">
                    <th className="pb-2.5 font-semibold">User / Client</th>
                    <th className="pb-2.5 font-semibold">Target Server</th>
                    <th className="pb-2.5 font-semibold">Invoked Tool</th>
                    <th className="pb-2.5 font-semibold">Outcome</th>
                    <th className="pb-2.5 font-semibold">Duration</th>
                    <th className="pb-2.5 font-semibold">Timestamp</th>
                    <th className="pb-2.5 font-semibold text-right">Trace</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-brand-border/60">
                  {auditLogs.slice(0, 4).map((log) => {
                    const isDenied = log.status.includes('403') || log.status.includes('Blocked');
                    return (
                      <tr key={log.id} className="hover:bg-brand-surface/40 transition">
                        <td className="py-2.5 text-slate-200">
                          <div className="flex items-center gap-2">
                            {log.avatarUrl ? (
                              <img src={log.avatarUrl} className="w-5 h-5 rounded-full object-cover" />
                            ) : (
                              <div className="w-5 h-5 rounded-full bg-slate-800 flex items-center justify-center text-[10px]">
                                🤖
                              </div>
                            )}
                            <span className="font-semibold truncate max-w-[120px]">{log.principal}</span>
                          </div>
                        </td>
                        <td className="py-2.5 text-slate-400">{log.targetServer}</td>
                        <td className="py-2.5">
                          <span className={isDenied ? 'text-red-400 font-semibold' : 'text-emerald-400'}>
                            {log.toolName}
                          </span>
                        </td>
                        <td className="py-2.5">
                          <span className={`px-2 py-0.5 rounded text-[10px] font-semibold ${
                            isDenied 
                              ? 'bg-red-950 text-red-400 border border-red-800/60'
                              : 'bg-emerald-950 text-emerald-400 border border-emerald-800/60'
                          }`}>
                            {isDenied ? 'Denied (Policy #4)' : 'Success (200 OK)'}
                          </span>
                        </td>
                        <td className="py-2.5 text-slate-400">{log.durationMs}ms</td>
                        <td className="py-2.5 text-slate-400">{log.timeAgo}</td>
                        <td className="py-2.5 text-right">
                          <button
                            onClick={() => onOpenTrace(log)}
                            className="p-1 text-slate-400 hover:text-emerald-400 transition"
                            title="View trace"
                          >
                            <ExternalLink className="w-3.5 h-3.5" />
                          </button>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          </div>
        </div>

        {/* Right Column (1 span): Gateway Status & Sessions */}
        <div className="space-y-6">
          {/* Gateway Status Card */}
          <div className="p-5 rounded-xl bg-brand-card border border-brand-border space-y-4">
            <div className="flex items-center justify-between pb-3 border-b border-brand-border">
              <div className="flex items-center gap-2">
                <ShieldAlert className="w-4 h-4 text-emerald-400" />
                <h3 className="text-sm font-semibold text-slate-100">Gateway Status</h3>
              </div>
              <span className="text-[10px] font-mono bg-emerald-950 text-emerald-400 border border-emerald-800/60 px-2 py-0.5 rounded font-semibold">
                Ready
              </span>
            </div>

            <div className="space-y-2.5 text-xs font-mono">
              <div className="flex items-center justify-between text-slate-400">
                <span>Gateway Version:</span>
                <span className="text-slate-200">v1.4.2-enterprise</span>
              </div>
              <div className="flex items-center justify-between text-slate-400">
                <span>Protocol Support:</span>
                <span className="text-slate-200">MCP Spec 2024-11-05</span>
              </div>
              <div className="flex items-center justify-between text-slate-400">
                <span>Transport Type:</span>
                <span className="text-emerald-400 font-semibold">Streamable HTTP (SSE)</span>
              </div>
              <div className="flex items-center justify-between text-slate-400">
                <span>Upstream Health:</span>
                <span className="text-emerald-400 font-semibold flex items-center gap-1">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
                  3/3 connected
                </span>
              </div>
              <div className="flex items-center justify-between text-slate-400">
                <span>Last Sync:</span>
                <span className="text-slate-300">14:32:05 UTC (60s cycle)</span>
              </div>
            </div>

            <button
              onClick={handleForceSync}
              disabled={isSyncing}
              className={`w-full py-2 px-3 rounded-lg border text-xs font-mono font-semibold flex items-center justify-center gap-2 transition cursor-pointer ${
                syncSuccess 
                  ? 'bg-emerald-500 text-slate-950 border-emerald-400 font-bold'
                  : 'bg-brand-surface hover:bg-brand-surface/80 border-brand-border text-slate-200'
              }`}
            >
              <RefreshCw className={`w-3.5 h-3.5 ${isSyncing ? 'animate-spin text-emerald-400' : ''}`} />
              <span>{isSyncing ? 'Synchronizing...' : syncSuccess ? 'Sync Complete (18 Tools)' : 'Trigger Force Sync'}</span>
            </button>
          </div>

          {/* Active Client Sessions Card */}
          <div className="p-5 rounded-xl bg-brand-card border border-brand-border space-y-3">
            <div className="flex items-center justify-between pb-2 border-b border-brand-border">
              <div className="flex items-center gap-2">
                <Terminal className="w-4 h-4 text-emerald-400" />
                <h3 className="text-sm font-semibold text-slate-100">Active Client Sessions</h3>
              </div>
              <span className="text-[10px] font-mono bg-emerald-950/80 text-emerald-400 border border-emerald-800/60 px-1.5 py-0.2 rounded font-semibold">
                3 Live
              </span>
            </div>

            <div className="space-y-2">
              {clientSessions.map((session) => (
                <div 
                  key={session.id}
                  className="p-2.5 rounded-lg bg-brand-surface/40 border border-brand-border flex items-center justify-between text-xs font-mono"
                >
                  <div className="flex items-center gap-2">
                    <span className="text-slate-400 font-bold">&lt;&gt;</span>
                    <div>
                      <div className="text-slate-200 font-semibold">{session.name}</div>
                      <div className="text-[10px] text-slate-400">Token: {session.tokenPrefix}</div>
                    </div>
                  </div>
                  <span className="w-2 h-2 rounded-full bg-emerald-400"></span>
                </div>
              ))}
            </div>

            {/* Access Control Footnote */}
            <div className="pt-2 text-[11px] text-slate-400 leading-relaxed border-t border-brand-border/60">
              Access control enforcement is strictly configured. Tools require role-based confirmation prompts.
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
