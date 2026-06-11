# SecurityVibe

**Defensive security audit toolkit for Next.js + Supabase + Vercel projects.**

SecurityVibe is an open-source documentation archive and testing framework for security reviews, code reviews, configuration reviews, hardening, and **authorized** penetration testing of applications built with:

- Next.js App Router & React Server Components
- Supabase Auth, Database, Storage, Realtime
- Vercel Deploy, Preview, Edge & Serverless
- Tailwind CSS (and common adjacent tooling)

> **Defensive only.** This project covers attack vectors, bug classes, misconfigurations, detection patterns, and mitigations. It does **not** include payloads, PoCs, operational bypass instructions, or weaponization guidance.

## Who is this for?

- Security engineers running structured reviews
- Full-stack developers hardening their own stack
- AI coding agents performing evidence-based audits
- Teams preparing for production launch or compliance checks

## Quick start

1. **Clone or copy** this repository into your workflow (or reference it as a submodule).
2. Read [Getting Started](docs/getting-started.md) and [Audit Workflow](docs/audit-workflow.md).
3. Run the **Version and Advisory Gate** first: [docs/categories/01-version-advisory-gate.md](docs/categories/01-version-advisory-gate.md).
4. Execute detection scripts against your target project:

   ```bash
   # Unix / macOS / Linux / Git Bash
   ./scripts/inventory.sh /path/to/your-project

   # Windows PowerShell
   ./scripts/inventory.ps1 -ProjectPath C:\path\to\your-project
   ```

5. Work through audit categories in order (see [docs/README.md](docs/README.md)).
6. Record findings using [templates/finding.md](templates/finding.md).
7. Use [prompts/](prompts/) with AI agents — one category at a time.

## Repository structure

```
SecurityVibe/
├── docs/                  # Full audit methodology and category guides
├── checklists/            # Printable / copy-paste audit checklists
├── prompts/               # AI agent prompts (defensive, evidence-based)
├── templates/             # Finding and executive report templates
├── scripts/               # ripgrep-based detection helpers
├── sql/                   # Supabase/Postgres RLS audit queries
├── references/            # Verified external sources
└── .github/               # Issue and PR templates
```

## Recommended audit order

| Step | Category | Doc |
|------|----------|-----|
| 0 | Version & Advisory Gate | [01-version-advisory-gate](docs/categories/01-version-advisory-gate.md) |
| 1 | Project inventory | [02-project-inventory](docs/categories/02-project-inventory.md) |
| 2 | Supabase Auth & SSR | [03-supabase-auth](docs/categories/03-supabase-auth.md) |
| 3 | RLS & multi-tenant | [04-rls-multi-tenant](docs/categories/04-rls-multi-tenant.md) |
| 4 | Storage & upload | [05-storage-upload](docs/categories/05-storage-upload.md) |
| 5 | Server Actions | [06-server-actions](docs/categories/06-server-actions.md) |
| 6 | Route Handlers & API | [07-route-handlers-api](docs/categories/07-route-handlers-api.md) |
| 7 | RSC, cache & data security | [08-rsc-cache-data-security](docs/categories/08-rsc-cache-data-security.md) |
| 8 | Middleware & routing | [09-middleware-routing](docs/categories/09-middleware-routing.md) |
| 9 | Cache, CDN & images | [10-cache-cdn-image](docs/categories/10-cache-cdn-image.md) |
| 10 | Vercel deployment | [11-vercel-deployment](docs/categories/11-vercel-deployment.md) |
| 11 | Realtime | [12-realtime](docs/categories/12-realtime.md) |
| 12 | XSS, CSP & frontend | [13-xss-csp](docs/categories/13-xss-csp.md) |
| 13 | SSRF & outbound requests | [14-ssrf-outbound](docs/categories/14-ssrf-outbound.md) |
| 14 | DoS & cost control | [15-dos-cost-control](docs/categories/15-dos-cost-control.md) |
| 15 | Supply chain & secrets | [16-supply-chain](docs/categories/16-supply-chain.md) |
| 16 | AI/LLM (if applicable) | [17-ai-llm](docs/categories/17-ai-llm.md) |
| 17 | Dashboard checks | [18-dashboard-checks](docs/categories/18-dashboard-checks.md) |
| 18 | Regression test suite | [19-regression-test-suite](docs/categories/19-regression-test-suite.md) |
| 19 | CSRF, CORS & cross-origin | [20-csrf-cors](docs/categories/20-csrf-cors.md) |
| 20 | Secrets & key management | [21-secrets-management](docs/categories/21-secrets-management.md) |
| 21 | Supabase Edge Functions | [22-supabase-edge-functions](docs/categories/22-supabase-edge-functions.md) |
| 22 | Logging & monitoring | [23-logging-monitoring](docs/categories/23-logging-monitoring.md) |
| 23 | Account takeover & identity | [24-account-takeover](docs/categories/24-account-takeover.md) |
| 24 | Postgres extensions & pg_graphql | [25-postgres-extensions](docs/categories/25-postgres-extensions.md) |
| 25 | Security headers & cookies | [26-security-headers-cookies](docs/categories/26-security-headers-cookies.md) |
| 26 | Business logic & IDOR | [27-business-logic-idor](docs/categories/27-business-logic-idor.md) |
| 27 | Email infrastructure (SPF/DKIM/DMARC) | [28-email-infrastructure](docs/categories/28-email-infrastructure.md) |
| 28 | Compliance & audit tables | [29-compliance-audit-tables](docs/categories/29-compliance-audit-tables.md) |
| 29 | PostgREST info disclosure | [30-postgrest-info-disclosure](docs/categories/30-postgrest-info-disclosure.md) |

## Examples

- [Retest playbook template](examples/retest-playbook-template.md) — verify fixes after an audit (PASS/FAIL)

## References

- [Next.js / React CVE & advisory catalog](references/nextjs-cve-catalog.md)
- [OWASP mapping (Top 10 / API / LLM)](references/owasp-mapping.md)
- [Incident patterns (defensive case studies)](references/incident-patterns.md)

## Severity model

See [docs/severity.md](docs/severity.md) for severity definitions and recommended SLAs.

## AI agents

If you use Cursor, Copilot, Claude Code, or similar tools, read [AGENTS.md](AGENTS.md) before running category prompts. Agents must produce **evidence-based** findings with file paths and line numbers — never invented issues.

## Contributing

Contributions welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) and [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## Star History

<a href="https://www.star-history.com/?repos=bnistor4%2FSecurityVibe&type=date&legend=top-left">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=bnistor4/SecurityVibe&type=date&theme=dark&legend=top-left" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=bnistor4/SecurityVibe&type=date&legend=top-left" />
    <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=bnistor4/SecurityVibe&type=date&legend=top-left" />
  </picture>
</a>

## License

[MIT](LICENSE)

## Copyright

Copyright © 2026 [bnistor4](https://github.com/bnistor4). All rights reserved where applicable. Released under the [MIT License](LICENSE).

## Disclaimer

This toolkit is for **authorized** security assessment and defensive hardening only. You are responsible for obtaining proper permission before testing any system you do not own or operate.
