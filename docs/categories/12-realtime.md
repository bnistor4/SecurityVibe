# 12 — Realtime, Presence & Broadcast

## Bug classes to cover

- [ ] Subscription without cleanup
- [ ] Over-broad filters
- [ ] Channels built from unvalidated tenant/user input
- [ ] Broadcast payload contains PII or raw records
- [ ] Presence used for sensitive data
- [ ] Reconnection loop without backoff
- [ ] Duplicate subscriptions from render/effect
- [ ] Auth changed but old subscription remains
- [ ] Missing rate limit on custom broadcast/presence
- [ ] Realtime where polling/cache would suffice

## Detection

```bash
rg -n 'channel\(|subscribe\(|removeChannel|unsubscribe|presence|broadcast|postgres_changes|REALTIME' app src
```

## Mitigations

- Cleanup in `useEffect` return
- Deterministic tenant-scoped channel naming
- Minimal payloads
- Clean re-auth/re-subscribe on session change
- Specific filters per tenant/record
- Quota and rate limit for user-exposed broadcast
- Test User A/B and account switch in same browser

## Related

- [Prompt](../../prompts/13-realtime.md)
