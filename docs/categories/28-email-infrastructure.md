# 28 — Email Infrastructure (SPF, DKIM, DMARC)

Transactional and auth email (magic link, OTP, password reset, reminders) depends on DNS and provider configuration — not visible from application code alone.

## Bug classes to cover

- [ ] DMARC policy `p=none` on a production domain sending user email
- [ ] Missing or invalid SPF record
- [ ] Missing or invalid DKIM signing
- [ ] SPF `+all` or overly permissive includes
- [ ] DMARC `rua`/`ruf` pointing to placeholder or unmonitored addresses
- [ ] Auth email sent from a domain without aligned SPF/DKIM (spoofing risk)
- [ ] No gradual path to `p=quarantine` → `p=reject`
- [ ] Bounce/complaint handling not configured (reputation + deliverability)
- [ ] Shared sending domain across untrusted tenants (SaaS)
- [ ] Email provider API keys without send-rate limits

## Detection (authorized DNS / dashboard)

```bash
# Replace with your sending domain
dig TXT example.com +short          # SPF
dig TXT _dmarc.example.com +short   # DMARC
dig TXT default._domainkey.example.com +short  # DKIM (provider-specific selector)
```

Dashboard checks:
- Email provider (Resend, SendGrid, Postmark, Supabase Auth SMTP): domain verification status
- Supabase Auth → SMTP / custom domain settings
- Bounce and complaint webhooks configured

## Risk scenarios (defensive)

| Misconfiguration | Impact |
|------------------|--------|
| `p=none` long-term | Phishing using your domain; user trust loss |
| No DKIM | Messages land in spam; easier spoofing |
| Weak SPF | Unauthorized senders can pass partial checks |
| No bounce handling | Continued sends to bad addresses; reputation damage |

## Mitigations

- Verify SPF, DKIM, and DMARC for every domain that sends user email.
- Move DMARC toward enforcement: `none` → `quarantine` → `reject` with monitoring.
- Configure real `rua` reporting and review aggregate reports.
- Use a dedicated transactional subdomain (e.g. `mail.example.com`) where appropriate.
- Align `From` domain with SPF/DKIM signing domain.
- Rate-limit auth email endpoints (see [24-account-takeover](24-account-takeover.md), [15-dos-cost-control](15-dos-cost-control.md)).
- Handle bounces/complaints; stop sending to invalid addresses.

## Regression tests

- [ ] SPF, DKIM, DMARC records present and valid (DNS lookup in CI or manual checklist)
- [ ] Test message passes mailbox provider authentication checks (Gmail/Outlook headers show `spf=pass`, `dkim=pass`)
- [ ] DMARC policy documented with target enforcement date
- [ ] Bounce webhook fires on simulated invalid recipient (staging)

## Related

- [Prompt](../../prompts/25-email-infrastructure.md)
- [18-dashboard-checks](18-dashboard-checks.md)
- [24-account-takeover](24-account-takeover.md)
