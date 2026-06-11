# 16 — Supply Chain, Build & Secrets

## Bug classes to cover

- [ ] Missing lockfile or not enforced in CI
- [ ] Dependency updates without review
- [ ] Suspicious `postinstall`, `prepare`, `preinstall`
- [ ] Typosquatting or unpinned scopes
- [ ] Build script printing env
- [ ] Committed `.npmrc` with token
- [ ] `vercel env pull` creating committable `.env`
- [ ] Production sourcemaps with secrets or internal code
- [ ] GitHub Actions/Vercel integration with excessive permissions
- [ ] Missing Dependabot/SCA
- [ ] Package manager mismatch local vs CI
- [ ] Unreviewed shadcn/copied components
- [ ] Dev dependencies with build env access

## Detection

```bash
rg -n 'preinstall|postinstall|prepare|curl |wget |Invoke-WebRequest|eval|node -e|process\.env|npmrc|NPM_TOKEN|VERCEL_TOKEN|SENTRY_AUTH_TOKEN' package.json .github .npmrc .
rg -n 'sourceMap|productionBrowserSourceMaps|sourcemap|env pull|dotenv|\.env' .
npm audit --omit=dev
```

## Mitigations

- Mandatory lockfile; frozen install in CI
- Review lifecycle scripts
- SCA in CI: npm audit/OSV/Dependabot/Snyk
- Secret scanning on repo and history
- Minimal GitHub Actions permissions
- Rotate tokens appearing in logs or non-sensitive env
- Disable or protect browser sourcemaps in production

## Related

- [Prompt](../../prompts/15-supply-chain.md)
