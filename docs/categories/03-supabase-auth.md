# 03 — Supabase Auth & SSR Session

## Bug classes to cover

- [ ] `getSession()` used server-side to authorize data or pages
- [ ] Middleware/Proxy reads cookies without JWT validation
- [ ] Server Supabase client missing SSR cookie adapter
- [ ] Browser client imported in Server Components or Route Handlers
- [ ] `service_role`, `sb_secret_*`, or legacy service key in user-facing flows
- [ ] OAuth callback without strict redirect URL allowlist
- [ ] Magic link/OTP accepting arbitrary `next`/`redirectTo`
- [ ] Custom login endpoints without rate limiting
- [ ] Anonymous sign-in without quota, cleanup, upgrade flow
- [ ] Password reset revealing whether email exists
- [ ] MFA required only in UI, not server-side for sensitive operations
- [ ] Logout client-only; server cookies/session not cleared
- [ ] Refresh token reuse accepted after rotation (no reuse detection / token family revocation)
- [ ] Access JWT still valid for PostgREST/API for long window after logout (no short TTL or revocation strategy)
- [ ] Weak password policy: short passwords, common passwords, no strength check
- [ ] Login/signup/password-reset without rate limiting or CAPTCHA
- [ ] Session refresh not propagated to Server Components
- [ ] Duplicated auth state across Supabase, custom cookies, local DB
- [ ] OAuth callback linking identity without verifying existing account ownership
- [ ] User metadata used as authorization

## Detection

```bash
rg -n 'getSession\(|getUser\(|getClaims\(|onAuthStateChange|signInWith|signOut|exchangeCodeForSession|resetPassword|updateUser' app src lib
rg -n 'redirectTo|next=|returnTo|callback|oauth|magic|otp|mfa|aal' app src
rg -n 'raw_user_meta_data|user_metadata|app_metadata|auth\.jwt' supabase app src
```

## Evidence to hunt

- `getSession()` in `middleware.ts`, `proxy.ts`, Server Components, Server Actions, Route Handlers
- Protected routes not calling `getUser()`/`getClaims()` or equivalent helper
- Forms/actions mutating data after only `if (!session)`
- Post-login redirect built from unvalidated query strings
- Policies reading `raw_user_meta_data`
- Missing tests for expired token, logout, failed refresh, disabled user

## Mitigations

- Use `@supabase/ssr` with separate browser/server clients
- Server-side: protect pages and data with real token validation (`getClaims()`/`getUser()` per SDK version)
- Never authorize based on spoofable/readable cookies alone
- Centralize `requireUser()`, `requireTenant()`, `requireRole()` — still verify per-object ownership
- Allowlist post-auth redirects (relative paths or known domains)
- MFA/AAL for sensitive actions: export, email change, password change, admin, billing
- Rate limit login/OTP/email wrappers; CAPTCHA where appropriate
- Complete server-side logout: invalidate and clear cookies on server and browser
- Enable refresh token rotation and reuse detection in Supabase Auth / GoTrue (verify applied in target environment)
- Short access-token TTL where compatible with UX; document acceptable post-logout JWT window for stateless tokens
- Password policy: minimum length (8–12+), block common passwords, optional strength meter
- Rate limit login, signup, OTP, magic link, and recover endpoints per IP/account

## Regression tests

- [ ] Anonymous user on all protected routes
- [ ] User A attempts read/write of User B records
- [ ] Expired or tampered token/cookie
- [ ] OAuth redirect to external destination rejected or normalized
- [ ] Password reset/magic link: no email enumeration
- [ ] Sensitive action fails with insufficient AAL
- [ ] Reused refresh token after rotation returns error (ideally revokes token family)
- [ ] Weak passwords (`123456`, `password`, etc.) rejected at signup
- [ ] Repeated failed logins trigger 429, backoff, or CAPTCHA (staging, limited attempts)

## Related

- [Prompt](../../prompts/02-supabase-auth-ssr.md)
- [Supabase SSR docs](https://supabase.com/docs/guides/auth/server-side/nextjs)
