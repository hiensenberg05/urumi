import React, { useState } from 'react';
import { 
  ScrollText, 
  Search, 
  Filter, 
  RefreshCw, 
  Download, 
  ExternalLink, 
  CheckCircle2, 
  AlertOctagon, 
  Clock,
  Radio,
  ChevronDown
} from 'lucide-react';
import { AuditLogItem } from '../types';

interface AuditLogsViewProps {
  logs: AuditLogItem[];
  onSelectLog: (log: AuditLogItem) => void;
}

export const AuditLogsView: React.FC<AuditLogsViewProps> = ({ logs, onSelectLog }) => {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedOutcome, setSelectedOutcome] = useState<'all' | 'success' | 'blocked'>('all');
  const [isLiveStreaming, setIsLiveStreaming] = useState(true);
  const [isRefreshing, setIsRefreshing] = useState(false);

  const handleRefresh = () => {
    setIsRefreshing(true);
    setTimeout(() => setIsRefreshing(false), 600);
  };

  const filteredLogs = logs.filter(log => {
    if (selectedOutcome === 'success' && !log.status.includes('200')) return false;
    if (selectedOutcome === 'blocked' && !log.status.includes('403') && !log.status.includes('Blocked')) return false;
    if (searchQuery) {
      return log.correlationId.toLowerCase().includes(searchQuery.toLowerCase()) ||
             log.toolName.toLowerCase().includes(searchQuery.toLowerCase()) ||
             log.principal.toLowerCase().includes(searchQuery.toLowerCase()) ||
             log.targetServer.toLowerCase().includes(searchQuery.toLowerCase());
    }
    return true;
  });

  return (
    <div className="space-y-6 animate-fadeIn">
      {/* Top Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-3">
            <h1 className="text-xl font-bold tracking-tight text-slate-100">Audit Logs</h1>
            <span className="text-[11px] font-mono bg-brand-surface border border-brand-border text-slate-300 px-2 py-0.5 rounded font-medium">
              RFC-9482 Compliant
            </span>
          </div>
          <p className="text-xs text-slate-400 mt-1 max-w-3xl leading-relaxed">
            Inspect real-time tool calls, strict zero-trust policy decisions, and execution traces across gateway routes.
          </p>
        </div>

        {/* Header Action Buttons */}
        <div className="flex items-center gap-2.5">
          <button 
            onClick={() => setIsLiveStreaming(!isLiveStreaming)}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg border text-xs font-mono font-medium transition ${
              isLiveStreaming 
                ? 'bg-emerald-950/60 border-emerald-800/80 text-emerald-400' 
                : 'bg-brand-card border-brand-border text-slate-400'
            }`}
          >
            <span className={`w-2 h-2 rounded-full ${isLiveStreaming ? 'bg-emerald-400 animate-pulse' : 'bg-slate-500'}`}></span>
            <span>Live Stream {isLiveStreaming ? 'ON' : 'OFF'}</span>
          </button>
          <button 
            onClick={handleRefresh}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-brand-card hover:bg-brand-surface border border-brand-border text-xs text-slate-300 font-mono transition"
          >
            <RefreshCw className={`w-3.5 h-3.5 ${isRefreshing ? 'animate-spin text-emerald-400' : 'text-slate-400'}`} />
            <span>Refresh</span>
          </button>
          <button 
            className="flex items-center gap-1.5 px-3.5 py-1.5 rounded-lg bg-emerald-500 hover:bg-emerald-600 text-slate-950 font-semibold text-xs shadow-md shadow-emerald-500/20 transition cursor-pointer font-mono"
          >
            <Download className="w-3.5 h-3.5" />
            <span>Export ↓</span>
          </button>
        </div>
      </div>

      {/* 4 Stat Metric Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
          <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
            Total Invocations (24h)
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold font-mono text-slate-100">48,241</span>
            <span className="text-xs text-emerald-400 font-mono">+12.4%</span>
          </div>
          <div className="text-[11px] text-slate-400 font-mono mt-2">
            Across 3 MCP upstream clusters
          </div>
        </div>

        <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
          <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
            Successful Invocations
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold font-mono text-slate-100">47,896</span>
            <span className="text-xs text-emerald-400 font-mono">99.28%</span>
          </div>
          <div className="text-[11px] text-slate-400 font-mono mt-2 flex items-center gap-1">
            <span className="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
            Within SLA thresholds
          </div>
        </div>

        <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
          <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
            Policy Denials / Blocks
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold font-mono text-red-400">312</span>
            <span className="text-[10px] font-mono bg-red-950 text-red-400 border border-red-800/60 px-1.5 py-0.2 rounded font-semibold">
              Explicit Deny
            </span>
          </div>
          <div className="text-[11px] text-slate-400 font-mono mt-2">
            Enforced via Zero-Trust Policy #4
          </div>
        </div>

        <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
          <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
            Avg Roundtrip Latency
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold font-mono text-slate-100">142 ms</span>
            <span className="text-xs text-slate-400 font-mono">p95: 380ms</span>
          </div>
          <div className="text-[11px] text-slate-400 font-mono mt-2">
            Gateway overhead: <span className="text-emerald-400 font-semibold">~1.8ms median</span>
          </div>
        </div>
      </div>

      {/* Filter Row Controls */}
      <div className="p-4 rounded-xl bg-brand-card border border-brand-border space-y-3">
        <div className="grid grid-cols-1 md:grid-cols-6 gap-3">
          {/* Search */}
          <div className="md:col-span-2 relative">
            <Search className="w-3.5 h-3.5 text-slate-400 absolute left-3 top-2.5 pointer-events-none" />
            <input 
              type="text"
              placeholder="Filter by Correlation ID, tool name..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="bg-brand-surface border border-brand-border text-xs text-slate-200 placeholder-slate-400 pl-8 pr-4 py-1.5 rounded-lg focus:outline-none focus:border-emerald-500/50 w-full font-mono"
            />
          </div>

          {/* Time Filter */}
          <div className="flex items-center justify-between px-3 py-1.5 rounded-lg bg-brand-surface border border-brand-border text-xs font-mono text-slate-300 cursor-pointer">
            <span>Last 24 Hours</span>
            <ChevronDown className="w-3.5 h-3.5 text-slate-400" />
          </div>

          {/* Principals */}
          <div className="flex items-center justify-between px-3 py-1.5 rounded-lg bg-brand-surface border border-brand-border text-xs font-mono text-slate-300 cursor-pointer">
            <span>Principals (All)</span>
            <ChevronDown className="w-3.5 h-3.5 text-slate-400" />
          </div>

          {/* Servers */}
          <div className="flex items-center justify-between px-3 py-1.5 rounded-lg bg-brand-surface border border-brand-border text-xs font-mono text-slate-300 cursor-pointer">
            <span>Servers (3)</span>
            <ChevronDown className="w-3.5 h-3.5 text-slate-400" />
          </div>

          {/* Outcome Filter */}
          <div className="flex items-center gap-1 p-0.5 rounded-lg bg-brand-surface border border-brand-border text-[11px] font-mono">
            <button
              onClick={() => setSelectedOutcome('all')}
              className={`flex-1 py-1 rounded transition text-center ${selectedOutcome === 'all' ? 'bg-emerald-500 text-slate-950 font-bold' : 'text-slate-400'}`}
            >
              All
            </button>
            <button
              onClick={() => setSelectedOutcome('success')}
              className={`flex-1 py-1 rounded transition text-center ${selectedOutcome === 'success' ? 'bg-emerald-500 text-slate-950 font-bold' : 'text-slate-400'}`}
            >
              200
            </button>
            <button
              onClick={() => setSelectedOutcome('blocked')}
              className={`flex-1 py-1 rounded transition text-center ${selectedOutcome === 'blocked' ? 'bg-red-500 text-white font-bold' : 'text-slate-400'}`}
            >
              403
            </button>
          </div>
        </div>

        {/* Active Filter Chips */}
        <div className="flex items-center justify-between pt-2 border-t border-brand-border/60 text-[11px] font-mono">
          <div className="flex items-center gap-2">
            <span className="text-slate-400">ACTIVE:</span>
            <span className="px-2 py-0.5 rounded bg-brand-surface border border-brand-border text-slate-300">
              Time: 24h ✕
            </span>
            <span className="px-2 py-0.5 rounded bg-brand-surface border border-brand-border text-slate-300">
              Route: All Active Upstreams ✕
            </span>
            <span className="px-2 py-0.5 rounded bg-emerald-950/60 border border-emerald-800/60 text-emerald-400 font-semibold">
              Audit Policy: Enabled ✕
            </span>
            <button 
              onClick={() => { setSearchQuery(''); setSelectedOutcome('all'); }}
              className="text-slate-400 hover:text-slate-200 underline ml-2 cursor-pointer"
            >
              Clear all
            </button>
          </div>
          <div className="text-slate-400">
            Buffer: 1,000 in-memory • Engine: <span className="text-emerald-400 font-semibold">Synced</span>
          </div>
        </div>
      </div>

      {/* Audit Logs Table */}
      <div className="rounded-xl bg-brand-card border border-brand-border overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs font-mono">
            <thead>
              <tr className="border-b border-brand-border bg-brand-surface/30 text-slate-400 text-[10px] uppercase">
                <th className="py-3 px-4 font-semibold">Timestamp</th>
                <th className="py-3 px-4 font-semibold">Correlation ID</th>
                <th className="py-3 px-4 font-semibold">Principal</th>
                <th className="py-3 px-4 font-semibold">Server</th>
                <th className="py-3 px-4 font-semibold">Tool Name</th>
                <th className="py-3 px-4 font-semibold">Duration</th>
                <th className="py-3 px-4 font-semibold">Outcome</th>
                <th className="py-3 px-4 font-semibold text-right">Action</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-brand-border/60">
              {filteredLogs.map((log) => {
                const isDenied = log.status.includes('403') || log.status.includes('Blocked');
                return (
                  <tr 
                    key={log.id}
                    onClick={() => onSelectLog(log)}
                    className="hover:bg-brand-surface/40 transition cursor-pointer group"
                  >
                    <td className="py-3 px-4 text-slate-400 whitespace-nowrap">
                      <div>{log.timestamp}</div>
                      <div className="text-[10px] text-slate-400">{log.timeAgo}</div>
                    </td>
                    <td className="py-3 px-4 text-emerald-400 font-semibold whitespace-nowrap">
                      <span className="p-1 rounded bg-[#070c14] border border-brand-border group-hover:border-emerald-500/40 transition">
                        {log.correlationId}
                      </span>
                    </td>
                    <td className="py-3 px-4 text-slate-200 whitespace-nowrap">
                      <div className="flex items-center gap-2">
                        {log.avatarUrl ? (
                          <img src={log.avatarUrl} className="w-5 h-5 rounded-full object-cover shrink-0" />
                        ) : (
                          <div className="w-5 h-5 rounded-full bg-slate-800 text-[10px] flex items-center justify-center shrink-0">
                            🤖
                          </div>
                        )}
                        <div>
                          <div className="font-semibold text-slate-100">{log.principal}</div>
                          <div className="text-[10px] text-slate-400">{log.clientAgent}</div>
                        </div>
                      </div>
                    </td>
                    <td className="py-3 px-4 text-slate-300 font-semibold whitespace-nowrap">
                      {log.targetServer}
                    </td>
                    <td className="py-3 px-4 whitespace-nowrap">
                      <span className={isDenied ? 'text-red-400 font-semibold' : 'text-emerald-400'}>
                        {log.toolName}
                      </span>
                    </td>
                    <td className="py-3 px-4 text-slate-400 whitespace-nowrap">
                      {log.durationMs}ms
                    </td>
                    <td className="py-3 px-4 whitespace-nowrap">
                      <span className={`px-2 py-0.5 rounded text-[10px] font-semibold ${
                        isDenied 
                          ? 'bg-red-950 text-red-400 border border-red-800/60'
                          : 'bg-emerald-950 text-emerald-400 border border-emerald-800/60'
                      }`}>
                        {log.status}
                      </span>
                    </td>
                    <td className="py-3 px-4 text-right whitespace-nowrap">
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          onSelectLog(log);
                        }}
                        className="text-[11px] text-slate-400 hover:text-emerald-400 flex items-center gap-1 ml-auto font-medium"
                      >
                        <span>Trace</span>
                        <ExternalLink className="w-3 h-3" />
                      </button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>

        {/* Table Footer / Pagination */}
        <div className="p-3 border-t border-brand-border bg-[#070b13] flex items-center justify-between text-xs font-mono text-slate-400">
          <div>
            Showing <span className="text-slate-200 font-semibold">1-8</span> of <span className="text-slate-200 font-semibold">{logs.length}</span> events
          </div>
          <div className="flex items-center gap-1.5">
            <span className="px-2 py-1 rounded bg-emerald-500 text-slate-950 font-bold">1</span>
            <span className="px-2 py-1 rounded hover:bg-brand-surface cursor-pointer">2</span>
            <span className="px-2 py-1 rounded hover:bg-brand-surface cursor-pointer">3</span>
          </div>
        </div>
      </div>
    </div>
  );
};
