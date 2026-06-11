# Severity and Priority

## Severity levels

| Severity | When to use | Recommended SLA |
|----------|-------------|-----------------|
| **Critical** | RCE, global auth bypass, exposed `service_role`, missing RLS on sensitive data, preview writing to production, secrets in client bundle | Immediate fix or mitigation |
| **High** | IDOR/BOLA, tenant leak, server-side SSRF, unsigned webhooks, mutating Server Action without authz, persistent XSS, permissive credentialed CORS | 24–72 hours |
| **Medium** | Limited cache leak, missing rate limits on abusable endpoints, weak upload validation, env drift, non-critical PII in logs | Current sprint |
| **Low** | Incomplete security headers, DX/test gaps, performance bugs without data impact, non-exposed config issues | Prioritized backlog |

## Practical priority

1. Protect data and secrets
2. Block auth/authz bypass
3. Reduce remote exploitability
4. Reduce blast radius
5. Add regression tests

## Finding status (separate from severity)

| Status | Meaning |
|--------|---------|
| **Confirmed bug** | Evidence in repo or verified in environment |
| **Potential risk** | Pattern warrants investigation |
| **Verification gap** | Cannot conclude from repo; external check documented |

A **Verification gap** can still be **Critical** if the missing check involves production RLS or exposed service keys.

## Example severity mapping

| Issue | Typical severity |
|-------|------------------|
| Vulnerable Next.js middleware bypass advisory, authz only in middleware | Critical / High |
| Server Action allows `role` mass assignment | High |
| Missing `Cache-Control` on user-specific API | Medium |
| Missing `Permissions-Policy` header | Low |
