# Finding Template

Copy for each confirmed issue, potential risk, or verification gap.

```markdown
### Finding SEC-XXX: [short title]

- **Severity:** Critical / High / Medium / Low
- **Category:** Auth / RLS / Storage / Server Action / Route Handler / Vercel / Supply chain / etc.
- **Status:** Confirmed bug / Potential risk / Verification gap
- **File and lines:**
- **Evidence:**
- **Authorized abuse scenario:**
- **Impact:**
- **Root cause:**
- **Recommended fix:**
- **Regression test:**
- **Owner:**
- **Priority:**
- **Manual/dashboard notes:**
```

## Example

```markdown
### Finding SEC-001: Server-side authorization uses getSession only

- **Severity:** High
- **Category:** Auth
- **Status:** Confirmed bug
- **File and lines:** `lib/auth.ts:42`, `app/dashboard/page.tsx:18`
- **Evidence:** `getSession()` used to gate dashboard data fetch; no `getUser()`/`getClaims()` call
- **Authorized abuse scenario:** Attacker presents tampered session cookie; server trusts unvalidated session object
- **Impact:** Unauthorized access to user-specific data
- **Root cause:** Misunderstanding of Supabase SSR session vs validated JWT
- **Recommended fix:** Replace with `getUser()` or `getClaims()` in server paths; add `requireUser()` helper
- **Regression test:** Request protected page with invalid/expired token → 401/redirect; no data returned
- **Owner:** Backend
- **Priority:** P0
- **Manual/dashboard notes:** N/A
```
