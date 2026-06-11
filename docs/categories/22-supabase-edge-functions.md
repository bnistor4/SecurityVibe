# 22 — Supabase Edge Functions (Deno)

Edge Functions run server-side Deno with direct access to service keys and the database. They are a high-value, frequently under-reviewed surface.

## Bug classes to cover

- [ ] Function uses `service_role` and skips per-request user authorization
- [ ] No verification of the caller's JWT (`verify_jwt` disabled without compensating auth)
- [ ] `Authorization` header trusted without validation
- [ ] User-controlled input passed to SQL/RPC without validation (injection)
- [ ] SSRF: function fetches user-supplied URLs (Deno `fetch`)
- [ ] Secrets read from function env returned or logged
- [ ] Overly broad CORS headers returned by the function
- [ ] No rate limiting / abuse control on public functions
- [ ] Webhook function without signature verification on raw body
- [ ] Long-running work without timeout; cost/DoS exposure
- [ ] Error responses leak stack traces or internal config
- [ ] Function callable anonymously when it should require auth
- [ ] Shared utility uses caller-provided `tenant_id`/`user_id` instead of JWT claims

## Detection

```bash
rg -n 'Deno\.serve|serve\(|createClient|SUPABASE_SERVICE_ROLE|verify_jwt|getUser|Authorization' supabase/functions
rg -n 'fetch\(|Deno\.env\.get|new URL|req\.headers' supabase/functions
rg -n 'verify_jwt' supabase/config.toml supabase
```

## Mitigations

- Default to verifying the caller JWT; derive identity from validated claims, not request body.
- Use `service_role` only for system operations after authorizing the user separately.
- Validate all input with a schema before DB/RPC calls.
- Allowlist outbound hosts; block private ranges; set fetch timeouts.
- Verify webhook signatures on the raw body.
- Return generic errors; log details server-side, redacted.
- Configure `verify_jwt` and document any function intentionally public.
- Add rate limiting / quotas for public functions.

## Regression tests

- [ ] Anonymous call to an auth-required function fails
- [ ] Caller cannot act on another tenant by changing body params
- [ ] Webhook function rejects missing/invalid signature
- [ ] Outbound fetch to disallowed host is blocked

## Related

- [Prompt](../../prompts/19-supabase-edge-functions.md)
- [14-ssrf-outbound](14-ssrf-outbound.md)
- [07-route-handlers-api](07-route-handlers-api.md)
