# 20 — CSRF, CORS & Cross-origin Abuse

Server Actions and Route Handlers are state-changing endpoints. Cross-origin protections are often assumed, not verified.

## Bug classes to cover

- [ ] State-changing Route Handler relying only on cookies (no CSRF defense, no `SameSite`)
- [ ] `SameSite=None` cookies without strong justification
- [ ] Missing `SameSite`/`Secure`/`HttpOnly` on auth/session cookies
- [ ] Server Action invoked cross-site because `allowedOrigins` is too broad
- [ ] CORS reflecting `Origin` header back into `Access-Control-Allow-Origin`
- [ ] `Access-Control-Allow-Origin: *` combined with `Access-Control-Allow-Credentials: true`
- [ ] CORS allowlist using `endsWith`/`includes` (e.g. `evil-example.com` passes `example.com` check)
- [ ] Preflight (`OPTIONS`) not validated; actual method bypasses checks
- [ ] JSON endpoint accepting `text/plain` or form content-type (simple request, no preflight)
- [ ] GET endpoints with side effects reachable via `<img>`/`<form>`
- [ ] Login CSRF (forced login to attacker account) on auth callback
- [ ] WebSocket/Realtime upgrade without origin check
- [ ] PostMessage handlers without origin verification
- [ ] Clickjacking: missing `frame-ancestors` / `X-Frame-Options` on sensitive UI

## Detection

```bash
rg -n 'Access-Control-Allow-Origin|Access-Control-Allow-Credentials|allowedOrigins|SameSite|sameSite|secure:|httpOnly|credentials:' app src lib next.config.* middleware.* proxy.*
rg -n 'addEventListener\(.message|postMessage|event\.origin|\.origin ===' app src components
rg -n 'export async function (GET|POST|PUT|PATCH|DELETE)' app src
```

## Mitigations

- Prefer Server Actions (Next.js adds origin checks) over hand-rolled mutating Route Handlers.
- Set `allowedOrigins` explicitly when behind a reverse proxy; never wildcard.
- Cookies: `HttpOnly`, `Secure`, `SameSite=Lax` (or `Strict` for admin) by default.
- CORS: exact-match origin allowlist via URL parsing — never reflect, never `*` with credentials.
- Validate `Origin`/`Referer` on sensitive state-changing requests as defense in depth.
- No side effects on GET.
- PostMessage handlers must verify `event.origin` against an allowlist.
- `frame-ancestors 'none'` (or strict allowlist) on dashboards and admin.

## Regression tests

- [ ] Cross-origin `fetch` with credentials to a mutating endpoint is rejected
- [ ] CORS preflight from disallowed origin returns no permissive headers
- [ ] Cookie attributes verified in `Set-Cookie` response
- [ ] Sensitive page cannot be framed (CSP/`X-Frame-Options`)

## Related

- [Prompt](../../prompts/17-csrf-cors.md)
- [13-xss-csp](13-xss-csp.md)
- [07-route-handlers-api](07-route-handlers-api.md)
