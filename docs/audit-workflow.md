# Audit Workflow

## Phase 0 — Preparation

- [ ] Confirm written authorization to test the target
- [ ] Identify environments: local, preview, production
- [ ] Note Supabase project(s) and Vercel team/project
- [ ] Clone SecurityVibe (or add as reference)

## Phase 1 — Advisory gate

**Doc:** [categories/01-version-advisory-gate.md](categories/01-version-advisory-gate.md)

- [ ] Check `package.json` and lockfile versions
- [ ] Run `npm audit --omit=dev`
- [ ] Compare deployed runtime vs lockfile (Vercel build logs)
- [ ] Patch or document exceptions before deep review

## Phase 2 — Inventory

**Doc:** [categories/02-project-inventory.md](categories/02-project-inventory.md)

- [ ] Run `scripts/inventory.sh` or `scripts/inventory.ps1`
- [ ] Map entry points, auth/data/cache/secret boundaries
- [ ] List all Server Actions, Route Handlers, webhooks, crons

## Phase 3 — Core stack (ordered)

| Order | Category | Checklist section |
|-------|----------|-------------------|
| 1 | Auth & SSR | [03-supabase-auth](categories/03-supabase-auth.md) |
| 2 | RLS & tenant isolation | [04-rls-multi-tenant](categories/04-rls-multi-tenant.md) |
| 3 | Storage | [05-storage-upload](categories/05-storage-upload.md) |
| 4 | Server Actions | [06-server-actions](categories/06-server-actions.md) |
| 5 | Route Handlers & API | [07-route-handlers-api](categories/07-route-handlers-api.md) |
| 6 | RSC & cache | [08-rsc-cache-data-security](categories/08-rsc-cache-data-security.md) |
| 7 | Middleware | [09-middleware-routing](categories/09-middleware-routing.md) |
| 8 | CDN & images | [10-cache-cdn-image](categories/10-cache-cdn-image.md) |
| 9 | Vercel & preview | [11-vercel-deployment](categories/11-vercel-deployment.md) |

## Phase 4 — Extended surface

| Category | Doc |
|----------|-----|
| Realtime | [12-realtime](categories/12-realtime.md) |
| XSS & CSP | [13-xss-csp](categories/13-xss-csp.md) |
| SSRF | [14-ssrf-outbound](categories/14-ssrf-outbound.md) |
| DoS & cost | [15-dos-cost-control](categories/15-dos-cost-control.md) |
| Supply chain | [16-supply-chain](categories/16-supply-chain.md) |
| AI/LLM (if used) | [17-ai-llm](categories/17-ai-llm.md) |

## Phase 5 — External verification

**Doc:** [categories/18-dashboard-checks.md](categories/18-dashboard-checks.md)

- [ ] Supabase: RLS, storage, keys, logs
- [ ] Vercel: env, protection, crons, deployments
- [ ] Third-party: Stripe webhooks, email, monitoring

## Phase 6 — Report & remediate

- [ ] Normalize findings with [templates/finding.md](../templates/finding.md)
- [ ] Build executive table with [templates/executive-report.md](../templates/executive-report.md)
- [ ] Assign owners and SLAs per [severity.md](severity.md)
- [ ] Add regression tests per [categories/19-regression-test-suite.md](categories/19-regression-test-suite.md)

## Phase 7 — Re-test

- [ ] Re-run affected detection scripts
- [ ] Run E2E negative tests (anon, user A/B, tenant A/B)
- [ ] Close or downgrade findings with evidence

## AI-assisted variant

For each phase-3/4 category:

1. Open matching file in `prompts/`
2. Paste into agent with target repo in workspace
3. Enforce [AGENTS.md](../AGENTS.md) output format
4. Human-triage every proposed finding
