import React, { useState } from 'react';
import { 
  Bot, 
  Send, 
  Sparkles, 
  Layers, 
  ShieldCheck, 
  Server, 
  Activity, 
  CheckCircle2, 
  ExternalLink,
  Lock,
  ArrowRight
} from 'lucide-react';
import { ChatMessage, User } from '../types';

interface ChatViewProps {
  messages: ChatMessage[];
  currentUser: User;
  onSendMessage?: (content: string) => void;
}

export const ChatView: React.FC<ChatViewProps> = ({
  messages: initialMessages,
  currentUser,
  onSendMessage
}) => {
  const [messages, setMessages] = useState<ChatMessage[]>(initialMessages);
  const [inputPrompt, setInputPrompt] = useState('');
  const [selectedModel, setSelectedModel] = useState('openai/gpt-oss-120b');
  const [isLoading, setIsLoading] = useState(false);

  const quickPrompts = [
    "Show me today's WooCommerce orders and check stock for the top-selling product.",
    "Check low-stock inventory across warehouses",
    "List open WooCommerce orders",
    "Compare daily sales with 30-day baseline"
  ];

  const handleSend = (textToSend?: string) => {
    const text = textToSend || inputPrompt;
    if (!text.trim()) return;

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

    // Simulate intelligent multi-step tool call response
    setTimeout(() => {
      let botResponse: ChatMessage;

      if (text.toLowerCase().includes('stock') || text.toLowerCase().includes('order')) {
        botResponse = {
          id: `bot-${Date.now()}`,
          role: 'assistant',
          content: "I executed two sequential tool invocations across **WooCommerce** and **Inventory**. The top order product is **Ergonomic Mechanical Keyboard (SKU: KB-992)**. The Inventory service confirms healthy stock across both regional warehouses.",
          timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
          model: selectedModel,
          steps: [
            {
              stepNumber: 1,
              server: 'WOOCOMMERCE SERVER',
              tool: 'woocommerce__list_orders',
              args: { limit: 5, status: 'completed' },
              result: {
                orders_count: 5,
                top_sku: 'KB-992',
                product_name: 'Ergonomic Mechanical Keyboard',
                units_sold_today: 14,
                gross_revenue: 1666.00
              },
              status: '200 OK',
              durationMs: 128,
              summaryNote: 'Returned 5 orders. Extracted highest velocity SKU: KB-992'
            },
            {
              stepNumber: 2,
              server: 'INVENTORY SERVICE',
              tool: 'inventory__get_sku_stock',
              args: { sku: 'KB-992' },
              result: {
                sku: 'KB-992',
                total_stock: 170,
                allocations: [
                  { hub: 'Austin Hub', qty: 142 },
                  { hub: 'Berlin Central', qty: 28 }
                ],
                reorder_point: 40
              },
              status: '200 OK',
              durationMs: 94,
              summaryNote: 'Warehouse telemetry verified against 2 locations'
            }
          ]
        };
      } else {
        botResponse = {
          id: `bot-${Date.now()}`,
          role: 'assistant',
          content: `I processed your request using **${selectedModel}** via the MCP Gateway. All 18 tools from WooCommerce, Inventory, and Analytics are available for query execution.`,
          timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
          model: selectedModel,
          steps: [
            {
              stepNumber: 1,
              server: 'ANALYTICS & BI ENGINE',
              tool: 'analytics__get_daily_sales',
              args: { date: 'today' },
              result: { total_sales: 4210.50, orders_count: 24, aov: 175.43 },
              status: '200 OK',
              durationMs: 76,
              summaryNote: 'Daily performance aggregates computed'
            }
          ]
        };
      }

      setMessages(prev => [...prev, botResponse]);
      setIsLoading(false);
    }, 1200);
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
              <h2 className="text-sm font-semibold text-slate-100">Production Operations & Catalog Check</h2>
            </div>
            <div className="flex items-center gap-2 text-[11px] font-mono text-slate-400 mt-0.5">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
              <span>Active Context: 18 Tools Across 3 Servers</span>
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
              <option value="claude-3-7-sonnet">Claude 3.7 Sonnet</option>
            </select>

            {/* Zero-Trust Badge */}
            <span className={`text-[10px] font-mono px-2 py-1 rounded font-semibold border ${
              currentUser.role === 'ADMIN'
                ? 'bg-purple-950/60 text-purple-300 border-purple-800/60'
                : 'bg-emerald-950/60 text-emerald-300 border-emerald-800/60'
            }`}>
              {currentUser.role === 'ADMIN' ? 'ZERO-TRUST: ADMIN' : 'ZERO-TRUST: MEMBER'}
            </span>
          </div>
        </div>

        {/* Message History Feed */}
        <div className="flex-1 overflow-y-auto p-4 space-y-5">
          {/* Gateway Session Banner */}
          <div className="text-center">
            <span className="inline-flex items-center gap-2 text-[10px] font-mono text-slate-400 bg-brand-surface/60 border border-brand-border px-3 py-1 rounded-full">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
              Gateway Session initialized with 3 upstream sockets (REST, SSE, Stdio) • Audit trace session #urm-88214
            </span>
          </div>

          {messages.map((msg) => (
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
                /* Assistant Bubble with Decomposed Execution Steps */
                <div className="flex justify-start">
                  <div className="max-w-2xl w-full space-y-3">
                    <div className="flex items-center gap-2 text-[10px] font-mono text-slate-400">
                      <span className="font-semibold text-emerald-400 flex items-center gap-1">
                        <Bot className="w-3.5 h-3.5" />
                        Urumi Gateway Copilot
                      </span>
                      <span>model: {msg.model || 'openai/gpt-oss-120b'}</span>
                      <span>{msg.timestamp}</span>
                    </div>

                    {/* Decomposing Plan Banner */}
                    {msg.steps && msg.steps.length > 0 && (
                      <div className="p-2.5 rounded-lg bg-[#070c14] border border-brand-border text-xs font-mono text-slate-400 flex items-center gap-2">
                        <span className="text-emerald-400">⚡</span>
                        <span>Evaluating query intentions. Decomposing into {msg.steps.length} sequential MCP upstream RPC invocations...</span>
                      </div>
                    )}

                    {/* Step-by-Step Tool Cards */}
                    {msg.steps?.map((step) => (
                      <div 
                        key={step.stepNumber}
                        className="rounded-lg bg-[#070b13] border border-brand-border overflow-hidden text-xs font-mono"
                      >
                        {/* Step Header */}
                        <div className="p-2.5 bg-brand-surface/40 border-b border-brand-border flex items-center justify-between">
                          <div className="flex items-center gap-2">
                            <span className="w-4 h-4 rounded bg-emerald-500/20 text-emerald-400 flex items-center justify-center text-[10px] font-bold">
                              {step.stepNumber}
                            </span>
                            <span className="text-[10px] font-semibold text-slate-400">{step.server}</span>
                            <span className="text-emerald-400 font-semibold">{step.tool}</span>
                            <span className="text-slate-400 text-[10px]">({JSON.stringify(step.args)})</span>
                          </div>
                          <span className="text-[10px] font-semibold text-emerald-400 bg-emerald-950/70 border border-emerald-800/60 px-1.5 py-0.2 rounded">
                            {step.status} {step.durationMs}ms
                          </span>
                        </div>

                        {/* Step Output Box */}
                        <div className="p-3 bg-[#04070e] text-slate-300">
                          <div className="flex items-center gap-1.5 text-emerald-400 mb-1.5 font-semibold text-[11px]">
                            <CheckCircle2 className="w-3.5 h-3.5" />
                            <span>{step.summaryNote}</span>
                          </div>
                          <pre className="p-2 rounded bg-[#060a12] text-[11px] text-slate-400 border border-brand-border/60 overflow-x-auto">
                            {JSON.stringify(step.result, null, 2)}
                          </pre>
                        </div>
                      </div>
                    ))}

                    {/* Final Conversational Synthesis */}
                    <div className="p-4 rounded-xl bg-brand-surface/40 border border-brand-border text-xs text-slate-200 leading-relaxed font-sans">
                      {msg.content}
                    </div>
                  </div>
                </div>
              )}
            </div>
          ))}

          {isLoading && (
            <div className="flex items-center gap-3 p-3 rounded-lg bg-brand-surface/30 border border-brand-border text-xs font-mono text-emerald-400 animate-pulse">
              <Sparkles className="w-4 h-4 animate-spin" />
              <span>Gateway orchestrating tools across WooCommerce & Inventory...</span>
            </div>
          )}
        </div>

        {/* Quick Suggestion Chips */}
        <div className="p-2.5 bg-[#070b13] border-t border-brand-border flex items-center gap-2 overflow-x-auto">
          {quickPrompts.map((p, i) => (
            <button
              key={i}
              onClick={() => handleSend(p)}
              className="text-[11px] font-mono text-slate-400 hover:text-emerald-400 bg-brand-surface hover:bg-brand-surface/80 border border-brand-border px-2.5 py-1 rounded-md shrink-0 transition"
            >
              + {p}
            </button>
          ))}
        </div>

        {/* Input Bar */}
        <div className="p-3 bg-[#0a101b] border-t border-brand-border">
          <div className="relative">
            <textarea
              rows={2}
              value={inputPrompt}
              onChange={(e) => setInputPrompt(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === 'Enter' && !e.shiftKey) {
                  e.preventDefault();
                  handleSend();
                }
              }}
              placeholder="Ask Urumi AI to orchestrate tools across WooCommerce, Inventory, and Analytics... (Press Return to send)"
              className="w-full bg-[#060a12] border border-brand-border rounded-lg p-3 pb-8 text-xs text-slate-100 placeholder-slate-400 focus:outline-none focus:border-emerald-500/60 font-mono resize-none transition"
            />
            
            {/* Inside Input Bottom Bar */}
            <div className="absolute bottom-2.5 left-3 right-3 flex items-center justify-between text-[10px] font-mono text-slate-400 pointer-events-none">
              <div className="flex items-center gap-3">
                <span className="flex items-center gap-1">
                  <Layers className="w-3 h-3 text-emerald-400" />
                  <span>3 servers / 18 tools connected</span>
                </span>
                <span className="flex items-center gap-1 text-emerald-400">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
                  <span>Zero-Trust Proxy Ingress</span>
                </span>
              </div>
              <button
                type="button"
                onClick={() => handleSend()}
                disabled={!inputPrompt.trim() || isLoading}
                className="pointer-events-auto p-1.5 rounded-md bg-emerald-500 hover:bg-emerald-600 disabled:opacity-40 text-slate-950 font-bold transition cursor-pointer"
              >
                <Send className="w-3 h-3" />
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Right Column: Active Upstreams & Gateway Telemetry */}
      <div className="space-y-6">
        {/* Active Upstreams Card */}
        <div className="p-5 rounded-xl bg-brand-card border border-brand-border space-y-4">
          <div className="flex items-center justify-between pb-2 border-b border-brand-border">
            <div className="flex items-center gap-2">
              <Server className="w-4 h-4 text-emerald-400" />
              <h3 className="text-sm font-semibold text-slate-100">Active Upstreams</h3>
            </div>
            <span className="text-[10px] font-mono bg-emerald-950 text-emerald-400 border border-emerald-800/60 px-1.5 py-0.2 rounded font-semibold">
              3 Online
            </span>
          </div>

          <div className="space-y-3 font-mono text-xs">
            {/* WooCommerce */}
            <div className="p-3 rounded-lg bg-brand-surface/40 border border-brand-border space-y-1.5">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-1.5 font-semibold text-slate-200">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
                  <span>WooCommerce Core</span>
                </div>
                <span className="text-[10px] text-slate-400">REST / SSE</span>
              </div>
              <div className="flex items-center justify-between text-[11px] text-slate-400">
                <span>7 Exposed Tools</span>
                <span className="text-emerald-400 font-semibold">98.9% Success</span>
              </div>
              <div className="flex items-center gap-1 pt-1">
                <span className="text-[9px] bg-[#070c14] px-1.5 py-0.5 rounded border border-brand-border text-slate-300">list_orders</span>
                <span className="text-[9px] bg-[#070c14] px-1.5 py-0.5 rounded border border-brand-border text-slate-300">create_product</span>
              </div>
            </div>

            {/* Inventory */}
            <div className="p-3 rounded-lg bg-brand-surface/40 border border-brand-border space-y-1.5">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-1.5 font-semibold text-slate-200">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
                  <span>Inventory Service</span>
                </div>
                <span className="text-[10px] text-slate-400">Stdio Pipe</span>
              </div>
              <div className="flex items-center justify-between text-[11px] text-slate-400">
                <span>5 Exposed Tools</span>
                <span className="text-emerald-400 font-semibold">100% Success</span>
              </div>
              <div className="flex items-center gap-1 pt-1">
                <span className="text-[9px] bg-[#070c14] px-1.5 py-0.5 rounded border border-brand-border text-slate-300">get_sku_stock</span>
                <span className="text-[9px] bg-[#070c14] px-1.5 py-0.5 rounded border border-brand-border text-slate-300">reserve_sku</span>
              </div>
            </div>

            {/* Analytics */}
            <div className="p-3 rounded-lg bg-brand-surface/40 border border-brand-border space-y-1.5">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-1.5 font-semibold text-slate-200">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
                  <span>Analytics & BI Engine</span>
                </div>
                <span className="text-[10px] text-slate-400">gRPC Bridge</span>
              </div>
              <div className="flex items-center justify-between text-[11px] text-slate-400">
                <span>6 Exposed Tools</span>
                <span className="text-amber-400 font-semibold">RBAC Guarded</span>
              </div>
              <div className="flex items-center gap-1 pt-1">
                <span className="text-[9px] bg-[#070c14] px-1.5 py-0.5 rounded border border-brand-border text-slate-300">run_query</span>
                <span className="text-[9px] bg-red-950 text-red-400 px-1.5 py-0.5 rounded border border-red-800/60">Policy Block</span>
              </div>
            </div>
          </div>
        </div>

        {/* Gateway Telemetry & Security Card */}
        <div className="p-5 rounded-xl bg-brand-card border border-brand-border space-y-3 font-mono text-xs">
          <div className="flex items-center justify-between pb-2 border-b border-brand-border">
            <div className="flex items-center gap-2">
              <Activity className="w-4 h-4 text-emerald-400" />
              <h3 className="text-sm font-semibold text-slate-100 font-sans">Gateway Telemetry</h3>
            </div>
            <span className="text-[10px] text-slate-400">⚙</span>
          </div>

          <div className="space-y-2">
            <div className="flex items-center justify-between text-slate-400">
              <span>Rate Limit (Rolling Window):</span>
              <span className="text-slate-200 font-semibold">32 / 500 req/min</span>
            </div>
            <div className="w-full bg-[#070c14] h-1.5 rounded-full overflow-hidden">
              <div className="bg-emerald-400 h-full w-[12%]"></div>
            </div>

            <div className="flex items-center justify-between text-slate-400 pt-1">
              <span>Average MCP Latency:</span>
              <span className="text-emerald-400 font-semibold">~142ms</span>
            </div>

            <div className="pt-2 border-t border-brand-border/60 space-y-1.5 text-[11px]">
              <div className="flex items-center justify-between">
                <span className="text-slate-400">• Prompt Injection Filter</span>
                <span className="text-emerald-400 font-semibold">Enabled</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-slate-400">• PII Redaction Engine</span>
                <span className="text-emerald-400 font-semibold">Active</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-slate-400">• Financial Data Boundary</span>
                <span className="text-red-400 font-semibold">Strict Deny</span>
              </div>
            </div>
          </div>

          <div className="pt-3 border-t border-brand-border/60">
            <a 
              href="#schemas" 
              onClick={(e) => e.preventDefault()}
              className="text-emerald-400 hover:text-emerald-300 text-xs flex items-center justify-between"
            >
              <span>Inspect MCP Schemas</span>
              <ArrowRight className="w-3.5 h-3.5" />
            </a>
          </div>
        </div>
      </div>
    </div>
  );
};
