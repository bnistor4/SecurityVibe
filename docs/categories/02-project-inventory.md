# 02 — Project Inventory

Build a map of attack surface before deep category reviews.

## Automated inventory

```bash
./scripts/inventory.sh /path/to/your-project
# or
./scripts/inventory.ps1 -ProjectPath C:\path\to\your-project
```

## Manual patterns

```bash
rg -n '"use server"|export async function (GET|POST|PUT|PATCH|DELETE)|NextResponse|NextRequest' app src
rg -n 'middleware|proxy|matcher|redirect\(|rewrite\(' .
rg -n 'createClient|createServerClient|createBrowserClient|getSession|getUser|getClaims|auth\.uid|auth\.jwt' .
rg -n 'service_role|sb_secret|SUPABASE_SERVICE|NEXT_PUBLIC_.*(SECRET|TOKEN|KEY|PASSWORD)' .
rg -n 'dangerouslySetInnerHTML|innerHTML|outerHTML|DOMPurify|sanitize|mdx|markdown' app src components
rg -n 'fetch\(|axios|new URL|URLSearchParams|request\.json\(|formData\(' app src
rg -n 'revalidatePath|revalidateTag|unstable_cache|cacheTag|use cache|cookies\(|headers\(' app src
rg -n 'storage\.from|createSignedUrl|upload\(|download\(|remove\(' app src supabase
rg -n 'channel\(|subscribe\(|removeChannel|presence|broadcast|realtime' app src
rg -n 'webhook|signature|svix|stripe|resend|cron|schedule' app src vercel.json
rg -n 'dangerouslyAllowSVG|remotePatterns|domains:|maximumRedirects|maximumResponseBody|maximumDiskCacheSize' next.config.* .
rg -n 'runtime = .edge.|runtime: .edge.|edge' app src next.config.* vercel.json
```

## Classification matrix

Tag each hit as one or more:

| Boundary | Examples |
|----------|----------|
| **Public entry point** | API routes, Server Actions, forms, webhooks, uploads, OAuth callbacks, crons, preview URLs |
| **Auth boundary** | Login, logout, session refresh, middleware/proxy, data access layer |
| **Data boundary** | Tables, RLS, storage buckets, tenant scope, admin paths, service role usage |
| **Cache boundary** | RSC payload, route cache, CDN, image cache, revalidation |
| **Secret boundary** | Env vars, logs, build output, client bundle, Vercel dashboard |

## Deliverable

Produce a surface map table:

| ID | Type | Path | Boundary | Notes |
|----|------|------|----------|-------|
| EP-001 | Route Handler | `app/api/...` | Public + Data | Needs authz review |

Use this map to prioritize category audits.

## Checklist

- [ ] All `route.ts` files listed
- [ ] All `"use server"` action files listed
- [ ] Middleware/proxy matcher documented
- [ ] Supabase client creation sites documented
- [ ] `service_role` / secret key references flagged
- [ ] Webhooks and crons identified
