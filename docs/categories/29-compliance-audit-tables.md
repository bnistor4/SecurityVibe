# 29 — Compliance & Audit Tables (Append-only)

Tables for consents, audit logs, billing events, and legal records must be **append-only**. Mutable or deletable audit data undermines GDPR, SOC2, and incident forensics.

## Bug classes to cover

- [ ] Consent records (`user_consents`, `cookie_consents`, etc.) allow `UPDATE` or `DELETE` by end users
- [ ] Audit fields (`accepted_at`, `ip_address_hash`, `policy_version`, `user_agent`) writable after insert
- [ ] Consent revocation implemented as destructive delete instead of new append event
- [ ] No unique constraint → duplicate consent rows via race (same user/type/version)
- [ ] Compliance table without RLS or with `USING (true)` on mutations
- [ ] Audit log table readable by normal users
- [ ] `user_id` on consent/audit row settable from client instead of `auth.uid()`
- [ ] Soft-delete on audit tables without immutability trigger
- [ ] Export/deletion (GDPR erasure) removes audit trail instead of anonymizing

## Detection

```bash
rg -n 'user_consents|cookie_consent|audit_log|consent_type|policy_version|accepted_at|is_accepted' supabase migrations app src
rg -n 'enable row level security|create policy|update policy|delete policy' supabase migrations db sql
```

```sql
-- Tables that allow UPDATE/DELETE to authenticated (review each)
SELECT schemaname, tablename, policyname, cmd
FROM pg_policies
WHERE schemaname = 'public'
  AND cmd IN ('UPDATE', 'DELETE')
  AND tablename ~ '(consent|audit|log|event)'
ORDER BY tablename, cmd;

-- Missing unique constraints on consent-like tables (manual review)
SELECT conname, conrelid::regclass, pg_get_constraintdef(oid)
FROM pg_constraint
WHERE contype = 'u'
  AND conrelid::regclass::text ~ 'consent';
```

## Design patterns

### Append-only consent

| Action | Correct pattern |
|--------|-----------------|
| User accepts policy | `INSERT` new row with `is_accepted=true`, version, timestamp |
| User revokes consent | `INSERT` new row with `is_accepted=false` or `event_type=revoked` |
| Admin correction | Separate admin audit table; never mutate user-facing consent row |

### RLS baseline

- `SELECT`: user sees own rows only (`auth.uid() = user_id`)
- `INSERT`: user can insert own consent events only; `user_id` from `auth.uid()`, not client
- `UPDATE` / `DELETE`: **denied** for `authenticated` and `anon`

### Race / idempotency

- Unique constraint on `(user_id, consent_type, policy_version)` for acceptance events, **or**
- Idempotency key / `ON CONFLICT DO NOTHING` for concurrent inserts

### Immutability trigger (conceptual)

```sql
-- Pattern: reject UPDATE/DELETE on audit columns (adapt to your schema)
CREATE OR REPLACE FUNCTION prevent_audit_mutation()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  RAISE EXCEPTION 'audit records are immutable';
END;
$$;
```

## Regression tests

- [ ] `PATCH` on consent audit fields fails (RLS or trigger)
- [ ] `DELETE` on consent record fails
- [ ] Concurrent identical consent inserts produce at most one logical acceptance (unique or idempotent)
- [ ] `user_id` cannot be set to another user's UUID from client
- [ ] Revocation creates new event; original acceptance row unchanged

## Related

- [Prompt](../../prompts/26-compliance-audit-tables.md)
- [04-rls-multi-tenant](04-rls-multi-tenant.md)
- [25-postgres-extensions](25-postgres-extensions.md)
- [27-business-logic-idor](27-business-logic-idor.md)
