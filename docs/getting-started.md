# Getting Started

Run SecurityVibe against **your own project** or a system you are **explicitly authorized** to test.

## Prerequisites

- [ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`) installed
- Node.js/npm (for `npm ls` and `npm audit` in advisory gate)
- Access to target repository source code
- Optional: Supabase SQL access and Vercel dashboard (for dashboard checks)

## 5-minute first audit

### 1. Advisory gate (mandatory)

Open [categories/01-version-advisory-gate.md](categories/01-version-advisory-gate.md) and reconcile `next`, `react`, `react-dom`, `@supabase/supabase-js`, and `@supabase/ssr` against official advisories.

```bash
cd /path/to/your-project
npm ls next react react-dom @supabase/supabase-js @supabase/ssr
npm audit --omit=dev
```

Stop and patch before continuing if critical advisories apply to your deployed versions.

### 2. Surface inventory

From the SecurityVibe repo root:

```bash
./scripts/inventory.sh /path/to/your-project
```

Review output and classify hits into entry points, auth boundaries, data boundaries, cache boundaries, and secret boundaries (see [categories/02-project-inventory.md](categories/02-project-inventory.md)).

### 3. Category-by-category review

Follow [audit-workflow.md](audit-workflow.md). For each category:

1. Read the category doc
2. Check off items in [checklists/master-audit-checklist.md](../checklists/master-audit-checklist.md)
3. Run category-specific detection patterns
4. Optionally run the matching prompt from [prompts/](../prompts/)
5. Log findings with [templates/finding.md](../templates/finding.md)

### 4. Dashboard verification

Many controls cannot be verified from git alone. Complete [categories/18-dashboard-checks.md](categories/18-dashboard-checks.md) in Supabase and Vercel dashboards.

### 5. Regression tests

Implement tests from [categories/19-regression-test-suite.md](categories/19-regression-test-suite.md) for every confirmed finding.

### 6. Retest after remediation

Use [examples/retest-playbook-template.md](../examples/retest-playbook-template.md) to document PASS/FAIL verification per finding.

## Using with AI coding agents

1. Add SecurityVibe to agent context or clone alongside your project.
2. Read [AGENTS.md](../AGENTS.md).
3. Run **one category prompt at a time** from `prompts/`.
4. Require file/line evidence in every finding.

**Bad prompt:** "Find all security vulnerabilities in my app."

**Good prompt:** Use `prompts/04-rls-multi-tenant.md` and require the output format from `AGENTS.md`.

## Expected deliverables

| Artifact | Template |
|----------|----------|
| Per-finding write-up | [templates/finding.md](../templates/finding.md) |
| Executive summary table | [templates/executive-report.md](../templates/executive-report.md) |
| Test backlog | Category docs + checklist |

## Original monolithic document

The source audit that seeded this archive is preserved at the repository root:

`nextjs-supabase-vercel-expanded-defensive-bug-exploit-audit-2026-06-09.md` (Italian, single-file edition).

The modular `docs/` tree is the maintained, English, open-source edition.
