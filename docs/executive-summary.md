# Executive Summary

**Target stack:** Next.js App Router, React Server Components, Supabase Auth/Database/Storage/Realtime, Vercel Deploy/Preview/Edge/Serverless, Tailwind.

Areas requiring **immediate priority**:

## 1. Next.js / React advisories

Before reviewing application code, reconcile `next`, `react`, `react-dom`, and lockfiles with official advisories — especially:

- RSC RCE
- Middleware/Proxy bypass
- Server Actions SSRF
- Cache poisoning
- Request smuggling
- Image Optimizer DoS
- Server Components DoS

→ [01-version-advisory-gate.md](categories/01-version-advisory-gate.md)

## 2. Server-side auth

In Next.js + Supabase, **cookies are not proof of identity**. Server code must use correct SSR clients and token-validating calls — not session reads alone.

→ [03-supabase-auth.md](categories/03-supabase-auth.md)

## 3. RLS and Storage

Every exposed table or bucket needs testable policies. The `service_role` / secret key **bypasses all policies** — exposure in client, logs, or preview is a critical incident.

→ [04-rls-multi-tenant.md](categories/04-rls-multi-tenant.md), [05-storage-upload.md](categories/05-storage-upload.md)

## 4. Per-object authorization

Middleware, UI guards, and protected pages are insufficient. Every Server Action, Route Handler, RPC, and query must verify owner/tenant/role on the **specific record**.

→ [06-server-actions.md](categories/06-server-actions.md), [07-route-handlers-api.md](categories/07-route-handlers-api.md)

## 5. Vercel preview deployments

Preview URLs are a **public attack surface**. They must not write to production Supabase, expose real user data, or use unprotected secrets.

→ [11-vercel-deployment.md](categories/11-vercel-deployment.md)

## 6. Cache and RSC payload

User data, tenant context, secrets, and raw DB records must not be cross-user cached or serialized to Client Components.

→ [08-rsc-cache-data-security.md](categories/08-rsc-cache-data-security.md), [10-cache-cdn-image.md](categories/10-cache-cdn-image.md)

## 7. Supply chain and build

Build pipelines, postinstall scripts, CI env, and Vercel logs are concrete secret exfiltration points.

→ [16-supply-chain.md](categories/16-supply-chain.md)

## 8. AI / LLM features

If present, treat prompt injection, tool abuse, RAG leakage, SSRF via tools/fetch, and cost DoS as **first-class application security** — not a secondary feature concern.

→ [17-ai-llm.md](categories/17-ai-llm.md)
