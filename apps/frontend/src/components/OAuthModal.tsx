import React, { useState, useEffect } from 'react';
import { 
  ShieldCheck, 
  Key, 
  UserCheck, 
  CheckCircle2, 
  Copy, 
  ExternalLink, 
  Sparkles, 
  Clock, 
  Layers, 
  Lock, 
  X, 
  RefreshCw,
  Cpu,
  ChevronRight,
  Code
} from 'lucide-react';
import { User, OAuthPersona } from '../types';

interface OAuthModalProps {
  isOpen: boolean;
  onClose: () => void;
  currentUser: User;
  activeToken: string;
  onLoginPersona: (token: string, user: User) => void;
}

export const OAuthModal: React.FC<OAuthModalProps> = ({
  isOpen,
  onClose,
  currentUser,
  activeToken,
  onLoginPersona
}) => {
  const [personas, setPersonas] = useState<OAuthPersona[]>([]);
  const [loading, setLoading] = useState(false);
  const [activeTab, setActiveTab] = useState<'personas' | 'inspector' | 'sso'>('personas');
  const [copied, setCopied] = useState(false);
  const [claims, setClaims] = useState<Record<string, any> | null>(null);
  const [authType, setAuthType] = useState<string>('Unknown');
  const [tokenPrefix, setTokenPrefix] = useState<string>('');
  const [switchingKey, setSwitchingKey] = useState<string | null>(null);

  // Fetch auth providers & me introspection
  useEffect(() => {
    if (!isOpen) return;

    const fetchAuthData = async () => {
      try {
        const provRes = await fetch('/api/v1/auth/providers');
        if (provRes.ok) {
          const data = await provRes.json();
          setPersonas(data.personas || []);
        }

        const meRes = await fetch('/api/v1/auth/me', {
          headers: { 'Authorization': `Bearer ${activeToken}`, 'X-API-Key': activeToken }
        });
        if (meRes.ok) {
          const meData = await meRes.json();
          setAuthType(meData.token?.type || 'API Key');
          setTokenPrefix(meData.token?.prefix || '');
          setClaims(meData.token?.claims || null);
        }
      } catch (err) {
        console.error('Failed to load auth metadata:', err);
      }
    };

    fetchAuthData();
  }, [isOpen, activeToken]);

  if (!isOpen) return null;

  const handleSelectPersona = async (p: OAuthPersona) => {
    setSwitchingKey(p.key);
    try {
      const res = await fetch('/api/v1/auth/oauth/token', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ grant_type: 'persona', persona: p.key })
      });

      if (res.ok) {
        const data = await res.json();
        const updatedUser: User = {
          id: data.user.id,
          name: data.user.name,
          email: data.user.email,
          role: data.user.role.toUpperCase() === 'ADMIN' ? 'ADMIN' : 'MEMBER',
          avatarUrl: data.user.avatar
        };
        onLoginPersona(data.access_token, updatedUser);
        onClose();
      } else {
        alert('Failed to issue OAuth JWT token.');
      }
    } catch (e) {
      console.error('OAuth exchange error:', e);
    } finally {
      setSwitchingKey(null);
    }
  };

  const handleCopyToken = () => {
    navigator.clipboard.writeText(activeToken);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const isJwt = activeToken.includes('.') && activeToken.split('.').length === 3;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm animate-in fade-in duration-200">
      <div className="relative w-full max-w-3xl bg-[#0b1320] border border-slate-700/80 rounded-2xl shadow-2xl overflow-hidden flex flex-col max-h-[90vh]">
        {/* Header */}
        <div className="px-6 py-5 border-b border-slate-800 bg-slate-900/60 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-purple-500/10 border border-purple-500/30 flex items-center justify-center text-purple-400">
              <ShieldCheck className="w-6 h-6" />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h2 className="text-lg font-bold text-white tracking-tight">Enterprise OAuth 2.0 & Identity Management</h2>
                <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-purple-950/80 text-purple-300 border border-purple-800/60 font-semibold">
                  RFC 7519 JWT
                </span>
              </div>
              <p className="text-xs text-slate-400 mt-0.5">
                Cryptographically signed bearer tokens, role federation, and seamless SSO persona switching.
              </p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="p-1.5 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 transition"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Active Session Status Bar */}
        <div className="px-6 py-3.5 bg-purple-950/20 border-b border-purple-900/30 flex flex-wrap items-center justify-between gap-3 text-xs">
          <div className="flex items-center gap-3">
            <img 
              src={currentUser.avatarUrl} 
              alt={currentUser.name} 
              className="w-7 h-7 rounded-full object-cover border border-purple-500/40"
            />
            <div>
              <div className="flex items-center gap-2 font-medium text-slate-200">
                <span>{currentUser.name}</span>
                <span className={`text-[10px] px-1.5 py-0.2 rounded font-mono font-semibold ${
                  currentUser.role === 'ADMIN' 
                    ? 'bg-purple-900/60 text-purple-300 border border-purple-700/60'
                    : 'bg-emerald-900/60 text-emerald-300 border border-emerald-700/60'
                }`}>
                  {currentUser.role}
                </span>
                <span className="text-slate-400 text-[11px] font-mono">({currentUser.email})</span>
              </div>
              <div className="text-[11px] text-slate-400 flex items-center gap-2 mt-0.5">
                <span>Mode: <strong className={isJwt ? "text-purple-400" : "text-amber-400"}>{isJwt ? "OAuth 2.0 (HS256 JWT)" : "Legacy Static API Key"}</strong></span>
                <span>•</span>
                <span className="font-mono text-slate-300">{tokenPrefix || activeToken.slice(0, 12) + '...'}</span>
              </div>
            </div>
          </div>

          <button
            onClick={handleCopyToken}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-medium border border-slate-700 transition"
          >
            {copied ? <CheckCircle2 className="w-3.5 h-3.5 text-emerald-400" /> : <Copy className="w-3.5 h-3.5" />}
            <span>{copied ? 'Copied' : 'Copy Bearer Token'}</span>
          </button>
        </div>

        {/* Tab Navigation */}
        <div className="flex border-b border-slate-800 bg-slate-900/30 px-6">
          <button
            onClick={() => setActiveTab('personas')}
            className={`py-3 px-4 text-xs font-semibold border-b-2 transition flex items-center gap-2 ${
              activeTab === 'personas'
                ? 'border-purple-500 text-purple-400'
                : 'border-transparent text-slate-400 hover:text-slate-200'
            }`}
          >
            <UserCheck className="w-4 h-4" />
            <span>OAuth SSO Personas</span>
          </button>
          <button
            onClick={() => setActiveTab('inspector')}
            className={`py-3 px-4 text-xs font-semibold border-b-2 transition flex items-center gap-2 ${
              activeTab === 'inspector'
                ? 'border-purple-500 text-purple-400'
                : 'border-transparent text-slate-400 hover:text-slate-200'
            }`}
          >
            <Code className="w-4 h-4" />
            <span>JWT Claims Inspector</span>
          </button>
          <button
            onClick={() => setActiveTab('sso')}
            className={`py-3 px-4 text-xs font-semibold border-b-2 transition flex items-center gap-2 ${
              activeTab === 'sso'
                ? 'border-purple-500 text-purple-400'
                : 'border-transparent text-slate-400 hover:text-slate-200'
            }`}
          >
            <Layers className="w-4 h-4" />
            <span>External IdP Providers</span>
          </button>
        </div>

        {/* Body Content */}
        <div className="p-6 overflow-y-auto space-y-4">
          {activeTab === 'personas' && (
            <div>
              <div className="flex items-center justify-between mb-3">
                <span className="text-xs font-semibold uppercase tracking-wider text-slate-400">
                  Select Identity to Issue New Cryptographic JWT
                </span>
                <span className="text-[11px] text-purple-400 font-mono">
                  Standard RFC 7519 • HMAC-SHA256 Signature
                </span>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                {personas.map((p) => {
                  const isCurrent = currentUser.email.toLowerCase() === p.email.toLowerCase();
                  const isSwitching = switchingKey === p.key;

                  return (
                    <div
                      key={p.key}
                      onClick={() => !isCurrent && handleSelectPersona(p)}
                      className={`p-4 rounded-xl border transition flex flex-col justify-between ${
                        isCurrent 
                          ? 'bg-purple-950/30 border-purple-500/60 shadow-sm'
                          : 'bg-slate-900/60 border-slate-800 hover:border-slate-700 hover:bg-slate-800/50 cursor-pointer'
                      }`}
                    >
                      <div>
                        <div className="flex items-center justify-between mb-2">
                          <div className="flex items-center gap-2.5">
                            <img 
                              src={p.avatar} 
                              alt={p.name} 
                              className="w-9 h-9 rounded-full object-cover border border-slate-700"
                            />
                            <div>
                              <div className="font-semibold text-slate-100 text-sm flex items-center gap-2">
                                {p.name}
                                {isCurrent && (
                                  <span className="text-[9px] px-1.5 py-0.2 rounded bg-purple-900/60 text-purple-300 font-bold border border-purple-700">
                                    ACTIVE
                                  </span>
                                )}
                              </div>
                              <div className="text-[11px] text-slate-400">{p.title}</div>
                            </div>
                          </div>
                          <span className={`text-[10px] font-mono px-2 py-0.5 rounded font-semibold uppercase ${
                            p.role === 'admin'
                              ? 'bg-purple-950 text-purple-300 border border-purple-800'
                              : 'bg-emerald-950 text-emerald-300 border border-emerald-800'
                          }`}>
                            {p.role}
                          </span>
                        </div>

                        <div className="text-[11px] text-slate-400 mb-2 font-mono">
                          {p.email} • {p.department}
                        </div>

                        <div className="flex flex-wrap gap-1 mt-2">
                          {p.scopes.slice(0, 3).map((scope) => (
                            <span 
                              key={scope} 
                              className="text-[9px] font-mono bg-slate-800 text-slate-300 px-1.5 py-0.5 rounded border border-slate-700/60"
                            >
                              {scope}
                            </span>
                          ))}
                          {p.scopes.length > 3 && (
                            <span className="text-[9px] font-mono text-slate-400 px-1">
                              +{p.scopes.length - 3} more
                            </span>
                          )}
                        </div>
                      </div>

                      <div className="mt-3 pt-3 border-t border-slate-800/80 flex items-center justify-between">
                        <span className="text-[11px] text-slate-500">
                          {isCurrent ? 'Currently signed in' : 'Click to authenticate via OAuth'}
                        </span>
                        {!isCurrent && (
                          <button 
                            disabled={isSwitching}
                            className="px-2.5 py-1 rounded bg-purple-600 hover:bg-purple-500 text-white text-[11px] font-medium flex items-center gap-1 transition"
                          >
                            {isSwitching ? <RefreshCw className="w-3 h-3 animate-spin" /> : <ChevronRight className="w-3 h-3" />}
                            <span>Switch via OAuth</span>
                          </button>
                        )}
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {activeTab === 'inspector' && (
            <div className="space-y-4">
              <div className="p-4 rounded-xl bg-slate-900/70 border border-slate-800">
                <div className="text-xs font-semibold text-slate-300 mb-2 flex items-center justify-between">
                  <span>Raw Bearer Token</span>
                  <span className="text-[10px] font-mono text-purple-400">
                    {isJwt ? 'Valid 3-Segment Cryptographic JWT' : 'Plaintext API Key String'}
                  </span>
                </div>
                <div className="p-3 bg-black/60 rounded-lg border border-slate-800 font-mono text-[11px] text-emerald-400 break-all select-all">
                  {activeToken}
                </div>
              </div>

              {claims ? (
                <div className="p-4 rounded-xl bg-slate-900/70 border border-slate-800">
                  <div className="text-xs font-semibold text-slate-300 mb-2 flex items-center justify-between">
                    <span>Decoded RFC 7519 Claims (Verified Signature)</span>
                    <span className="text-[10px] font-mono text-slate-400">HMAC-SHA256 • Verified by Gateway</span>
                  </div>
                  <pre className="p-3 bg-black/60 rounded-lg border border-slate-800 font-mono text-[11px] text-purple-300 overflow-x-auto">
                    {JSON.stringify(claims, null, 2)}
                  </pre>
                </div>
              ) : (
                <div className="p-4 rounded-xl bg-amber-950/20 border border-amber-800/40 text-amber-300 text-xs flex items-start gap-2.5">
                  <Lock className="w-4 h-4 shrink-0 mt-0.5" />
                  <div>
                    <span className="font-semibold">Current session is using a legacy static API key.</span>
                    <p className="mt-1 text-slate-400">
                      To inspect cryptographic claims (`sub`, `iss`, `scopes`, `exp`), select an OAuth persona from the first tab to issue a signed JWT.
                    </p>
                  </div>
                </div>
              )}
            </div>
          )}

          {activeTab === 'sso' && (
            <div className="space-y-3">
              <p className="text-xs text-slate-400">
                Urumi Gateway supports external identity federation via OpenID Connect (OIDC) and SAML 2.0. Click below to simulate external enterprise login:
              </p>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-3 pt-2">
                <div 
                  onClick={() => handleSelectPersona(personas[0] || { key: 'alice' } as any)}
                  className="p-4 rounded-xl bg-slate-900/60 border border-slate-800 hover:border-slate-700 hover:bg-slate-800/40 cursor-pointer transition text-center"
                >
                  <div className="w-10 h-10 mx-auto mb-2 rounded-xl bg-blue-500/10 border border-blue-500/30 flex items-center justify-center text-blue-400 font-bold">
                    G
                  </div>
                  <div className="text-sm font-semibold text-white">Google Workspace</div>
                  <div className="text-[11px] text-slate-400 mt-1">OIDC Cloud Identity</div>
                  <span className="mt-3 inline-block text-[10px] px-2 py-0.5 rounded bg-blue-950 text-blue-300 border border-blue-800">
                    Federate as Admin
                  </span>
                </div>

                <div 
                  onClick={() => handleSelectPersona(personas[1] || { key: 'bob' } as any)}
                  className="p-4 rounded-xl bg-slate-900/60 border border-slate-800 hover:border-slate-700 hover:bg-slate-800/40 cursor-pointer transition text-center"
                >
                  <div className="w-10 h-10 mx-auto mb-2 rounded-xl bg-slate-700/20 border border-slate-600/30 flex items-center justify-center text-slate-200 font-bold">
                    GH
                  </div>
                  <div className="text-sm font-semibold text-white">GitHub Enterprise</div>
                  <div className="text-[11px] text-slate-400 mt-1">OAuth Organization</div>
                  <span className="mt-3 inline-block text-[10px] px-2 py-0.5 rounded bg-slate-800 text-slate-300 border border-slate-700">
                    Federate as Inventory
                  </span>
                </div>

                <div 
                  onClick={() => handleSelectPersona(personas[2] || { key: 'charlie' } as any)}
                  className="p-4 rounded-xl bg-slate-900/60 border border-slate-800 hover:border-slate-700 hover:bg-slate-800/40 cursor-pointer transition text-center"
                >
                  <div className="w-10 h-10 mx-auto mb-2 rounded-xl bg-purple-500/10 border border-purple-500/30 flex items-center justify-center text-purple-400 font-bold">
                    OK
                  </div>
                  <div className="text-sm font-semibold text-white">Okta / SAML 2.0</div>
                  <div className="text-[11px] text-slate-400 mt-1">Corporate Directory</div>
                  <span className="mt-3 inline-block text-[10px] px-2 py-0.5 rounded bg-purple-950 text-purple-300 border border-purple-800">
                    Federate as Analyst
                  </span>
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="px-6 py-4 border-t border-slate-800 bg-slate-900/60 flex items-center justify-between text-xs text-slate-400">
          <div className="flex items-center gap-2">
            <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
            <span>Gateway JWT Authority Online</span>
          </div>
          <button
            onClick={onClose}
            className="px-4 py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-white font-medium transition"
          >
            Close
          </button>
        </div>
      </div>
    </div>
  );
};
