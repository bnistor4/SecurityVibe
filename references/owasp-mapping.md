# OWASP Mapping

Maps SecurityVibe categories to OWASP Top 10 (2021), OWASP API Security Top 10 (2023), and OWASP Top 10 for LLM Applications. Useful for compliance reporting and coverage gap analysis.

## OWASP Top 10 (2021)

| OWASP | SecurityVibe categories |
|-------|-------------------------|
| A01 Broken Access Control | [04-rls](../docs/categories/04-rls-multi-tenant.md), [06-server-actions](../docs/categories/06-server-actions.md), [09-middleware](../docs/categories/09-middleware-routing.md), [27-business-logic-idor](../docs/categories/27-business-logic-idor.md) |
| A02 Cryptographic Failures | [21-secrets](../docs/categories/21-secrets-management.md), [26-headers-cookies](../docs/categories/26-security-headers-cookies.md) |
| A03 Injection | [04-rls](../docs/categories/04-rls-multi-tenant.md), [25-postgres-extensions](../docs/categories/25-postgres-extensions.md), [13-xss-csp](../docs/categories/13-xss-csp.md) |
| A04 Insecure Design | [27-business-logic-idor](../docs/categories/27-business-logic-idor.md), [24-account-takeover](../docs/categories/24-account-takeover.md) |
| A05 Security Misconfiguration | [11-vercel](../docs/categories/11-vercel-deployment.md), [26-headers-cookies](../docs/categories/26-security-headers-cookies.md), [18-dashboard-checks](../docs/categories/18-dashboard-checks.md) |
| A06 Vulnerable & Outdated Components | [01-advisory-gate](../docs/categories/01-version-advisory-gate.md), [16-supply-chain](../docs/categories/16-supply-chain.md) |
| A07 Identification & Auth Failures | [03-auth](../docs/categories/03-supabase-auth.md), [24-account-takeover](../docs/categories/24-account-takeover.md) |
| A08 Software & Data Integrity Failures | [16-supply-chain](../docs/categories/16-supply-chain.md), [07-route-handlers-api](../docs/categories/07-route-handlers-api.md) (webhooks) |
| A09 Security Logging & Monitoring Failures | [23-logging-monitoring](../docs/categories/23-logging-monitoring.md) |
| A10 Server-Side Request Forgery | [14-ssrf](../docs/categories/14-ssrf-outbound.md), [22-edge-functions](../docs/categories/22-supabase-edge-functions.md), [25-postgres-extensions](../docs/categories/25-postgres-extensions.md) (pg_net) |

## OWASP API Security Top 10 (2023)

| API risk | SecurityVibe categories |
|----------|-------------------------|
| API1 Broken Object Level Authorization (BOLA) | [27-business-logic-idor](../docs/categories/27-business-logic-idor.md), [04-rls](../docs/categories/04-rls-multi-tenant.md) |
| API2 Broken Authentication | [03-auth](../docs/categories/03-supabase-auth.md), [24-account-takeover](../docs/categories/24-account-takeover.md) |
| API3 Broken Object Property Level Authorization | [06-server-actions](../docs/categories/06-server-actions.md) (mass assignment), [08-rsc](../docs/categories/08-rsc-cache-data-security.md) (over-exposure) |
| API4 Unrestricted Resource Consumption | [15-dos-cost-control](../docs/categories/15-dos-cost-control.md) |
| API5 Broken Function Level Authorization (BFLA) | [27-business-logic-idor](../docs/categories/27-business-logic-idor.md), [07-route-handlers-api](../docs/categories/07-route-handlers-api.md) |
| API6 Unrestricted Access to Sensitive Business Flows | [27-business-logic-idor](../docs/categories/27-business-logic-idor.md) |
| API7 Server-Side Request Forgery | [14-ssrf](../docs/categories/14-ssrf-outbound.md) |
| API8 Security Misconfiguration | [11-vercel](../docs/categories/11-vercel-deployment.md), [26-headers-cookies](../docs/categories/26-security-headers-cookies.md) |
| API9 Improper Inventory Management | [02-inventory](../docs/categories/02-project-inventory.md), [11-vercel](../docs/categories/11-vercel-deployment.md) (preview/old deploys) |
| API10 Unsafe Consumption of APIs | [07-route-handlers-api](../docs/categories/07-route-handlers-api.md) (webhooks), [14-ssrf](../docs/categories/14-ssrf-outbound.md) |

## OWASP Top 10 for LLM Applications

| LLM risk | SecurityVibe |
|----------|--------------|
| LLM01 Prompt Injection | [17-ai-llm](../docs/categories/17-ai-llm.md) |
| LLM02 Sensitive Information Disclosure | [17-ai-llm](../docs/categories/17-ai-llm.md), [23-logging](../docs/categories/23-logging-monitoring.md) |
| LLM05 Improper Output Handling | [17-ai-llm](../docs/categories/17-ai-llm.md) |
| LLM06 Excessive Agency | [17-ai-llm](../docs/categories/17-ai-llm.md) (tool authz/approval) |
| LLM08 Vector & Embedding Weaknesses | [25-postgres-extensions](../docs/categories/25-postgres-extensions.md) (pgvector tenant filtering) |
| LLM10 Unbounded Consumption | [15-dos-cost-control](../docs/categories/15-dos-cost-control.md) |

## Coverage note

A category may map to several OWASP items and vice versa. Use this table to demonstrate coverage in audit reports, not as a strict 1:1 taxonomy.

Sources: [OWASP Top 10](https://owasp.org/www-project-top-ten/), [OWASP API Security](https://owasp.org/www-project-api-security/), [OWASP Top 10 for LLM](https://owasp.org/www-project-top-10-for-large-language-model-applications/).
