---
paths:
  - "*.md"
  - "**/*.md"
  - ".claude/**"
---

# Definition of Done

<!-- Adapted from methodology Appendix E for this docs-only repo: no build/test/lint step,
     so the bar is consistency and review rather than a green suite. Deliberate divergence. -->

A change is not done until ALL of these hold. Do not report a task complete until you have
checked each one and can say which evidence confirms it. This repo has no build, test, or
lint step; the bar is consistency and review, not a green suite.

- [ ] **British English throughout** — spelling, `DD/MM/YYYY` dates, `£`/`€` before figures.
- [ ] **Internal consistency** — every `§N` cross-reference and appendix letter (A–N) touched
      by the change resolves to the right target; nothing dangling or mis-lettered. When a
      number or letter moved, every reference to it moved too.
- [ ] **No contradiction or duplication** — new guidance does not conflict with, or silently
      restate, what another doc already says.
- [ ] **Links and paths resolve** — intra-repo references point at files that exist.
- [ ] **Descriptive claims are true** — CHANGELOG lines, README statements, doc-to-doc pointers,
      and prose file paths match the *current* contents they describe, not merely resolve as links.
- [ ] **CLAUDE.md stays lean** — if it was touched, it has not accreted rules that belong in
      `docs/` or `.claude/`.
- [ ] **CHANGELOG.md `[Unreleased]` updated** if the change is user-facing. For a methodology
      whose docs are the product, that is most guidance changes — internal churn aside.
- [ ] **`code-reviewer` subagent run on the diff**, with no Critical findings outstanding.
- [ ] **Active plan in `docs/plans/` advanced** if one is live (stage, ticked steps, deviations).

If any item cannot be met, stop and say so rather than working around it.
