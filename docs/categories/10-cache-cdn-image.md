# 10 — Cache, CDN, ISR & Image Optimizer

## Bug classes to cover

- [ ] User-specific data with public cache headers
- [ ] User-specific Route Handler without `Cache-Control: private/no-store`
- [ ] Default-cache `fetch` on per-user/tenant data
- [ ] Global cache tags for tenant-specific data
- [ ] Over-broad `revalidatePath`
- [ ] Cacheable redirect with user input
- [ ] Missing `Vary` when response depends on auth/headers
- [ ] Image Optimization `remotePatterns` too broad
- [ ] Remote SVG without CSP/content disposition
- [ ] Local IP or image redirects allowed unnecessarily
- [ ] Unbounded image cache on attacker-controlled input
- [ ] ISR on pages with private data

## Detection

```bash
rg -n 'Cache-Control|revalidate|revalidatePath|revalidateTag|unstable_cache|use cache|cacheTag|fetch\(' app src next.config.*
rg -n 'remotePatterns|dangerouslyAllowSVG|dangerouslyAllowLocalIP|maximumRedirects|maximumDiskCacheSize|maximumResponseBody|contentSecurityPolicy' next.config.* app src
```

## Mitigations

- `no-store` or `private` for user-specific data
- Tenant/resource-scoped cache tags; targeted invalidation
- No ISR for private pages
- Tight `remotePatterns`: protocol, hostname, pathname, search
- Disable SVG or serve as attachment with CSP
- Limit image redirect/body/disk cache where configurable
- Patch Next.js for cache/image advisories

## Related

- [Prompt](../../prompts/09-cache-rsc-data-security.md)
