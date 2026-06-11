# 14 — SSRF, URL Handling & Outbound Requests

## Bug classes to cover

- [ ] `fetch(url)` with URL from query/body/form
- [ ] Webhook tester/importer downloading user URLs
- [ ] Image/proxy endpoint fetching arbitrary resources
- [ ] AI/tool feature navigating/downloading user links
- [ ] Automatic redirect following to unintended hosts
- [ ] String-prefix allowlist instead of URL parsing
- [ ] Host header used to build server-side URLs
- [ ] Internal IP/local network not blocked (self-hosted)
- [ ] Missing timeouts
- [ ] Internal response logged or returned to client

## Detection

```bash
rg -n 'fetch\(|axios|got|undici|new URL|URL\.canParse|redirect\(|headers\(\)\.get\(.host|x-forwarded-host|webhook|import.*url|crawl|scrape' app src lib
```

## Mitigations

- Allowlist exact protocol and hostname
- No arbitrary user URLs for server-side requests
- Block private IP/link-local/localhost on self-hosted external URL features
- Short timeouts, max response size, controlled redirects
- Never attach internal tokens to untrusted hosts
- Log redacted metadata only

## Related

- [Prompt](../../prompts/11-ssrf-outbound.md)
