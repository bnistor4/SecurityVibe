# Master Audit Checklist

Use with [docs/audit-workflow.md](../docs/audit-workflow.md). Check categories in order.

## Phase 1 — Gate & inventory

- [ ] **01** Version & Advisory Gate — dependencies patched or accepted
- [ ] **02** Project inventory script run; surface map created

## Phase 2 — Core security

- [ ] **03** Supabase Auth & SSR — no server `getSession()` authz
- [ ] **04** RLS — every table has policies; SQL audit run
- [ ] **05** Storage — buckets and policies reviewed
- [ ] **06** Server Actions — mutating actions meet 10-point standard
- [ ] **07** Route Handlers — schema, authz, webhooks, crons
- [ ] **08** RSC & data — DAL, DTOs, no cross-user cache
- [ ] **09** Middleware — not sole auth gate; matcher reviewed
- [ ] **10** Cache & images — no private data in public cache
- [ ] **11** Vercel — preview/prod separation

## Phase 3 — Extended

- [ ] **12** Realtime — cleanup, tenant-scoped channels
- [ ] **13** XSS & CSP — sanitization and headers
- [ ] **14** SSRF — no user-controlled server fetch
- [ ] **15** DoS & cost — limits, pagination, quotas
- [ ] **16** Supply chain — lockfile, scripts, secrets
- [ ] **17** AI/LLM — if applicable

## Phase 4 — External & tests

- [ ] **18** Dashboard checks — Supabase, Vercel, providers
- [ ] **19** Regression tests — unit, RLS, E2E, ops

## Deliverables

- [ ] Findings logged with [templates/finding.md](../templates/finding.md)
- [ ] Executive table with [templates/executive-report.md](../templates/executive-report.md)
- [ ] Owners and SLAs assigned per [docs/severity.md](../docs/severity.md)
