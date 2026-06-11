# 11 — Vercel Deployment, Preview, Env & Runtime

## Bug classes to cover

- [ ] Preview deployment connected to production Supabase with write access
- [ ] Public preview URLs without Deployment Protection
- [ ] Generated production URLs accessible when only custom domain expected
- [ ] Preview env identical to Production
- [ ] Missing branch-specific env for staging
- [ ] Secrets not marked sensitive
- [ ] Env changed but old deployments still active with old values
- [ ] Build logs printing env or tokens
- [ ] `NEXT_PUBLIC_` used for sensitive values
- [ ] Edge Runtime for libraries requiring Node
- [ ] Edge env too large or unavailable as expected
- [ ] Cron without secret
- [ ] Rollback to deployment with incompatible schema/env
- [ ] Wrong production branch
- [ ] Exposed or unrotated deploy hook
- [ ] Domain redirect/rewrites inconsistent with auth/cookie domain

## Detection

```bash
rg -n 'NEXT_PUBLIC_|process\.env|VERCEL_|SUPABASE_|SECRET|TOKEN|PASSWORD|API_KEY' app src lib next.config.* vercel.json .env.example
rg -n 'runtime|edge|nodejs|maxDuration|regions|crons|rewrites|redirects|headers' app src next.config.* vercel.json
```

## Vercel dashboard checklist

- [ ] Production, Preview, Development env separated
- [ ] Preview env points to Supabase staging/branch — not production
- [ ] Deployment Protection (Standard+) on preview/generated URLs
- [ ] Sensitive env enabled for tokens/secrets in Production/Preview
- [ ] No secrets in build logs
- [ ] Old deployments with compromised env removed or invalidated
- [ ] Activity log reviewed for env/domain/deploy hook changes
- [ ] Cron routes protected
- [ ] Rollback tested with migration compatibility

## Mitigations

- Separate Supabase project for preview/staging, or read-only creds where possible
- Branch-specific env for PR/staging
- Mark sensitive for tokens/secrets in Vercel
- Rotate secrets after exposure or doubt
- Deployment Protection on preview — not a substitute for app auth
- `nodejs` runtime for SDKs needing Node APIs; Edge only when compatible

## Related

- [Prompt](../../prompts/12-vercel-env-preview.md)
- [18-dashboard-checks](18-dashboard-checks.md)
