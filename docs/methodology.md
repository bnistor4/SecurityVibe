# Methodology

## Purpose

SecurityVibe supports:

- Security review
- Code review (security-focused)
- Configuration review
- Hardening
- Authorized penetration testing

**Expected output per finding:** file references, line numbers, evidence, impact, fix, and regression test.

## Defensive scope

This toolkit is intentionally **defensive**:

| Included | Excluded |
|----------|----------|
| Bug classes and misconfiguration patterns | Weaponized payloads |
| Detection commands and SQL queries | Operational bypass recipes |
| Mitigations and test cases | PoC exploit chains |
| Authorized abuse scenario descriptions | Instructions to attack third parties |

## Evidence rules

1. **No finding without evidence** — code, config, migration, lockfile, header, log, or dashboard setting.
2. **Three-way classification:**
   - **Confirmed bug** — reproducible from repository artifacts
   - **Potential risk** — code smell or pattern that may be exploitable after confirmation
   - **Verification gap** — requires Supabase/Vercel/runtime check; document exactly what to verify
3. **Advisory findings** must state installed version, patched version, and lockfile path.

## Priority order

When time is limited, work in this order:

1. Protect data and secrets
2. Block auth/authz bypass
3. Reduce remote exploitability
4. Reduce blast radius
5. Add regression tests

## Manual vs automated

| Automated (repo scripts) | Manual (dashboard/runtime) |
|--------------------------|----------------------------|
| ripgrep pattern scans | Supabase RLS policy review in dashboard |
| `npm audit` / lockfile | Vercel env separation & Deployment Protection |
| SQL files run on authorized DB | Auth rate limits, storage bucket visibility |
| Static checklist review | E2E cross-user cache tests |

## AI-assisted audits

Agents are accelerators, not auditors of record. Human review is required for:

- Severity assignment
- Production impact
- Dashboard-only controls
- Business context (public vs private data)

See [AGENTS.md](../AGENTS.md).
