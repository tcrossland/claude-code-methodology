---
name: project-plan-archiving
description: The plan-archiving convention (completed plans move to docs/plans/archive/) and the doc spots that describe it
metadata:
  type: project
---

Completed plans move from `docs/plans/` to `docs/plans/archive/`, staying versioned as history so only live work shows in `docs/plans/`. Convention added 06/2026.

Where it is described (keep these consistent on any future edit):
- `docs/methodology.md` §3 closing paragraph (~line 83) — "when a plan is done, move it to `docs/plans/archive/` and clear the active-plan pointer".
- `docs/methodology.md` Appendix D (~line 424) — completion note: set `**Status:** done (DD/MM/YYYY)`, clear pointer, move to archive.

**Why:** keeps the active plan set scannable for a cold-start session.
**How to apply:** the active-plan pointer lives in `CLAUDE.md` or `docs/plans/README.md` (§3 point 3, Appendix D comment ~line 383) — "clear the pointer" is consistent with both. `.claude/commands/`, `templates/CLAUDE.template.md`, README "file layout" and the DoD all still say plans live in `docs/plans/` generically; that stays *true* (archive is a subdir), so they are NOT made wrong by the convention and need not be touched. Only flag them if a future edit asserts completed plans stay in `docs/plans/` directly. See [[project-repo-shape]].
