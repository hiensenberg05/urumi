export type UserRole = 'ADMIN' | 'MEMBER';

export interface User {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  avatarUrl: string;
}

export type ServerStatus = 'Connected' | 'Unreachable' | 'Disabled';

export interface McpServer {
  id: string;
  name: string;
  tag: string;
  endpointUrl: string;
  status: ServerStatus;
  transport: string;
  pingMs: number;
  uptimePct: number;
  toolsCount: number;
  discoveredTools: string[];
  lastChecked: string;
  authType: string;
}

export type RiskProfile = 
  | 'Low (Read-only)'
  | 'Medium (Customer PII)'
  | 'High (Write Mutation)'
  | 'Critical (Financial Impact)'
  | 'Medium (Session lock)'
  | 'High (Operational write)'
  | 'Critical (Stock Discrepancy)'
  | 'Medium (Read Aggregate)';

export type PolicyAssignment = 'ALLOW' | 'DENY' | 'INHERIT';

export interface ServerTool {
  id: string;
  namespacedName: string;
  originalName: string;
  serverId: string;
  serverName: string;
  description: string;
  riskProfile: RiskProfile;
  rateLimit: string;
  policy: PolicyAssignment;
  effectiveRule: string;
  schema?: Record<string, any>;
  isAllowed: boolean;
}

export interface AuditLogItem {
  id: string;
  correlationId: string;
  timestamp: string;
  timeAgo: string;
  principal: string;
  userRole: UserRole;
  avatarUrl?: string;
  clientAgent: string;
  clientIp: string;
  targetServer: string;
  toolName: string;
  durationMs: number;
  status: '200 OK' | '403 Blocked' | '504 Timeout' | '500 Error';
  lifecycle?: {
    ingressAuthMs: number;
    policyEvalMs: number;
    policyRuleDetail?: string;
    upstreamStatus: 'Dispatched' | 'Skipped' | 'Timed Out';
  };
  sanitizedParams?: Record<string, any>;
}

export interface ToolExecutionStep {
  stepNumber: number;
  server: string;
  tool: string;
  args: Record<string, any>;
  result: Record<string, any>;
  status: '200 OK' | '403 Blocked' | 'Error';
  durationMs: number;
  summaryNote?: string;
}

export interface ChatMessage {
  id: string;
  role: 'user' | 'assistant';
  content: string;
  timestamp: string;
  senderName?: string;
  model?: string;
  steps?: ToolExecutionStep[];
}

export interface ApiKeyItem {
  id: string;
  name: string;
  key?: string;
  keyPrefix: string;
  scope: string;
  role: UserRole;
  createdAt: string;
  lastUsedAt: string;
  expiresAt: string;
  isRevoked: boolean;
}

export interface ClientSession {
  id: string;
  name: string;
  tokenPrefix: string;
  isLive: boolean;
}

export type StoreStatus = 'Provisioning' | 'Ready' | 'Failed' | 'Deleting';

export interface StoreTenant {
  id: string;
  name: string;
  namespace: string;
  status: StoreStatus;
  ingressUrl: string;
  mcpEndpoint: string;
  createdAt: string;
  toolsCount: number;
  category?: string;
  errorMessage?: string;
}

export interface ServerTelemetryRow {
  id: string;
  name: string;
  tag: string;
  status: ServerStatus;
  endpointUrl: string;
  circuitBreaker: 'CLOSED' | 'OPEN' | 'HALF_OPEN';
  circuitTrips: number;
  totalCalls: number;
  errorCount: number;
  errorRatePct: number;
  p50LatencyMs: number;
  p95LatencyMs: number;
  p99LatencyMs: number;
  avgLatencyMs: number;
  lastError?: {
    timestamp: string;
    tool: string;
    category: string;
    detail: string;
    status: string;
  } | null;
}

export interface ToolTelemetryRow {
  name: string;
  serverName: string;
  totalCalls: number;
  errorCount: number;
  errorRatePct: number;
  p50LatencyMs: number;
  p95LatencyMs: number;
  avgLatencyMs: number;
}

export interface TelemetrySummary {
  uptimeSeconds: number;
  totalInvocations: number;
  successfulInvocations: number;
  failedInvocations: number;
  errorRatePct: number;
  successRatePct: number;
  rbacViolations: number;
  rateLimitBlocks: number;
  activeServers: number;
  totalServers: number;
  totalTools: number;
  latency: {
    p50: number;
    p90: number;
    p95: number;
    p99: number;
    avg: number;
    min: number;
    max: number;
  };
}

export interface TelemetryReport {
  summary: TelemetrySummary;
  servers: ServerTelemetryRow[];
  topTools: ToolTelemetryRow[];
  roleDistribution: Record<string, number>;
}

export interface HostedToolInfo {
  name: string;
  description: string;
}

export interface HostedMcpServer {
  id: string;
  name: string;
  template: string;
  tag: string;
  image: string;
  port: number;
  replicas: number;
  status: 'Provisioning' | 'Running' | 'Sleeping' | 'Failed';
  endpointUrl: string;
  healthUrl: string;
  toolsCount: number;
  tools: HostedToolInfo[];
  createdAt: string;
  errorMessage?: string | null;
}

export interface HostedTemplate {
  id: string;
  name: string;
  tag: string;
  description: string;
  image: string;
  port: number;
  env: Record<string, string>;
  tools: HostedToolInfo[];
}

export interface OAuthPersona {
  key: string;
  name: string;
  role: string;
  email: string;
  title: string;
  avatar: string;
  department: string;
  scopes: string[];
}

export interface DynamicPolicyItem {
  namespacedName: string;
  serverName: string;
  description: string;
  riskProfile: string;
  roles: Record<string, {
    policy: 'ALLOW' | 'DENY';
    isCustomOverride: boolean;
    defaultPolicy: 'ALLOW' | 'DENY';
  }>;
}

export interface DynamicPolicyMatrix {
  roles: Array<{ id: string; name: string }>;
  tools: DynamicPolicyItem[];
  totalTools: number;
  customOverridesCount: number;
  lastUpdated: string;
}



