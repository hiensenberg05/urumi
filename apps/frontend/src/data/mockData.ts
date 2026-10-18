import { User, McpServer, ServerTool, AuditLogItem, ChatMessage, ApiKeyItem, ClientSession } from '../types';

export const MOCK_USERS: User[] = [
  {
    id: 'user-admin-1',
    name: 'Sarah Chen',
    email: 'sarah@acme.corp',
    role: 'ADMIN',
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
  },
  {
    id: 'user-member-1',
    name: 'Alex Rivera',
    email: 'alex@acme.corp',
    role: 'MEMBER',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80',
  }
];

export const MOCK_SERVERS: McpServer[] = [
  {
    id: 'server-wc',
    name: 'WooCommerce Server',
    tag: 'PRIMARY UPSTREAM',
    endpointUrl: 'https://api.acme-store.internal/mcp/v1',
    status: 'Connected',
    transport: 'Streamable HTTP (SSE)',
    pingMs: 48,
    uptimePct: 99.98,
    toolsCount: 5,
    discoveredTools: [
      'woocommerce__list_products',
      'woocommerce__list_orders',
      'woocommerce__create_product',
      'woocommerce__get_order',
      'woocommerce__update_order_status'
    ],
    lastChecked: '12s ago',
    authType: 'Bearer Secret'
  },
  {
    id: 'server-inv',
    name: 'Inventory Service',
    tag: 'WAREHOUSE SYNC',
    endpointUrl: 'https://inventory-service.acme.corp/mcp',
    status: 'Connected',
    transport: 'Streamable HTTP (SSE)',
    pingMs: 32,
    uptimePct: 99.99,
    toolsCount: 7,
    discoveredTools: [
      'inventory__get_sku_stock',
      'inventory__check_warehouse_capacity',
      'inventory__reserve_item',
      'inventory__find_low_stock',
      'inventory__list_stock',
      'inventory__update_warehouse',
      'inventory__batch_adjust_stock'
    ],
    lastChecked: '18s ago',
    authType: 'Static Header'
  },
  {
    id: 'server-an',
    name: 'Analytics & BI',
    tag: 'SNOWFLAKE MCP',
    endpointUrl: 'https://analytics.data.internal/mcp/gateway',
    status: 'Connected',
    transport: 'Streamable HTTP (SSE)',
    pingMs: 76,
    uptimePct: 99.95,
    toolsCount: 6,
    discoveredTools: [
      'analytics__get_daily_sales',
      'analytics__get_product_performance',
      'analytics__run_revenue_query',
      'analytics__export_daily_cohort',
      'analytics__sales_velocity',
      'analytics__customer_retention'
    ],
    lastChecked: '5s ago',
    authType: 'None (Internal)'
  }
];

export const MOCK_TOOLS: ServerTool[] = [
  // WooCommerce Tools
  {
    id: 'tool-wc-1',
    namespacedName: 'woocommerce__list_products',
    originalName: 'list_products',
    serverId: 'server-wc',
    serverName: 'WooCommerce Store MCP',
    description: 'Retrieve catalog products with pagination, pricing, and stock metadata.',
    riskProfile: 'Low (Read-only)',
    rateLimit: '60 req/min',
    policy: 'ALLOW',
    effectiveRule: 'Allowed via Role: Member',
    isAllowed: true,
  },
  {
    id: 'tool-wc-2',
    namespacedName: 'woocommerce__list_orders',
    originalName: 'list_orders',
    serverId: 'server-wc',
    serverName: 'WooCommerce Store MCP',
    description: 'Fetch customer orders, totals, shipping status, and timestamps.',
    riskProfile: 'Medium (Customer PII)',
    rateLimit: '45 req/min',
    policy: 'ALLOW',
    effectiveRule: 'Allowed via Role: Member',
    isAllowed: true,
  },
  {
    id: 'tool-wc-3',
    namespacedName: 'woocommerce__create_product',
    originalName: 'create_product',
    serverId: 'server-wc',
    serverName: 'WooCommerce Store MCP',
    description: 'Add new products to catalog, set live inventory and sales price.',
    riskProfile: 'High (Write Mutation)',
    rateLimit: '15 req/min',
    policy: 'DENY',
    effectiveRule: 'Explicitly Denied (Requires Admin)',
    isAllowed: false,
  },
  {
    id: 'tool-wc-4',
    namespacedName: 'woocommerce__update_order_status',
    originalName: 'update_order_status',
    serverId: 'server-wc',
    serverName: 'WooCommerce Store MCP',
    description: 'Mutate order fulfillment state, process refunds or cancel orders.',
    riskProfile: 'Critical (Financial Impact)',
    rateLimit: '10 req/min',
    policy: 'DENY',
    effectiveRule: 'Explicitly Denied (Financial Action)',
    isAllowed: false,
  },
  {
    id: 'tool-wc-5',
    namespacedName: 'woocommerce__get_customer',
    originalName: 'get_customer',
    serverId: 'server-wc',
    serverName: 'WooCommerce Store MCP',
    description: 'Lookup customer profile, saved addresses, and payment tokens.',
    riskProfile: 'Critical (Financial Impact)',
    rateLimit: '20 req/min',
    policy: 'DENY',
    effectiveRule: 'Explicitly Denied',
    isAllowed: false,
  },

  // Inventory Tools
  {
    id: 'tool-inv-1',
    namespacedName: 'inventory__get_sku_stock',
    originalName: 'get_sku_stock',
    serverId: 'server-inv',
    serverName: 'Inventory Service MCP',
    description: 'Check real-time stock levels across regional fulfillment centers.',
    riskProfile: 'Low (Read-only)',
    rateLimit: '120 req/min',
    policy: 'ALLOW',
    effectiveRule: 'Allowed via Role: Member',
    isAllowed: true,
  },
  {
    id: 'tool-inv-2',
    namespacedName: 'inventory__check_warehouse_capacity',
    originalName: 'check_warehouse_capacity',
    serverId: 'server-inv',
    serverName: 'Inventory Service MCP',
    description: 'Inspect rack and bin availability for inbound logistics.',
    riskProfile: 'Low (Read-only)',
    rateLimit: '60 req/min',
    policy: 'ALLOW',
    effectiveRule: 'Allowed via Role: Member',
    isAllowed: true,
  },
  {
    id: 'tool-inv-3',
    namespacedName: 'inventory__reserve_item',
    originalName: 'reserve_item',
    serverId: 'server-inv',
    serverName: 'Inventory Service MCP',
    description: 'Place temporary hold on inventory unit for checkout carts.',
    riskProfile: 'Medium (Session lock)',
    rateLimit: '15 req/min',
    policy: 'ALLOW',
    effectiveRule: 'Allowed via Role: Member',
    isAllowed: true,
  },
  {
    id: 'tool-inv-4',
    namespacedName: 'inventory__find_low_stock',
    originalName: 'find_low_stock',
    serverId: 'server-inv',
    serverName: 'Inventory Service MCP',
    description: 'Query all warehouse items that have fallen below safety reorder thresholds.',
    riskProfile: 'Low (Read-only)',
    rateLimit: '30 req/min',
    policy: 'ALLOW',
    effectiveRule: 'Allowed via Role: Member',
    isAllowed: true,
  },
  {
    id: 'tool-inv-5',
    namespacedName: 'inventory__list_stock',
    originalName: 'list_stock',
    serverId: 'server-inv',
    serverName: 'Inventory Service MCP',
    description: 'Dump or filter inventory entries by facility warehouse ID.',
    riskProfile: 'Low (Read-only)',
    rateLimit: '40 req/min',
    policy: 'ALLOW',
    effectiveRule: 'Allowed via Role: Member',
    isAllowed: true,
  },
  {
    id: 'tool-inv-6',
    namespacedName: 'inventory__update_warehouse',
    originalName: 'update_warehouse',
    serverId: 'server-inv',
    serverName: 'Inventory Service MCP',
    description: 'Update physical bin locations, re-assign SKUs, modify lead times.',
    riskProfile: 'High (Operational write)',
    rateLimit: '10 req/min',
    policy: 'DENY',
    effectiveRule: 'Explicitly Denied (Requires Admin)',
    isAllowed: false,
  },
  {
    id: 'tool-inv-7',
    namespacedName: 'inventory__batch_adjust_stock',
    originalName: 'batch_adjust_stock',
    serverId: 'server-inv',
    serverName: 'Inventory Service MCP',
    description: 'Bulk overwrite SKU inventory quantities and write-offs.',
    riskProfile: 'Critical (Stock Discrepancy)',
    rateLimit: '5 req/min',
    policy: 'DENY',
    effectiveRule: 'Explicitly Denied',
    isAllowed: false,
  },

  // Analytics Tools
  {
    id: 'tool-an-1',
    namespacedName: 'analytics__get_daily_sales',
    originalName: 'get_daily_sales',
    serverId: 'server-an',
    serverName: 'Analytics & BI Engine MCP',
    description: 'Retrieve daily total revenue, tax, and order volume aggregates.',
    riskProfile: 'Medium (Read Aggregate)',
    rateLimit: '30 req/min',
    policy: 'ALLOW',
    effectiveRule: 'Allowed via Role: Member',
    isAllowed: true,
  },
  {
    id: 'tool-an-2',
    namespacedName: 'analytics__get_product_performance',
    originalName: 'get_product_performance',
    serverId: 'server-an',
    serverName: 'Analytics & BI Engine MCP',
    description: 'Rank top-selling items and velocity trends over given timeframe.',
    riskProfile: 'Medium (Read Aggregate)',
    rateLimit: '25 req/min',
    policy: 'ALLOW',
    effectiveRule: 'Allowed via Role: Member',
    isAllowed: true,
  },
  {
    id: 'tool-an-3',
    namespacedName: 'analytics__run_revenue_query',
    originalName: 'run_revenue_query',
    serverId: 'server-an',
    serverName: 'Analytics & BI Engine MCP',
    description: 'Execute predefined sanitized read-only financial summary metrics.',
    riskProfile: 'Medium (Read Aggregate)',
    rateLimit: '10 req/min',
    policy: 'DENY',
    effectiveRule: 'Blocked by Policy #4 (General members denied financial aggregations)',
    isAllowed: false,
  },
  {
    id: 'tool-an-4',
    namespacedName: 'analytics__export_daily_cohort',
    originalName: 'export_daily_cohort',
    serverId: 'server-an',
    serverName: 'Analytics & BI Engine MCP',
    description: 'Download user engagement and daily retention cohorts.',
    riskProfile: 'Low (Read-only)',
    rateLimit: '15 req/min',
    policy: 'ALLOW',
    effectiveRule: 'Allowed via Role: Member',
    isAllowed: true,
  },
  {
    id: 'tool-an-5',
    namespacedName: 'analytics__sales_velocity',
    originalName: 'sales_velocity',
    serverId: 'server-an',
    serverName: 'Analytics & BI Engine MCP',
    description: 'Calculate rolling hourly sales velocity versus 30-day baseline.',
    riskProfile: 'Low (Read-only)',
    rateLimit: '30 req/min',
    policy: 'ALLOW',
    effectiveRule: 'Allowed via Role: Member',
    isAllowed: true,
  },
  {
    id: 'tool-an-6',
    namespacedName: 'analytics__customer_retention',
    originalName: 'customer_retention',
    serverId: 'server-an',
    serverName: 'Analytics & BI Engine MCP',
    description: 'Measure repeat purchase frequency and LTV distributions.',
    riskProfile: 'Medium (Read Aggregate)',
    rateLimit: '10 req/min',
    policy: 'INHERIT',
    effectiveRule: 'Inherited Default (Denied)',
    isAllowed: false,
  }
];

export const MOCK_AUDIT_LOGS: AuditLogItem[] = [
  {
    id: 'log-1',
    correlationId: 'req_98f4a12c',
    timestamp: '14:38:12 UTC',
    timeAgo: '2 mins ago',
    principal: 'Sarah Chen',
    userRole: 'ADMIN',
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
    clientAgent: 'Claude Desktop',
    clientIp: '10.240.18.94 (us-east-1)',
    targetServer: 'WooCommerce',
    toolName: 'woocommerce__list_products',
    durationMs: 128,
    status: '200 OK',
    lifecycle: {
      ingressAuthMs: 1.1,
      policyEvalMs: 0.6,
      policyRuleDetail: 'MATCH role:ADMIN -> ALLOW',
      upstreamStatus: 'Dispatched'
    },
    sanitizedParams: {
      limit: 10,
      status: 'publish',
      page: 1
    }
  },
  {
    id: 'log-2',
    correlationId: 'req_76a2b89e',
    timestamp: '14:19:04 UTC',
    timeAgo: '21 mins ago',
    principal: 'Dev Agent Service',
    userRole: 'MEMBER',
    clientAgent: 'sa_ingress_99',
    clientIp: '10.240.18.94 (us-east-1)',
    targetServer: 'Analytics',
    toolName: 'analytics__run_revenue_query',
    durationMs: 42,
    status: '403 Blocked',
    lifecycle: {
      ingressAuthMs: 1.2,
      policyEvalMs: 0.8,
      policyRuleDetail: 'MATCH rule #4 [analytics_*] -> DENY FOR principal:sa_dev_ingress_99',
      upstreamStatus: 'Skipped'
    },
    sanitizedParams: {
      query_range: 'Q1_2025_ACTUALS',
      include_pii: false,
      dimension: 'gross_merchandise_value',
      limit: 500,
      '//_security_scrub': 'Headers & DB auth hashes stripped at edge'
    }
  },
  {
    id: 'log-3',
    correlationId: 'req_43b81109',
    timestamp: '14:02:51 UTC',
    timeAgo: '37 mins ago',
    principal: 'Alex Rivera',
    userRole: 'MEMBER',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80',
    clientAgent: 'Cursor IDE',
    clientIp: '192.168.1.104',
    targetServer: 'Inventory',
    toolName: 'inventory__get_sku_stock',
    durationMs: 94,
    status: '200 OK',
    lifecycle: {
      ingressAuthMs: 0.9,
      policyEvalMs: 0.7,
      policyRuleDetail: 'MATCH role:MEMBER -> ALLOW [inventory__get_sku_stock]',
      upstreamStatus: 'Dispatched'
    },
    sanitizedParams: {
      sku: 'KB-992'
    }
  },
  {
    id: 'log-4',
    correlationId: 'req_18cc90fa',
    timestamp: '13:48:19 UTC',
    timeAgo: '52 mins ago',
    principal: 'Sarah Chen',
    userRole: 'ADMIN',
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
    clientAgent: 'Urumi AI Chat',
    clientIp: '127.0.0.1 (cluster-internal)',
    targetServer: 'WooCommerce',
    toolName: 'woocommerce__list_orders',
    durationMs: 112,
    status: '200 OK',
    lifecycle: {
      ingressAuthMs: 0.4,
      policyEvalMs: 0.5,
      policyRuleDetail: 'MATCH internal_actor:sarah_chen -> ALLOW',
      upstreamStatus: 'Dispatched'
    },
    sanitizedParams: {
      date: 'today',
      status: 'completed'
    }
  },
  {
    id: 'log-5',
    correlationId: 'req_aa129e01',
    timestamp: '13:12:00 UTC',
    timeAgo: '1 hour ago',
    principal: 'Dev Agent Service',
    userRole: 'MEMBER',
    clientAgent: 'Direct Gateway API',
    clientIp: '10.244.0.12',
    targetServer: 'Inventory',
    toolName: 'inventory__check_warehouse_capacity',
    durationMs: 85,
    status: '200 OK',
    lifecycle: {
      ingressAuthMs: 1.0,
      policyEvalMs: 0.5,
      upstreamStatus: 'Dispatched'
    },
    sanitizedParams: {
      warehouse_id: 'WH-01'
    }
  },
  {
    id: 'log-6',
    correlationId: 'req_bb882103',
    timestamp: '12:54:33 UTC',
    timeAgo: '2 hours ago',
    principal: 'Alex Rivera',
    userRole: 'MEMBER',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80',
    clientAgent: 'Cursor IDE',
    clientIp: '192.168.1.104',
    targetServer: 'WooCommerce',
    toolName: 'woocommerce__list_orders',
    durationMs: 112,
    status: '200 OK',
    lifecycle: {
      ingressAuthMs: 0.8,
      policyEvalMs: 0.7,
      upstreamStatus: 'Dispatched'
    },
    sanitizedParams: {
      limit: 10
    }
  },
  {
    id: 'log-7',
    correlationId: 'req_cc4499ff',
    timestamp: '12:30:11 UTC',
    timeAgo: '2 hours ago',
    principal: 'Autopilot Daemon',
    userRole: 'ADMIN',
    clientAgent: 'Daemon Cron',
    clientIp: '10.240.10.5',
    targetServer: 'WooCommerce',
    toolName: 'woocommerce__create_product',
    durationMs: 310,
    status: '200 OK',
    lifecycle: {
      ingressAuthMs: 0.9,
      policyEvalMs: 0.6,
      upstreamStatus: 'Dispatched'
    },
    sanitizedParams: {
      name: 'Wireless Ergonomic Mouse',
      price: '49.99'
    }
  },
  {
    id: 'log-8',
    correlationId: 'req_fe771120',
    timestamp: '11:58:02 UTC',
    timeAgo: '3 hours ago',
    principal: 'Sarah Chen',
    userRole: 'ADMIN',
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
    clientAgent: 'Claude Desktop',
    clientIp: '10.240.18.94',
    targetServer: 'Inventory',
    toolName: 'inventory__reserve_item',
    durationMs: 88,
    status: '200 OK',
    lifecycle: {
      ingressAuthMs: 1.1,
      policyEvalMs: 0.5,
      upstreamStatus: 'Dispatched'
    },
    sanitizedParams: {
      sku: 'KB-992',
      qty: 1
    }
  }
];

export const MOCK_CHAT_MESSAGES: ChatMessage[] = [
  {
    id: 'msg-1',
    role: 'user',
    content: "Show me today's WooCommerce orders and check stock for the top-selling product.",
    timestamp: '10:42:15 AM',
    senderName: 'Sarah Chen (Admin)'
  },
  {
    id: 'msg-2',
    role: 'assistant',
    content: "I queried WooCommerce for today's completed orders and discovered that the top-selling product is the **Ergonomic Mechanical Keyboard (SKU: KB-992)** with 14 units sold today. I then cross-referenced its stock in the Inventory Service, which reports **170 units total** in stock across two warehouse locations (Austin Hub and Berlin Central). Everything is currently well above the reorder point of 40.",
    timestamp: '10:42:17 AM',
    model: 'openai/gpt-oss-120b',
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
  }
];

export const MOCK_API_KEYS: ApiKeyItem[] = [
  {
    id: 'key-1',
    name: 'claude-desktop-production',
    keyPrefix: 'urumi_live_9a1b...',
    scope: 'Production Gateway',
    role: 'ADMIN',
    createdAt: '2026-10-10',
    lastUsedAt: '2 mins ago',
    expiresAt: '2027-10-10',
    isRevoked: false
  },
  {
    id: 'key-2',
    name: 'cursor-ide-developer',
    keyPrefix: 'urumi_live_8fdc...',
    scope: 'Member Workspace',
    role: 'MEMBER',
    createdAt: '2026-10-12',
    lastUsedAt: '3m ago',
    expiresAt: '2027-10-12',
    isRevoked: false
  },
  {
    id: 'key-3',
    name: 'eval-pipeline-legacy',
    keyPrefix: 'urumi_live_3c91...',
    scope: 'Testing',
    role: 'MEMBER',
    createdAt: '2026-09-01',
    lastUsedAt: '12 days ago',
    expiresAt: '2026-10-01',
    isRevoked: true
  }
];

export const MOCK_CLIENT_SESSIONS: ClientSession[] = [
  { id: 's-1', name: 'Claude Desktop (Mac)', tokenPrefix: 'mcp_prod_a91b...', isLive: true },
  { id: 's-2', name: 'Cursor IDE Extension', tokenPrefix: 'mcp_dev_38fe...', isLive: true },
  { id: 's-3', name: 'Internal Autopilot Bot', tokenPrefix: 'mcp_srv_7718...', isLive: true }
];
