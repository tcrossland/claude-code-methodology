---
description: Close out the session — confirm durable records are current, then summarise and name it.
---

End-of-session wrap. Work in order; do not edit files until I confirm each write.

1. Durable records — check and update:
   - Active plan in `docs/plans/`: advance the current stage, tick completed steps, note deviations.
   - `CHANGELOG.md`: draft any user-facing changes under `[Unreleased]`.
   - Decisions: log any made this session in the plan, or propose an ADR under `docs/design/` if significant.
   - Consistency sweep: if the session renumbered a `§N` or re-lettered an appendix, confirm every reference moved with it.
2. Retro signal: list anything I had to correct more than once, and propose the single
   durable fix for each (a CLAUDE.md/rules entry, a hook, a subagent, a skill, or a
   clarification to the documented guidance itself).
3. Pointer summary: one line naming which artefacts this session touched and where
   things landed — not a re-narration of the work.
4. Suggest a session name mirroring the active plan (e.g. `add-importer`), so the session
   and plan cross-reference.

Produce all of the above yourself from the session and git history. Do not rely on the
native /recap — it may be unavailable in this environment.
