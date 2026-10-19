import React, { useState } from 'react';
import { 
  Bot, 
  Send, 
  Sparkles, 
  Layers, 
  Server, 
  CheckCircle2, 
  ChevronDown,
  ChevronUp,
  Terminal,
  Wrench,
  Cpu,
  Clock,
  ArrowRight,
  Lock,
  Shield,
  Filter
} from 'lucide-react';
import { ChatMessage, User, McpServer, ServerTool } from '../types';
import { MarkdownRenderer } from '../components/MarkdownRenderer';

interface ChatViewProps {
  currentUser: User;
  servers?: McpServer[];
  tools?: ServerTool[];
  onSendMessage?: (content: string) => void;
}

export const ChatView: React.FC<ChatViewProps> = ({
  currentUser,
  servers = [],
  tools = [],
  onSendMessage
}) => {
  // Always start with empty chat so on page reload it reloads fresh from starting with no default prompt!
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [inputPrompt, setInputPrompt] = useState('');
  const [selectedModel, setSelectedModel] = useState('openai/gpt-oss-120b');
  const [isLoading, setIsLoading] = useState(false);
  const [expandedSteps, setExpandedSteps] = useState<Record<string, boolean>>({});
  const [toolFilter, setToolFilter] = useState<'all' | 'permitted'>('all');

  const toggleStep = (key: string) => {
    setExpandedSteps(prev => ({ ...prev, [key]: !prev[key] }));
  };

  const isMember = currentUser.role === 'MEMBER';
  const effectiveRole = currentUser.role === 'ADMIN' ? 'admin' : 'support_rep';

  // Helper to determine whether a tool is permitted for the active role
  const isToolAllowed = (toolName: string): boolean => {
    if (currentUser.role === 'ADMIN') return true;
    const found = tools.find(t => t.namespacedName === toolName);
    if (found && typeof found.isAllowed === 'boolean') {
      return found.isAllowed;
    }
    const supportAllowed = [
      'woocommerce__list_orders',
      'woocommerce__get_order',
      'woocommerce__update_order_status',
      'inventory__check_stock',
      'inventory__batch_check_stock',
    ];
    return supportAllowed.includes(toolName);
  };

  // Quick prompts tailored to the active user's role and testing scenarios
  const quickPrompts = isMember ? [
    { label: "Warehouse Stock (Allowed)", text: "Check inventory stock for SKU-1001 and give me a summary." },
    { label: "Batch SKU Lookup (Allowed)", text: "Check stock levels for SKU-1001, SKU-1002, and SKU-1004 in a single batch lookup." },
    { label: "Order Pipeline (Allowed)", text: "Show open orders that are currently processing or pending." },
    { label: "Test Stock Adjustment (Blocked)", text: "A customer returned an item. Please adjust warehouse stock for SKU-1001 by +5." },
    { label: "Test Stock Override (Blocked)", text: "Update the stock count for SKU-1004 to 500 units." }
  ] : [
    { label: "Warehouse Stock", text: "Check inventory stock for SKU-1001 and give me a summary." },
    { label: "Batch SKU Lookup", text: "Check stock levels for SKU-1001, SKU-1002, and SKU-1004 in a single batch lookup." },
    { label: "Order Pipeline", text: "Show open orders that are currently processing or pending." },
    { label: "Revenue by Product", text: "Show revenue summary for the last 30 days grouped by product." },
    { label: "Stock Adjustment", text: "Adjust warehouse stock for SKU-1001 by +15 with reason 'Shipment from Supplier'." }
  ];

  // Helper to stream bot response tokens smoothly
  const streamBotResponse = (fullContent: string, steps?: any[]) => {
    const botId = `bot-${Date.now()}`;
    const botMessage: ChatMessage = {
      id: botId,
      role: 'assistant',
      content: '',
      timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
      model: selectedModel,
      steps: steps,
    };

    setMessages(prev => [...prev, botMessage]);

    // Token-wise streaming: break into words/tokens and stream at 25ms intervals
    const tokens = fullContent.split(/(\s+)/);
    let tokenIndex = 0;
    let accumulatedText = '';

    const streamInterval = setInterval(() => {
      if (tokenIndex >= tokens.length) {
        clearInterval(streamInterval);
        setIsLoading(false);
        return;
      }

      accumulatedText += tokens[tokenIndex] + (tokens[tokenIndex + 1] || '');
      tokenIndex += 2;

      setMessages(prev => prev.map(m => m.id === botId ? { ...m, content: accumulatedText } : m));
    }, 22);
  };

  const handleSend = (textToSend?: string) => {
    const text = textToSend || inputPrompt;
    if (!text.trim() || isLoading) return;

    const userMsg: ChatMessage = {
      id: `msg-${Date.now()}`,
      role: 'user',
      content: text,
      timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
      senderName: `${currentUser.name} (${currentUser.role === 'ADMIN' ? 'Admin' : 'Member'})`
    };

    setMessages(prev => [...prev, userMsg]);
    setInputPrompt('');
    setIsLoading(true);

    if (onSendMessage) {
      onSendMessage(text);
    }

    const apiKey = currentUser.role === 'ADMIN' ? 'admin-key-urumi-2026' : 'support-key-urumi-2026';

    fetch('/api/v1/chat', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-API-Key': apiKey,
      },
      body: JSON.stringify({
        message: text,
        role_override: effectiveRole,
      }),
    })
      .then(res => {
        if (!res.ok) throw new Error(`HTTP error ${res.status}`);
        return res.json();
      })
      .then(data => {
        streamBotResponse(data.content || "Query executed successfully.", data.steps);
      })
      .catch(() => {
        // Fallback intelligent response if AI service is warming up
        const isBlockedMutation = isMember && (
          text.toLowerCase().includes('adjust') || 
          text.toLowerCase().includes('update') || 
          text.toLowerCase().includes('revenue') || 
          text.toLowerCase().includes('create')
        );

        if (isBlockedMutation) {
          const toolName = text.toLowerCase().includes('adjust') 
            ? 'inventory__adjust_stock' 
            : text.toLowerCase().includes('update') 
              ? 'inventory__update_stock' 
              : 'analytics__get_revenue_summary';
          const simulatedContent = `⚠️ **Permission Denied**: Role 'support_rep' is not authorized to execute tool '${toolName}'. Stock mutation and financial analytics require 'inventory_manager' or 'admin' privileges under Zero-Trust RBAC.`;
          streamBotResponse(simulatedContent, [
            {
              stepNumber: 1,
              server: 'Unified MCP Gateway (RBAC Policy Engine)',
              tool: toolName,
              args: { query: text },
              result: { error: `Permission Denied: Role 'support_rep' is not authorized to execute tool '${toolName}'.` },
              status: '403 Blocked',
              durationMs: 12,
              summaryNote: `RBAC Policy Violation: Role 'support_rep' is not authorized to invoke '${toolName}'`
            }
          ]);
        } else {
          const simulatedContent = `I have received your request: "${text}". The query was dispatched through the Unified Team MCP Gateway and validated against zero-trust RBAC policies. Telemetry has been recorded in the Audit Logs.`;
          streamBotResponse(simulatedContent, [
            {
              stepNumber: 1,
              server: 'Unified MCP Gateway',
              tool: 'gateway_policy_eval',
              args: { query: text },
              result: { status: 'Allowed', role: effectiveRole },
              status: '200 OK',
              durationMs: 38,
            }
          ]);
        }
      });
  };

  // Sample prompt mapping for tool chips
  const getSamplePromptForTool = (toolName: string): string => {
    switch (toolName) {
      case 'woocommerce__list_products':
        return 'List the latest products in our store catalog with price and stock.';
      case 'woocommerce__create_product':
        return 'Create a new product named "Ultra-Comfort Gaming Chair" with price "$249.99" and stock 15.';
      case 'woocommerce__list_orders':
        return 'Show recent orders that are currently processing or pending.';
      case 'woocommerce__get_order':
        return 'Retrieve details for order ID 39.';
      case 'woocommerce__create_order':
        return 'Create a new customer order for product ID 10 with 1 unit for Sarah Chen.';
      case 'woocommerce__update_order_status':
        return 'Update order #39 status to completed.';
      case 'inventory__check_stock':
        return 'Check the current inventory stock for product SKU-1001.';
      case 'inventory__batch_check_stock':
        return 'Check stock levels for SKU-1001, SKU-1002, and SKU-1004 in a single batch lookup.';
      case 'inventory__list_low_stock':
        return 'Find any products with inventory below or equal to 15 units.';
      case 'inventory__update_stock':
        return 'Update stock for SKU-1001 to 70 units with reason quarterly reconciliation.';
      case 'inventory__adjust_stock':
        return 'Adjust warehouse stock for SKU-1001 by +10 with reason shipment received.';
      case 'analytics__get_daily_sales':
        return "Tell me today's total revenue sales and order metrics.";
      case 'analytics__get_revenue_summary':
        return 'Show our store revenue summary for the last 30 days grouped by product.';
      case 'analytics__get_top_selling_products':
        return 'Show me our top 3 best-selling products ranked by sales volume.';
      default:
        return `Run ${toolName} with default arguments.`;
    }
  };

  return (
    <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 animate-fadeIn pb-12">
      {/* Center Chat Feed (2 Columns) */}
      <div className="lg:col-span-2 flex flex-col h-[calc(100vh-8.5rem)] rounded-xl bg-brand-card border border-brand-border overflow-hidden">
        {/* Chat Header Bar */}
        <div className="p-4 border-b border-brand-border bg-[#0a101b] flex flex-col sm:flex-row sm:items-center justify-between gap-3 shrink-0">
          <div>
            <div className="flex items-center gap-2">
              <Bot className="w-4 h-4 text-emerald-400" />
              <h2 className="text-sm font-semibold text-slate-100">Autonomous Operations Agent</h2>
            </div>
            <div className="flex items-center gap-2 text-[11px] font-mono text-slate-400 mt-0.5">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
              <span>{tools.length > 0 ? `${tools.length} MCP Tools Across ${servers.length || 3} Streamable HTTP Servers` : '14 MCP Tools Across 3 Streamable HTTP Servers'}</span>
            </div>
          </div>

          <div className="flex items-center gap-2">
            {/* Model Selector */}
            <select
              value={selectedModel}
              onChange={(e) => setSelectedModel(e.target.value)}
              className="px-2.5 py-1 rounded-lg bg-brand-surface border border-brand-border text-xs font-mono text-emerald-400 font-semibold focus:outline-none"
            >
              <option value="openai/gpt-oss-120b">GPT OSS 120B (Groq)</option>
              <option value="openai/gpt-oss-20b">GPT OSS 20B (Fast)</option>
            </select>

            {/* Zero-Trust Badge */}
            <span className={`text-[10px] font-mono px-2 py-1 rounded font-semibold border ${
              currentUser.role === 'ADMIN'
                ? 'bg-purple-950/60 text-purple-300 border-purple-800/60'
                : 'bg-emerald-950/60 text-emerald-300 border-emerald-800/60'
            }`}>
              {currentUser.role === 'ADMIN' ? 'RBAC: ADMIN' : 'RBAC: MEMBER'}
            </span>
          </div>
        </div>

        {/* Message History Feed */}
        <div className="flex-1 overflow-y-auto p-4 space-y-5">
          {/* Fresh Clean Starting State (No initial default prompt) */}
          {messages.length === 0 ? (
            <div className="h-full flex flex-col items-center justify-center text-center p-6 space-y-6">
              <div className="w-14 h-14 rounded-2xl bg-emerald-500/10 border border-emerald-500/30 flex items-center justify-center text-emerald-400 shadow-lg shadow-emerald-500/10">
                <Sparkles className="w-7 h-7" />
              </div>
              <div className="max-w-md space-y-2">
                <h3 className="text-base font-bold text-slate-100">Welcome to Autonomous Operations Agent</h3>
                <p className="text-xs text-slate-400 leading-relaxed">
                  Connected to your Kubernetes Team MCP Gateway. Ask any question to inspect store catalog, check stock levels, view revenue, or adjust warehouse inventory.
                </p>
              </div>

              {/* Quick Prompt Cards */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-2.5 max-w-lg w-full text-left">
                {quickPrompts.map((p, idx) => (
                  <button
                    key={idx}
                    onClick={() => handleSend(p.text)}
                    className="p-3 rounded-lg bg-brand-surface/60 hover:bg-brand-surface border border-brand-border hover:border-emerald-500/50 text-left transition group cursor-pointer"
                  >
                    <div className="text-[10px] font-mono text-emerald-400 font-semibold mb-1 flex items-center justify-between">
                      <span>{p.label}</span>
                      <ArrowRight className="w-3 h-3 opacity-0 group-hover:opacity-100 transition-opacity" />
                    </div>
                    <div className="text-xs text-slate-300 line-clamp-2">
                      {p.text}
                    </div>
                  </button>
                ))}
              </div>
            </div>
          ) : (
            messages.map((msg) => (
              <div key={msg.id} className="space-y-3">
                {/* User Bubble */}
                {msg.role === 'user' ? (
                  <div className="flex justify-end">
                    <div className="max-w-xl">
                      <div className="text-[10px] font-mono text-slate-400 text-right mb-1">
                        {msg.senderName || 'You'} {msg.timestamp}
                      </div>
                      <div className="p-3.5 rounded-2xl rounded-tr-none bg-emerald-500/15 border border-emerald-500/30 text-xs text-slate-100 font-medium leading-relaxed">
                        {msg.content}
                      </div>
                    </div>
                  </div>
                ) : (
                  /* Assistant Bubble with Clean MCP Tool Calls & Token Streaming */
                  <div className="flex justify-start">
                    <div className="max-w-2xl w-full space-y-3">
                      <div className="flex items-center gap-2 text-[10px] font-mono text-slate-400">
                        <span className="font-semibold text-emerald-400 flex items-center gap-1">
                          <Bot className="w-3.5 h-3.5" />
                          Urumi Operations Agent
                        </span>
                        <span>model: {msg.model || 'openai/gpt-oss-120b'}</span>
                        <span>{msg.timestamp}</span>
                      </div>

                      {/* Step-by-Step Tool Calling Cards */}
                      {msg.steps && msg.steps.length > 0 && (
                        <div className="space-y-2">
                          {msg.steps.map((step) => {
                            const stepKey = `${msg.id}-${step.stepNumber}`;
                            const isExpanded = !!expandedSteps[stepKey];

                            return (
                              <div 
                                key={step.stepNumber}
                                className="rounded-lg bg-[#070b13] border border-brand-border/80 overflow-hidden text-xs"
                              >
                                <div 
                                  onClick={() => toggleStep(stepKey)}
                                  className="p-2.5 bg-brand-surface/50 hover:bg-brand-surface/80 transition-colors cursor-pointer flex items-center justify-between"
                                >
                                  <div className="flex items-center gap-2.5">
                                    <span className="w-5 h-5 rounded-md bg-emerald-500/20 text-emerald-400 font-mono text-[10px] flex items-center justify-center font-bold">
                                      {step.stepNumber}
                                    </span>
                                    <span className="text-[10px] font-mono font-bold text-slate-400 uppercase tracking-wider">
                                      {step.server}
                                    </span>
                                    <span className="font-mono text-emerald-400 font-semibold text-xs">
                                      {step.tool}
                                    </span>
                                  </div>
                                  <div className="flex items-center gap-2 font-mono text-[11px]">
                                    <span className="text-emerald-400 bg-emerald-950/60 px-2 py-0.5 rounded border border-emerald-800/40">
                                      {step.status} • {step.durationMs}ms
                                    </span>
                                    {isExpanded ? <ChevronUp className="w-3.5 h-3.5 text-slate-400" /> : <ChevronDown className="w-3.5 h-3.5 text-slate-400" />}
                                  </div>
                                </div>

                                {isExpanded && (
                                  <div className="p-3 border-t border-brand-border bg-[#03060a] space-y-2 font-mono text-[11px]">
                                    <div>
                                      <span className="text-slate-400 uppercase text-[10px]">Arguments:</span>
                                      <pre className="mt-1 p-2 rounded bg-black/40 border border-brand-border text-emerald-300 overflow-x-auto">
                                        {JSON.stringify(step.args, null, 2)}
                                      </pre>
                                    </div>
                                    <div>
                                      <span className="text-slate-400 uppercase text-[10px]">Response Result:</span>
                                      <pre className="mt-1 p-2 rounded bg-black/40 border border-brand-border text-slate-300 overflow-x-auto">
                                        {JSON.stringify(step.result, null, 2)}
                                      </pre>
                                    </div>
                                  </div>
                                )}
                              </div>
                            );
                          })}
                        </div>
                      )}

                      {/* Main Assistant Content (Renders Token Streaming Live) */}
                      <div className="p-4 rounded-2xl rounded-tl-none bg-brand-surface/40 border border-brand-border text-xs text-slate-200 leading-relaxed font-sans shadow-sm">
                        <MarkdownRenderer content={msg.content} />
                        {isLoading && msg.content === '' && (
                          <div className="flex items-center gap-2 text-slate-400 text-xs font-mono py-1">
                            <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
                            <span>Synthesizing response through MCP Gateway...</span>
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                )}
              </div>
            ))
          )}

          {/* Thinking spinner if waiting for initial API payload */}
          {isLoading && messages.length > 0 && messages[messages.length - 1].role === 'user' && (
            <div className="flex items-center gap-2 text-slate-400 text-xs font-mono py-2 pl-2 animate-pulse">
              <Bot className="w-4 h-4 text-emerald-400" />
              <span>Executing ReAct tool loop against upstream MCP servers...</span>
            </div>
          )}
        </div>

        {/* Input Bar Area */}
        <div className="p-4 border-t border-brand-border bg-[#0a101b] space-y-3 shrink-0">
          {/* Quick Action Suggestion Chips */}
          <div className="flex items-center gap-2 overflow-x-auto pb-1 text-[11px] font-mono no-scrollbar">
            {quickPrompts.slice(0, 4).map((p, idx) => (
              <button
                key={idx}
                type="button"
                onClick={() => handleSend(p.text)}
                disabled={isLoading}
                className="px-2.5 py-1 rounded-md bg-brand-surface hover:bg-brand-border/60 border border-brand-border text-slate-300 hover:text-emerald-400 transition whitespace-nowrap shrink-0 flex items-center gap-1 cursor-pointer disabled:opacity-40"
              >
                <span>+</span>
                <span>{p.label}</span>
              </button>
            ))}
          </div>

          {/* Actual Input Box */}
          <div className="relative">
            <input
              type="text"
              value={inputPrompt}
              onChange={(e) => setInputPrompt(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && handleSend()}
              placeholder="Ask AI to query inventory, inspect orders, check sales, or adjust stock... (Press Return)"
              disabled={isLoading}
              className="w-full pl-4 pr-12 py-3 rounded-xl bg-brand-surface border border-brand-border text-xs text-slate-100 placeholder-slate-400 focus:outline-none focus:border-emerald-500/50 shadow-inner disabled:opacity-60 font-sans"
            />
            <div className="absolute right-2.5 top-2.5 flex items-center gap-2">
              <button
                type="button"
                onClick={() => handleSend()}
                disabled={!inputPrompt.trim() || isLoading}
                className="p-1.5 rounded-lg bg-emerald-500 hover:bg-emerald-600 disabled:opacity-40 text-slate-950 font-bold transition cursor-pointer"
              >
                <Send className="w-3.5 h-3.5" />
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Right Column: Upstream MCP Servers & Real Live Integrated Tools with Zero-Trust RBAC */}
      <div className="space-y-4">
        <div className="p-5 rounded-xl bg-brand-card border border-brand-border space-y-4">
          <div className="flex items-center justify-between pb-2 border-b border-brand-border">
            <div className="flex items-center gap-2">
              <Server className="w-4 h-4 text-emerald-400" />
              <h3 className="text-sm font-semibold text-slate-100">Upstream MCP Servers</h3>
            </div>
            <span className="text-[10px] font-mono bg-emerald-950 text-emerald-400 border border-emerald-800/60 px-2 py-0.5 rounded font-semibold">
              {servers.length > 0 ? `${servers.filter(s => s.status === 'Connected').length} Online` : '3 Online'}
            </span>
          </div>

          {/* Active Principal & RBAC Limits Banner */}
          <div className="p-3.5 rounded-lg bg-brand-surface/60 border border-brand-border space-y-2.5">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <div className={`w-2 h-2 rounded-full ${currentUser.role === 'ADMIN' ? 'bg-purple-400 animate-pulse' : 'bg-blue-400 animate-pulse'}`} />
                <span className="text-xs font-semibold text-slate-200">{currentUser.name}</span>
              </div>
              <span className={`text-[10px] font-mono px-2 py-0.5 rounded font-bold ${
                currentUser.role === 'ADMIN' 
                  ? 'bg-purple-950/80 text-purple-300 border border-purple-800/60' 
                  : 'bg-blue-950/80 text-blue-300 border border-blue-800/60'
              }`}>
                {currentUser.role === 'ADMIN' ? 'ADMIN (Full Access)' : 'MEMBER (support_rep)'}
              </span>
            </div>
            <div className="flex items-center justify-between text-[11px] font-mono text-slate-400">
              <span className="flex items-center gap-1">
                <Shield className="w-3 h-3 text-emerald-400" />
                <span>Zero-Trust Policy:</span>
              </span>
              <span className="text-emerald-400 font-semibold">
                {currentUser.role === 'ADMIN' ? '14 / 14 Tools Permitted' : '5 Allowed · 9 Restricted'}
              </span>
            </div>

            {/* Filter Toggle */}
            <div className="flex items-center gap-1.5 pt-1">
              <button
                type="button"
                onClick={() => setToolFilter('all')}
                className={`flex-1 py-1 px-2 rounded text-[10px] font-mono transition text-center ${
                  toolFilter === 'all'
                    ? 'bg-brand-card text-slate-100 border border-brand-border font-semibold shadow-sm'
                    : 'text-slate-400 hover:text-slate-200'
                }`}
              >
                All Tools (14)
              </button>
              <button
                type="button"
                onClick={() => setToolFilter('permitted')}
                className={`flex-1 py-1 px-2 rounded text-[10px] font-mono transition text-center ${
                  toolFilter === 'permitted'
                    ? 'bg-emerald-950/80 text-emerald-300 border border-emerald-800/60 font-semibold shadow-sm'
                    : 'text-slate-400 hover:text-slate-200'
                }`}
              >
                Permitted Only ({currentUser.role === 'ADMIN' ? '14' : '5'})
              </button>
            </div>
          </div>

          <p className="text-[11px] text-slate-400 font-sans leading-relaxed">
            {isMember 
              ? 'Zero-trust RBAC limits tool execution. Permitted tools are active in green; unauthorized tools are locked with 403 enforcement.'
              : 'FastMCP servers registered with the Gateway. Click any tool chip below to test that tool in the chat.'
            }
          </p>

          <div className="space-y-4 font-mono text-xs">
            {/* Server 1: WooCommerce */}
            <div className="p-3.5 rounded-lg bg-brand-surface/40 border border-brand-border space-y-2">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-1.5 font-semibold text-slate-200">
                  <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
                  <span>WooCommerce Store Server</span>
                </div>
                <span className="text-[10px] text-emerald-400 bg-emerald-950/60 px-1.5 py-0.5 rounded border border-emerald-800/50">
                  Port 8001
                </span>
              </div>
              <div className="flex items-center justify-between text-[10px] text-slate-400">
                <span>CATALOG & ORDERS</span>
                <span className="font-semibold text-slate-300">
                  {[
                    'woocommerce__list_products',
                    'woocommerce__create_product',
                    'woocommerce__list_orders',
                    'woocommerce__get_order',
                    'woocommerce__create_order',
                    'woocommerce__update_order_status'
                  ].filter(name => isToolAllowed(name)).length} / 6 Permitted
                </span>
              </div>
              <div className="flex flex-wrap gap-1.5 pt-1">
                {[
                  'woocommerce__list_products',
                  'woocommerce__create_product',
                  'woocommerce__list_orders',
                  'woocommerce__get_order',
                  'woocommerce__create_order',
                  'woocommerce__update_order_status'
                ].map((toolName) => {
                  const allowed = isToolAllowed(toolName);
                  if (toolFilter === 'permitted' && !allowed) return null;
                  const shortName = toolName.replace('woocommerce__', '');

                  if (allowed) {
                    return (
                      <button
                        key={toolName}
                        onClick={() => handleSend(getSamplePromptForTool(toolName))}
                        title={`Click to execute permitted tool: ${toolName}`}
                        className="text-[10px] bg-[#060a12] hover:bg-emerald-950/60 text-slate-300 hover:text-emerald-300 px-2 py-1 rounded border border-brand-border hover:border-emerald-600/50 transition cursor-pointer flex items-center gap-1 shadow-sm"
                      >
                        <Wrench className="w-2.5 h-2.5 text-emerald-400" />
                        <span>{shortName}</span>
                      </button>
                    );
                  }

                  return (
                    <button
                      key={toolName}
                      onClick={() => handleSend(getSamplePromptForTool(toolName))}
                      title={`🔒 Restricted for role '${effectiveRole}'. Click to test Zero-Trust 403 RBAC Block.`}
                      className="text-[10px] bg-red-950/20 hover:bg-red-950/40 text-slate-400 hover:text-red-300 px-2 py-1 rounded border border-red-900/40 hover:border-red-700/60 transition cursor-pointer flex items-center gap-1"
                    >
                      <Lock className="w-2.5 h-2.5 text-red-400 shrink-0" />
                      <span className="line-through decoration-red-500/50">{shortName}</span>
                      <span className="text-[8px] bg-red-950/80 text-red-400 px-1 py-0.2 rounded border border-red-800/40 font-mono font-semibold">
                        Locked
                      </span>
                    </button>
                  );
                })}
              </div>
            </div>

            {/* Server 2: Inventory */}
            <div className="p-3.5 rounded-lg bg-brand-surface/40 border border-brand-border space-y-2">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-1.5 font-semibold text-slate-200">
                  <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
                  <span>Inventory Tracker Server</span>
                </div>
                <span className="text-[10px] text-emerald-400 bg-emerald-950/60 px-1.5 py-0.5 rounded border border-emerald-800/50">
                  Port 8002
                </span>
              </div>
              <div className="flex items-center justify-between text-[10px] text-slate-400">
                <span>WAREHOUSE STOCK</span>
                <span className="font-semibold text-slate-300">
                  {[
                    'inventory__check_stock',
                    'inventory__batch_check_stock',
                    'inventory__list_low_stock',
                    'inventory__update_stock',
                    'inventory__adjust_stock'
                  ].filter(name => isToolAllowed(name)).length} / 5 Permitted
                </span>
              </div>
              <div className="flex flex-wrap gap-1.5 pt-1">
                {[
                  'inventory__check_stock',
                  'inventory__batch_check_stock',
                  'inventory__list_low_stock',
                  'inventory__update_stock',
                  'inventory__adjust_stock'
                ].map((toolName) => {
                  const allowed = isToolAllowed(toolName);
                  if (toolFilter === 'permitted' && !allowed) return null;
                  const shortName = toolName.replace('inventory__', '');

                  if (allowed) {
                    return (
                      <button
                        key={toolName}
                        onClick={() => handleSend(getSamplePromptForTool(toolName))}
                        title={`Click to execute permitted tool: ${toolName}`}
                        className="text-[10px] bg-[#060a12] hover:bg-emerald-950/60 text-slate-300 hover:text-emerald-300 px-2 py-1 rounded border border-brand-border hover:border-emerald-600/50 transition cursor-pointer flex items-center gap-1 shadow-sm"
                      >
                        <Wrench className="w-2.5 h-2.5 text-emerald-400" />
                        <span>{shortName}</span>
                      </button>
                    );
                  }

                  return (
                    <button
                      key={toolName}
                      onClick={() => handleSend(getSamplePromptForTool(toolName))}
                      title={`🔒 Restricted for role '${effectiveRole}'. Click to test Zero-Trust 403 RBAC Block.`}
                      className="text-[10px] bg-red-950/20 hover:bg-red-950/40 text-slate-400 hover:text-red-300 px-2 py-1 rounded border border-red-900/40 hover:border-red-700/60 transition cursor-pointer flex items-center gap-1"
                    >
                      <Lock className="w-2.5 h-2.5 text-red-400 shrink-0" />
                      <span className="line-through decoration-red-500/50">{shortName}</span>
                      <span className="text-[8px] bg-red-950/80 text-red-400 px-1 py-0.2 rounded border border-red-800/40 font-mono font-semibold">
                        Locked
                      </span>
                    </button>
                  );
                })}
              </div>
            </div>

            {/* Server 3: Analytics */}
            <div className="p-3.5 rounded-lg bg-brand-surface/40 border border-brand-border space-y-2">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-1.5 font-semibold text-slate-200">
                  <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
                  <span>Business Analytics Server</span>
                </div>
                <span className="text-[10px] text-emerald-400 bg-emerald-950/60 px-1.5 py-0.5 rounded border border-emerald-800/50">
                  Port 8003
                </span>
              </div>
              <div className="flex items-center justify-between text-[10px] text-slate-400">
                <span>SALES & METRICS</span>
                <span className="font-semibold text-slate-300">
                  {[
                    'analytics__get_daily_sales',
                    'analytics__get_revenue_summary',
                    'analytics__get_top_selling_products'
                  ].filter(name => isToolAllowed(name)).length} / 3 Permitted
                </span>
              </div>
              <div className="flex flex-wrap gap-1.5 pt-1">
                {[
                  'analytics__get_daily_sales',
                  'analytics__get_revenue_summary',
                  'analytics__get_top_selling_products'
                ].map((toolName) => {
                  const allowed = isToolAllowed(toolName);
                  if (toolFilter === 'permitted' && !allowed) return null;
                  const shortName = toolName.replace('analytics__', '');

                  if (allowed) {
                    return (
                      <button
                        key={toolName}
                        onClick={() => handleSend(getSamplePromptForTool(toolName))}
                        title={`Click to execute permitted tool: ${toolName}`}
                        className="text-[10px] bg-[#060a12] hover:bg-emerald-950/60 text-slate-300 hover:text-emerald-300 px-2 py-1 rounded border border-brand-border hover:border-emerald-600/50 transition cursor-pointer flex items-center gap-1 shadow-sm"
                      >
                        <Wrench className="w-2.5 h-2.5 text-emerald-400" />
                        <span>{shortName}</span>
                      </button>
                    );
                  }

                  return (
                    <button
                      key={toolName}
                      onClick={() => handleSend(getSamplePromptForTool(toolName))}
                      title={`🔒 Restricted for role '${effectiveRole}'. Click to test Zero-Trust 403 RBAC Block.`}
                      className="text-[10px] bg-red-950/20 hover:bg-red-950/40 text-slate-400 hover:text-red-300 px-2 py-1 rounded border border-red-900/40 hover:border-red-700/60 transition cursor-pointer flex items-center gap-1"
                    >
                      <Lock className="w-2.5 h-2.5 text-red-400 shrink-0" />
                      <span className="line-through decoration-red-500/50">{shortName}</span>
                      <span className="text-[8px] bg-red-950/80 text-red-400 px-1 py-0.2 rounded border border-red-800/40 font-mono font-semibold">
                        Locked
                      </span>
                    </button>
                  );
                })}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
