# 30 — PostgREST / API Schema & Error Disclosure

Supabase exposes Postgres via PostgREST. Error responses and OpenAPI schema can leak table names, column names, RPC signatures, and migration hints to unauthenticated callers.

## Bug classes to cover

- [ ] Requests to non-existent tables return `hint` suggesting similar table names
- [ ] RPC errors expose function signatures or parameter names
- [ ] Broken/legacy RPC endpoints still callable and returning verbose errors
- [ ] OpenAPI schema (`/rest/v1/`) exposes internal tables not meant for public clients
- [ ] Column-level errors reveal schema (`column "foo" does not exist` with suggestions)
- [ ] Stack traces or SQL fragments in API error bodies
- [ ] GraphQL introspection enabled in production without need
- [ ] Exposed views revealing cross-tenant aggregates
- [ ] `pg_catalog` or system metadata reachable via API

## Detection

```bash
# In authorized staging only — do not probe production aggressively
curl -s "$SB_URL/rest/v1/non_existing_table_probe" -H "apikey: $ANON_KEY"
curl -s "$SB_URL/rest/v1/rpc/non_existing_function_probe" -X POST \
  -H "apikey: $ANON_KEY" -H "Content-Type: application/json" -d '{}'
```

Repo-side:

```bash
rg -n 'create view|grant select|expose|openapi|graphql' supabase migrations db sql
rg -n 'error\.message|error\.hint|JSON\.stringify\(error|PostgrestError' app src lib
```

## What to look for in responses

| Signal | Risk |
|--------|------|
| `"hint": "Perhaps you meant the table 'internal_admin_logs'"` | Schema enumeration |
| Function signature in error text | RPC surface mapping |
| Column name suggestions | Schema mapping |
| Full SQL in error | High — internal query leak |

## Mitigations

- Remove or revoke grants on tables/RPC not needed by the client.
- Drop or restrict legacy/broken RPC functions.
- Ensure RLS is enabled — errors should not substitute for access control.
- Application layer: map PostgREST errors to generic client messages; log details server-side only.
- Disable GraphQL introspection in production if `pg_graphql` is enabled.
- Review exposed views; prefer server-only DAL for sensitive reads.
- Monitor for scanning patterns (repeated 404/hint responses).

## Regression tests

- [ ] Request to non-existent table returns generic error without table name hints (or minimal disclosure acceptable per policy)
- [ ] Request to non-existent RPC returns generic error without signature leak
- [ ] Client-facing error handler never forwards `hint` or raw PostgREST body
- [ ] Internal tables not listed in client-accessible schema

## Related

- [Prompt](../../prompts/27-postgrest-info-disclosure.md)
- [07-route-handlers-api](07-route-handlers-api.md)
- [25-postgres-extensions](25-postgres-extensions.md)
- [23-logging-monitoring](23-logging-monitoring.md)
