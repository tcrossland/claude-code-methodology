---
name: project-repo-shape
description: What the claude-methodology repo is, its structure, and the load-bearing invariants every review must check
metadata:
  type: project
---

This repo *is* the methodology it documents: mostly prose now, heading toward a Claude Code plugin (`docs/packaging-as-a-plugin.md`), so shell scripts + JSON manifests will arrive later.

Key structure as of 06/2026:
- `docs/methodology.md` — main reference. Sections §1–§11 (§11 = Security), Appendices A–N (14, all present and resolving). `/plan` J, `/accept` K, `/retro` L, `/release` M, `/wrap` N.
- `docs/packaging-as-a-plugin.md` — plugin companion. Does NOT discuss licensing.
- A gitignored `docs/local/` may hold local-only working notes — don't treat their presence as a defect.
- `.claude/` — live dogfooding: 5 commands (plan/accept/release/retro/wrap), `code-reviewer` agent, `definition-of-done.md` rule. No `test-writer` agent actually present (template references it as illustrative only).

**Why:** the internal-consistency invariant is load-bearing — §N cross-refs and appendix letters A–N must all resolve, and a renumber must move every reference.
**How to apply:** every review, verify §refs against actual `## N.` headings and appendix refs against actual `## Appendix X` headings; verify British English + DD/MM/YYYY (ISO dates only legitimate in session-name examples where chronological sort is the point); verify CHANGELOG [Unreleased] claims match what the docs actually contain. See [[feedback-recurring-defects]].
