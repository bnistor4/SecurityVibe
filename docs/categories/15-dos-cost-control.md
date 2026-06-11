# 15 — DoS, Abuse & Cost Control

## Bug classes to cover

- [ ] Public endpoints without rate limit
- [ ] Queries without `limit`
- [ ] `select("*")` on large tables or heavy JSONB
- [ ] Repeated `count` on large tables
- [ ] N+1 in Server Components/Route Handlers
- [ ] `ilike`/full-text without index
- [ ] ReDoS regex
- [ ] Upload without size/quota
- [ ] AI generation without per-user/tenant budget
- [ ] Email/OTP/invite without quota
- [ ] Realtime broadcast flood
- [ ] Long serverless function without timeout/cancel
- [ ] Connection pooling not configured
- [ ] Non-idempotent cron/job
- [ ] Image optimizer abuse for cost/cache

## Detection

```bash
rg -n 'select\("\*"\)|select\(\)|limit\(|range\(|count:|ilike|like|regexp|new RegExp|setTimeout|Promise\.all|for .*await' app src
rg -n 'rateLimit|limiter|quota|throttle|debounce|AbortController|timeout|maxDuration|queue|idempot' app src
```

## Mitigations

- Rate limit per IP/user/tenant/action
- Mandatory pagination
- Indexes and `EXPLAIN` on critical queries
- `AbortController` timeouts
- Storage/AI/email quotas
- Queue for heavy jobs
- Idempotency keys for payment/webhook/job
- Load test critical routes

## Related

- [Prompt](../../prompts/14-dos-cost-control.md)
