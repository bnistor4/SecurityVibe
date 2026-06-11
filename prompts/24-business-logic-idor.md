# Prompt: Business Logic, IDOR & Authorization Depth

```text
[Use Master Prompt from master-prompt.md]
CATEGORY: Business logic, IDOR/BOLA, and authorization depth.

Reason about intent, not just patterns. Find object-level authz gaps (resource by id without owner/tenant check), function-level authz gaps (admin actions callable by users), invalid state transitions, price/quantity tampering, race conditions/TOCTOU, missing idempotency on money operations, abusable coupon/credit/referral logic, and roles read from client/user_metadata.
For each, give the authorized abuse scenario and a regression test.
```
