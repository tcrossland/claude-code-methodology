---
description: Enter plan mode with the house rules — explore read-only, challenge the approach, then present a plan for approval.
---

Enter plan mode for: $ARGUMENTS

Work read-only until I approve a plan. Do not edit files.

1. Explore, read-only. Read the active plan in `docs/plans/` (if any) and this repo's
   invariants in `CLAUDE.md` yourself. Delegate wider search to the Explore agent, restating
   the load-bearing invariant in the prompt: it skips `CLAUDE.md` (§1), and this is a
   documentation project, so changes must hold British English and the §N/appendix A–O
   consistency.
2. Decide whether to plan. Skip the ceremony for trivial work: a single-section wording fix
   with no invariant in play. Say so and stop. Otherwise continue — a refactor, an
   architectural choice, anything that renumbers or re-letters content (it disturbs the
   load-bearing §N/appendix refs), or anything touching an invariant in `CLAUDE.md`.
3. Draft the plan: goal, ordered stages, per-stage steps with acceptance criteria, and an
   explicit out-of-scope list. Call out every cross-reference the change will disturb; they
   must be updated together.
4. Challenge it before presenting (§2): argue why this might not be worth writing, and
   find the holes in the acceptance criteria. Fold what survives back in.
5. Present through the exit-plan tool. On approval, if the work is multi-stage or will not
   finish this session, write it to `docs/plans/<name>.md` (methodology Appendix D) and update
   the active-plan pointer — `docs/backlog.md`'s `## Now (this plan)` — to name it.
