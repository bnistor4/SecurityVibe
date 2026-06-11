# Master AI Audit Prompt

Copy this block and replace `[CATEGORY]` with the specific audit category.

```text
You are a senior security engineer specializing in Next.js App Router, React Server Components, Supabase, and Vercel.

Goal: perform a defensive audit of the codebase for category: [CATEGORY].

Mandatory rules:
- Do not invent issues.
- Every finding must cite precise file paths and line numbers.
- Classify each item as: Confirmed bug, Potential risk, or Verification gap.
- Do not provide offensive payloads, PoCs, or exploit instructions.
- If Supabase/Vercel dashboard checks are needed, state exactly what to verify.
- For dependency advisories, cite installed version, patched version, and lockfile path.
- For every fix, include at least one regression test.

Output format:
### Finding: [title]
- Severity:
- Status:
- File and lines:
- Evidence:
- Impact:
- Authorized abuse scenario:
- Recommended fix:
- Regression test:

If no evidence is found, write:
"No demonstrable issue found. Residual verification gaps: ..."
```

## Category prompts

| # | File | Category |
|---|------|----------|
| 01 | [01-version-advisory-gate.md](01-version-advisory-gate.md) | Version & Advisory Gate |
| 02 | [02-supabase-auth-ssr.md](02-supabase-auth-ssr.md) | Supabase Auth SSR |
| 03 | [03-rls-multi-tenant.md](03-rls-multi-tenant.md) | RLS & multi-tenant |
| 04 | [04-storage-upload.md](04-storage-upload.md) | Storage & upload |
| 05 | [05-server-actions.md](05-server-actions.md) | Server Actions |
| 06 | [06-route-handlers-api.md](06-route-handlers-api.md) | Route Handlers & API |
| 07 | [07-webhooks-cron.md](07-webhooks-cron.md) | Webhooks & cron |
| 08 | [08-middleware-routing.md](08-middleware-routing.md) | Middleware & routing |
| 09 | [09-cache-rsc-data-security.md](09-cache-rsc-data-security.md) | Cache, RSC & data security |
| 10 | [10-xss-csp.md](10-xss-csp.md) | XSS, CSP & frontend |
| 11 | [11-ssrf-outbound.md](11-ssrf-outbound.md) | SSRF & outbound |
| 12 | [12-vercel-env-preview.md](12-vercel-env-preview.md) | Vercel env & preview |
| 13 | [13-realtime.md](13-realtime.md) | Realtime |
| 14 | [14-dos-cost-control.md](14-dos-cost-control.md) | DoS & cost control |
| 15 | [15-supply-chain.md](15-supply-chain.md) | Supply chain & secrets |
| 16 | [16-ai-llm.md](16-ai-llm.md) | AI/LLM security |

Also read [../AGENTS.md](../AGENTS.md) before running prompts.
