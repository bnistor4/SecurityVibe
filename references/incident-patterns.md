# Incident Patterns (Defensive Case Studies)

Recurring, real-world failure patterns for this stack — described defensively. Each entry: how it happens, how to detect it, how to prevent it. **No payloads or exploitation steps.**

These are anonymized, generalized patterns representative of common Next.js + Supabase + Vercel incidents. Use them to prioritize review and to brief teams.

---

## P1 — `service_role` key shipped to the browser

**Pattern:** A developer needs to "make a query work" and uses the Supabase service key in a client component or a `NEXT_PUBLIC_` variable. The key bypasses all RLS.

**Why it happens:** RLS blocked a query during development; the service key "fixed" it quickly.

**Detect:** grep for `service_role`/`sb_secret` in `app/`, `components/`, and any `NEXT_PUBLIC_*`; inspect the production client bundle.

**Prevent:** service key only in server-only modules; mark sensitive in Vercel; fix the underlying RLS policy instead; CI secret scanning. → [21-secrets](../docs/categories/21-secrets-management.md)

---

## P2 — RLS disabled "temporarily" reaches production

**Pattern:** A new table is created without RLS, or RLS is disabled to debug, and the migration ships. Every row is world-readable via the API.

**Detect:** SQL audit (`pg_tables.rowsecurity = false` in `public`); migration review for `disable row level security` and missing `enable`.

**Prevent:** policy that every new table enables RLS; CI check; the [rls-audit.sql](../sql/rls-audit.sql) queries. → [04-rls](../docs/categories/04-rls-multi-tenant.md)

---

## P3 — Authorization only in middleware

**Pattern:** Auth is enforced in `middleware.ts`. A middleware-bypass advisory, a new unmatched route, or a direct data-layer call exposes protected data.

**Detect:** confirm protected Route Handlers/Server Actions independently authorize; check matcher coverage; verify Next.js patch level.

**Prevent:** treat middleware as UX gating only; enforce authz in the DAL. → [09-middleware](../docs/categories/09-middleware-routing.md), [01-advisory-gate](../docs/categories/01-version-advisory-gate.md)

---

## P4 — Server Action mass assignment

**Pattern:** A profile-update action forwards the whole parsed object to `update()`. A client adds `role: "admin"` or `tenant_id` and escalates.

**Detect:** actions passing full objects/`FormData` into DB writes without field whitelisting.

**Prevent:** explicit field allowlist; server-side role checks; DB constraints. → [06-server-actions](../docs/categories/06-server-actions.md), [27-business-logic-idor](../docs/categories/27-business-logic-idor.md)

---

## P5 — IDOR on a Route Handler

**Pattern:** `GET /api/invoices/:id` loads by ID and returns it. No owner check. Iterating IDs returns other tenants' invoices.

**Detect:** handlers fetching by `params.id` without an owner/tenant predicate; rely on RLS or explicit checks.

**Prevent:** authorize the subject-object relationship in the query/DAL; enable RLS as defense in depth. → [27-business-logic-idor](../docs/categories/27-business-logic-idor.md)

---

## P6 — Preview deployment writing to production data

**Pattern:** Preview env inherits production Supabase credentials. A PR preview runs migrations/seeds or test writes against production.

**Detect:** Vercel Preview env inspection; compare Preview vs Production `SUPABASE_URL`/keys.

**Prevent:** separate Supabase project/branch for preview; Deployment Protection; never reuse prod credentials in preview. → [11-vercel](../docs/categories/11-vercel-deployment.md)

---

## P7 — Cross-user data cached in RSC/CDN

**Pattern:** A user-specific page is cached publicly (default `fetch` cache, ISR, or global tag). User B sees User A's data.

**Detect:** user-specific routes without `no-store`/`private`; global cache tags; ISR on private pages.

**Prevent:** `no-store`/`private` for user data; tenant-scoped cache keys/tags. → [08-rsc](../docs/categories/08-rsc-cache-data-security.md), [10-cache-cdn-image](../docs/categories/10-cache-cdn-image.md)

---

## P8 — Webhook without signature verification

**Pattern:** A payment/email webhook updates state based on the request body alone. Anyone who learns the URL can forge events (e.g. mark orders paid).

**Detect:** webhook handlers not verifying a provider signature over the raw body; non-idempotent processing.

**Prevent:** verify signature on raw body; idempotency keys; replay window. → [07-route-handlers-api](../docs/categories/07-route-handlers-api.md)

---

## P9 — Password reset host header poisoning

**Pattern:** Reset email link is built from the request `Host`/`X-Forwarded-Host`. An attacker-influenced host sends the victim a reset link pointing to an attacker domain.

**Detect:** reset/verification URL construction reading request host headers.

**Prevent:** build links from a fixed configured base URL; single-use, short-TTL tokens. → [24-account-takeover](../docs/categories/24-account-takeover.md)

---

## P10 — SSRF via "fetch this URL" feature

**Pattern:** An importer/preview/AI tool fetches a user-supplied URL server-side, enabling access to internal services or cloud metadata (self-hosted especially).

**Detect:** `fetch`/`axios` with user input; redirect following; missing host allowlist.

**Prevent:** exact-host allowlist; block private ranges; timeouts; no internal tokens to untrusted hosts. → [14-ssrf](../docs/categories/14-ssrf-outbound.md)

---

## P11 — Stored XSS via rich text / Markdown

**Pattern:** User-supplied HTML/Markdown with raw HTML is rendered with `dangerouslySetInnerHTML` without sanitization; script executes in other users' sessions.

**Detect:** `dangerouslySetInnerHTML`, Markdown with raw HTML enabled, unsanitized rich text.

**Prevent:** server-side sanitization; avoid raw HTML; strict CSP. → [13-xss-csp](../docs/categories/13-xss-csp.md)

---

## P12 — Supply-chain via lifecycle script

**Pattern:** A compromised or typosquatted dependency runs a `postinstall` script during CI/build with access to env secrets, exfiltrating tokens.

**Detect:** review `postinstall`/`preinstall`/`prepare`; lockfile drift; unexpected network calls in build.

**Prevent:** frozen lockfile installs; review lifecycle scripts; minimal CI token scope; SCA. → [16-supply-chain](../docs/categories/16-supply-chain.md)

---

## P13 — Cross-tenant retrieval in RAG/pgvector

**Pattern:** Vector similarity search isn't filtered by tenant; an AI assistant retrieves and surfaces another tenant's documents.

**Detect:** vector queries without tenant predicate; embedding tables without RLS.

**Prevent:** tenant-filter retrieval; RLS on embedding tables; scope citations. → [25-postgres-extensions](../docs/categories/25-postgres-extensions.md), [17-ai-llm](../docs/categories/17-ai-llm.md)

---

## P14 — Prompt injection drives a tool action

**Pattern:** Untrusted content (a document, web page) instructs the LLM to call a mutating tool or exfiltrate data; the agent complies without authorization.

**Detect:** tools invoked from model output without per-action authz/approval; system prompt overridable by content.

**Prevent:** tool allowlist + authz; explicit confirmation for risky actions; never execute model output as code/SQL. → [17-ai-llm](../docs/categories/17-ai-llm.md)

---

## Using these patterns

- Brief new engineers with the 3–4 most relevant to your app.
- Turn each relevant pattern into a regression test ([19-regression-test-suite](../docs/categories/19-regression-test-suite.md)).
- Track which patterns you've explicitly ruled out in your audit report.
