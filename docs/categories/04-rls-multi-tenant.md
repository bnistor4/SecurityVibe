# 04 — RLS, Postgres & Multi-tenant Isolation

## Bug classes to cover

- [ ] RLS disabled on tables in exposed schema
- [ ] `USING (true)` policies on non-public data
- [ ] Missing `WITH CHECK` on `INSERT`/`UPDATE`
- [ ] `UPDATE` with `USING` but no `WITH CHECK` — owner/tenant swappable
- [ ] Nullable `user_id`, `tenant_id`, `org_id` where required
- [ ] Records inserted with client-supplied `user_id`/`tenant_id`
- [ ] Join tables without own policies
- [ ] Views/materialized views exposing cross-tenant aggregates
- [ ] `SECURITY DEFINER` RPC with overly broad grants
- [ ] SQL functions using unvalidated input in dynamic SQL
- [ ] Postgres roles with `BYPASSRLS`
- [ ] `service_role` in user flows instead of admin/system only
- [ ] `auth.jwt()` based on stale or user-modifiable claims
- [ ] Expensive policies without indexes on filtered columns
- [ ] Policies with subqueries causing full table scans
- [ ] Missing `TO authenticated`/`TO anon` — wrong role scope
- [ ] `anon` allowed `insert/update/delete` without documented reason
- [ ] Soft delete not enforced in policies
- [ ] Audit/log tables readable by normal users
- [ ] Migrations enable RLS locally but not production

## SQL audit queries

Run on **authorized** database — see [sql/rls-audit.sql](../../sql/rls-audit.sql).

## Repo detection

```bash
rg -n 'enable row level security|disable row level security|create policy|alter policy|drop policy|security definer|bypassrls|grant |revoke ' supabase migrations db sql
rg -n 'user_id|tenant_id|org_id|workspace_id|owner_id|auth\.uid|auth\.jwt|WITH CHECK|USING' supabase migrations db sql
```

## Critical signals

- New table migration without `ALTER TABLE ... ENABLE ROW LEVEL SECURITY`
- `WITH CHECK (true)` on tenant-specific insert/update
- Delete policy only checking `auth.role() = 'authenticated'`
- Admin RPC callable from authenticated client
- `auth.jwt()->'user_metadata'` or `raw_user_meta_data` as authz criterion
- Missing indexes on `tenant_id`, `user_id`, `owner_id` used in policies

## Mitigations

- RLS on every Supabase API-accessible table
- Separate policies for `SELECT`, `INSERT`, `UPDATE`, `DELETE`
- `WITH CHECK` on all mutations to prevent owner/tenant swap
- Assign owner/tenant server-side, never from client
- DB constraints: `NOT NULL`, FK, tenant-scoped unique composites
- Use `raw_app_meta_data` only for authz claims (JWT may be stale)
- Minimal RPC grants and input schemas
- Automated RLS tests: users A/B, tenants A/B, anon, admin
- Indexes on policy filter columns

## Minimum RLS test matrix

| Identity | Must pass | Must fail |
|----------|-----------|-----------|
| anon | Public data only | Private data; non-public mutations |
| user A | Own records | User B records |
| tenant A member | Tenant A records | Tenant B records |
| tenant A admin | Tenant A admin ops | Tenant B / global admin |
| service/admin server | Authorized system jobs | Browser/user-facing flows |

## Related

- [Prompt](../../prompts/03-rls-multi-tenant.md)
- [Supabase RLS](https://supabase.com/docs/guides/database/postgres/row-level-security)
