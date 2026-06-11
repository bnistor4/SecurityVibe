# 09 — Middleware, Proxy & Routing

## Bug classes to cover

- [ ] Middleware/Proxy as sole auth control
- [ ] Matcher too narrow: new routes unprotected
- [ ] Matcher too broad: assets/API/health broken or slowed
- [ ] Login/protected redirect loop
- [ ] Middleware using unvalidated session
- [ ] Known unpatched bypass advisory
- [ ] Rewrites changing auth semantics
- [ ] i18n/basePath/trailingSlash not considered
- [ ] Unvalidated dynamic routes
- [ ] Trusted forwarded/host/origin headers without normalization
- [ ] Cache poisoning on redirects/rewrites
- [ ] Edge Middleware with unsupported Node dependencies

## Detection

```bash
rg -n 'middleware|proxy|matcher|NextResponse\.redirect|NextResponse\.rewrite|x-forwarded|host|origin|basePath|i18n|trailingSlash' .
```

## Mitigations

- Middleware/Proxy as UX filter / early reject only — not final authorization
- Authz in Route Handlers, Server Actions, and DAL
- Protected route test matrix: anon, normal user, wrong tenant, admin
- Patch Next.js for Middleware/Proxy advisories
- Explicit matchers; review when adding routes
- Normalize host/origin; don't trust forwarded headers unless platform-controlled

## Related

- [Prompt](../../prompts/08-middleware-routing.md)
- [01-version-advisory-gate](01-version-advisory-gate.md)
