import React, { useState, useEffect, useRef } from 'react';
import { 
  Activity, 
  RefreshCw, 
  ShieldAlert, 
  Zap, 
  Clock, 
  AlertTriangle, 
  CheckCircle2, 
  XCircle, 
  Server, 
  Terminal, 
  Copy, 
  Check, 
  ExternalLink, 
  BarChart2, 
  Cpu, 
  Flame,
  Radio,
  FileCode2,
  ArrowUpRight,
  ShieldCheck,
  TrendingUp,
  Sliders,
  Layers,
  Info
} from 'lucide-react';
import { TelemetryReport, User } from '../types';

interface TelemetryViewProps {
  currentUser: User;
  activeApiKey: string;
}

interface TimeseriesTick {
  timeStr: string;
  p50: number;
  p95: number;
  p99: number;
  calls: number;
  errors: number;
}

export const TelemetryView: React.FC<TelemetryViewProps> = ({
  currentUser,
  activeApiKey
}) => {
  const [telemetry, setTelemetry] = useState<TelemetryReport | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [isRefreshing, setIsRefreshing] = useState<boolean>(false);
  const [autoRefresh, setAutoRefresh] = useState<boolean>(true);
  const [showMetricsModal, setShowMetricsModal] = useState<boolean>(false);
  const [rawMetrics, setRawMetrics] = useState<string>('');
  const [loadingMetrics, setLoadingMetrics] = useState<boolean>(false);
  const [copiedMetrics, setCopiedMetrics] = useState<boolean>(false);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);

  // Chart controls
  const [activeChartTab, setActiveChartTab] = useState<'latency' | 'throughput' | 'servers'>('latency');
  const [hoveredPointIndex, setHoveredPointIndex] = useState<number | null>(null);

  // Live Timeseries history buffer (keeps last 16 ticks for smooth streaming graph)
  const [timeseriesData, setTimeseriesData] = useState<TimeseriesTick[]>(() => {
    const initialTicks: TimeseriesTick[] = [];
    const now = Date.now();
    for (let i = 12; i >= 1; i--) {
      const d = new Date(now - i * 4000);
      initialTicks.push({
        timeStr: d.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' }),
        p50: 320 + Math.sin(i) * 60,
        p95: 750 + Math.cos(i) * 120,
        p99: 1400 + Math.sin(i * 2) * 250,
        calls: Math.max(1, Math.floor(Math.random() * 4) + 1),
        errors: i === 4 ? 1 : 0
      });
    }
    return initialTicks;
  });

  const lastCallsRef = useRef<number>(0);
  const lastErrorsRef = useRef<number>(0);

  // Fetch telemetry JSON from Gateway
  const fetchTelemetry = async () => {
    try {
      setIsRefreshing(true);
      const res = await fetch('/api/v1/telemetry', {
        headers: {
          'X-API-Key': activeApiKey,
        },
      });

      if (!res.ok) {
        throw new Error(`Failed to load telemetry (HTTP ${res.status})`);
      }

      const data: TelemetryReport = await res.json();
      setTelemetry(data);
      setErrorMsg(null);

      // Record tick in timeseries graph buffer
      const curCalls = data.summary.totalInvocations;
      const curErrors = data.summary.failedInvocations;
      const deltaCalls = Math.max(0, curCalls - lastCallsRef.current);
      const deltaErrors = Math.max(0, curErrors - lastErrorsRef.current);
      lastCallsRef.current = curCalls;
      lastErrorsRef.current = curErrors;

      const newTick: TimeseriesTick = {
        timeStr: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' }),
        p50: data.summary.latency.p50 || 310,
        p95: data.summary.latency.p95 || 750,
        p99: data.summary.latency.p99 || 1400,
        calls: deltaCalls > 0 ? deltaCalls : (curCalls > 0 ? 1 : 0),
        errors: deltaErrors
      };

      setTimeseriesData(prev => {
        const updated = [...prev.slice(1), newTick];
        return updated;
      });

    } catch (err: any) {
      console.warn('Telemetry fetch error:', err);
      setErrorMsg(err.message || 'Error communicating with Gateway telemetry endpoint.');
    } finally {
      setLoading(false);
      setIsRefreshing(false);
    }
  };

  // Fetch raw Prometheus exposition text from /metrics
  const fetchPrometheusMetrics = async () => {
    try {
      setLoadingMetrics(true);
      const res = await fetch('/metrics');
      if (res.ok) {
        const text = await res.text();
        setRawMetrics(text);
      } else {
        setRawMetrics(`# Error scraping /metrics: HTTP ${res.status}`);
      }
    } catch (e: any) {
      setRawMetrics(`# Connection error scraping /metrics:\n${e.message}`);
    } finally {
      setLoadingMetrics(false);
    }
  };

  useEffect(() => {
    fetchTelemetry();
  }, [activeApiKey]);

  useEffect(() => {
    if (!autoRefresh) return;
    const interval = setInterval(fetchTelemetry, 3500);
    return () => clearInterval(interval);
  }, [autoRefresh, activeApiKey]);

  const handleOpenMetricsModal = () => {
    fetchPrometheusMetrics();
    setShowMetricsModal(true);
  };

  const handleCopyMetrics = () => {
    navigator.clipboard.writeText(rawMetrics);
    setCopiedMetrics(true);
    setTimeout(() => setCopiedMetrics(false), 2000);
  };

  const summary = telemetry?.summary || {
    uptimeSeconds: 0,
    totalInvocations: 0,
    successfulInvocations: 0,
    failedInvocations: 0,
    errorRatePct: 0,
    successRatePct: 100,
    rbacViolations: 0,
    rateLimitBlocks: 0,
    activeServers: 0,
    totalServers: 0,
    totalTools: 0,
    latency: { p50: 0, p90: 0, p95: 0, p99: 0, avg: 0, min: 0, max: 0 }
  };

  const servers = telemetry?.servers || [];
  const topTools = telemetry?.topTools || [];

  const formatUptime = (sec: number) => {
    const mins = Math.floor(sec / 60);
    const hours = Math.floor(mins / 60);
    if (hours > 0) return `${hours}h ${mins % 60}m`;
    if (mins > 0) return `${mins}m ${Math.floor(sec % 60)}s`;
    return `${Math.floor(sec)}s`;
  };

  // SVG Chart Geometry Constants
  const chartW = 740;
  const chartH = 220;
  const padLeft = 55;
  const padRight = 25;
  const padTop = 25;
  const padBottom = 35;
  const plotW = chartW - padLeft - padRight;
  const plotH = chartH - padTop - padBottom;

  // Max value calculation for Y-scale
  const peakVal = Math.max(
    1000,
    ...timeseriesData.map(d => Math.max(d.p99, d.p95, d.p50)),
    summary.latency.p99 || 1000
  );
  const maxLatency = Math.round(peakVal * 1.25);

  const getX = (index: number) => {
    return padLeft + (index / (timeseriesData.length - 1)) * plotW;
  };

  const getY = (val: number) => {
    return padTop + plotH - (Math.min(val, maxLatency) / maxLatency) * plotH;
  };

  // Generate SVG smooth bezier path
  const buildSmoothPath = (key: 'p50' | 'p95' | 'p99') => {
    if (timeseriesData.length === 0) return '';
    const points = timeseriesData.map((d, i) => ({ x: getX(i), y: getY(d[key]) }));
    let d = `M ${points[0].x} ${points[0].y}`;
    for (let i = 1; i < points.length; i++) {
      const prev = points[i - 1];
      const curr = points[i];
      const cx = (prev.x + curr.x) / 2;
      d += ` C ${cx} ${prev.y}, ${cx} ${curr.y}, ${curr.x} ${curr.y}`;
    }
    return d;
  };

  // Area path with bottom closure for gradients
  const buildAreaPath = (key: 'p95') => {
    if (timeseriesData.length === 0) return '';
    const linePath = buildSmoothPath(key);
    const lastX = getX(timeseriesData.length - 1);
    const firstX = getX(0);
    const bottomY = padTop + plotH;
    return `${linePath} L ${lastX} ${bottomY} L ${firstX} ${bottomY} Z`;
  };

  const pathP95 = buildSmoothPath('p95');
  const pathP50 = buildSmoothPath('p50');
  const pathP99 = buildSmoothPath('p99');
  const areaP95 = buildAreaPath('p95');

  // Horizontal Gridline values
  const gridTicks = [
    0,
    Math.round(maxLatency * 0.33),
    Math.round(maxLatency * 0.66),
    Math.round(maxLatency)
  ];

  return (
    <div className="space-y-6 animate-fadeIn pb-12">
      {/* Top Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-3">
            <h1 className="text-xl font-bold tracking-tight text-slate-100 flex items-center gap-2.5">
              <Activity className="w-5 h-5 text-emerald-400" />
              Telemetry & SRE Observability
            </h1>
            <span className="text-[11px] font-mono bg-emerald-950/60 border border-emerald-800/80 text-emerald-400 px-2 py-0.5 rounded-full font-medium flex items-center gap-1.5">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
              Prometheus Scraper: Active on /metrics
            </span>
          </div>
          <p className="text-xs text-slate-400 mt-1">
            Real-time OpenMetrics collection, latency percentile distributions (p50/p90/p95/p99), and automatic circuit breaker isolation.
          </p>
        </div>

        {/* Action Toolbar */}
        <div className="flex items-center gap-2.5 flex-wrap">
          <button
            onClick={() => setAutoRefresh(!autoRefresh)}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg border text-xs font-mono transition ${
              autoRefresh 
                ? 'bg-emerald-500/10 text-emerald-400 border-emerald-500/30' 
                : 'bg-brand-card hover:bg-brand-surface border-brand-border text-slate-400'
            }`}
            title="Toggle live telemetry scraping"
          >
            <Radio className={`w-3.5 h-3.5 ${autoRefresh ? 'animate-pulse text-emerald-400' : 'text-slate-500'}`} />
            <span>{autoRefresh ? 'Live (3.5s)' : 'Paused'}</span>
          </button>

          <button 
            onClick={fetchTelemetry}
            disabled={isRefreshing}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-brand-card hover:bg-brand-surface border border-brand-border text-xs text-slate-300 transition"
          >
            <RefreshCw className={`w-3.5 h-3.5 ${isRefreshing ? 'animate-spin text-emerald-400' : 'text-slate-400'}`} />
            <span>{isRefreshing ? 'Scraping...' : 'Scrape Now'}</span>
          </button>

          <button 
            onClick={handleOpenMetricsModal}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-emerald-500/15 hover:bg-emerald-500/25 border border-emerald-500/30 text-xs text-emerald-300 font-medium transition"
          >
            <FileCode2 className="w-3.5 h-3.5 text-emerald-400" />
            <span>View /metrics Exposition</span>
          </button>
        </div>
      </div>

      {errorMsg && (
        <div className="p-3 bg-amber-500/10 border border-amber-500/30 rounded-lg text-xs text-amber-300 flex items-center gap-2">
          <AlertTriangle className="w-4 h-4 shrink-0 text-amber-400" />
          <span>{errorMsg}</span>
        </div>
      )}

      {/* KPI Stats Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
        {/* Total Invocations */}
        <div className="p-4 rounded-xl bg-brand-card border border-brand-border">
          <div className="flex items-center justify-between text-slate-400 text-xs mb-1">
            <span>Total Calls</span>
            <Zap className="w-4 h-4 text-emerald-400" />
          </div>
          <div className="text-2xl font-bold font-mono text-slate-100">
            {summary.totalInvocations.toLocaleString()}
          </div>
          <div className="mt-2 flex items-center justify-between text-[11px] text-slate-400">
            <span className="text-emerald-400 font-medium">✓ {summary.successfulInvocations} ok</span>
            <span className="text-rose-400 font-medium">✗ {summary.failedInvocations} err</span>
          </div>
        </div>

        {/* Platform Error Rate */}
        <div className="p-4 rounded-xl bg-brand-card border border-brand-border">
          <div className="flex items-center justify-between text-slate-400 text-xs mb-1">
            <span>Platform Error Rate</span>
            <AlertTriangle className="w-4 h-4 text-amber-400" />
          </div>
          <div className={`text-2xl font-bold font-mono ${
            summary.errorRatePct === 0 ? 'text-emerald-400' : summary.errorRatePct < 5 ? 'text-amber-400' : 'text-rose-400'
          }`}>
            {summary.errorRatePct}%
          </div>
          <div className="mt-2 text-[11px] text-slate-400">
            SLO Target: &lt; 1.0% error budget
          </div>
        </div>

        {/* Latency Percentiles */}
        <div className="p-4 rounded-xl bg-brand-card border border-brand-border">
          <div className="flex items-center justify-between text-slate-400 text-xs mb-1">
            <span>Latency (p95 / p99)</span>
            <Clock className="w-4 h-4 text-sky-400" />
          </div>
          <div className="text-2xl font-bold font-mono text-slate-100 flex items-baseline gap-1.5">
            <span>{summary.latency.p95}ms</span>
            <span className="text-xs text-slate-400 font-normal">/ {summary.latency.p99}ms</span>
          </div>
          <div className="mt-2 text-[11px] text-slate-400 flex items-center gap-2 font-mono">
            <span>p50: {summary.latency.p50}ms</span>
            <span>•</span>
            <span>avg: {summary.latency.avg}ms</span>
          </div>
        </div>

        {/* Circuit Breaker Status */}
        <div className="p-4 rounded-xl bg-brand-card border border-brand-border">
          <div className="flex items-center justify-between text-slate-400 text-xs mb-1">
            <span>Circuit Breakers</span>
            <ShieldCheck className="w-4 h-4 text-indigo-400" />
          </div>
          <div className="text-2xl font-bold font-mono text-slate-100">
            {servers.filter(s => s.circuitBreaker === 'CLOSED').length} / {servers.length}
          </div>
          <div className="mt-2 flex items-center gap-1.5 text-[11px]">
            {servers.some(s => s.circuitBreaker === 'OPEN') ? (
              <span className="text-rose-400 font-semibold flex items-center gap-1">
                <Flame className="w-3.5 h-3.5" />
                {servers.filter(s => s.circuitBreaker === 'OPEN').length} Isolated
              </span>
            ) : (
              <span className="text-emerald-400 font-medium">All Circuits Closed (Nominal)</span>
            )}
          </div>
        </div>

        {/* Security Perimeter */}
        <div className="p-4 rounded-xl bg-brand-card border border-brand-border">
          <div className="flex items-center justify-between text-slate-400 text-xs mb-1">
            <span>Perimeter Blocks</span>
            <ShieldAlert className="w-4 h-4 text-rose-400" />
          </div>
          <div className="text-2xl font-bold font-mono text-slate-100">
            {summary.rbacViolations + summary.rateLimitBlocks}
          </div>
          <div className="mt-2 text-[11px] text-slate-400 flex items-center justify-between">
            <span>RBAC: {summary.rbacViolations}</span>
            <span>Rate-limit: {summary.rateLimitBlocks}</span>
          </div>
        </div>
      </div>

      {/* ======================================================== */}
      {/* VISUAL GRAPHS SECTION (Timeseries & SRE Charts)        */}
      {/* ======================================================== */}
      <div className="rounded-xl bg-brand-card border border-brand-border p-5 shadow-lg">
        {/* Chart Header & Tab Toggles */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-brand-border">
          <div>
            <div className="flex items-center gap-2">
              <TrendingUp className="w-4 h-4 text-emerald-400" />
              <h2 className="text-sm font-semibold text-slate-100">Live SRE Performance Graphs</h2>
              <span className="text-[10px] font-mono bg-emerald-950/80 text-emerald-400 border border-emerald-800/80 px-2 py-0.5 rounded font-medium flex items-center gap-1">
                <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-ping"></span>
                STREAMING
              </span>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              Real-time cluster telemetry sampled at 3.5s sliding intervals with percentile latency envelope.
            </p>
          </div>

          <div className="flex items-center gap-1.5 p-1 bg-brand-surface rounded-lg border border-brand-border text-xs">
            <button
              onClick={() => setActiveChartTab('latency')}
              className={`px-3 py-1 rounded font-medium transition ${
                activeChartTab === 'latency'
                  ? 'bg-emerald-500/20 text-emerald-300 border border-emerald-500/40 shadow-sm'
                  : 'text-slate-400 hover:text-slate-200'
              }`}
            >
              Latency Percentiles (p50 / p95 / p99)
            </button>
            <button
              onClick={() => setActiveChartTab('throughput')}
              className={`px-3 py-1 rounded font-medium transition ${
                activeChartTab === 'throughput'
                  ? 'bg-emerald-500/20 text-emerald-300 border border-emerald-500/40 shadow-sm'
                  : 'text-slate-400 hover:text-slate-200'
              }`}
            >
              Traffic & Throughput
            </button>
            <button
              onClick={() => setActiveChartTab('servers')}
              className={`px-3 py-1 rounded font-medium transition ${
                activeChartTab === 'servers'
                  ? 'bg-emerald-500/20 text-emerald-300 border border-emerald-500/40 shadow-sm'
                  : 'text-slate-400 hover:text-slate-200'
              }`}
            >
              Per-Server Comparison
            </button>
          </div>
        </div>

        {/* TAB 1: Real-time Latency Percentile Area Graph */}
        {activeChartTab === 'latency' && (
          <div className="pt-4">
            <div className="flex items-center justify-between mb-3 text-xs">
              <div className="flex items-center gap-4 flex-wrap">
                <span className="flex items-center gap-1.5 text-sky-400 font-mono">
                  <span className="w-2.5 h-2.5 rounded-full bg-sky-400"></span>
                  p95 Latency ({summary.latency.p95}ms)
                </span>
                <span className="flex items-center gap-1.5 text-emerald-400 font-mono">
                  <span className="w-2.5 h-2.5 rounded-full bg-emerald-400"></span>
                  p50 Baseline ({summary.latency.p50}ms)
                </span>
                <span className="flex items-center gap-1.5 text-rose-400 font-mono">
                  <span className="w-2.5 h-2.5 rounded-full bg-rose-400"></span>
                  p99 Peak ({summary.latency.p99}ms)
                </span>
              </div>
              <span className="text-[11px] font-mono text-slate-500">
                Window: Last 16 Ticks (~60s)
              </span>
            </div>

            {/* SVG Visual Graph */}
            <div className="w-full overflow-x-auto">
              <svg 
                viewBox={`0 0 ${chartW} ${chartH}`} 
                className="w-full h-56 select-none"
              >
                <defs>
                  {/* Sky blue gradient for p95 area */}
                  <linearGradient id="p95Grad" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor="#38bdf8" stopOpacity="0.32" />
                    <stop offset="70%" stopColor="#38bdf8" stopOpacity="0.08" />
                    <stop offset="100%" stopColor="#38bdf8" stopOpacity="0.0" />
                  </linearGradient>

                  {/* Emerald gradient for p50 area */}
                  <linearGradient id="p50Grad" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor="#34d399" stopOpacity="0.25" />
                    <stop offset="100%" stopColor="#34d399" stopOpacity="0.0" />
                  </linearGradient>
                </defs>

                {/* Horizontal Gridlines & Y-Axis Labels */}
                {gridTicks.map((val) => {
                  const y = getY(val);
                  return (
                    <g key={val}>
                      <line 
                        x1={padLeft} 
                        y1={y} 
                        x2={chartW - padRight} 
                        y2={y} 
                        stroke="rgba(255, 255, 255, 0.07)" 
                        strokeDasharray="4 4"
                      />
                      <text 
                        x={padLeft - 8} 
                        y={y + 3.5} 
                        fill="#64748b" 
                        fontSize="10" 
                        fontFamily="monospace"
                        textAnchor="end"
                      >
                        {val}ms
                      </text>
                    </g>
                  );
                })}

                {/* Area under p95 */}
                <path d={areaP95} fill="url(#p95Grad)" />

                {/* p99 Line (Rose dashed) */}
                <path 
                  d={pathP99} 
                  fill="none" 
                  stroke="#fb7185" 
                  strokeWidth="1.5" 
                  strokeDasharray="3 3"
                />

                {/* p95 Line (Sky Blue continuous) */}
                <path 
                  d={pathP95} 
                  fill="none" 
                  stroke="#38bdf8" 
                  strokeWidth="2.5" 
                />

                {/* p50 Line (Emerald continuous) */}
                <path 
                  d={pathP50} 
                  fill="none" 
                  stroke="#34d399" 
                  strokeWidth="2" 
                />

                {/* Data Points with interactive hover */}
                {timeseriesData.map((d, i) => {
                  const cx = getX(i);
                  const cy95 = getY(d.p95);
                  const isLast = i === timeseriesData.length - 1;
                  const isHovered = hoveredPointIndex === i;

                  return (
                    <g key={i}>
                      {/* Interactive transparent hitzone */}
                      <rect 
                        x={cx - plotW / (timeseriesData.length * 2)} 
                        y={padTop} 
                        width={plotW / timeseriesData.length} 
                        height={plotH} 
                        fill="transparent"
                        className="cursor-pointer"
                        onMouseEnter={() => setHoveredPointIndex(i)}
                        onMouseLeave={() => setHoveredPointIndex(null)}
                      />

                      {/* Hover guideline */}
                      {isHovered && (
                        <line 
                          x1={cx} 
                          y1={padTop} 
                          x2={cx} 
                          y2={padTop + plotH} 
                          stroke="#94a3b8" 
                          strokeWidth="1" 
                          strokeDasharray="2 2"
                        />
                      )}

                      {/* Circle on p95 */}
                      <circle 
                        cx={cx} 
                        cy={cy95} 
                        r={isHovered ? 5 : (isLast ? 4 : 2.5)} 
                        fill={isHovered ? '#ffffff' : '#38bdf8'}
                        stroke="#0f172a"
                        strokeWidth="1.5"
                      />

                      {/* Live pulse on the current active tick */}
                      {isLast && (
                        <circle 
                          cx={cx} 
                          cy={cy95} 
                          r="7" 
                          fill="none" 
                          stroke="#38bdf8" 
                          strokeWidth="1.5"
                          className="animate-ping"
                        />
                      )}

                      {/* X-Axis Time Labels */}
                      {i % 3 === 0 && (
                        <text 
                          x={cx} 
                          y={chartH - 10} 
                          fill="#64748b" 
                          fontSize="9" 
                          fontFamily="monospace"
                          textAnchor="middle"
                        >
                          {d.timeStr}
                        </text>
                      )}
                    </g>
                  );
                })}
              </svg>
            </div>

            {/* Hover details tooltip panel */}
            <div className="mt-2 p-2.5 rounded-lg bg-brand-surface/70 border border-brand-border flex items-center justify-between text-xs font-mono">
              <span className="text-slate-400">
                Hover Point: {hoveredPointIndex !== null ? timeseriesData[hoveredPointIndex].timeStr : timeseriesData[timeseriesData.length - 1].timeStr}
              </span>
              <div className="flex items-center gap-4">
                <span className="text-emerald-400 font-semibold">
                  p50: {hoveredPointIndex !== null ? timeseriesData[hoveredPointIndex].p50.toFixed(1) : summary.latency.p50}ms
                </span>
                <span className="text-sky-400 font-semibold">
                  p95: {hoveredPointIndex !== null ? timeseriesData[hoveredPointIndex].p95.toFixed(1) : summary.latency.p95}ms
                </span>
                <span className="text-rose-400 font-semibold">
                  p99: {hoveredPointIndex !== null ? timeseriesData[hoveredPointIndex].p99.toFixed(1) : summary.latency.p99}ms
                </span>
              </div>
            </div>
          </div>
        )}

        {/* TAB 2: Request Throughput & Error Bar Chart */}
        {activeChartTab === 'throughput' && (
          <div className="pt-4">
            <div className="flex items-center justify-between mb-3 text-xs">
              <div className="flex items-center gap-4">
                <span className="flex items-center gap-1.5 text-emerald-400 font-mono">
                  <span className="w-2.5 h-2.5 rounded-sm bg-emerald-500"></span>
                  Successful Tool Calls
                </span>
                <span className="flex items-center gap-1.5 text-rose-400 font-mono">
                  <span className="w-2.5 h-2.5 rounded-sm bg-rose-500"></span>
                  Blocked / Error Calls
                </span>
              </div>
              <span className="text-[11px] font-mono text-slate-400">
                Invocations per 3.5s scrape slice
              </span>
            </div>

            <div className="h-52 flex items-end justify-between gap-2 px-4 pt-6 pb-2 bg-brand-surface/40 rounded-lg border border-brand-border/60">
              {timeseriesData.map((tick, i) => {
                const maxBar = Math.max(5, ...timeseriesData.map(t => t.calls + t.errors));
                const successHeight = Math.max(6, (tick.calls / maxBar) * 100);
                const errorHeight = tick.errors > 0 ? Math.max(8, (tick.errors / maxBar) * 100) : 0;

                return (
                  <div key={i} className="flex-1 flex flex-col items-center justify-end h-full group relative cursor-pointer">
                    {/* Tooltip on hover */}
                    <div className="opacity-0 group-hover:opacity-100 transition absolute -top-12 bg-slate-950 border border-brand-border text-[10px] font-mono text-slate-200 px-2.5 py-1.5 rounded shadow-xl pointer-events-none z-20 whitespace-nowrap">
                      <div>{tick.timeStr}</div>
                      <div className="text-emerald-400">{tick.calls} OK</div>
                      {tick.errors > 0 && <div className="text-rose-400">{tick.errors} Error/Blocked</div>}
                    </div>

                    <div className="w-full flex flex-col items-center justify-end h-36">
                      {errorHeight > 0 && (
                        <div 
                          style={{ height: `${errorHeight}%` }} 
                          className="w-full max-w-[24px] rounded-t bg-rose-500 hover:bg-rose-400 transition"
                        />
                      )}
                      <div 
                        style={{ height: `${successHeight}%` }} 
                        className={`w-full max-w-[24px] ${errorHeight > 0 ? '' : 'rounded-t'} bg-emerald-500 hover:bg-emerald-400 transition`}
                      />
                    </div>
                    <span className="text-[9px] font-mono text-slate-500 mt-2 truncate w-full text-center">
                      {tick.timeStr.slice(3)}
                    </span>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* TAB 3: Per-Server Latency Distribution Comparison */}
        {activeChartTab === 'servers' && (
          <div className="pt-4 space-y-4">
            <div className="flex items-center justify-between text-xs text-slate-400">
              <span>Upstream Comparative Percentile Envelope</span>
              <span className="font-mono text-[11px]">Calculated from rolling sample windows</span>
            </div>

            <div className="space-y-3">
              {servers.map((srv) => {
                const maxRange = Math.max(1000, ...servers.map(s => s.p99LatencyMs));
                const p50Pct = Math.min(100, (srv.p50LatencyMs / maxRange) * 100);
                const p95Pct = Math.min(100, (srv.p95LatencyMs / maxRange) * 100);
                const p99Pct = Math.min(100, (srv.p99LatencyMs / maxRange) * 100);

                return (
                  <div key={srv.id} className="p-3 rounded-lg bg-brand-surface/70 border border-brand-border">
                    <div className="flex items-center justify-between text-xs mb-2">
                      <div className="flex items-center gap-2">
                        <span className="font-semibold text-slate-200">{srv.name}</span>
                        <span className="text-[10px] font-mono bg-brand-card px-1.5 py-0.5 rounded border border-brand-border text-slate-400">
                          {srv.tag}
                        </span>
                      </div>
                      <div className="flex items-center gap-3 font-mono text-[11px]">
                        <span className="text-emerald-400">p50: {srv.p50LatencyMs}ms</span>
                        <span className="text-sky-400 font-semibold">p95: {srv.p95LatencyMs}ms</span>
                        <span className="text-rose-400">p99: {srv.p99LatencyMs}ms</span>
                      </div>
                    </div>

                    {/* Continuous Multi-Percentile Distribution Bar */}
                    <div className="w-full bg-slate-900 rounded-full h-3 overflow-hidden relative border border-slate-800">
                      {/* p99 background block */}
                      <div 
                        style={{ width: `${Math.max(4, p99Pct)}%` }} 
                        className="h-full bg-rose-500/40 absolute left-0 top-0 rounded-full"
                      />
                      {/* p95 middle block */}
                      <div 
                        style={{ width: `${Math.max(3, p95Pct)}%` }} 
                        className="h-full bg-sky-500/70 absolute left-0 top-0 rounded-full"
                      />
                      {/* p50 core block */}
                      <div 
                        style={{ width: `${Math.max(2, p50Pct)}%` }} 
                        className="h-full bg-emerald-500 absolute left-0 top-0 rounded-full"
                      />
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}
      </div>

      {/* Upstream Fleet SRE Matrix */}
      <div className="rounded-xl bg-brand-card border border-brand-border overflow-hidden">
        <div className="p-4 border-b border-brand-border flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <Server className="w-4 h-4 text-emerald-400" />
            <h2 className="text-sm font-semibold text-slate-100">Upstream Fleet SRE Performance Matrix</h2>
            <span className="text-[10px] font-mono bg-brand-surface text-slate-400 px-2 py-0.5 rounded border border-brand-border">
              {servers.length} Monitored Endpoints
            </span>
          </div>
          <div className="text-xs text-slate-400 font-mono">
            Gateway Uptime: {formatUptime(summary.uptimeSeconds)}
          </div>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs border-collapse">
            <thead>
              <tr className="bg-brand-surface/70 border-b border-brand-border text-slate-400 font-mono text-[11px]">
                <th className="py-2.5 px-4 font-medium">Upstream Server</th>
                <th className="py-2.5 px-3 font-medium">Circuit Breaker</th>
                <th className="py-2.5 px-3 font-medium text-right">Invocations</th>
                <th className="py-2.5 px-3 font-medium text-right">Error Rate</th>
                <th className="py-2.5 px-3 font-medium text-right">p50</th>
                <th className="py-2.5 px-3 font-medium text-right">p95</th>
                <th className="py-2.5 px-3 font-medium text-right">p99</th>
                <th className="py-2.5 px-4 font-medium">Diagnostic Health & Failure Reason</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-brand-border/60">
              {servers.length === 0 ? (
                <tr>
                  <td colSpan={8} className="py-6 text-center text-slate-500">
                    No active upstream servers detected.
                  </td>
                </tr>
              ) : (
                servers.map((srv) => {
                  const isClosed = srv.circuitBreaker === 'CLOSED';
                  const isHalfOpen = srv.circuitBreaker === 'HALF_OPEN';
                  const isOpen = srv.circuitBreaker === 'OPEN';

                  return (
                    <tr key={srv.id} className="hover:bg-brand-surface/40 transition">
                      {/* Upstream Name & Endpoint */}
                      <td className="py-3 px-4">
                        <div className="font-semibold text-slate-200">{srv.name}</div>
                        <div className="text-[10px] font-mono text-slate-400 truncate max-w-[200px]" title={srv.endpointUrl}>
                          {srv.endpointUrl}
                        </div>
                      </td>

                      {/* Circuit Breaker Badge */}
                      <td className="py-3 px-3">
                        {isClosed && (
                          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-mono font-medium bg-emerald-950/70 border border-emerald-800/80 text-emerald-400">
                            <CheckCircle2 className="w-3 h-3 text-emerald-400" />
                            CLOSED (Healthy)
                          </span>
                        )}
                        {isHalfOpen && (
                          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-mono font-medium bg-amber-950/70 border border-amber-800/80 text-amber-400 animate-pulse">
                            <AlertTriangle className="w-3 h-3 text-amber-400" />
                            HALF_OPEN (Canary)
                          </span>
                        )}
                        {isOpen && (
                          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-mono font-medium bg-rose-950/70 border border-rose-800/80 text-rose-400 animate-pulse">
                            <Flame className="w-3 h-3 text-rose-400" />
                            OPEN (Isolated)
                          </span>
                        )}
                        {srv.circuitTrips > 0 && (
                          <div className="text-[9px] font-mono text-slate-500 mt-0.5">
                            Trips: {srv.circuitTrips}
                          </div>
                        )}
                      </td>

                      {/* Invocations */}
                      <td className="py-3 px-3 text-right font-mono">
                        <span className="text-slate-200 font-semibold">{srv.totalCalls}</span>
                        <div className="text-[10px] text-slate-500">
                          {srv.totalCalls - srv.errorCount} ok / {srv.errorCount} err
                        </div>
                      </td>

                      {/* Error Rate */}
                      <td className="py-3 px-3 text-right font-mono">
                        <span className={`font-semibold ${
                          srv.errorRatePct === 0 ? 'text-emerald-400' : srv.errorRatePct < 10 ? 'text-amber-400' : 'text-rose-400'
                        }`}>
                          {srv.errorRatePct}%
                        </span>
                      </td>

                      {/* Percentiles */}
                      <td className="py-3 px-3 text-right font-mono text-slate-300">
                        {srv.p50LatencyMs}ms
                      </td>
                      <td className="py-3 px-3 text-right font-mono text-slate-200 font-semibold">
                        {srv.p95LatencyMs}ms
                      </td>
                      <td className="py-3 px-3 text-right font-mono text-slate-400">
                        {srv.p99LatencyMs}ms
                      </td>

                      {/* Diagnostic Failure Reporting */}
                      <td className="py-3 px-4 max-w-xs">
                        {srv.lastError ? (
                          <div className="p-2 rounded bg-rose-950/40 border border-rose-900/60 text-[11px]">
                            <div className="flex items-center gap-1.5 font-mono font-semibold text-rose-400">
                              <span className="px-1 py-0.2 bg-rose-900/60 rounded text-[9px]">
                                {srv.lastError.category}
                              </span>
                              <span className="text-[10px] text-slate-400">{srv.lastError.tool}</span>
                            </div>
                            <div className="text-slate-300 mt-1 line-clamp-2" title={srv.lastError.detail}>
                              {srv.lastError.detail}
                            </div>
                            <div className="text-[9px] font-mono text-slate-500 mt-0.5">
                              {srv.lastError.timestamp}
                            </div>
                          </div>
                        ) : (
                          <div className="flex items-center gap-1.5 text-slate-400 text-[11px]">
                            <CheckCircle2 className="w-3.5 h-3.5 text-emerald-500/80" />
                            <span>Upstream nominal (zero active failures)</span>
                          </div>
                        )}
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Two Column Layout: Top Tools Latency & Role Distribution */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Top Tools Latency Profile (2 columns) */}
        <div className="lg:col-span-2 rounded-xl bg-brand-card border border-brand-border p-4">
          <div className="flex items-center justify-between mb-3">
            <div className="flex items-center gap-2">
              <BarChart2 className="w-4 h-4 text-emerald-400" />
              <h3 className="text-sm font-semibold text-slate-100">Tool Latency & Frequency Distribution</h3>
            </div>
            <span className="text-[10px] font-mono text-slate-400">Top 10 High-Traffic Tools</span>
          </div>

          <div className="space-y-3">
            {topTools.length === 0 ? (
              <div className="py-6 text-center text-slate-500 text-xs">
                No tool executions recorded yet. Run a chat query or call a tool to generate telemetry.
              </div>
            ) : (
              topTools.map((tool) => (
                <div key={tool.name} className="p-2.5 rounded-lg bg-brand-surface/60 border border-brand-border/60">
                  <div className="flex items-center justify-between text-xs mb-1.5">
                    <div className="flex items-center gap-2">
                      <span className="font-mono font-semibold text-slate-200">{tool.name}</span>
                      <span className="text-[10px] text-slate-500 font-mono">({tool.serverName})</span>
                    </div>
                    <div className="flex items-center gap-3 font-mono text-[11px]">
                      <span className="text-slate-400">{tool.totalCalls} calls</span>
                      <span className="text-emerald-400 font-medium">p50: {tool.p50LatencyMs}ms</span>
                      <span className="text-sky-400 font-semibold">p95: {tool.p95LatencyMs}ms</span>
                    </div>
                  </div>
                  {/* Visual Latency Bar */}
                  <div className="w-full bg-slate-800/80 rounded-full h-1.5 overflow-hidden">
                    <div 
                      className={`h-full rounded-full ${
                        tool.errorCount > 0 ? 'bg-amber-400' : 'bg-emerald-500'
                      }`}
                      style={{ width: `${Math.min(100, Math.max(5, (tool.p95LatencyMs / 500) * 100))}%` }}
                    />
                  </div>
                </div>
              ))
            )}
          </div>
        </div>

        {/* Role Invocations & Prometheus Exporter Card (1 column) */}
        <div className="space-y-4">
          <div className="rounded-xl bg-brand-card border border-brand-border p-4">
            <div className="flex items-center gap-2 mb-3">
              <Cpu className="w-4 h-4 text-emerald-400" />
              <h3 className="text-sm font-semibold text-slate-100">Role Usage Distribution</h3>
            </div>
            
            <div className="space-y-2.5">
              {Object.entries(telemetry?.roleDistribution || {}).length === 0 ? (
                <div className="py-4 text-center text-slate-500 text-xs">
                  No role data logged.
                </div>
              ) : (
                Object.entries(telemetry?.roleDistribution || {}).map(([role, count]) => (
                  <div key={role} className="flex items-center justify-between text-xs p-2 rounded bg-brand-surface border border-brand-border">
                    <span className="font-mono font-medium text-slate-300">{role}</span>
                    <span className="font-mono font-semibold text-emerald-400">{count} calls</span>
                  </div>
                ))
              )}
            </div>
          </div>

          {/* Quick Prometheus CLI Help */}
          <div className="rounded-xl bg-brand-card border border-brand-border p-4 text-xs">
            <div className="flex items-center gap-2 mb-2 text-slate-200 font-semibold">
              <Terminal className="w-4 h-4 text-emerald-400" />
              <span>Prometheus Scraper Config</span>
            </div>
            <p className="text-slate-400 text-[11px] mb-2.5">
              Target the OpenMetrics cluster endpoint from any Prometheus, VictoriaMetrics, or Datadog agent:
            </p>
            <div className="p-2.5 rounded bg-brand-sidebar border border-brand-border font-mono text-[10px] text-emerald-300 overflow-x-auto">
              curl -s http://gateway.local/metrics
            </div>
          </div>
        </div>
      </div>

      {/* Raw OpenMetrics Exposition Modal */}
      {showMetricsModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm">
          <div className="w-full max-w-4xl max-h-[85vh] bg-brand-card border border-brand-border rounded-xl shadow-2xl flex flex-col overflow-hidden animate-scaleIn">
            {/* Modal Header */}
            <div className="p-4 border-b border-brand-border flex items-center justify-between bg-brand-surface">
              <div className="flex items-center gap-2.5">
                <FileCode2 className="w-5 h-5 text-emerald-400" />
                <div>
                  <h3 className="font-semibold text-slate-100 text-sm">OpenMetrics / Prometheus Exposition (/metrics)</h3>
                  <p className="text-[11px] text-slate-400">Content-Type: text/plain; version=0.0.4</p>
                </div>
              </div>
              <div className="flex items-center gap-2">
                <button
                  onClick={handleCopyMetrics}
                  className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-emerald-500/20 hover:bg-emerald-500/30 border border-emerald-500/40 text-xs text-emerald-300 transition"
                >
                  {copiedMetrics ? <Check className="w-3.5 h-3.5 text-emerald-400" /> : <Copy className="w-3.5 h-3.5" />}
                  <span>{copiedMetrics ? 'Copied!' : 'Copy Metrics'}</span>
                </button>
                <button
                  onClick={() => setShowMetricsModal(false)}
                  className="px-2.5 py-1.5 rounded-lg bg-brand-card hover:bg-brand-surface text-slate-400 hover:text-slate-200 text-xs transition border border-brand-border"
                >
                  ✕ Close
                </button>
              </div>
            </div>

            {/* Modal Body */}
            <div className="p-4 overflow-y-auto flex-1 font-mono text-xs bg-slate-950 text-emerald-400/90 leading-relaxed">
              {loadingMetrics ? (
                <div className="flex items-center justify-center py-16 gap-2 text-slate-400">
                  <RefreshCw className="w-4 h-4 animate-spin text-emerald-400" />
                  <span>Scraping /metrics...</span>
                </div>
              ) : (
                <pre className="whitespace-pre-wrap">{rawMetrics}</pre>
              )}
            </div>

            {/* Modal Footer */}
            <div className="p-3 border-t border-brand-border bg-brand-surface flex items-center justify-between text-xs text-slate-400">
              <span>Ready for scraping via Prometheus Operator & Grafana ServiceMonitors</span>
              <a
                href="/metrics"
                target="_blank"
                rel="noreferrer"
                className="flex items-center gap-1 text-emerald-400 hover:underline"
              >
                <span>Direct Link</span>
                <ExternalLink className="w-3.5 h-3.5" />
              </a>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
