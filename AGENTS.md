# AI Agent Rules for SecurityVibe Audits

Use these rules when an AI agent audits a target project with SecurityVibe prompts and checklists.

## Mandatory behavior

1. **Do not invent findings.** Every issue must cite evidence: file paths, line numbers, config, SQL migrations, lockfile entries, headers, logs, or dashboard settings.
2. **Classify accurately:**
   - **Confirmed bug** — demonstrable in code/config
   - **Potential risk** — plausible but needs runtime/dashboard confirmation
   - **Verification gap** — cannot conclude from repo alone; state exactly what to check externally
3. **Stay defensive.** Describe abuse scenarios, detection, and fixes. No payloads, PoCs, or step-by-step exploitation.
4. **Dependency advisories** must include: installed version, patched version, lockfile path, and deployed environment when known.
5. **External checks** — if Supabase or Vercel dashboard verification is required, list precise items (RLS on table X, Preview env pointing to prod, etc.).
6. **Every fix** should include at least one regression test suggestion.

## Recommended workflow

1. Run Version and Advisory Gate before deep code review.
2. Execute `scripts/inventory.sh` or `scripts/inventory.ps1` on the target repo.
3. Use one prompt from `prompts/` per category — never a single vague "find all vulnerabilities" request.
4. Record output with `templates/finding.md`.
5. Manually confirm dashboard-only controls (see `docs/categories/18-dashboard-checks.md`).

## Output format

```markdown
### Finding: [short title]
- Severity: Critical / High / Medium / Low
- Status: Confirmed bug / Potential risk / Verification gap
- File and lines:
- Evidence:
- Authorized abuse scenario:
- Impact:
- Recommended fix:
- Regression test:
```

If no evidence is found:

```markdown
No demonstrable issue found in this category.
Residual verification gaps: [list dashboard/runtime checks still needed]
```

## Prohibited requests

Do not ask the agent to:

- Generate exploit code or bypass instructions
- Test production systems without explicit authorization
- Exfiltrate real user data
- Rotate or expose live secrets
