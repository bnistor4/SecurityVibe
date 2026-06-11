# Contributing to SecurityVibe

Thank you for helping improve this defensive security audit toolkit.

## What we welcome

- New detection patterns for emerging Next.js / Supabase / Vercel issues
- Corrections to advisory tables and version guidance
- Additional regression test scenarios
- Improved scripts (bash/PowerShell) with clear output
- Translations (keep English as the canonical source)
- Dashboard checklist items backed by official documentation

## What we do not accept

- Offensive payloads, exploit PoCs, or weaponization instructions
- Findings without reproducible detection guidance
- Vendor-specific marketing content
- Changes that remove the defensive-only scope

## How to contribute

1. Fork the repository.
2. Create a branch: `git checkout -b docs/rls-policy-patterns`.
3. Make focused changes — one category or concern per PR when possible.
4. Update cross-links if you add or rename files.
5. Open a pull request with:
   - **What** changed
   - **Why** (advisory, doc update, gap filled)
   - **Sources** (official advisories, docs URLs)

## Style guide

- Write in clear English.
- Use evidence-based language: "verify", "detect", "mitigate" — not "exploit".
- Checklists use `- [ ]` markdown task items.
- Detection commands should work with [ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`).
- Cite official sources in `references/sources.md` when adding new advisory rows.

## Reporting issues

Use the GitHub issue templates for:

- Documentation gaps
- Outdated advisory information
- Script false positives/negatives

Do **not** file public issues containing secrets, live production URLs, or customer data.

## Code of conduct

Be respectful and constructive. This project exists to help teams build safer applications.
