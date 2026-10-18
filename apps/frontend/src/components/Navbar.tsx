import React from 'react';
import { Search, Bell, CheckCircle2 } from 'lucide-react';
import { User } from '../types';

interface NavbarProps {
  currentView: string;
  currentUser: User;
}

export const Navbar: React.FC<NavbarProps> = ({ currentView, currentUser }) => {
  const getViewTitle = (id: string) => {
    switch (id) {
      case 'overview': return 'Overview';
      case 'servers': return 'MCP Servers';
      case 'permissions': return 'Tool Permissions';
      case 'keys': return 'Team & API Keys';
      case 'audit': return 'Audit Logs';
      case 'chat': return 'AI Chat';
      case 'member-overview': return 'Member Overview';
      default: return 'Console';
    }
  };

  return (
    <header className="h-14 border-b border-brand-border bg-brand-bg/80 backdrop-blur-md px-6 flex items-center justify-between sticky top-0 z-20">
      {/* Breadcrumbs */}
      <div className="flex items-center gap-2 text-xs font-mono text-slate-400">
        <span className="text-slate-400">Acme Workspace</span>
        <span className="text-slate-600">/</span>
        <span className="text-slate-400">MCP Gateway Console</span>
        <span className="text-slate-600">/</span>
        <span className="text-emerald-400 font-semibold">{getViewTitle(currentView)}</span>
      </div>

      {/* Center Search Bar */}
      <div className="flex-1 max-w-md mx-6">
        <div className="relative flex items-center">
          <Search className="w-3.5 h-3.5 text-slate-400 absolute left-3 pointer-events-none" />
          <input 
            type="text" 
            placeholder="Search tools, servers, logs..."
            className="w-full bg-brand-card/90 border border-brand-border text-xs text-slate-200 placeholder-slate-400 pl-8 pr-12 py-1.5 rounded-lg focus:outline-none focus:border-emerald-500/60 focus:ring-1 focus:ring-emerald-500/30 transition"
          />
          <kbd className="absolute right-2.5 px-1.5 py-0.5 text-[10px] font-mono text-slate-400 bg-brand-surface rounded border border-brand-border pointer-events-none">
            ⌘K
          </kbd>
        </div>
      </div>

      {/* Right Status & Profile Badges */}
      <div className="flex items-center gap-4">
        {/* Live Cluster Upstream Status Badge */}
        <div className="flex items-center gap-2 px-2.5 py-1 rounded-full bg-emerald-950/40 border border-emerald-800/60 text-xs font-mono text-emerald-400">
          <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
          <span className="font-medium text-[11px]">All 3 Upstreams Healthy</span>
          <span className="text-slate-400">•</span>
          <span className="text-[11px] text-slate-400">42ms</span>
        </div>

        {/* Notification Bell */}
        <button 
          title="Notifications"
          className="p-1.5 rounded-lg text-slate-400 hover:text-slate-200 hover:bg-brand-surface transition relative"
        >
          <Bell className="w-4 h-4" />
          <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 absolute top-1.5 right-1.5"></span>
        </button>

        {/* User Mini Avatar */}
        <div className="flex items-center gap-2 pl-2 border-l border-brand-border">
          <img 
            src={currentUser.avatarUrl} 
            alt={currentUser.name}
            className="w-7 h-7 rounded-full object-cover border border-emerald-500/30"
          />
        </div>
      </div>
    </header>
  );
};
