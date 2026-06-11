# 19 — Minimum Regression Test Suite

Implement tests for every **confirmed** finding and for baseline security invariants.

## Unit / integration

- [ ] `requireUser` fails for anon/invalid token
- [ ] `requireTenant` fails for non-member tenant
- [ ] Server Action validates input and ignores extra fields
- [ ] Serializer/DTO excludes sensitive fields
- [ ] URL allowlist rejects unexpected hosts
- [ ] Webhook rejects missing/wrong signature and replay

## Database / RLS

- [ ] User A cannot read/write User B
- [ ] Tenant A cannot read/write Tenant B
- [ ] `INSERT` with altered `tenant_id` fails
- [ ] `UPDATE` changing owner/tenant fails
- [ ] `anon` sees only truly public records
- [ ] Unauthorized RPC fails

## E2E

- [ ] Anonymous on all protected routes
- [ ] Normal user on admin routes
- [ ] Preview deployment does not write to production
- [ ] Allowed and disallowed file uploads
- [ ] Logout invalidates protected page access
- [ ] Cache cross-user: login/logout/user switch without leak

## Operational

- [ ] Alert on 401/403/429 spikes
- [ ] Alert on anomalous service_role usage
- [ ] Alert on API/webhook error rate
- [ ] Database restore drill
- [ ] Secret rotation drill

## Suggested tooling

| Layer | Examples |
|-------|----------|
| Unit | Vitest, Jest |
| API | Supertest, fetch against local server |
| RLS | Supabase test users + SQL or integration tests |
| E2E | Playwright, Cypress |
| Load | k6, Artillery (authorized environments only) |

## Mapping findings to tests

Each finding template includes a **Regression test** field. Copy those into your test tracker and link PRs that close SEC-XXX findings.
