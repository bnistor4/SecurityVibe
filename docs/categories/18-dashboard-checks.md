# 18 — Dashboard Checks (Not Verifiable from Repo Alone)

## Supabase

- [ ] RLS enabled on every exposed table
- [ ] Policies for `public` schema and `storage.objects`
- [ ] Auth rate limits; IP forwarding if backend concentrates IPs
- [ ] MFA settings per business requirements
- [ ] Storage bucket public/private settings and policies
- [ ] API keys: publishable vs secret/legacy anon/service_role separation
- [ ] Logs: auth failures, RLS denials, storage denied, unusual service_role usage
- [ ] Backup/PITR and restore test

## Vercel

- [ ] Environment variables: Production / Preview / Development
- [ ] Sensitive env for tokens/secrets
- [ ] Deployment Protection on preview/generated URLs
- [ ] Correct production branch
- [ ] Activity Log for env/domains/deploy hooks
- [ ] Old deployments still accessible?
- [ ] Cron configuration
- [ ] Function duration/concurrency/runtime
- [ ] Build logs and source maps

## External providers

- [ ] Stripe/webhook signing secrets and idempotency
- [ ] Email: domain auth, rate, unsubscribe, bounce handling
- [ ] Analytics: consent, PII redaction
- [ ] Error monitoring: token redaction, source map access
- [ ] GitHub: branch protection, Actions permissions, Dependabot/SCA

## How to document gaps

For each unchecked item, create a **Verification gap** finding:

```markdown
### Finding: Preview Supabase connection not verified from repo
- Severity: Critical (if preview may write to prod)
- Status: Verification gap
- Evidence: Cannot determine from git; requires Vercel Preview env inspection
- Manual check: Vercel → Project → Settings → Environment Variables → Preview → `SUPABASE_URL` / keys
- Impact: Preview PR could mutate production data
```
