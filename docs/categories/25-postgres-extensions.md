# 25 — Postgres Extensions, RPC & pg_graphql

Supabase exposes powerful Postgres extensions. Misuse turns the database into an attack surface beyond table RLS.

## Areas & bug classes

### `pg_graphql` (GraphQL API)
- [ ] GraphQL endpoint exposing tables/relationships that bypass intended access paths
- [ ] Relationship traversal leaking cross-tenant rows (RLS is the only guard — verify it holds)
- [ ] Introspection revealing internal schema not meant to be public
- [ ] No depth/complexity limits → query-cost DoS

### `pg_net` / `http` (outbound from DB)
- [ ] Database making outbound HTTP to user-controlled URLs (SSRF from inside Postgres)
- [ ] Triggers calling `net.http_post` with secrets to untrusted hosts
- [ ] No allowlist/timeouts on DB-initiated requests

### `pg_cron` / `pg_net` scheduled jobs
- [ ] Cron jobs running as superuser/elevated role
- [ ] Job definitions containing secrets in plaintext
- [ ] Jobs not idempotent; overlapping runs
- [ ] Schedule modifiable by insufficiently privileged roles

### `pgvector` / RAG
- [ ] Vector similarity search not filtered by tenant/user (cross-tenant retrieval)
- [ ] Document/embedding rows without RLS
- [ ] Metadata enabling enumeration of other tenants' documents

### RPC / `SECURITY DEFINER` functions
- [ ] RPC accepts `p_user_id` / `p_tenant_id` from client instead of `auth.uid()` / JWT claims
- [ ] Upsert conflict target wrong — e.g. unique on `query_normalized` only, not `(user_id, query_normalized)` → cross-user overwrite
- [ ] `SECURITY DEFINER` function with broad `EXECUTE` grant to `anon`/`authenticated`
- [ ] Dynamic SQL built from unvalidated input (SQL injection inside function)
- [ ] `search_path` not pinned in `SECURITY DEFINER` (function hijack via shadowing)
- [ ] Function returning more rows/columns than the caller is authorized to see
- [ ] Privilege escalation: function performs admin action callable by normal users

### Extensions hygiene
- [ ] Extensions installed in `public` schema increasing attack surface
- [ ] Unused/risky extensions enabled
- [ ] Custom roles with `BYPASSRLS` or `SUPERUSER`

## Detection

```bash
rg -n 'security definer|create function|create or replace function|execute |grant execute|search_path|p_user_id|p_tenant_id|auth\.uid\(\)' supabase migrations db sql
rg -n 'on conflict|unique \(|upsert' supabase migrations db sql
rg -n 'pg_cron|cron\.schedule|pg_net|net\.http_(get|post)|http_post|pg_graphql|graphql\.|vector|embedding|<->|<=>' supabase migrations db sql
```

```sql
-- SECURITY DEFINER functions and their search_path
SELECT n.nspname AS schema, p.proname, p.prosecdef,
       pg_get_function_identity_arguments(p.oid) AS args,
       p.proconfig AS settings
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE p.prosecdef = true
ORDER BY 1, 2;

-- Grants to anon/authenticated on functions
SELECT routine_schema, routine_name, grantee, privilege_type
FROM information_schema.routine_privileges
WHERE grantee IN ('anon', 'authenticated')
ORDER BY routine_schema, routine_name;
```

## Mitigations

- Derive `user_id`/`tenant_id` from `auth.uid()` inside RPC — never trust `p_user_id` / `p_tenant_id` from the client.
- Upsert `ON CONFLICT` targets must include user/tenant scope (e.g. `(user_id, query_normalized)`), not a global natural key alone.
- For `SECURITY DEFINER`: pin `SET search_path = ''` (fully-qualified names), minimal grants, validated input, no dynamic SQL from user input.
- Verify RLS is enforced for every table reachable via `pg_graphql` and `pgvector` search.
- Tenant-filter vector search at query time; enable RLS on embedding tables.
- Restrict DB outbound (`pg_net`/`http`): allowlist hosts, timeouts, no secrets to untrusted targets.
- Run `pg_cron` jobs with least privilege; keep secrets in Vault, not job SQL; make jobs idempotent.
- Install extensions in a dedicated schema; remove unused ones.
- Audit roles for `BYPASSRLS`/`SUPERUSER`.

## Regression tests

- [ ] GraphQL query as tenant A cannot traverse to tenant B rows
- [ ] `SECURITY DEFINER` RPC rejects unauthorized caller and invalid input
- [ ] User A cannot overwrite User B's row via RPC upsert on shared normalized key
- [ ] RPC ignores client-supplied `p_user_id`; uses `auth.uid()` only
- [ ] Vector search returns only caller-scoped documents
- [ ] DB outbound request to disallowed host fails

## Related

- [Prompt](../../prompts/22-postgres-extensions.md)
- [04-rls-multi-tenant](04-rls-multi-tenant.md)
- [17-ai-llm](17-ai-llm.md)
