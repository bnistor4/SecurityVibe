# Examples

Worked templates for using SecurityVibe after an initial audit.

| File | Purpose |
|------|---------|
| [retest-playbook-template.md](retest-playbook-template.md) | Generic PASS/FAIL retest procedure after remediation |

## App-specific playbooks

Keep project-specific retest playbooks (real table names, RPC names, staging URLs) **outside** this public repo or in a private engagement folder. Use the generic template here and link findings to SecurityVibe category docs.

Example mapping from a real engagement:

| External ID | SecurityVibe category |
|-------------|----------------------|
| Refresh token replay | [03-supabase-auth](../docs/categories/03-supabase-auth.md) |
| Cross-user RPC upsert | [25-postgres-extensions](../docs/categories/25-postgres-extensions.md) |
| Consent tampering | [29-compliance-audit-tables](../docs/categories/29-compliance-audit-tables.md) |
| DMARC `p=none` | [28-email-infrastructure](../docs/categories/28-email-infrastructure.md) |
| PostgREST hints | [30-postgrest-info-disclosure](../docs/categories/30-postgrest-info-disclosure.md) |
