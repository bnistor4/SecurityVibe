# 13 — XSS, CSP, Markdown/MDX & Frontend Injection

## Bug classes to cover

- [ ] `dangerouslySetInnerHTML` without sanitization
- [ ] Markdown/MDX with raw HTML enabled
- [ ] User HTML in email, preview, rich text, comments, profile
- [ ] SVG upload/render inline
- [ ] `next/script` with `beforeInteractive` and untrusted input
- [ ] Missing or overly permissive CSP
- [ ] Nonce reused, predictable, or not per-request
- [ ] `unsafe-inline`/`unsafe-eval` in production without justification
- [ ] Missing `frame-ancestors` on dashboard/admin
- [ ] Overly permissive Referrer-Policy
- [ ] Tailwind class injection from user input
- [ ] Unvalidated URLs in `href`/`src`
- [ ] Tabnabbing on external links
- [ ] Third-party `<script src="...">` without Subresource Integrity (`integrity` + `crossorigin`)
- [ ] Third-party scripts loaded from unpinned / non-versioned CDN URLs
- [ ] `next/script` external URLs without integrity where SRI is supported

## Detection

```bash
rg -n 'dangerouslySetInnerHTML|innerHTML|outerHTML|marked|remark|rehype|mdx|sanitize|DOMPurify|Script|beforeInteractive' app src components
rg -n 'Content-Security-Policy|frame-ancestors|Referrer-Policy|Permissions-Policy|X-Frame-Options|headers\(' next.config.* app src
rg -n 'className=.*\$\{|className=\{|href=\{|src=\{|target="_blank"' app src components
rg -n '<script[^>]+src=|next/script|integrity=|crossorigin' app src components
```

## Mitigations

- Server-side sanitization for allowed HTML
- Prefer Markdown without raw HTML
- Per-request CSP nonce if inline scripts unavoidable
- `frame-ancestors 'none'` or allowlist for admin/dashboard
- URL validation with protocol/host allowlist
- Map user input to static Tailwind classes — never interpolate arbitrary classes
- External links: `rel="noopener noreferrer"`
- Add SRI (`integrity` + `crossorigin="anonymous"`) for third-party scripts where the vendor publishes hashes
- Pin CDN URLs to versioned paths; prefer self-hosting for critical static scripts
- For `next/script`: use `integrity` when loading external scripts; avoid loading untrusted dynamic URLs

## Regression tests

- [ ] Third-party scripts in production HTML include `integrity` where feasible
- [ ] Tampered CDN file fails to load (SRI mismatch) in browser test
- [ ] User-supplied marker renders escaped in admin/dashboard paths

## Related

- [Prompt](../../prompts/10-xss-csp.md)
- [Next.js CSP guide](https://nextjs.org/docs/app/guides/content-security-policy)
