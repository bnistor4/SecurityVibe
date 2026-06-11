# 01 — Version and Advisory Gate

**Run this first.** A deep audit is wasted if base dependencies are already exposed.

## Files to inspect

- `package.json`
- `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `bun.lockb`
- `next.config.*`
- Vercel build logs
- Container/self-hosted image if not on Vercel

## Defensive commands

```bash
rg -n '"next"|"react"|"react-dom"|@supabase/supabase-js|@supabase/ssr' package.json package-lock.json pnpm-lock.yaml yarn.lock bun.lockb
npm ls next react react-dom @supabase/supabase-js @supabase/ssr
npm audit --omit=dev
```

## Next.js / React advisories to reconcile immediately

| Area | Advisory/CVE | Risk | What to verify |
|------|--------------|------|----------------|
| React Server Components | GHSA-9qr9-h5gf-34mp / CVE-2025-55182 | RCE on vulnerable RSC/App Router stack | `next`, `react`, `react-dom` at patched versions; lockfile and live deploy |
| Middleware/Proxy | GHSA-f82v-jwr5-mffw / CVE-2025-29927 | Auth bypass when control lives only in Middleware | Patch; duplicate authz in handlers/actions/DAL |
| App Router segment-prefetch | GHSA-267c-6grr-h53f, GHSA-26hh-7cqf-hhc6 | Middleware/Proxy bypass on unpatched versions | Next.js >= patch; test protected routes; Turbopack awareness |
| Dynamic route parameter injection | GHSA-492v-c6pp-mqqv | Middleware/Proxy bypass | Patch; param validation; DAL authz |
| Server Actions SSRF | GHSA-fr5h-rqp8-mj6g / CVE-2024-34351 | Server-side requests to unintended destinations | Patch; block user-controlled URLs/hosts |
| WebSocket SSRF | GHSA-c4j6-fc7j-m34r | SSRF via WebSocket upgrades | Host allowlist; timeouts |
| Routing/rewrites | GHSA-77r5-gw3j-2mpf, GHSA-ggv3-7p47-pfv8 | Request smuggling / header confusion | Patch; header normalization; review rewrites |
| RSC cache | GHSA-wfc6-r584-vfw7, GHSA-vfv6-92ff-j949 | Cache poisoning / cache-busting collisions | Patch; no user data in public cache |
| Image Optimizer | GHSA-h64f-5h5j-jqjh, GHSA-3x4c-7xq6-9pq8, GHSA-9g9p-9gw9-jx7f | DoS, cache growth, content injection | Patch; tighten `remotePatterns`, sizes, redirects, body size, SVG |
| Server Components DoS | GHSA-8h8q-6873-q5fj, GHSA-q4gf-8mx6-v5v3, GHSA-h25m-26qc-wcjf, GHSA-mwv6-3258-q52c | Availability loss | Patch; rate limits; timeouts; load tests |

## Typical finding

```markdown
### Finding: Next.js vulnerable to Middleware/Proxy bypass advisory
- Severity: Critical/High
- Evidence: package.json + lockfile show `next@...`; advisory requires >= ...
- Impact: Middleware/Proxy-protected routes reachable without application control
- Fix: Upgrade Next.js; add authz in Server Actions, Route Handlers, DAL; negative E2E on protected routes
- Test: `npm ls next`; E2E anonymous user on all protected routes/APIs
```

## Checklist

- [ ] Lockfile committed and used in CI
- [ ] Installed versions match deployed build
- [ ] All applicable advisories patched or risk-accepted with compensating controls
- [ ] Compensating controls documented if patch blocked

## Related

- [Prompt: Version & Advisory Gate](../../prompts/01-version-advisory-gate.md)
- [References](../../references/sources.md)
