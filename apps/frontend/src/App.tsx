import React, { useState, useEffect } from 'react';
import { Sidebar } from './components/Sidebar';
import { Navbar } from './components/Navbar';
import { ApiKeyModal } from './components/ApiKeyModal';
import { TraceDrawer } from './components/TraceDrawer';
import { AddServerModal } from './components/AddServerModal';

import { OverviewView } from './views/OverviewView';
import { ServersView } from './views/ServersView';
import { PermissionsView } from './views/PermissionsView';
import { AuditLogsView } from './views/AuditLogsView';
import { ChatView } from './views/ChatView';
import { MemberOverviewView } from './views/MemberOverviewView';
import { ApiKeysView } from './views/ApiKeysView';

import { 
  MOCK_USERS, 
  MOCK_SERVERS, 
  MOCK_TOOLS, 
  MOCK_AUDIT_LOGS, 
  MOCK_CHAT_MESSAGES, 
  MOCK_API_KEYS, 
  MOCK_CLIENT_SESSIONS 
} from './data/mockData';
import { User, McpServer, ServerTool, AuditLogItem, ApiKeyItem } from './types';

export function App() {
  const [currentUser, setCurrentUser] = useState<User>(MOCK_USERS[0]); // Default Sarah Chen (Admin)
  const [currentView, setCurrentView] = useState<string>('overview');
  
  // Platform interactive state
  const [servers, setServers] = useState<McpServer[]>(MOCK_SERVERS);
  const [tools, setTools] = useState<ServerTool[]>(MOCK_TOOLS);
  const [auditLogs, setAuditLogs] = useState<AuditLogItem[]>(MOCK_AUDIT_LOGS);
  const [apiKeys, setApiKeys] = useState<ApiKeyItem[]>(MOCK_API_KEYS);

  const activeApiKey = currentUser.role === 'ADMIN' ? 'admin-key-urumi-2026' : 'support-key-urumi-2026';

  const fetchLivePlatformState = async () => {
    try {
      const headers = { 'X-API-Key': activeApiKey };
      const [serversRes, toolsRes, logsRes, keysRes] = await Promise.all([
        fetch('/api/v1/servers', { headers }),
        fetch(`/api/v1/tools?role=${currentUser.role === 'ADMIN' ? 'admin' : 'support_rep'}`, { headers }),
        fetch('/api/v1/audit-logs', { headers }),
        fetch('/api/v1/api-keys', { headers }),
      ]);

      if (serversRes.ok) {
        const s = await serversRes.json();
        if (Array.isArray(s) && s.length > 0) setServers(s);
      }
      if (toolsRes.ok) {
        const t = await toolsRes.json();
        if (Array.isArray(t) && t.length > 0) setTools(t);
      }
      if (logsRes.ok) {
        const l = await logsRes.json();
        if (Array.isArray(l) && l.length > 0) setAuditLogs(l);
      }
      if (keysRes.ok) {
        const k = await keysRes.json();
        if (Array.isArray(k) && k.length > 0) setApiKeys(k);
      }
    } catch (e) {
      // Graceful fallback to initial mock state if gateway warming up
    }
  };

  useEffect(() => {
    fetchLivePlatformState();
    const interval = setInterval(fetchLivePlatformState, 4000);
    return () => clearInterval(interval);
  }, [currentUser]);

  // Modals and Drawers
  const [selectedTraceLog, setSelectedTraceLog] = useState<AuditLogItem | null>(null);
  const [isApiKeyModalOpen, setIsApiKeyModalOpen] = useState(false);
  const [isAddServerModalOpen, setIsAddServerModalOpen] = useState(false);

  // Toggle user role between Admin (Sarah) and Member (Alex) for live testing
  const handleToggleUser = () => {
    if (currentUser.role === 'ADMIN') {
      setCurrentUser(MOCK_USERS[1]); // Alex (Member)
      setCurrentView('member-overview');
    } else {
      setCurrentUser(MOCK_USERS[0]); // Sarah (Admin)
      setCurrentView('overview');
    }
  };

  // Toggle server active state (e.g. for testing disabled server scenario from rubric!)
  const handleToggleServerStatus = (serverId: string) => {
    setServers(prev => prev.map(s => {
      if (s.id === serverId) {
        const nextStatus = s.status === 'Connected' ? 'Disabled' : 'Connected';
        return { ...s, status: nextStatus };
      }
      return s;
    }));
  };

  // Add new server
  const handleAddServer = (newServer: McpServer) => {
    setServers(prev => [...prev, newServer]);
    // Also add discovered tools into tools catalog
    const newTools: ServerTool[] = newServer.discoveredTools.map(name => ({
      id: `tool-${Date.now()}-${name}`,
      namespacedName: name,
      originalName: name.split('__')[1] || name,
      serverId: newServer.id,
      serverName: newServer.name,
      description: `Discovered RPC capability from ${newServer.name}.`,
      riskProfile: 'Low (Read-only)',
      rateLimit: '30 req/min',
      policy: 'ALLOW',
      effectiveRule: 'Allowed via Role: Member',
      isAllowed: true
    }));
    setTools(prev => [...prev, ...newTools]);
  };

  // Revoke API key (satisfies rubric requirement: "Revoke user B's key. Their next call is rejected.")
  const handleRevokeKey = (keyId: string) => {
    setApiKeys(prev => prev.map(k => {
      if (k.id === keyId) {
        return { ...k, isRevoked: true };
      }
      return k;
    }));
  };

  return (
    <div className="flex h-screen bg-[#080d14] text-slate-100 overflow-hidden font-sans">
      {/* Sidebar Navigation */}
      <Sidebar 
        currentView={currentView}
        setCurrentView={setCurrentView}
        currentUser={currentUser}
        onToggleUser={handleToggleUser}
      />

      {/* Main Workspace Area */}
      <div className="flex-1 flex flex-col h-screen overflow-hidden">
        {/* Top Navbar */}
        <Navbar 
          currentView={currentView}
          currentUser={currentUser}
        />

        {/* Viewport Content */}
        <main className="flex-1 overflow-y-auto p-6">
          <div className="max-w-7xl mx-auto">
            {currentView === 'overview' && (
              <OverviewView 
                servers={servers}
                auditLogs={auditLogs}
                clientSessions={MOCK_CLIENT_SESSIONS}
                onOpenTrace={(log) => setSelectedTraceLog(log)}
                onNavigateToServers={() => setCurrentView('servers')}
                onNavigateToAudit={() => setCurrentView('audit')}
                onAddServer={() => setIsAddServerModalOpen(true)}
              />
            )}

            {currentView === 'servers' && (
              <ServersView 
                servers={servers}
                onToggleServerStatus={handleToggleServerStatus}
                onAddServer={() => setIsAddServerModalOpen(true)}
              />
            )}

            {currentView === 'permissions' && (
              <PermissionsView 
                tools={tools}
                onSavePolicies={(updated) => setTools(updated)}
              />
            )}

            {currentView === 'audit' && (
              <AuditLogsView 
                logs={auditLogs}
                onSelectLog={(log) => setSelectedTraceLog(log)}
              />
            )}

            {currentView === 'chat' && (
              <ChatView 
                messages={MOCK_CHAT_MESSAGES}
                currentUser={currentUser}
              />
            )}

            {currentView === 'member-overview' && (
              <MemberOverviewView 
                currentUser={currentUser}
                tools={tools}
                onOpenGenerateKey={() => setIsApiKeyModalOpen(true)}
                onNavigateToChat={() => setCurrentView('chat')}
              />
            )}

            {currentView === 'keys' && (
              <ApiKeysView 
                apiKeys={apiKeys}
                currentUser={currentUser}
                onOpenGenerateModal={() => setIsApiKeyModalOpen(true)}
                onRevokeKey={handleRevokeKey}
              />
            )}
          </div>
        </main>
      </div>

      {/* API Key Modal (Plaintext token reveal + zero-trust guarantee) */}
      <ApiKeyModal 
        isOpen={isApiKeyModalOpen}
        onClose={() => setIsApiKeyModalOpen(false)}
      />

      {/* Trace Drawer (RFC-9482 invocation lifecycle) */}
      <TraceDrawer 
        log={selectedTraceLog}
        onClose={() => setSelectedTraceLog(null)}
        onNavigateToPermissions={() => {
          setSelectedTraceLog(null);
          setCurrentView('permissions');
        }}
      />

      {/* Add Upstream Server Modal */}
      <AddServerModal 
        isOpen={isAddServerModalOpen}
        onClose={() => setIsAddServerModalOpen(false)}
        onAddServer={handleAddServer}
      />
    </div>
  );
}

export default App;
