# 21 — Secrets, Keys & Token Management

Secret exposure is the highest-impact, lowest-effort class of incident. Treat every key boundary explicitly.

## Bug classes to cover

- [ ] `service_role` / `sb_secret_*` key referenced in client-reachable code
- [ ] Secret behind `NEXT_PUBLIC_` (anything `NEXT_PUBLIC_` ships to the browser bundle)
- [ ] Secrets committed in `.env`, `.env.local`, `.env.production`, or history
- [ ] Secrets in `next.config.*` `env`/`publicRuntimeConfig`
- [ ] Hardcoded API keys, JWT signing secrets, DB URLs in source
- [ ] Secrets logged (request bodies, headers, error objects, `console.log(process.env)`)
- [ ] Secrets in client-readable error responses
- [ ] Provider keys (Stripe, OpenAI, Resend) used client-side
- [ ] Long-lived tokens where short-lived/rotating tokens are possible
- [ ] No rotation process after contributor offboarding or exposure
- [ ] Secrets in build artifacts / source maps shipped to production
- [ ] Same secret reused across Production / Preview / Development
- [ ] Secrets passed as build args visible in build logs
- [ ] `.npmrc`/`.yarnrc` tokens committed
- [ ] Supabase publishable vs secret key confusion

## Detection

```bash
rg -n 'service_role|sb_secret|SUPABASE_SERVICE_ROLE|JWT_SECRET|SIGNING_SECRET|PRIVATE_KEY|BEGIN (RSA|EC|OPENSSH|PRIVATE)' app src lib supabase .
rg -n 'NEXT_PUBLIC_.*(SECRET|TOKEN|KEY|PASSWORD|SERVICE)' .
rg -n 'console\.(log|error|warn)\(.*(process\.env|token|secret|key|password)' app src lib
rg -n 'sk_live_|sk_test_|rk_live_|xoxb-|AKIA[0-9A-Z]{16}|ghp_|github_pat_' .
rg -n 'publicRuntimeConfig|serverRuntimeConfig|env:\s*\{' next.config.*
```

> Also scan git history (e.g. `gitleaks detect`, `trufflehog`) — current HEAD is not enough.

## Key boundary model

| Key | May live in | Must NEVER be in |
|-----|-------------|------------------|
| Supabase publishable/anon | Browser, client bundle | — (still RLS-gated) |
| Supabase `service_role`/secret | Server-only, sensitive env | Client, logs, preview shared with prod |
| Provider API keys | Server-only env | `NEXT_PUBLIC_`, client, build logs |
| JWT signing secret | Server runtime | Repo, client, logs |

## Mitigations

- Server-only secrets via Vercel **Sensitive** env; mark all tokens sensitive.
- Distinct secrets per environment (Prod/Preview/Dev).
- Never prefix secrets with `NEXT_PUBLIC_`.
- Add `server-only` import guard to modules touching secrets.
- Redact logs: never log full env, raw headers, or token values.
- Secret scanning in CI + pre-commit (gitleaks/trufflehog) and on full history.
- Documented rotation runbook; rotate on exposure or offboarding.
- Disable production browser source maps unless protected.

## Regression tests

- [ ] CI fails if a known secret pattern is committed
- [ ] Client bundle grep for secret patterns returns nothing
- [ ] `service_role` only imported in server-only DAL modules
- [ ] Error responses contain no secret/provider detail

## Related

- [Prompt](../../prompts/18-secrets-management.md)
- [16-supply-chain](16-supply-chain.md)
- [11-vercel-deployment](11-vercel-deployment.md)
