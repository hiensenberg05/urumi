import React, { useState } from 'react';
import { 
  Terminal, 
  KeyRound, 
  Bot, 
  ShieldCheck, 
  CheckCircle2, 
  Lock, 
  Copy, 
  Check, 
  ExternalLink, 
  Search, 
  ChevronRight,
  Code2
} from 'lucide-react';
import { User, ServerTool, AuditLogItem } from '../types';

interface MemberOverviewViewProps {
  currentUser: User;
  tools: ServerTool[];
  onOpenGenerateKey: () => void;
  onNavigateToChat: () => void;
}

export const MemberOverviewView: React.FC<MemberOverviewViewProps> = ({
  currentUser,
  tools,
  onOpenGenerateKey,
  onNavigateToChat
}) => {
  const [activeTab, setActiveTab] = useState<'all' | 'wc' | 'inv'>('all');
  const [configTab, setConfigTab] = useState<'cline' | 'claude' | 'cursor' | 'envrc'>('cursor');
  const [copiedConfig, setCopiedConfig] = useState(false);
  const [copiedToken, setCopiedToken] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');

  const clientConfigJson = {
    mcpServers: {
      "urumi-gateway": {
        command: "npx",
        args: [
          "-y",
          "@modelcontextprotocol/server-sse",
          "http://gateway.local/sse"
        ],
        env: {
          URUMI_GATEWAY_TOKEN: "urumi_live_8fdc3a91b2e..."
        },
        disabled: false,
        autoApprove: []
      }
    }
  };

  const handleCopyConfig = () => {
    navigator.clipboard.writeText(JSON.stringify(clientConfigJson, null, 2));
    setCopiedConfig(true);
    setTimeout(() => setCopiedConfig(false), 2000);
  };

  const handleCopyToken = () => {
    navigator.clipboard.writeText("urumi_live_8fdc3a91b2e4401fa91bc2b9a");
    setCopiedToken(true);
    setTimeout(() => setCopiedToken(false), 2000);
  };

  const allowedTools = tools.filter(t => t.isAllowed);
  const restrictedTools = tools.filter(t => !t.isAllowed);

  const displayedAllowedTools = allowedTools.filter(t => {
    if (activeTab === 'wc' && !t.namespacedName.startsWith('woocommerce')) return false;
    if (activeTab === 'inv' && !t.namespacedName.startsWith('inventory')) return false;
    if (searchQuery) {
      return t.namespacedName.toLowerCase().includes(searchQuery.toLowerCase()) ||
             t.description.toLowerCase().includes(searchQuery.toLowerCase());
    }
    return true;
  });

  return (
    <div className="space-y-6 pb-16 animate-fadeIn">
      {/* Top Welcome Banner */}
      <div className="p-5 rounded-xl bg-brand-card border border-brand-border flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-2.5">
            <h1 className="text-xl font-bold tracking-tight text-slate-100">Welcome back, {currentUser.name}</h1>
            <span className="text-[10px] font-mono bg-brand-surface border border-brand-border text-slate-300 px-2 py-0.5 rounded font-semibold uppercase">
              Member Node
            </span>
            <span className="text-[10px] font-mono bg-emerald-950/80 text-emerald-400 border border-emerald-800/60 px-2 py-0.5 rounded font-semibold">
              SSE Active
            </span>
          </div>
          <div className="text-xs text-slate-400 mt-1 font-mono flex items-center gap-2">
            <span>Member Workspace</span>
            <span>•</span>
            <span>Assigned Role: <strong className="text-slate-200">Member (Default Developer)</strong></span>
            <span>•</span>
            <span className="text-emerald-400 font-semibold">{allowedTools.length} of {tools.length} Tools Authorized</span>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="flex items-center gap-3">
          <button
            onClick={onOpenGenerateKey}
            className="flex items-center gap-1.5 px-3.5 py-2 rounded-lg bg-brand-surface hover:bg-brand-surface/80 border border-brand-border text-xs font-mono font-semibold text-slate-200 transition"
          >
            <KeyRound className="w-3.5 h-3.5 text-emerald-400" />
            <span>+ Generate Token</span>
          </button>
          <button
            onClick={onNavigateToChat}
            className="flex items-center gap-1.5 px-4 py-2 rounded-lg bg-emerald-500 hover:bg-emerald-600 text-slate-950 font-bold text-xs font-mono shadow-md shadow-emerald-500/20 transition cursor-pointer"
          >
            <Bot className="w-4 h-4" />
            <span>Launch AI Chat</span>
          </button>
        </div>
      </div>

      {/* Zero-Trust Notice */}
      <div className="p-4 rounded-xl bg-brand-card border border-brand-border flex items-start gap-3">
        <ShieldCheck className="w-5 h-5 text-emerald-400 shrink-0 mt-0.5" />
        <div className="flex-1">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <span className="text-xs font-mono font-semibold text-slate-200">Zero-Trust Protocol Enforcement Active</span>
              <span className="text-[9px] font-mono text-slate-400 bg-brand-surface px-1.5 py-0.2 rounded border border-brand-border">
                Egress Policy A21-B
              </span>
            </div>
            <span className="text-[10px] font-mono bg-emerald-950/60 text-emerald-400 border border-emerald-800/40 px-2 py-0.5 rounded">
              Proxy Mode: mTLS-Strict
            </span>
          </div>
          <p className="text-xs text-slate-400 mt-1 max-w-4xl leading-relaxed">
            Direct upstream secrets (WooCommerce API Keys, Database Connection Strings, HashiCorp Vault tokens) are securely abstracted and protected by gateway policy. Plaintext credentials are never distributed to client runtimes, IDE extensions, or agent prompts.
          </p>
        </div>
      </div>

      {/* 4 Stat Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
          <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
            Authorized Tools
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold font-mono text-slate-100">{allowedTools.length} / {tools.length}</span>
            <span className="text-xs text-emerald-400 font-mono">Available</span>
          </div>
          <div className="mt-2.5 flex items-center gap-1.5 text-[10px] font-mono">
            <span className="bg-brand-surface px-1.5 py-0.5 rounded border border-brand-border text-slate-300">5 Woo</span>
            <span className="bg-brand-surface px-1.5 py-0.5 rounded border border-brand-border text-slate-300">7 Inv</span>
            <span className="bg-red-950 text-red-400 px-1.5 py-0.5 rounded border border-red-800/60">0 Analytics</span>
          </div>
        </div>

        <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
          <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
            Invocations (24h)
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold font-mono text-slate-100">1,482</span>
            <span className="text-xs text-emerald-400 font-mono">99.8% OK</span>
          </div>
          <div className="mt-2.5 text-[11px] font-mono text-slate-400">
            0 Rate Limits • Quota: 10k/day
          </div>
        </div>

        <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
          <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
            Avg Roundtrip Latency
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold font-mono text-slate-100">94 ms</span>
          </div>
          <div className="mt-2.5 text-[11px] font-mono text-slate-400">
            Gateway overhead <span className="text-emerald-400 font-semibold">~1.2ms</span>
          </div>
        </div>

        <div className="p-4 rounded-xl bg-brand-card border border-brand-border/80">
          <div className="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold mb-1">
            Active Client Tokens
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold font-mono text-slate-100">1</span>
            <span className="text-xs text-emerald-400 font-mono">Token Live</span>
          </div>
          <div className="mt-2.5 text-[11px] font-mono text-slate-400 truncate">
            <code>cursor-ide-developer</code>
          </div>
        </div>
      </div>

      {/* Main 2-Column Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left (2 Spans): Authorized Tools Catalog & Blocked Section */}
        <div className="lg:col-span-2 space-y-6">
          <div className="p-5 rounded-xl bg-brand-card border border-brand-border space-y-4">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
              <div>
                <h3 className="text-sm font-semibold text-slate-100">My Authorized Tools Catalog</h3>
                <p className="text-xs text-slate-400 mt-0.5">
                  Tools exposed through your gateway token based on workspace role.
                </p>
              </div>

              {/* Tabs */}
              <div className="flex items-center gap-1 p-1 rounded-lg bg-brand-surface border border-brand-border text-xs font-mono">
                <button
                  onClick={() => setActiveTab('all')}
                  className={`px-2.5 py-1 rounded transition ${activeTab === 'all' ? 'bg-emerald-500 text-slate-950 font-bold' : 'text-slate-400 hover:text-slate-200'}`}
                >
                  ALL (12)
                </button>
                <button
                  onClick={() => setActiveTab('wc')}
                  className={`px-2.5 py-1 rounded transition ${activeTab === 'wc' ? 'bg-emerald-500 text-slate-950 font-bold' : 'text-slate-400 hover:text-slate-200'}`}
                >
                  WooCommerce (5)
                </button>
                <button
                  onClick={() => setActiveTab('inv')}
                  className={`px-2.5 py-1 rounded transition ${activeTab === 'inv' ? 'bg-emerald-500 text-slate-950 font-bold' : 'text-slate-400 hover:text-slate-200'}`}
                >
                  Inventory (7)
                </button>
              </div>
            </div>

            {/* Tool Search Bar */}
            <div className="relative">
              <Search className="w-3.5 h-3.5 text-slate-400 absolute left-3 top-2.5 pointer-events-none" />
              <input
                type="text"
                placeholder="Filter tools by capability, schema parameter, or server..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full bg-[#060a12] border border-brand-border text-xs text-slate-200 placeholder-slate-400 pl-8 pr-4 py-2 rounded-lg focus:outline-none focus:border-emerald-500/50 font-mono"
              />
            </div>

            {/* Allowed Tools Cards */}
            <div className="space-y-2.5 pt-1">
              {displayedAllowedTools.map((tool) => (
                <div 
                  key={tool.id}
                  className="p-3.5 rounded-lg bg-brand-surface/30 border border-brand-border hover:border-brand-borderLight transition flex items-center justify-between text-xs font-mono"
                >
                  <div className="flex items-start gap-3">
                    <div className="w-7 h-7 rounded bg-[#070c14] border border-brand-border flex items-center justify-center text-emerald-400 shrink-0 mt-0.5">
                      <Code2 className="w-4 h-4" />
                    </div>
                    <div>
                      <div className="flex items-center gap-2">
                        <span className="font-semibold text-slate-200">{tool.namespacedName}</span>
                        <span className="text-[9px] bg-[#070c14] border border-brand-border px-1.5 py-0.2 rounded text-slate-400">
                          {tool.rateLimit}
                        </span>
                      </div>
                      <div className="text-[11px] text-slate-400 font-sans mt-0.5">
                        {tool.description}
                      </div>
                    </div>
                  </div>

                  <div className="flex items-center gap-2 pl-4 shrink-0">
                    <span className="flex items-center gap-1 text-[11px] text-emerald-400 font-semibold bg-emerald-950/60 border border-emerald-800/60 px-2 py-0.5 rounded">
                      <span className="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
                      Allowed
                    </span>
                  </div>
                </div>
              ))}
            </div>

            {/* Restricted / Policy Blocked Tools Box */}
            <div className="p-4 rounded-xl bg-red-950/20 border border-red-900/40 space-y-3">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2 text-xs font-mono font-semibold text-red-400">
                  <Lock className="w-4 h-4" />
                  <span>Restricted / Policy Blocked Tools ({restrictedTools.length})</span>
                  <span className="text-[9px] bg-red-950 text-red-300 border border-red-800/80 px-1.5 py-0.2 rounded">
                    RBAC Restricted
                  </span>
                </div>
                <button
                  type="button"
                  className="text-xs font-mono font-semibold text-slate-200 bg-brand-surface hover:bg-brand-surface/80 border border-brand-border px-3 py-1 rounded transition"
                >
                  Request Tool Access
                </button>
              </div>
              <p className="text-xs text-slate-400 leading-relaxed font-sans">
                Mutations or financial analytics (<code className="text-red-400 font-mono">woocommerce__create_product</code>, <code className="text-red-400 font-mono">woocommerce__update_order_status</code>, <code className="text-red-400 font-mono">analytics__run_revenue_query</code>) require an Elevated Developer Role or single-invocation approval.
              </p>
            </div>
          </div>
        </div>

        {/* Right (1 Span): Active Token & Client Config Snippet */}
        <div className="space-y-6">
          {/* Active Client Token Card */}
          <div className="p-5 rounded-xl bg-brand-card border border-brand-border space-y-3 font-mono text-xs">
            <div className="flex items-center justify-between pb-2 border-b border-brand-border">
              <div className="flex items-center gap-2 text-slate-200 font-semibold">
                <KeyRound className="w-4 h-4 text-emerald-400" />
                <span>Active Client Token</span>
              </div>
              <span className="text-[10px] bg-emerald-950 text-emerald-400 border border-emerald-800/60 px-1.5 py-0.2 rounded font-semibold">
                ACTIVE
              </span>
            </div>

            <div className="p-3 rounded-lg bg-[#060a12] border border-brand-border space-y-2">
              <div className="flex items-center justify-between">
                <span className="font-semibold text-slate-200">cursor-ide-developer</span>
                <span className="text-[10px] text-slate-400">ID: tok_99f2</span>
              </div>
              <div className="flex items-center justify-between text-[11px] text-emerald-400 bg-[#040810] p-1.5 rounded border border-emerald-500/30">
                <span className="truncate">urumi_live_8fdc••••••••••2b9a</span>
                <button onClick={handleCopyToken} className="hover:text-emerald-300">
                  {copiedToken ? <Check className="w-3.5 h-3.5" /> : <Copy className="w-3.5 h-3.5" />}
                </button>
              </div>
              <div className="flex items-center justify-between text-[10px] text-slate-400 pt-1">
                <span>Created: 12 days ago</span>
                <span>Last used: <strong className="text-slate-300">3m ago</strong></span>
              </div>
            </div>

            <div className="flex items-center justify-between pt-1 text-[11px] text-slate-400">
              <span>Expires: Oct 14, 2026</span>
              <button className="text-red-400 hover:text-red-300 font-semibold underline underline-offset-2">
                Revoke Key
              </button>
            </div>
          </div>

          {/* Client Config Snippet Box (Cursor / Claude Desktop / Cline) */}
          <div className="p-5 rounded-xl bg-brand-card border border-brand-border space-y-3 font-mono text-xs">
            <div className="flex items-center justify-between pb-2 border-b border-brand-border">
              <div className="flex items-center gap-2 text-slate-200 font-semibold">
                <Terminal className="w-4 h-4 text-emerald-400" />
                <span>Client Config</span>
              </div>
              <span className="text-[10px] text-emerald-400">TLS 1.3</span>
            </div>

            <p className="text-xs text-slate-400 font-sans leading-relaxed">
              Select your runtime to configure upstream SSE endpoint connectivity:
            </p>

            {/* Config Tabs */}
            <div className="flex items-center gap-1 p-1 rounded-lg bg-brand-surface border border-brand-border text-[11px]">
              <button 
                onClick={() => setConfigTab('cursor')}
                className={`flex-1 py-1 rounded text-center transition ${configTab === 'cursor' ? 'bg-emerald-500 text-slate-950 font-bold' : 'text-slate-400'}`}
              >
                Cursor
              </button>
              <button 
                onClick={() => setConfigTab('claude')}
                className={`flex-1 py-1 rounded text-center transition ${configTab === 'claude' ? 'bg-emerald-500 text-slate-950 font-bold' : 'text-slate-400'}`}
              >
                Claude
              </button>
              <button 
                onClick={() => setConfigTab('cline')}
                className={`flex-1 py-1 rounded text-center transition ${configTab === 'cline' ? 'bg-emerald-500 text-slate-950 font-bold' : 'text-slate-400'}`}
              >
                Cline / Roo
              </button>
              <button 
                onClick={() => setConfigTab('envrc')}
                className={`flex-1 py-1 rounded text-center transition ${configTab === 'envrc' ? 'bg-emerald-500 text-slate-950 font-bold' : 'text-slate-400'}`}
              >
                .envrc
              </button>
            </div>

            {/* JSON Code Snippet */}
            <pre className="p-3 rounded-lg bg-[#05080f] border border-brand-border text-[11px] text-slate-300 overflow-x-auto leading-relaxed">
{`{
  "mcpServers": {
    "urumi-gateway": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-sse",
        "https://gateway.acme.local/sse"
      ],
      "env": {
        "URUMI_GATEWAY_TOKEN": "urumi_live_8fdc..."
      },
      "disabled": false,
      "autoApprove": []
    }
  }
}`}
            </pre>

            <button
              onClick={handleCopyConfig}
              className={`w-full py-2 px-3 rounded-lg text-xs font-semibold flex items-center justify-center gap-2 transition cursor-pointer ${
                copiedConfig
                  ? 'bg-emerald-500 text-slate-950 font-bold'
                  : 'bg-brand-surface hover:bg-brand-surface/80 border border-brand-border text-slate-200'
              }`}
            >
              {copiedConfig ? <Check className="w-3.5 h-3.5" /> : <Copy className="w-3.5 h-3.5" />}
              <span>{copiedConfig ? 'Copied Config JSON!' : 'Copy Config JSON'}</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};
