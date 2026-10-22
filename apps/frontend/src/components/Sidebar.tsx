import React from 'react';
import { 
  LayoutDashboard, 
  Server, 
  Store,
  ShieldCheck, 
  KeyRound, 
  ScrollText, 
  Bot, 
  ExternalLink,
  ChevronDown,
  Layers,
  Terminal,
  Activity
} from 'lucide-react';
import { User } from '../types';

interface SidebarProps {
  currentView: string;
  setCurrentView: (view: string) => void;
  currentUser: User;
  onToggleUser: () => void;
}

export const Sidebar: React.FC<SidebarProps> = ({
  currentView,
  setCurrentView,
  currentUser,
  onToggleUser
}) => {
  const navItems = [
    { id: 'overview', label: 'Overview', icon: LayoutDashboard },
    { id: 'servers', label: 'MCP Servers', icon: Server, badge: '3' },
    { id: 'stores', label: 'Stores Provisioner', icon: Store, badge: 'K8s', isHighlight: true },
    { id: 'permissions', label: 'Tool Permissions', icon: ShieldCheck, hasDot: true },
    { id: 'telemetry', label: 'Telemetry & SRE', icon: Activity, badge: 'LIVE', isHighlight: true },
    { id: 'keys', label: 'Team & API Keys', icon: KeyRound },
    { id: 'audit', label: 'Audit Logs', icon: ScrollText },
    { id: 'chat', label: 'AI Chat', icon: Bot, isHighlight: true },
  ];

  return (
    <aside className="w-64 bg-brand-sidebar border-r border-brand-border flex flex-col justify-between shrink-0 h-screen select-none">
      <div className="flex flex-col">
        {/* Brand Header */}
        <div className="p-4 border-b border-brand-border">
          <div className="flex items-center gap-2 mb-3">
            <div className="w-8 h-8 rounded-lg bg-emerald-500/20 border border-emerald-500/40 flex items-center justify-center text-emerald-400 font-bold shadow-sm">
              <Layers className="w-4 h-4" />
            </div>
            <div>
              <span className="font-bold text-slate-100 tracking-tight text-base">Urumi</span>
              <span className="ml-2 text-[10px] font-mono tracking-wider bg-emerald-950/80 text-emerald-400 border border-emerald-800/60 px-1.5 py-0.5 rounded font-semibold">
                MCP GATEWAY
              </span>
            </div>
          </div>

          {/* Workspace Switcher */}
          <div className="flex items-center justify-between p-2 rounded-lg bg-brand-card/80 border border-brand-border/70 text-xs text-slate-300 hover:border-slate-700 cursor-pointer transition">
            <div className="flex items-center gap-2 overflow-hidden">
              <div className="w-4 h-4 rounded bg-emerald-500/30 flex items-center justify-center text-emerald-300 font-mono text-[10px]">
                ⚡
              </div>
              <div className="truncate">
                <div className="font-semibold text-slate-200 truncate">Acme Workspace</div>
                <div className="text-[10px] text-slate-400 truncate">Enterprise Plan</div>
              </div>
            </div>
            <ChevronDown className="w-3.5 h-3.5 text-slate-500 shrink-0" />
          </div>
        </div>

        {/* Navigation Sections */}
        <div className="px-3 py-4">
          <div className="text-[10px] font-mono font-semibold tracking-wider text-slate-400 px-3 mb-2 uppercase">
            Gateway Orchestration
          </div>
          <nav className="space-y-1">
            {navItems.map((item) => {
              const Icon = item.icon;
              const isActive = currentView === item.id;
              return (
                <button
                  key={item.id}
                  onClick={() => setCurrentView(item.id)}
                  className={`w-full flex items-center justify-between px-3 py-2 rounded-lg text-xs font-medium transition ${
                    isActive 
                      ? 'bg-emerald-500/15 text-emerald-400 border border-emerald-500/30 font-semibold' 
                      : 'text-slate-300 hover:text-slate-100 hover:bg-brand-surface/60'
                  }`}
                >
                  <div className="flex items-center gap-2.5">
                    <Icon className={`w-4 h-4 ${isActive ? 'text-emerald-400' : 'text-slate-400'}`} />
                    <span>{item.label}</span>
                  </div>
                  {item.badge && (
                    <span className="text-[10px] font-mono bg-brand-surface text-slate-300 px-1.5 py-0.5 rounded border border-brand-border">
                      {item.badge}
                    </span>
                  )}
                  {item.hasDot && (
                    <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
                  )}
                </button>
              );
            })}
          </nav>

          <div className="text-[10px] font-mono font-semibold tracking-wider text-slate-400 px-3 mt-6 mb-2 uppercase">
            Client Endpoints
          </div>
          <button
            onClick={() => setCurrentView('member-overview')}
            className={`w-full flex items-center justify-between px-3 py-2 rounded-lg text-xs font-medium transition ${
              currentView === 'member-overview'
                ? 'bg-emerald-500/15 text-emerald-400 border border-emerald-500/30 font-semibold'
                : 'text-slate-300 hover:text-slate-100 hover:bg-brand-surface/60'
            }`}
          >
            <div className="flex items-center gap-2.5">
              <Terminal className={`w-4 h-4 ${currentView === 'member-overview' ? 'text-emerald-400' : 'text-slate-400'}`} />
              <span>Member Overview</span>
            </div>
            <span className="text-[9px] font-mono bg-emerald-950 text-emerald-400 border border-emerald-800/80 px-1.5 py-0.5 rounded">
              {currentUser.role === 'MEMBER' ? 'Current' : 'Preview'}
            </span>
          </button>
        </div>
      </div>

      {/* Footer & User Profile Switcher */}
      <div className="p-3 border-t border-brand-border space-y-2">
        <a 
          href="#docs" 
          onClick={(e) => { e.preventDefault(); setCurrentView('overview'); }}
          className="flex items-center justify-between px-3 py-1.5 text-xs text-slate-400 hover:text-slate-200 transition"
        >
          <span className="flex items-center gap-2">
            <span className="text-slate-400">📖</span>
            <span>Docs & Spec</span>
          </span>
          <ExternalLink className="w-3 h-3 text-slate-400" />
        </a>

        {/* User Card with Role Toggle Button */}
        <div 
          onClick={onToggleUser}
          title="Click to toggle between Admin and Member roles for live demo!"
          className="flex items-center justify-between p-2 rounded-lg bg-brand-surface/60 border border-brand-border hover:border-emerald-500/40 cursor-pointer transition group"
        >
          <div className="flex items-center gap-2.5 overflow-hidden">
            <img 
              src={currentUser.avatarUrl} 
              alt={currentUser.name}
              className="w-8 h-8 rounded-full object-cover border border-brand-borderLight shrink-0" 
            />
            <div className="truncate text-left">
              <div className="text-xs font-semibold text-slate-200 group-hover:text-emerald-400 transition truncate flex items-center gap-1.5">
                {currentUser.name}
                <span className={`text-[9px] px-1 py-0.2 rounded font-mono font-medium ${
                  currentUser.role === 'ADMIN' 
                    ? 'bg-purple-900/40 text-purple-300 border border-purple-800/60'
                    : 'bg-emerald-900/40 text-emerald-300 border border-emerald-800/60'
                }`}>
                  {currentUser.role === 'ADMIN' ? 'Admin' : 'Member'}
                </span>
              </div>
              <div className="text-[10px] text-slate-400 truncate">{currentUser.email}</div>
            </div>
          </div>
          <div className="text-[10px] text-slate-400 group-hover:text-emerald-400 font-mono">
            ⇄ Switch
          </div>
        </div>
      </div>
    </aside>
  );
};
