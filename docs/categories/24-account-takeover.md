# 24 — Account Takeover & Identity Flows

Account takeover (ATO) usually chains small flaws across auth flows rather than a single bug. Audit the full identity lifecycle.

## Bug classes to cover

### Registration & verification
- [ ] Email verification not enforced before privileged actions
- [ ] Account created as verified using unverified email
- [ ] Pre-account-creation: attacker registers victim email, victim later "joins" same record

### Password & reset
- [ ] Reset token predictable, long-lived, or not single-use
- [ ] Reset token not invalidated after use or password change
- [ ] Reset link `host` derived from `Host`/`X-Forwarded-Host` (host header poisoning → token to attacker domain)
- [ ] Password change without current-password / re-auth
- [ ] No session invalidation after password reset
- [ ] User enumeration via reset/login/signup response differences or timing

### OAuth / SSO / identity linking
- [ ] OAuth account linking without verifying ownership of the existing account
- [ ] Linking by email without confirming the email is verified at the provider
- [ ] `state` parameter missing/!unvalidated (login CSRF)
- [ ] Open redirect via `redirectTo`/`next` after callback
- [ ] Mixing providers that share an email → identity collision

### Sessions & MFA
- [ ] Session not rotated on privilege change / login
- [ ] Logout does not revoke server session / refresh token
- [ ] MFA enforced in UI only, not for sensitive server actions (AAL)
- [ ] MFA enrollment bypass or recovery codes weakly protected
- [ ] Long absolute session lifetime without re-auth for sensitive ops
- [ ] Email change without confirming both old and new addresses

### Invitations & multi-tenant
- [ ] Invite token not scoped to email; anyone with the link joins
- [ ] Invite grants role from client-supplied value
- [ ] Re-used / non-expiring invites

## Detection

```bash
rg -n 'resetPassword|updateUser|verifyOtp|exchangeCodeForSession|signInWith|setSession|admin\.(createUser|updateUserById|generateLink)' app src lib
rg -n 'redirectTo|next=|returnTo|state=|Host|x-forwarded-host|origin' app src lib
rg -n 'invite|invitation|token|email_verified|email_confirmed|aal|mfa|factor' app src supabase
```

## Mitigations

- Enforce email verification before privileged actions.
- Reset tokens: high-entropy, single-use, short TTL, invalidated on use/change.
- Build reset/verification URLs from a trusted configured base URL — never from request `Host`.
- Re-authenticate (or require current password) for password/email change and sensitive ops.
- Rotate session and revoke other sessions on password reset/login.
- Validate OAuth `state`; allowlist post-auth redirects.
- Link identities only after verifying ownership of the existing account.
- Generic, constant-ish responses for auth endpoints to limit enumeration.
- Invites scoped to email, expiring, role assigned server-side.
- Enforce MFA/AAL server-side for sensitive Server Actions.

## Regression tests

- [ ] Reset token cannot be reused after password change
- [ ] Reset email link host is fixed regardless of `Host`/`X-Forwarded-Host`
- [ ] OAuth callback rejects missing/invalid `state` and external `redirectTo`
- [ ] Email change requires confirmation on old + new address
- [ ] Sensitive action fails without sufficient AAL
- [ ] Invite cannot be redeemed by a different email or escalate role

## Related

- [Prompt](../../prompts/21-account-takeover.md)
- [03-supabase-auth](03-supabase-auth.md)
- [20-csrf-cors](20-csrf-cors.md)
