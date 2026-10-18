# Tech Stack — Team MCP Gateway on Kubernetes

## 1. Overview

This document defines the technologies selected for the Team MCP Gateway platform, their responsibilities, and the rationale behind each choice.

The stack is divided into frontend, backend, MCP gateway, AI service, upstream MCP servers, databases, and infrastructure.

## 2. Technology Stack Summary

| Layer | Technology | Purpose |
|---|---|---|
| Frontend | React, TypeScript, Vite | Dashboard and chat interface |
| Backend API | Node.js, TypeScript, Fastify | Authentication, teams, server management, chat orchestration |
| MCP Gateway | Node.js, TypeScript, official MCP SDK | Unified MCP endpoint, tool discovery, authorization, routing |
| AI Service | Python, FastAPI | LLM integration and tool-calling loop |
| WooCommerce MCP | Python, FastMCP | Custom MCP tools for products and orders |
| Inventory MCP | Python, FastMCP | Inventory and stock-management tools |
| Analytics MCP | Python, FastMCP | Sales and product analytics tools |
| Storefront | WordPress, WooCommerce | E-commerce storefront and order management |
| Store Database | MariaDB | WordPress and WooCommerce data |
| Platform Database | PostgreSQL | Users, keys, servers, permissions, audit logs, chat metadata |
| ORM | Prisma | Database access and schema migrations for TypeScript services |
| Containerization | Docker | Build and package services |
| Local Kubernetes | Kind | Local Kubernetes development cluster |
| Production-like Kubernetes | k3s | Kubernetes deployment on a VPS |
| Deployment | Helm | Repeatable installation and configuration |
| Ingress | NGINX Ingress Controller | Stable external HTTP/HTTPS endpoints |
| API communication | HTTP/JSON | Communication between application services |
| MCP communication | Streamable HTTP | MCP client-server communication |
| AI provider | Hosted LLM with tool-calling support | Natural-language understanding and tool selection |

## 3. Frontend

### React + TypeScript + Vite

**Responsibilities**
- Admin dashboard.
- Member dashboard.
- MCP server management screens.
- Team and API key management.
- Tool permissions interface.
- Audit log viewer.
- AI chat interface.

**Why this stack?**

- React supports reusable UI components.
- TypeScript catches many type-related errors during development.
- Vite provides a fast development server and production build.
- The frontend can communicate with the backend through REST APIs.

**Important:** Frontend role-based rendering is for usability only. Authorization must be enforced by the backend and gateway.

## 4. Backend API

### Node.js + TypeScript + Fastify

The backend API is the control plane for platform management.

**Responsibilities**
- User registration and login.
- Session authentication.
- Admin/member role checks.
- Team invitations.
- API key generation and revocation.
- MCP server registration and configuration.
- Permission policy management.
- Chat conversation management.
- Dashboard data and audit log queries.
- Requests to the AI service.

### Why Fastify?

- Lightweight HTTP framework.
- Schema-based request validation.
- TypeScript-friendly development.
- Suitable for building structured REST APIs.

### API style

Use REST endpoints for dashboard operations, for example:

```text
POST   /api/auth/login
POST   /api/team/invitations
GET    /api/servers
POST   /api/servers
PATCH  /api/servers/:id
POST   /api/servers/:id/disable
GET    /api/servers/:id/tools
GET    /api/permissions
PUT    /api/permissions
POST   /api/api-keys
DELETE /api/api-keys/:id
GET    /api/audit-logs
POST   /api/chat/messages
```

These paths are proposed initial contracts and can be refined during implementation.

### Database access

Use Prisma for PostgreSQL access from the TypeScript backend. The gateway may use the same database through a separate data-access module or restricted database role.

Avoid coupling the backend's business logic directly to the gateway's internal implementation.

## 5. MCP Gateway

### Node.js + TypeScript + Official MCP SDK

This is the central component of the assignment.

**Responsibilities**
- Expose one unified MCP endpoint.
- Authenticate external MCP clients.
- Validate API keys.
- Resolve trusted internal user identity for chat-originated tool calls.
- Discover tools from registered upstream servers.
- Aggregate tools and schemas.
- Generate unique exposed tool names.
- Route invocations to the correct upstream.
- Enforce tool permissions.
- Handle timeouts and upstream failures.
- Write audit records.

### Why TypeScript for the gateway?

The gateway is a protocol-heavy routing and authorization service. TypeScript offers:

- Strong typing for request and tool metadata.
- A consistent language with the backend.
- Access to the official TypeScript MCP SDK.
- Shared types and validation patterns where useful.
- A straightforward path to implementing concurrent upstream requests.

The AI service and WooCommerce MCP server can remain in Python. Different services do not need to use the same language.

### MCP transport

Use **Streamable HTTP** for the public gateway and the custom WooCommerce MCP server. Use the same transport for the additional upstream servers unless an implementation requirement dictates otherwise.

The gateway is an MCP client of its upstream servers and an MCP server for downstream clients.

### Example exposed tools

```text
woocommerce__list_products
woocommerce__create_product
woocommerce__list_orders
inventory__get_stock
inventory__find_low_stock
analytics__get_daily_sales
```

The gateway must not rely on tool-name obscurity for security. Each invocation must be checked against the current permission policy.

## 6. AI Service

### Python + FastAPI

The AI service implements the LLM interaction layer.

**Responsibilities**
- Receive chat requests from the backend.
- Construct model prompts and conversation context.
- Provide the model with available tool descriptions.
- Call the hosted LLM.
- Parse model-requested tool calls.
- Invoke the MCP gateway.
- Return tool results to the model.
- Continue the tool-calling loop when required.
- Return the final response.

### Why Python?

- Strong ecosystem for LLM APIs and AI experimentation.
- Straightforward integration with model providers.
- Convenient handling of structured model responses and tool calls.
- Keeps AI-specific code separate from the TypeScript gateway.

### Tool-calling loop

The service should follow this general flow:

```text
User message
    |
    v
Build conversation context
    |
    v
Call hosted LLM
    |
    +---- Final response ----> Return to backend
    |
    +---- Tool call
              |
              v
        Invoke MCP Gateway
              |
              v
        Receive tool result
              |
              v
        Send result to LLM
              |
              v
        Continue or return final response
```

The implementation must limit the number of tool-calling iterations and handle invalid tool arguments, model errors, gateway errors, and timeouts.

The AI service must never contact upstream MCP servers directly or hold their credentials.

### LLM provider

The specific provider is intentionally not fixed yet. Select a hosted model that supports reliable tool calling, structured tool arguments, acceptable latency, and a suitable cost for development.

Keep provider-specific code behind an interface so the provider can be changed without redesigning the gateway.

## 7. WooCommerce MCP Server

### Python + FastMCP

Implement the custom WooCommerce MCP server from scratch using FastMCP.

**Initial tools**

| Tool | Responsibility |
|---|---|
| `list_products` | Retrieve products with suitable filters and pagination |
| `create_product` | Create a WooCommerce product |
| `list_orders` | Retrieve orders using filters such as status and date |
| `get_order` | Retrieve an individual order |
| `update_order_status` | Update an order's status |

The gateway will expose namespaced versions of these tools to clients.

### WooCommerce integration

The MCP server calls the WooCommerce REST API using server-side credentials.

Credentials must be provided through protected configuration or Kubernetes Secrets. They must not be embedded in source code, returned to the LLM, or exposed to external MCP clients.

Use input validation, pagination limits, request timeouts, and appropriate error handling.

## 8. Inventory and Analytics MCP Servers

### Inventory MCP — Python + FastMCP

Responsibilities:

- Retrieve stock levels.
- Look up stock by SKU or product.
- Identify low-stock items.
- Query warehouse inventory.

### Analytics MCP — Python + FastMCP

Responsibilities:

- Retrieve daily sales summaries.
- Retrieve revenue aggregates.
- Compare sales over date ranges.
- Retrieve product performance metrics.

These services will initially use deterministic synthetic data where appropriate. They must run as separate Kubernetes workloads so that their availability and failure behavior can be tested independently.

## 9. Databases

### PostgreSQL — Platform Database

PostgreSQL stores the platform's metadata:

- Users and roles.
- API key hashes and lifecycle metadata.
- MCP server registrations.
- Cached tool metadata.
- Permission rules.
- Invitations.
- Audit logs.
- Chat conversations and messages.

### MariaDB — WooCommerce Database

MariaDB stores WordPress and WooCommerce application data, including products, orders, customers, and related records.

The platform must not maintain a second authoritative copy of WooCommerce orders and products in PostgreSQL. The custom MCP server accesses them through the WooCommerce REST API.

### ORM and migrations

Use Prisma for PostgreSQL schema definition, migrations, and TypeScript data access.

Use WooCommerce APIs and the normal WordPress/WooCommerce setup for store data rather than modifying WooCommerce database tables directly.

Both databases require persistent storage in Kubernetes.

## 10. Containerization and Kubernetes

### Docker

Each application service should have a Dockerfile and a reproducible build process.

Build separate images for:

- Frontend.
- Backend API.
- MCP Gateway.
- AI service.
- WooCommerce MCP server.
- Inventory MCP server.
- Analytics MCP server.

WordPress/WooCommerce and the database services can use suitable maintained base images.

Do not place secrets inside Docker images.

### Kind — Local Kubernetes

Use Kind for local development.

Kind runs Kubernetes nodes as Docker containers. The application images must be built and made available to the Kind cluster before Helm deploys the workloads.

The expected workflow is:

1. Start the Kind cluster.
2. Build application images.
3. Load images into Kind or use an accessible image registry.
4. Install or upgrade Helm releases.
5. Configure local hostnames and Ingress.
6. Run tests against the deployed services.

### k3s — VPS deployment

Deploy the same application to a VPS running k3s.

The Helm charts should be reused, with environment-specific values for image locations, hostnames, storage, resources, and secret references.

Do not maintain a separate production implementation of the application.

### Helm

Helm is mandatory for repeatable deployment.

The charts should define application Deployments, Services, Ingress rules, configuration, probes, resource requests and limits, and persistent storage resources where appropriate.

Keep environment-specific settings in values files instead of hardcoding them in templates.

## 11. Networking and Service Communication

### Public entry points

Expose only the required endpoints through Ingress:

- Dashboard.
- Unified MCP gateway.
- WooCommerce storefront.

The backend API may be exposed under the dashboard's API route or through a separately configured endpoint, depending on the chosen Ingress layout.

### Internal services

Keep the following on internal Kubernetes networking:

- AI service.
- Upstream MCP servers.
- PostgreSQL.
- MariaDB.
- Other internal application services.

External MCP clients should not require access to individual upstream service addresses.

### Communication summary

| Source | Destination | Purpose |
|---|---|---|
| Frontend | Backend API | Authentication and dashboard operations |
| Backend API | PostgreSQL | Platform data |
| Backend API | AI service | Chat requests |
| AI service | MCP Gateway | Tool discovery and invocation |
| External MCP client | MCP Gateway | MCP operations |
| MCP Gateway | Upstream MCP servers | Tool discovery and invocation |
| WooCommerce MCP | WooCommerce REST API | Product and order operations |
| WordPress/WooCommerce | MariaDB | Store persistence |
| MCP Gateway | PostgreSQL | Authentication metadata, permissions, audit data |

## 12. Security Stack

Security controls are part of the application architecture, not optional frontend features.

- Password hashing using an established password-hashing library.
- Cryptographically random API keys.
- Hashed API key storage.
- Immediate or promptly enforced key revocation.
- Admin/member role checks.
- Gateway-side tool authorization.
- Protected upstream credentials.
- Kubernetes Secrets for deployment secrets.
- Input validation for API and tool requests.
- Upstream URL validation and SSRF protection.
- Request timeouts and safe error handling.
- Audit logs without secrets or unnecessary sensitive payloads.
- Restricted database and service network access.

The gateway must independently validate authorization even when requests originate from the trusted backend or AI service.

## 13. Testing Tools

Use a testing setup suitable for each layer.

| Area | Suggested tooling |
|---|---|
| Frontend | Vitest and React Testing Library |
| TypeScript backend | Vitest |
| Gateway | Vitest plus MCP client-based integration tests |
| Python services | pytest |
| API integration | HTTP-level integration tests |
| Database | Isolated test database and migration tests |
| Kubernetes | Helm validation, deployment smoke tests, and live cluster tests |
| End-to-end | Automated browser or API-driven workflow tests |

The final testing strategy and individual test cases will be documented separately in `test.md`.

## 14. Repository and Dependency Management

Use a monorepo initially to simplify local development and deployment coordination.

A proposed layout:

```text
urumi-mcp-gateway/
├── apps/
│   ├── frontend/
│   ├── backend/
│   ├── gateway/
│   └── ai-service/
├── services/
│   ├── woocommerce-mcp/
│   ├── inventory-mcp/
│   └── analytics-mcp/
├── packages/
│   └── shared-types/
├── infra/
│   ├── docker/
│   ├── kind/
│   ├── helm/
│   └── ingress/
├── scripts/
├── docs/
│   ├── architecture.md
│   ├── techstacks.md
│   ├── data_schema.md
│   └── test.md
├── .env.example
├── .gitignore
└── README.md
```

This is a proposed organization, not a requirement to use exactly these paths. The coding agent may refine it while preserving service boundaries and deployment responsibilities.

Use separate dependency manifests for TypeScript and Python services. Pin compatible versions and document setup commands.

## 15. Final Technology Decisions

The initial implementation will follow these decisions:

1. React + TypeScript + Vite for the frontend.
2. Node.js + TypeScript + Fastify for the backend API.
3. Node.js + TypeScript + the official MCP SDK for the gateway.
4. Python + FastAPI for the AI service.
5. Python + FastMCP for the WooCommerce, Inventory, and Analytics MCP servers.
6. PostgreSQL for platform metadata.
7. MariaDB for WordPress and WooCommerce.
8. Prisma for TypeScript access to PostgreSQL.
9. Docker for containerization.
10. Kind for local Kubernetes and k3s for the VPS.
11. Helm for both deployments.
12. NGINX Ingress for stable external endpoints.
13. A hosted LLM with tool-calling support, selected during implementation.

These decisions provide a clear starting point while keeping the gateway, AI service, commerce integration, and infrastructure independently testable.
