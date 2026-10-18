# Test Plan — Team MCP Gateway on Kubernetes

## 1. Purpose

This document defines the testing strategy for the Team MCP Gateway platform.

Testing must establish that:

- The dashboard and backend enforce admin/member access restrictions.
- API keys are securely generated, stored, validated, and revoked.
- The MCP Gateway exposes tools from three upstream MCP servers through one endpoint.
- Every tool invocation is authorized by the gateway.
- The AI service invokes tools only through the gateway.
- WooCommerce product and order operations work end to end.
- Upstream failures do not bring down unrelated services.
- Audit logs correctly identify the initiating user and invocation outcome.
- PostgreSQL and WooCommerce data persist across ordinary pod restarts.
- The same Helm charts work in local Kind and production-like k3s environments.

## 2. Testing Strategy

Use a layered testing strategy.

| Level | Scope | Main purpose |
|---|---|---|
| Unit tests | Individual functions and modules | Validate business rules and edge cases |
| API tests | Backend HTTP endpoints | Validate authentication, validation, and role enforcement |
| Gateway tests | MCP discovery and tool calls | Validate aggregation, authorization, and routing |
| Integration tests | Services and databases together | Validate actual inter-service behavior |
| AI workflow tests | LLM tool-calling loop | Validate tool selection, invocation, and error handling |
| Security tests | Authentication, authorization, URL validation | Detect access-control and credential-handling failures |
| Kubernetes tests | Helm, probes, storage, networking | Validate deployment and operational behavior |
| End-to-end tests | Complete user workflows | Verify the assignment's demonstration scenarios |
| VPS smoke tests | k3s deployment | Verify the production-like deployment |

## 3. Testing Tools

| Component | Recommended tools |
|---|---|
| Frontend | Vitest, React Testing Library |
| Backend API | Vitest and HTTP-level tests |
| MCP Gateway | Vitest, MCP SDK client, mock upstream servers |
| Python AI service | pytest, HTTPX test client |
| Python MCP servers | pytest and MCP client integration tests |
| PostgreSQL | Dedicated test database and migration tests |
| WooCommerce | Dedicated test store and REST API |
| Docker | Image build and container smoke tests |
| Kubernetes | Kind, `kubectl`, Helm validation |
| End-to-end | Playwright or equivalent browser automation, plus API-driven workflows |

Use deterministic fixtures and mock external dependencies where appropriate. Keep separate integration tests against real local MCP servers and WooCommerce.

## 4. Unit Tests

### 4.1 Backend API

| ID | Test case | Expected result |
|---|---|---|
| UT-BE-01 | Register a user with valid data | User is created successfully |
| UT-BE-02 | Register duplicate normalized email | Request is rejected |
| UT-BE-03 | Authenticate with valid credentials | Authentication succeeds |
| UT-BE-04 | Authenticate with an incorrect password | Authentication fails |
| UT-BE-05 | Authenticate a disabled user | Authentication fails |
| UT-BE-06 | Member calls an admin-only endpoint | Request is rejected |
| UT-BE-07 | Admin calls an authorized management endpoint | Request succeeds |
| UT-BE-08 | Submit malformed server configuration | Request is rejected with a useful validation error |
| UT-BE-09 | Submit an invalid permission rule | Request is rejected |
| UT-BE-10 | Member attempts to change platform-wide permissions | Request is rejected |
| UT-BE-11 | Member requests another user's private chat history | Access is denied |
| UT-BE-12 | Create an invitation with an invalid role | Request is rejected |

### 4.2 API key management

| ID | Test case | Expected result |
|---|---|---|
| UT-KEY-01 | Generate a new API key | Key is generated securely |
| UT-KEY-02 | Inspect the database after key creation | Plaintext key is not stored |
| UT-KEY-03 | Validate a correct key | Authentication succeeds |
| UT-KEY-04 | Validate an incorrect key | Authentication fails |
| UT-KEY-05 | Validate a revoked key | Authentication fails |
| UT-KEY-06 | Validate an expired key | Authentication fails |
| UT-KEY-07 | Use a key belonging to a disabled user | Authentication fails |
| UT-KEY-08 | Revoke another member's key without authorization | Request is rejected |
| UT-KEY-09 | Revoke a valid key | Subsequent requests using it fail |
| UT-KEY-10 | Inspect logs after authentication failures | Plaintext keys are absent |

### 4.3 Permission engine

| ID | Test case | Expected result |
|---|---|---|
| UT-PERM-01 | User has a matching `ALLOW` rule | Invocation is authorized |
| UT-PERM-02 | User has a matching `DENY` rule | Invocation is denied |
| UT-PERM-03 | Matching allow and deny rules both exist | Deny takes precedence |
| UT-PERM-04 | No rule matches the requested tool | Invocation is denied |
| UT-PERM-05 | Role-level allow applies without a deny | Invocation is authorized |
| UT-PERM-06 | User-specific deny overrides role-level allow | Invocation is denied |
| UT-PERM-07 | Tool is hidden in the UI but called directly | Gateway denies it if unauthorized |
| UT-PERM-08 | Tool belongs to a disabled server | Invocation is rejected |
| UT-PERM-09 | User attempts to modify their own role through an ordinary member API | Request is rejected |
| UT-PERM-10 | Permission policy changes | Subsequent requests use the updated policy |

The permission tests must exercise the actual policy evaluation function used by the gateway.

### 4.4 Gateway routing

| ID | Test case | Expected result |
|---|---|---|
| UT-GW-01 | Discover tools from enabled servers | Enabled tools are aggregated |
| UT-GW-02 | Two upstreams expose the same tool name | Exposed names remain unique |
| UT-GW-03 | Invoke a registered tool | Request routes to the correct upstream |
| UT-GW-04 | Invoke an unknown tool | Request is rejected |
| UT-GW-05 | Invoke a disabled tool | Request is rejected |
| UT-GW-06 | Upstream returns a structured error | Error is handled without crashing the gateway |
| UT-GW-07 | Upstream exceeds its timeout | Call fails within the configured timeout policy |
| UT-GW-08 | Upstream is unreachable during discovery | Healthy upstream tools remain discoverable |
| UT-GW-09 | Upstream metadata changes | Discovery refresh updates cached metadata |
| UT-GW-10 | Permission is revoked after a previous successful call | Subsequent invocation is denied |

### 4.5 AI service

| ID | Test case | Expected result |
|---|---|---|
| UT-AI-01 | User asks a general question requiring no tools | AI returns a normal response |
| UT-AI-02 | Model requests a valid tool call | AI invokes the gateway |
| UT-AI-03 | Model requests an unavailable tool | AI handles the failure safely |
| UT-AI-04 | Gateway denies a tool call | AI does not bypass the denial |
| UT-AI-05 | Gateway times out | AI returns a controlled error or recovery response |
| UT-AI-06 | Model returns invalid tool arguments | Invalid arguments are rejected or handled safely |
| UT-AI-07 | Model repeatedly requests tool calls | Configured iteration limit is enforced |
| UT-AI-08 | Tool returns an error | AI does not report the operation as successful |
| UT-AI-09 | Tool returns a valid result | AI uses the result to produce a final response |
| UT-AI-10 | Tool output contains instructions attempting to override system rules | Output is treated as untrusted data |

Use mocked LLM responses for deterministic unit tests. Add separate integration tests for the selected hosted LLM provider.

## 5. Database Tests

### 5.1 Schema and migration tests

| ID | Test case | Expected result |
|---|---|---|
| DB-01 | Apply migrations to a clean PostgreSQL database | Migrations succeed |
| DB-02 | Create a duplicate user email | Unique constraint prevents duplication |
| DB-03 | Create an API key record with an existing hash | Unique constraint prevents duplication |
| DB-04 | Create a tool referencing a nonexistent server | Foreign-key constraint rejects the record |
| DB-05 | Create an invalid permission target | Check constraint rejects the record |
| DB-06 | Insert an invalid enum value | Database rejects the value |
| DB-07 | Query audit logs by user and timestamp | Query returns correctly filtered results |
| DB-08 | Remove a server with historical audit records | Audit history remains available |
| DB-09 | Restart the PostgreSQL pod | Platform data persists |
| DB-10 | Restart the MariaDB pod | WooCommerce data persists |

### 5.2 Seed data tests

- Run platform seed scripts twice and confirm no duplicate logical records are created.
- Confirm at least three upstream server records exist in the demo environment.
- Confirm seed data includes users with different roles.
- Confirm permissions include both allow and deny cases.
- Confirm WooCommerce products and orders exist through the REST API.
- Confirm orders include today's, yesterday's, and older records.
- Confirm synthetic inventory contains low-stock and out-of-stock items.
- Confirm analytics data covers the configured date range.
- Confirm development seed scripts do not contain real credentials.

## 6. MCP Server Integration Tests

### 6.1 WooCommerce MCP server

Test against a running WordPress/WooCommerce instance.

| ID | Test case | Expected result |
|---|---|---|
| MCP-WC-01 | Discover WooCommerce tools | Required tools are listed |
| MCP-WC-02 | List products | Products are returned with valid structure |
| MCP-WC-03 | Create a product with valid input | Product is created in WooCommerce |
| MCP-WC-04 | Create a product with invalid input | Request is rejected with a useful error |
| MCP-WC-05 | List orders for a date range | Only matching orders are returned |
| MCP-WC-06 | Retrieve an existing order | Correct order details are returned |
| MCP-WC-07 | Retrieve a nonexistent order | A controlled not-found error is returned |
| MCP-WC-08 | Update an order status | WooCommerce reflects the new status |
| MCP-WC-09 | Submit invalid order status | Request is rejected |
| MCP-WC-10 | WooCommerce REST API is unavailable | MCP server returns a controlled error |
| MCP-WC-11 | Request a large product or order list | Pagination and limits are respected |
| MCP-WC-12 | Inspect responses and logs | WooCommerce credentials are not exposed |

### 6.2 Inventory MCP server

- Discover inventory tools.
- Retrieve a known SKU.
- Retrieve stock across warehouses.
- Find low-stock products.
- Handle an unknown SKU.
- Handle invalid warehouse identifiers.
- Handle an unavailable inventory service.

Expected result: valid requests return structured results, and invalid requests or unavailable dependencies produce controlled errors.

### 6.3 Analytics MCP server

- Discover analytics tools.
- Retrieve daily sales for a known date.
- Retrieve product performance.
- Query a date range.
- Query a range with no data.
- Reject invalid date ranges.
- Handle unavailable analytics storage or service dependencies.

Expected result: queries return consistent data and errors do not crash the service.

## 7. Gateway Integration Tests

Run these tests with the gateway connected to all three real upstream MCP servers.

| ID | Test case | Expected result |
|---|---|---|
| GW-INT-01 | Start all three upstreams | Gateway connects successfully |
| GW-INT-02 | Request the unified tool list | Tools from all enabled upstreams appear |
| GW-INT-03 | Invoke a WooCommerce tool | Correct WooCommerce MCP server receives the call |
| GW-INT-04 | Invoke an Inventory tool | Correct Inventory MCP server receives the call |
| GW-INT-05 | Invoke an Analytics tool | Correct Analytics MCP server receives the call |
| GW-INT-06 | Register an additional tool with a duplicate name | Gateway resolves the naming collision |
| GW-INT-07 | Disable an upstream server | Its tools disappear from refreshed discovery results |
| GW-INT-08 | Invoke a tool belonging to a disabled server | Invocation is rejected |
| GW-INT-09 | Re-enable a server | Discovery and routing recover |
| GW-INT-10 | Kill one upstream pod | Calls to the other two upstreams continue working |
| GW-INT-11 | Restart a failed upstream pod | Gateway resumes calls after recovery |
| GW-INT-12 | Trigger an upstream timeout | Gateway returns a controlled error and records the outcome |
| GW-INT-13 | Revoke a caller's API key | Subsequent calls using the key are rejected |
| GW-INT-14 | Revoke a tool permission | Subsequent calls are denied |
| GW-INT-15 | Inspect audit records | User, server, tool, timestamp, duration, and outcome are correctly recorded |

## 8. Security Tests

### 8.1 Authentication

- Missing credentials are rejected.
- Invalid credentials are rejected.
- Revoked and expired API keys are rejected.
- Disabled users cannot authenticate.
- A user cannot impersonate another user by changing a request parameter.
- A member cannot call admin-only backend endpoints.
- Internal chat requests cannot spoof the initiating user ID.
- Authentication failures do not disclose secrets.

### 8.2 Authorization

- Unauthorized tools cannot be invoked directly.
- Explicit deny rules override applicable allow rules.
- Missing permission rules result in denial.
- Disabled servers cannot be invoked even if clients retain stale tool metadata.
- Permission changes take effect promptly.
- External MCP clients and chat use the same gateway authorization rules.
- A member cannot modify server configuration or platform-wide permissions.
- A member cannot access another member's conversations or activity.

### 8.3 Secret handling

- Plaintext API keys are never stored in PostgreSQL.
- Upstream credentials are not returned in API responses.
- Passwords and secrets are absent from logs.
- Secrets are not committed to source control.
- Secrets are not embedded in container images.
- Tool descriptions and chat traces do not reveal upstream credentials.
- The AI service has no direct dependency on upstream credentials.

### 8.4 SSRF and upstream URL validation

An administrator-supplied upstream URL is a security-sensitive input.

Test that the platform rejects prohibited destinations, including applicable:

- Loopback addresses.
- Private or internal addresses not explicitly permitted.
- Link-local addresses.
- Cloud metadata endpoints.
- Invalid schemes and malformed URLs.
- Redirects that lead to prohibited destinations.

Validation must account for DNS resolution and changes in resolved addresses. Do not rely exclusively on a string-based hostname check.

Tests must use controlled mock endpoints and must not probe unrelated internal or public systems.

### 8.5 Input and output safety

- Malformed tool arguments are rejected.
- Excessively large requests are bounded.
- Tool outputs are treated as untrusted content by the AI service.
- Error responses do not expose stack traces or credentials to clients.
- Chat input cannot override gateway authorization.
- Sensitive customer and order data is not unnecessarily written to audit logs.

## 9. Audit Log Tests

| ID | Test case | Expected result |
|---|---|---|
| AUD-01 | Successful tool invocation | Success event is recorded |
| AUD-02 | Permission-denied invocation | Denial event is recorded |
| AUD-03 | Upstream timeout | Error event is recorded |
| AUD-04 | Invalid or revoked API key | Authentication failure is recorded according to the audit policy |
| AUD-05 | Invocation originates from chat | Actual initiating user is recorded |
| AUD-06 | Invocation originates from an external MCP client | Correct API key owner is recorded |
| AUD-07 | Filter by user | Only matching records are returned |
| AUD-08 | Filter by server | Only matching server records are returned |
| AUD-09 | Filter by time range and outcome | Results match the requested filters |
| AUD-10 | Inspect records after a server is removed | Historical audit records remain available |
| AUD-11 | Inspect logs for credentials | No plaintext credentials are present |
| AUD-12 | Compare invocation duration with recorded duration | Recorded duration is plausible and consistent with measured execution |

For every completed tool invocation, verify that the audit record identifies the initiating user, server, tool, timestamp, duration, and outcome. Use explicit error categories for failures.

## 10. End-to-End Tests

These workflows verify the full platform, not just individual services.

### E2E-01: Admin registers and inspects servers

1. Log in as an administrator.
2. Open MCP server management.
3. Register or inspect WooCommerce, Inventory, and Analytics.
4. Trigger tool discovery.
5. Verify that the dashboard shows server status and tools.

**Expected result:** All three servers are registered, their tools are discoverable, and the gateway exposes a unified tool list.

### E2E-02: WooCommerce product creation through chat

1. Log in as a member with permission to create products.
2. Open chat.
3. Ask the AI to create a product with a valid name, price, and other required fields.
4. Verify the AI requests the appropriate tool through the gateway.
5. Verify the gateway authorizes and routes the invocation.
6. Verify the product exists through the WooCommerce REST API.
7. Open the storefront and verify the product appears according to its publication and visibility settings.

**Expected result:** The product is created in WooCommerce, the AI reports the result accurately, and the audit log records the invocation.

### E2E-03: Query today's orders through chat

1. Seed WooCommerce with orders dated today, yesterday, and earlier.
2. Log in as a member with order-list permission.
3. Ask the AI to retrieve today's orders.
4. Verify the correct tool is invoked.
5. Verify the tool uses the configured store timezone and date boundaries.
6. Compare the result with the WooCommerce REST API.

**Expected result:** Only orders matching the requested date and applicable filters are returned.

### E2E-04: External MCP client

1. Generate an API key for a second member.
2. Configure an MCP client with the gateway URL and key.
3. Discover available tools.
4. Invoke an authorized tool.
5. Verify the result and audit record.

**Expected result:** The external client accesses the same gateway as chat and receives only the tools and operations allowed for that user.

### E2E-05: Cross-server workflow

1. Ask the AI to retrieve a product from WooCommerce.
2. Ask it to check the product's stock through Inventory.
3. Retrieve the relevant sales metrics through Analytics if the request requires them.
4. Inspect each gateway invocation.

**Expected result:** The workflow invokes multiple upstreams through the gateway. Each invocation is independently authorized and audited.

### E2E-06: Member permission restrictions

1. Configure a member to allow product listing but deny product creation.
2. Log in as that member.
3. Verify the UI reflects the member's available tools.
4. Attempt product creation through chat.
5. Attempt the same operation directly using an MCP client.

**Expected result:** Both unauthorized operations are denied by the gateway. Hiding the tool in the UI is not considered sufficient.

### E2E-07: API key revocation

1. Generate an API key.
2. Use it to make a successful gateway request.
3. Revoke the key.
4. Attempt the same request with the revoked key.

**Expected result:** The initial call succeeds and subsequent calls using the revoked key fail.

### E2E-08: Server disablement

1. Disable the Inventory server as an administrator.
2. Refresh gateway tool discovery.
3. Verify Inventory tools are absent.
4. Attempt to invoke an Inventory tool directly using a previously obtained tool name.
5. Invoke a WooCommerce tool.

**Expected result:** Inventory calls are rejected, while WooCommerce remains functional.

### E2E-09: Upstream pod failure

1. Confirm all three upstream MCP servers are healthy.
2. Successfully call one tool from each server.
3. Stop or delete the Inventory pod.
4. Attempt an Inventory call.
5. Invoke WooCommerce and Analytics tools.
6. Restore Inventory and retry its operation.

**Expected result:** Inventory fails gracefully, WooCommerce and Analytics continue working, and Inventory recovers after the pod returns.

### E2E-10: Audit attribution

1. Perform one tool invocation through chat as Member A.
2. Perform another invocation through an external MCP client as Member B.
3. Open the audit dashboard as an administrator.
4. Filter the events by user and server.

**Expected result:** Each event is attributed to the correct user and contains the required invocation details.

### E2E-11: Database persistence

1. Create platform records and a WooCommerce product.
2. Restart the PostgreSQL pod.
3. Verify platform records remain available.
4. Restart the MariaDB pod.
5. Verify the WooCommerce product and orders remain available.

**Expected result:** Persistent data survives ordinary database pod restarts.

## 11. Kubernetes and Helm Tests

### 11.1 Helm validation

Run validation before deploying:

```bash
helm lint infra/helm/<chart>
helm template <release-name> infra/helm/<chart> \
  -f infra/helm/<chart>/values-kind.yaml
```

Use the actual chart path and values filenames once the repository structure is finalized.

Verify:

- Helm templates render successfully.
- Required configuration is present.
- No secret values are hardcoded into chart templates or committed values.
- Deployments have resource requests and limits.
- Readiness and liveness probes are configured appropriately.
- Database PVCs are configured.
- Ingress hostnames and routes are correct.
- Application services use the intended internal networking.

### 11.2 Kind deployment

1. Create the Kind cluster.
2. Build and load application images.
3. Install the Helm release.
4. Wait for required pods to become ready.
5. Verify Services and Ingress.
6. Run smoke tests against the dashboard, gateway, and storefront.
7. Run the required end-to-end scenarios.

**Expected result:** The platform starts from a documented local installation procedure without manual edits to deployed resources.

### 11.3 Pod recovery

Test the following:

- Delete an application pod and verify its Deployment recreates it.
- Restart the gateway and verify it rediscovers or reconnects to upstreams.
- Restart an upstream MCP pod and verify recovery.
- Restart database pods and verify persistence.
- Make an upstream unavailable and verify readiness and error reporting behave as designed.

A liveness probe must not turn a temporary upstream failure into an unnecessary restart loop for an otherwise healthy gateway.

### 11.4 k3s deployment

Deploy the same Helm charts to the VPS environment with different values.

Verify:

- Application images can be pulled.
- Required pods become ready.
- Persistent storage works.
- Ingress hostnames and TLS configuration are correct for the deployment.
- Database services are not publicly exposed.
- Secrets are supplied through protected configuration.
- Gateway authentication and authorization work.
- Required end-to-end workflows pass.

**Expected result:** Deployment differences are handled through configuration rather than a separate application implementation.

## 12. Failure and Recovery Tests

| ID | Failure scenario | Expected behavior |
|---|---|---|
| FAIL-01 | WooCommerce MCP server unavailable | WooCommerce calls fail gracefully; other upstreams continue |
| FAIL-02 | Inventory MCP server unavailable | Inventory calls fail gracefully; other upstreams continue |
| FAIL-03 | Analytics MCP server unavailable | Analytics calls fail gracefully; other upstreams continue |
| FAIL-04 | One upstream times out | Timeout is bounded and audited |
| FAIL-05 | Gateway restarts | Deployment recovers and upstream connectivity is restored |
| FAIL-06 | PostgreSQL temporarily unavailable | Dependent operations fail safely and recover when the database returns |
| FAIL-07 | MariaDB temporarily unavailable | WooCommerce-dependent operations return controlled errors |
| FAIL-08 | LLM provider unavailable | Chat returns a controlled error; direct authorized MCP access remains independent |
| FAIL-09 | Invalid tool schema or arguments | Request fails safely without crashing the gateway |
| FAIL-10 | Stale cached tools after server disablement | Invocation is rejected |
| FAIL-11 | Revoked key remains in a client configuration | Gateway rejects the key |
| FAIL-12 | Upstream recovers after downtime | Tools become usable again after successful recovery and discovery |

Avoid automatic retries of non-idempotent operations, such as product creation or order-status changes, unless retry safety and duplicate-operation handling are explicitly implemented.

## 13. Performance and Resource Tests

The initial implementation should validate basic responsiveness and bounded resource usage rather than aim for premature large-scale optimization.

Measure:

- Gateway tool-discovery latency.
- Successful tool-invocation latency.
- Timeout behavior.
- Audit logging overhead.
- Behavior when one upstream is slow.
- Memory and CPU usage of application pods.
- Database connection recovery.
- Behavior with several concurrent tool invocations.

Use a small, documented concurrency workload appropriate for the local Kind cluster. Record the test environment and avoid claiming production capacity based on a local laptop benchmark.

Set resource requests and limits based on measured behavior and available VPS resources.

## 14. Test Data and Environment Requirements

Tests must use deterministic, synthetic data.

Required fixtures include:

- An administrator and at least two members.
- Active, revoked, and expired API keys.
- Three registered upstream MCP servers.
- Tools with allow and deny permissions.
- WooCommerce products and orders across several dates and statuses.
- Inventory with low-stock and out-of-stock records.
- Analytics data across multiple dates.
- Audit events with different users, servers, outcomes, and durations.

Use a dedicated test database or isolated records for automated tests. Do not run destructive reset operations against production-like data.

The exact schema and seed strategy are documented in `data_schema.md`.

## 15. Continuous Integration Checks

Where practical, automate the following checks:

1. TypeScript type checking.
2. Python linting and static checks.
3. Frontend and backend unit tests.
4. Gateway unit tests.
5. Python service unit tests.
6. Database migration validation.
7. Helm linting and template rendering.
8. Docker image builds.
9. Selected integration tests.
10. A clean local-cluster deployment smoke test.

Do not require live hosted-LLM credentials for every unit test. Use mocked model responses for deterministic checks, with a separate opt-in integration test for the actual provider.

## 16. Acceptance Criteria

The project is considered functionally ready for demonstration when all critical requirements below pass.

### Core functionality

- [ ] WooCommerce storefront is deployed and accessible.
- [ ] Custom WooCommerce MCP server exposes the required product and order tools.
- [ ] Inventory and Analytics MCP servers are connected.
- [ ] One gateway endpoint aggregates tools from all three servers.
- [ ] Chat invokes tools through the gateway.
- [ ] External MCP clients invoke tools through the same gateway.
- [ ] Tool names remain unique across upstreams.

### Security

- [ ] Admin and member permissions are enforced.
- [ ] API keys are hashed in storage.
- [ ] Revoked keys are rejected.
- [ ] Tool permissions are checked on every invocation.
- [ ] Direct unauthorized tool calls are rejected.
- [ ] Upstream credentials remain server-side.
- [ ] Upstream URL validation and SSRF protections are tested.
- [ ] Audit events identify the initiating user.

### Reliability

- [ ] Disabling a server removes its tools from refreshed discovery.
- [ ] Calls to disabled tools are rejected.
- [ ] One failed upstream does not disable unrelated healthy upstreams.
- [ ] Database persistence survives ordinary pod restarts.
- [ ] Application health probes and resource settings are configured.
- [ ] Timeout and recovery behavior are tested.

### Deployment and delivery

- [ ] Local Kind installation works through Helm.
- [ ] The same Helm charts deploy to k3s using environment-specific values.
- [ ] Mock data is deterministic and seed scripts are idempotent.
- [ ] README includes setup, deployment, configuration, and troubleshooting.
- [ ] Architecture and security decisions are documented.
- [ ] Required demonstration scenarios can be reproduced.

## 17. Final Demo Runbook

Run the final demonstration in this order:

1. Show the running WooCommerce storefront.
2. Log in as an administrator and show the three registered MCP servers.
3. Show the unified gateway tool list.
4. Log in as a member and create a product through AI chat.
5. Verify the product appears in WooCommerce.
6. Ask the AI to retrieve today's orders.
7. Connect a second member's external MCP client and invoke an authorized tool.
8. Demonstrate a cross-server workflow involving WooCommerce and Inventory or Analytics.
9. Show a denied operation for a member without permission.
10. Revoke an API key and demonstrate that subsequent calls fail.
11. Disable one upstream server and show its tools becoming unavailable.
12. Stop an upstream pod and demonstrate that the other services remain usable.
13. Show audit logs with correct user attribution, tool names, durations, and outcomes.
14. Show the Kind deployment and persistent database storage.
15. Demonstrate the same Helm-based deployment approach on the VPS.

Capture the final demonstration only after the required scenarios have been verified. Clearly distinguish successful tests from tests that remain incomplete.

## 18. Test Execution Reporting

For every test run, record:

- Test ID.
- Test environment.
- Date and time.
- Test data or fixture identifier.
- Actual result.
- Expected result.
- Pass/fail status.
- Failure details and relevant sanitized logs.

Do not mark a test as passing merely because a service starts or a tool appears in the UI. Verify the actual behavior and its relevant security, routing, persistence, or audit outcome.
