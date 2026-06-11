# 08 — RSC Payload, Data Security & Client Components

## Bug classes to cover

- [ ] DB/env imported directly in many Server Components without DAL
- [ ] Missing `server-only` on secret/DB access files
- [ ] Raw DB records passed to Client Components
- [ ] Over-broad Client props (`User`, `Profile`, `any`)
- [ ] RSC payload contains PII, secrets, tokens, internal IDs, other-tenant data
- [ ] `use client` on large layouts/pages forcing bundle and data exposure
- [ ] Unvalidated dynamic route params
- [ ] `cookies()`/`headers()` in components with unclear cache behavior
- [ ] User-specific data cached with global tags
- [ ] `use cache` / `unstable_cache` on tenant/user data without correct key/tags
- [ ] Global path/tag revalidation after tenant-specific mutation
- [ ] `Date.now()`, `Math.random()`, `window`, `localStorage` in initial render
- [ ] Side effects in render

## Detection

```bash
rg -n '"use client"|server-only|unstable_cache|use cache|cacheTag|cookies\(|headers\(|params|searchParams' app src
rg -n 'password|token|secret|apiKey|service|email|phone|address|ssn|tax|internal|metadata' app src
rg -n 'as any|: any|Record<string, any>|User\]|Profile\]|select\(\*\)|select\(\)' app src
```

## Mitigations

- Server-only Data Access Layer for sensitive data
- DTO/serializer: only necessary fields to client
- Strict Client Component prop types
- Schema-validate `params` and `searchParams`
- Cache keys include tenant/user when needed; otherwise `no-store`
- Targeted revalidation per tenant/resource
- Inspect Network/RSC payload in browser on sensitive pages
- No secrets in Server Action closures

## Regression tests

- [ ] Devtools: no email/token/role/tenant on unauthorized pages
- [ ] User A on cached page after User B: no cross-user leak
- [ ] Tenant A mutation does not invalidate/expose Tenant B

## Related

- [Prompt](../../prompts/09-cache-rsc-data-security.md)
- [Next.js Data Security](https://nextjs.org/docs/app/guides/data-security)
