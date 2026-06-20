# Plan: split appendices into docs/appendices/ (grouped) + security-checklist appendix   (approved 20/06/2026)

**Status:** done (20/06/2026) — all 7 stages complete; appendices in `docs/appendices/` (A–O),
hook reads cross-file, ADR recorded, full hook sweep + reviewer clean.
<!-- Completed in-session; archived under docs/plans/archive/ (§3). -->
<!-- Friction logged: the live hook flags plan files that *discuss* references — backlog item to
     scope docs/plans/ out of the hook. -->

## Goal
Move Appendices A–N out of `docs/methodology.md` into `docs/appendices/`, grouped by artefact
type, leaving the narrative (Operating principle + §1–§11) in the main file. Add the deferred
security-checklist appendix (the new one, lettered O) into the skeletons group. Record the
reversal of the single-page principle as the methodology's first ADR.

Grouping (mirrors the methodology's primitives and the `.claude/`/plugin layout):
- `docs/appendices/subagents.md` — A, B
- `docs/appendices/hooks.md` — C
- `docs/appendices/skeletons.md` — D, E, F, G, H, and the new checklist (O)
- `docs/appendices/skills-and-commands.md` — I, J–N
- `docs/appendices/README.md` — index, letter → file

References are all prose (no anchor links), so the split breaks nothing clickable. Letters are
stable identifiers, not a sort key: new appendices append (O lands last by letter) but sit in
their thematic file (O with the skeletons, next to the Definition of Done).

## Out of scope
- One file per appendix (over-fragments the short skeletons; pre-builds plugin structure the
  backlog defers).
- Converting prose appendix references to markdown anchor links.
- Editing appendix *content* beyond the verbatim move plus the new checklist appendix.
- `docs/packaging-as-a-plugin.md`'s appendix references — they keep resolving via the hook; no
  edit unless verification flags one.

## Stage 1 — create the four grouped files   [done]
- [x] Extract A–N verbatim by line range (sed, not retyped): subagents 259–326, hooks 327–390,
      skeletons 391–539, skills-and-commands 540–686; each with a short title/intro.
- [x] Append the new checklist appendix (O) into `skeletons.md`, after H.
- Acceptance: concatenating the four extracted ranges reproduces methodology.md lines 259–686
  byte-for-byte (diff-verified); each file passes the hook.

## Stage 2 — update the consistency hook   [done]
- [x] `valid_appendices` from `grep` over `docs/appendices/*.md`; `valid_sections` still from
      `methodology.md`; guard each source independently.
- Acceptance: hook acceptance suite still green; a body appendix reference validates cross-file;
  a deliberately dangling section/appendix reference is still caught.

## Stage 3 — strip the body   [done]
- [x] Remove methodology.md lines 257–686 (divider + appendix block); add a companion pointer at
      the end of §11 directing to `docs/appendices/`.
- Acceptance: no `## Appendix` heading remains in methodology.md; its prose appendix references
  still resolve via the hook (now reading the grouped files).

## Stage 4 — index   [done]
- [x] `docs/appendices/README.md` mapping every letter A–O to its file.

## Stage 5 — ripple the letter range and the moved-location fact   [done]
- [x] A–N → A–O and "appendices now under docs/appendices/" across: README (×3: count, invariant
      mention, What's-here), CLAUDE.md (Layout entry + invariant range), CHANGELOG (Unreleased
      narrative + a split/checklist line), `.claude/agents/code-reviewer.md`,
      `.claude/rules/definition-of-done.md`, `.claude/commands/plan.md`,
      `.claude/agent-memory/code-reviewer/project-repo-shape.md`.
- Acceptance: grep finds no stray "A–N"/"Fourteen" in tracked files; every checklist-appendix reference resolves.

## Stage 6 — ADR   [done]
- [x] `docs/design/0001-split-appendices.md` in the ADR skeleton format. Records three decisions:
      the split (reversing the single-page principle), group-by-type, and append-only letters
      (letter = stable ID, file = thematic home).

## Stage 7 — verify   [done]
- [x] Hook on every tracked `.md` (methodology, all appendices, packaging, README, CHANGELOG,
      ADR); `code-reviewer` on the full diff; Definition of Done.

## Ordering guarantee
Create files → update hook → strip body → index → ripple → ADR → verify, so the live hook never
throws a transient false dangling-reference.

## Deviations
- 20/06/2026 — the live hook flagged this plan repeatedly for *discussing* references (forward §-refs, named test values, the not-yet-created checklist appendix); non-defects, logged as a backlog item to scope docs/plans/ out of the hook.

## Decisions
- 20/06/2026 — group appendices by artefact type (4 files + index) rather than one companion file
  or one-per-appendix — organises the reference rather than relocating the lump; one-per-appendix
  over-fragments the short skeletons and pre-builds deferred plugin structure.
- 20/06/2026 — append-only letters: the new checklist takes the next free letter (O) but lives in
  the skeletons file with its kind. The letter is an identifier, not a position.
