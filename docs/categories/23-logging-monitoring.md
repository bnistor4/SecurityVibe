# 23 — Logging, Monitoring & Detection

You cannot respond to what you cannot see. Logging gaps turn a contained issue into an undetected breach; over-logging creates a new data-leak surface.

## Bug classes to cover

- [ ] PII/secrets written to logs (emails, tokens, full request bodies, headers)
- [ ] Auth failures, RLS denials, and `service_role` usage not logged or alerted
- [ ] No alerting on 401/403/429 spikes
- [ ] No alerting on error-rate or webhook-failure spikes
- [ ] Error monitoring (Sentry, etc.) capturing request bodies with secrets
- [ ] Source maps uploaded to monitoring without access control
- [ ] Logs world-readable or shared in preview environments
- [ ] No correlation/request IDs for incident tracing
- [ ] Client-side analytics sending PII without consent/redaction
- [ ] Missing audit trail for sensitive actions (role change, export, billing, admin)
- [ ] Logs retained too long (privacy) or too short (forensics)
- [ ] No tamper-evidence on audit logs

## Detection

```bash
rg -n 'console\.(log|info|warn|error)|logger\.|pino|winston|Sentry|captureException|datadog' app src lib
rg -n 'req\.headers|request\.headers|JSON\.stringify\(.*(body|user|req|headers)' app src lib
rg -n 'Sentry\.init|tracesSampleRate|beforeSend|sendDefaultPii|maskAllText' app src
```

## Mitigations

- Redact PII/secrets at the logger boundary (allowlist fields, not denylist).
- Log security events: auth failures, authz denials, signature failures, admin actions.
- Emit structured logs with request/correlation IDs.
- `beforeSend` scrubbing in error monitoring; disable PII capture by default.
- Alert on anomalies: 401/403/429 spikes, error-rate, anomalous `service_role` usage.
- Restrict source map access; gate behind auth or keep server-side.
- Define retention aligned with privacy + forensics needs.
- Append-only / immutable storage for audit-critical events.

## Regression tests

- [ ] Known sensitive fields never appear in emitted log lines (unit test the logger)
- [ ] A simulated auth failure produces a security log event
- [ ] Error monitor payload contains no tokens/PII (`beforeSend` test)
- [ ] Sensitive action writes an audit record

## Related

- [Prompt](../../prompts/20-logging-monitoring.md)
- [21-secrets-management](21-secrets-management.md)
- [18-dashboard-checks](18-dashboard-checks.md)
