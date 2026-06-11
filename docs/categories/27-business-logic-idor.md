# 27 — Business Logic, IDOR & Authorization Depth

The most common high-severity findings in real apps are not memory bugs — they are authorization and business-logic flaws. Scanners miss these; they require reasoning about intent.

## Bug classes to cover

### Object-level authorization (IDOR / BOLA)
- [ ] Resource fetched/mutated by `id` without owner/tenant check
- [ ] Sequential/guessable IDs enabling enumeration
- [ ] Authorization checks the user, not the user-vs-object relationship
- [ ] Nested resources (`/orgs/:o/projects/:p`) checking only the parent
- [ ] Authorization on read but not on write (or vice versa)

### Function-level authorization (BFLA)
- [ ] Admin/privileged action callable by normal users (no role check server-side)
- [ ] Role/permission read from client-controlled value or JWT `user_metadata`
- [ ] Feature gated only in UI

### Workflow & state
- [ ] State transitions not validated (skip payment, skip approval, reopen closed records)
- [ ] Negative/oversized quantities, price/amount tampering
- [ ] Race conditions / TOCTOU (double-spend, coupon reuse, concurrent limit bypass)
- [ ] Idempotency missing on payment/order/credit operations
- [ ] Rate/quantity limits enforced client-side only

### Economic & abuse logic
- [ ] Coupon/referral/credit logic abusable for value extraction
- [ ] Free-tier limits bypassable by re-registration or parallel requests
- [ ] Replay of signed requests/webhooks granting repeated effects

### Mass assignment (cross-link)
- [ ] Client can set `role`, `owner_id`, `tenant_id`, `status`, `price`, `is_admin` (see [06-server-actions](06-server-actions.md))

## Detection

This class is reasoning-driven; patterns are starting points only.

```bash
rg -n 'params\.id|searchParams|\.eq\(.id|findUnique|findFirst|\.single\(\)|byId|where:\s*\{\s*id' app src lib
rg -n 'role|isAdmin|is_admin|permission|can[A-Z]|authorize|ability|policy' app src lib
rg -n 'status|state|transition|approve|confirm|cancel|refund|price|amount|quantity|balance|credit|coupon' app src lib
rg -n 'idempot|Promise\.all|transaction|for update|lock|select.*for update' app src lib supabase
```

## Mitigations

- Authorize the **relationship**: verify the authenticated subject may act on *this* object in *this* way.
- Centralize an authorization layer (policy/ability), enforced in the DAL — not just UI/middleware.
- Validate every state transition against an explicit allowed-transition map.
- Server-side validation of amounts, quantities, and limits.
- Use DB constraints + transactions + row locks for invariants (balances, stock, unique redemption).
- Idempotency keys for money/credit/order operations; unique constraints to prevent replay.
- Derive roles from server-trusted claims (`app_metadata`), never `user_metadata` or request body.
- Prefer non-enumerable IDs (UU/ULID) but never rely on them as the only control.

## Regression tests

- [ ] User A cannot read/update/delete User B's object by ID
- [ ] Normal user cannot invoke admin function server-side
- [ ] Invalid state transition is rejected
- [ ] Tampered price/quantity is rejected server-side
- [ ] Concurrent requests cannot double-spend / exceed a limit
- [ ] Replayed signed request/webhook applies effect only once

## Related

- [Prompt](../../prompts/24-business-logic-idor.md)
- [06-server-actions](06-server-actions.md)
- [07-route-handlers-api](07-route-handlers-api.md)
- [04-rls-multi-tenant](04-rls-multi-tenant.md)
