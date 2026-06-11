# 26 — Security Headers & Cookies

Headers and cookie attributes are cheap, high-leverage controls. Missing ones rarely cause a single critical bug but widen the blast radius of every other class.

## Bug classes to cover

### Response headers
- [ ] Missing/weak `Content-Security-Policy`
- [ ] `unsafe-inline`/`unsafe-eval` in production CSP without justification
- [ ] Missing `Strict-Transport-Security` (HSTS) on production
- [ ] Missing `X-Content-Type-Options: nosniff`
- [ ] Missing `frame-ancestors` / `X-Frame-Options` on app/admin pages
- [ ] Overly permissive `Referrer-Policy` leaking URLs/tokens
- [ ] Permissive `Permissions-Policy` (camera, geolocation, etc.)
- [ ] CORS headers set globally instead of per-endpoint
- [ ] Caching headers exposing private data (see [10-cache-cdn-image](10-cache-cdn-image.md))
- [ ] Verbose `Server`/`X-Powered-By` disclosure

### Cookies
- [ ] Auth/session cookie without `HttpOnly`
- [ ] Cookie without `Secure` in production
- [ ] `SameSite` unset or `None` without need
- [ ] Cookie `Domain` scoped too broadly (shared across untrusted subdomains)
- [ ] Sensitive data stored in non-`HttpOnly` cookies or `localStorage`
- [ ] Auth state in `localStorage`/`sessionStorage` readable by XSS
- [ ] Cookie `Path` too broad for scoped tokens
- [ ] No `__Host-`/`__Secure-` prefix for sensitive cookies where applicable

## Detection

```bash
rg -n 'Content-Security-Policy|Strict-Transport-Security|X-Content-Type-Options|X-Frame-Options|frame-ancestors|Referrer-Policy|Permissions-Policy|X-Powered-By' next.config.* app src middleware.* proxy.*
rg -n 'cookies\(\)\.set|set-cookie|Set-Cookie|sameSite|httpOnly|secure:|domain:|maxAge|expires' app src lib middleware.* proxy.*
rg -n 'localStorage|sessionStorage' app src components
```

## Recommended baseline

| Header | Baseline |
|--------|----------|
| `Content-Security-Policy` | Strict; nonce-based; no `unsafe-inline` in prod |
| `Strict-Transport-Security` | `max-age=63072000; includeSubDomains; preload` |
| `X-Content-Type-Options` | `nosniff` |
| `X-Frame-Options` / CSP `frame-ancestors` | `DENY` / `'none'` for app & admin |
| `Referrer-Policy` | `strict-origin-when-cross-origin` (or stricter) |
| `Permissions-Policy` | Disable unused features |

| Cookie | Baseline |
|--------|----------|
| Session/auth | `HttpOnly; Secure; SameSite=Lax`; `__Host-` prefix where possible |
| Admin context | Consider `SameSite=Strict` |

## Mitigations

- Centralize headers (Next.js `headers()` config or middleware) and test them.
- Set strict CSP; use per-request nonce for unavoidable inline scripts.
- Keep auth tokens in `HttpOnly` cookies, never in `localStorage`.
- Scope cookie `Domain`/`Path` as narrowly as possible.
- Remove framework version disclosure headers.

## Regression tests

- [ ] Production responses include the baseline header set (automated header test)
- [ ] `Set-Cookie` for session has `HttpOnly; Secure; SameSite`
- [ ] No auth token present in `localStorage`/`sessionStorage`
- [ ] Admin page rejects framing

## Related

- [Prompt](../../prompts/23-security-headers-cookies.md)
- [13-xss-csp](13-xss-csp.md)
- [20-csrf-cors](20-csrf-cors.md)
