# Prompt: Compliance & Audit Tables

```text
[Use Master Prompt from master-prompt.md]
CATEGORY: Compliance and append-only audit tables.

Find consent/audit/log tables that allow UPDATE or DELETE by users, writable audit fields after insert, client-settable user_id, missing unique constraints on consents (race duplicates), and destructive revocation instead of append-only events.
Review RLS policies and migrations for user_consents and similar tables.
```
