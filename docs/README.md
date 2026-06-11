# SecurityVibe Documentation Index

## Foundation

| Document | Description |
|----------|-------------|
| [Getting Started](getting-started.md) | How to run your first audit |
| [Methodology](methodology.md) | Principles and scope |
| [Severity](severity.md) | Severity levels and SLAs |
| [Audit Workflow](audit-workflow.md) | Step-by-step review process |
| [Executive Summary](executive-summary.md) | Priority areas at a glance |

## Audit categories

| # | Category | File |
|---|----------|------|
| 01 | Version & Advisory Gate | [categories/01-version-advisory-gate.md](categories/01-version-advisory-gate.md) |
| 02 | Project Inventory | [categories/02-project-inventory.md](categories/02-project-inventory.md) |
| 03 | Supabase Auth & SSR | [categories/03-supabase-auth.md](categories/03-supabase-auth.md) |
| 04 | RLS & Multi-tenant | [categories/04-rls-multi-tenant.md](categories/04-rls-multi-tenant.md) |
| 05 | Storage & Upload | [categories/05-storage-upload.md](categories/05-storage-upload.md) |
| 06 | Server Actions | [categories/06-server-actions.md](categories/06-server-actions.md) |
| 07 | Route Handlers & API | [categories/07-route-handlers-api.md](categories/07-route-handlers-api.md) |
| 08 | RSC, Cache & Data Security | [categories/08-rsc-cache-data-security.md](categories/08-rsc-cache-data-security.md) |
| 09 | Middleware & Routing | [categories/09-middleware-routing.md](categories/09-middleware-routing.md) |
| 10 | Cache, CDN & Images | [categories/10-cache-cdn-image.md](categories/10-cache-cdn-image.md) |
| 11 | Vercel Deployment | [categories/11-vercel-deployment.md](categories/11-vercel-deployment.md) |
| 12 | Realtime | [categories/12-realtime.md](categories/12-realtime.md) |
| 13 | XSS, CSP & Frontend | [categories/13-xss-csp.md](categories/13-xss-csp.md) |
| 14 | SSRF & Outbound | [categories/14-ssrf-outbound.md](categories/14-ssrf-outbound.md) |
| 15 | DoS & Cost Control | [categories/15-dos-cost-control.md](categories/15-dos-cost-control.md) |
| 16 | Supply Chain & Secrets | [categories/16-supply-chain.md](categories/16-supply-chain.md) |
| 17 | AI/LLM Security | [categories/17-ai-llm.md](categories/17-ai-llm.md) |
| 18 | Dashboard Checks | [categories/18-dashboard-checks.md](categories/18-dashboard-checks.md) |
| 19 | Regression Test Suite | [categories/19-regression-test-suite.md](categories/19-regression-test-suite.md) |
| 20 | CSRF, CORS & Cross-origin | [categories/20-csrf-cors.md](categories/20-csrf-cors.md) |
| 21 | Secrets & Key Management | [categories/21-secrets-management.md](categories/21-secrets-management.md) |
| 22 | Supabase Edge Functions | [categories/22-supabase-edge-functions.md](categories/22-supabase-edge-functions.md) |
| 23 | Logging & Monitoring | [categories/23-logging-monitoring.md](categories/23-logging-monitoring.md) |
| 24 | Account Takeover & Identity | [categories/24-account-takeover.md](categories/24-account-takeover.md) |
| 25 | Postgres Extensions & pg_graphql | [categories/25-postgres-extensions.md](categories/25-postgres-extensions.md) |
| 26 | Security Headers & Cookies | [categories/26-security-headers-cookies.md](categories/26-security-headers-cookies.md) |
| 27 | Business Logic & IDOR | [categories/27-business-logic-idor.md](categories/27-business-logic-idor.md) |

## References

- [Next.js / React CVE & advisory catalog](../references/nextjs-cve-catalog.md)
- [OWASP mapping (Top 10 / API / LLM)](../references/owasp-mapping.md)
- [Incident patterns (defensive case studies)](../references/incident-patterns.md)
- [Verified sources](../references/sources.md)

## Supporting assets

- [Master checklist](../checklists/master-audit-checklist.md)
- [Finding template](../templates/finding.md)
- [AI prompts](../prompts/)
- [Detection scripts](../scripts/)
- [RLS SQL queries](../sql/rls-audit.sql)
