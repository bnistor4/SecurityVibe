# 07 — Route Handlers, API Routes & Webhooks

## Bug classes to cover

- [ ] `request.json()` without schema
- [ ] Mutating endpoint without method control
- [ ] CORS `*` with credentials or reflected origin
- [ ] Public API without rate limit
- [ ] IDOR/BOLA: `/api/resource/:id` without owner/tenant check
- [ ] Query param used in fetch/DB without allowlist
- [ ] SSRF via user-controlled URL/body/header
- [ ] Open redirect from `next`, `redirect`, `returnTo`
- [ ] Stack trace or raw provider errors in response
- [ ] Missing `Cache-Control` on user-specific data
- [ ] GET with side effects
- [ ] Non-idempotent DELETE/POST where retries expected
- [ ] Unbounded body size
- [ ] Webhook without signature on raw body
- [ ] Non-idempotent webhook
- [ ] Webhook replay not handled
- [ ] Cron endpoint publicly callable
- [ ] Admin endpoint protected only by hidden path

## Detection

```bash
rg -n 'export async function (GET|POST|PUT|PATCH|DELETE)|request\.json|NextResponse\.json|headers\(|cors|Access-Control' app src
rg -n 'webhook|signature|rawBody|constructEvent|svix|stripe|resend|github|clerk|supabase' app src
rg -n 'cron|CRON_SECRET|Authorization|Bearer|x-vercel-cron|schedule' app src vercel.json
```

## Mitigations

- Schema for body, query, and params
- Auth + per-object authz on every operation
- Allowlisted CORS separate from application auth
- `Cache-Control: private, no-store` for user-specific responses
- Rate limit and quota per IP/user/tenant
- Webhooks: signature on raw body, timestamp/replay window, idempotency key, unique constraint
- Cron: secret header or provider mechanism; idempotency; logs and alerts
- No raw errors to client; redacted server logs

## Related

- [Prompt: Route Handlers](../../prompts/06-route-handlers-api.md)
- [Prompt: Webhooks & Cron](../../prompts/07-webhooks-cron.md)
