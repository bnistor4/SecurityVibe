# Retest Playbook Template

Generic template for verifying that a **confirmed finding** has been remediated. Copy per issue after an initial audit (SecurityVibe finding ID or external report ID).

> **Scope:** authorized environments only (staging/local). Use synthetic test accounts. No real user data. No weaponized payloads.

---

## 0. Retest setup

### Environment variables (do not commit real values)

```bash
export APP_URL="https://staging.example.com"
export SB_URL="https://<project-ref>.supabase.co"
export ANON_KEY="<publishable-key>"
export AUTH_TOKEN_A="<jwt-user-a>"
export AUTH_TOKEN_B="<jwt-user-b>"
export USER_ID_A="<uuid-user-a>"
export USER_ID_B="<uuid-user-b>"
```

### Test accounts

- `user_a@example.test`
- `user_b@example.test`
- Optional admin (staging only)

### Retest rules

- Limit rate-limit tests to a few attempts on staging.
- Use innocuous markers for injection tests (e.g. `SV_RETEST_MARKER_<timestamp>`), not exfiltration payloads.
- Record: request summary, response status/body (redacted), timestamp, deploy/commit, tester.
- Clean up test data after each case.

---

## 1. Priority matrix (fill per engagement)

| Retest ID | Linked finding | Severity | Priority | Category |
|-----------|----------------|----------|----------|----------|
| RT-001 | SEC-XXX | High | P0 | Auth / RLS / … |

---

## 2. Per-issue retest procedure

For each finding, document:

### RT-XXX — [Short title]

**Objective:** What behavior must no longer be possible?

**Preconditions:**
- Accounts / data required
- Feature flags / deploy version

**Controlled test steps:**
1. …
2. …
3. …

**Vulnerable if:**
- …

**Expected after fix:**
- …

**Remediation hints:** (link to SecurityVibe category doc)

**Evidence to save:**
- Request/response (secrets redacted)
- Screenshot or log excerpt
- DB state before/after (synthetic data only)

---

## 3. Common retest patterns (defensive)

Map your finding to a pattern — adapt steps to your schema.

| Pattern | SecurityVibe doc | What to verify |
|---------|------------------|----------------|
| Cross-user RPC/RLS | [04-rls](../docs/categories/04-rls-multi-tenant.md), [25-postgres](../docs/categories/25-postgres-extensions.md) | User A cannot modify User B's rows via RPC or REST |
| Mass assignment | [06-server-actions](../docs/categories/06-server-actions.md), [27-business-logic](../docs/categories/27-business-logic-idor.md) | Client cannot set `role`, `email`, `tenant_id`, etc. |
| Consent tampering | [29-compliance](../docs/categories/29-compliance-audit-tables.md) | PATCH/DELETE on consent rows fails |
| Refresh token reuse | [03-auth](../docs/categories/03-supabase-auth.md) | Old refresh token rejected after rotation |
| JWT after logout | [03-auth](../docs/categories/03-supabase-auth.md) | Document acceptable window; sensitive ops require short TTL or revocation |
| User enumeration | [24-account-takeover](../docs/categories/24-account-takeover.md) | Signup/reset responses indistinguishable |
| XSS marker | [13-xss-csp](../docs/categories/13-xss-csp.md) | Marker stored escaped; no script execution in admin/UI |
| Storage listing | [05-storage](../docs/categories/05-storage-upload.md) | Anon cannot list private buckets |
| PostgREST hints | [30-postgrest](../docs/categories/30-postgrest-info-disclosure.md) | Errors do not suggest table/RPC names |
| Email abuse | [15-dos](../docs/categories/15-dos-cost-control.md), [24-account-takeover](../docs/categories/24-account-takeover.md) | Rate limit after threshold |
| DMARC/SPF | [28-email](../docs/categories/28-email-infrastructure.md) | DNS records valid; policy documented |

---

## 4. Result template (copy per issue)

```markdown
## Retest result — RT-XXX / SEC-XXX

- **Date/time:**
- **Environment:** staging / preview / production
- **Commit/deploy:**
- **Tester:**
- **Accounts used:** (synthetic only)
- **Test performed:**
- **Expected result:**
- **Actual result:**
- **Outcome:** PASS / FAIL / PARTIAL / NOT APPLICABLE
- **Evidence:**
  - Request: (redacted)
  - Response: (redacted)
  - Screenshot/log:
- **Remediation notes:**
- **Follow-up:**
```

---

## 5. Closure criteria

A finding may be closed only if:

1. Vulnerable behavior is no longer reproducible in staging.
2. Fix is deployed (or scheduled) to production with tracking.
3. Regression test or equivalent control added where feasible.
4. Logs/evidence do not expose secrets.
5. No significant UX/privacy regression introduced.

---

## 6. Outcome classification

| Label | Meaning |
|-------|---------|
| **Confirmed bug** | Impact reproduced end-to-end |
| **Architectural risk** | Dangerous config; impact not fully demonstrated |
| **False positive / mitigated** | Controls already effective |
| **Verification gap** | Needs dashboard/runtime check — document what to verify |

Align with [AGENTS.md](../AGENTS.md) and [templates/finding.md](../templates/finding.md).
