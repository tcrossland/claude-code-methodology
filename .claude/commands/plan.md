---
description: Enter plan mode with the house rules — explore read-only, challenge the approach, then present a plan for approval.
---

Enter plan mode for: $ARGUMENTS

Work read-only until I approve a plan. Do not edit files.

1. Explore first. Read the relevant docs under `docs/` and the active plan in
   `docs/plans/` (if any). Delegate breadth to the Explore agent, but restate the
   load-bearing invariant in the prompt — Explore skips CLAUDE.md (§1): this is a
   documentation project, so changes must hold British English and keep the
   methodology internally consistent (§N cross-references and appendix letters A–O).
2. Size the task. A single-section wording fix needs no plan — say so and recommend
   skipping the ceremony. Plan first when the approach isn't obvious: a refactor, an
   architectural choice, anything that renumbers or re-letters content (it disturbs the
   load-bearing §N/appendix refs), or anything touching an invariant in CLAUDE.md.
3. Otherwise draft a plan: goal, ordered stages, per-stage steps with acceptance
   criteria, and an explicit out-of-scope list. Call out every cross-reference the
   change will disturb, since those must be updated together.
4. Challenge it before presenting (§2): argue why this might not be worth writing, and
   find the holes in the acceptance criteria. Fold what survives back into the plan.
5. Present the plan through the exit-plan tool. On approval, if the work is multi-stage
   or will not finish this session, write it to `docs/plans/<name>.md` (methodology
   Appendix D) and update the active-plan pointer — `docs/backlog.md`'s `## Now (this plan)` — to name it.
