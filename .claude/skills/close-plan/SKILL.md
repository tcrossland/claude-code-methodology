---
name: close-plan
description: Close out a completed plan in docs/plans/ — set the done status, tick stage markers, clear the active-plan pointer, and archive the file. Use when a plan's work is finished and verified.
allowed-tools: Read, Edit, Bash
---

# Close out a completed plan

Closing a plan is four mechanical steps that are easy to half-do by hand — the failure mode
is a plan marked **done** but with `[current]` markers left in place, the file still in
`docs/plans/`, and the backlog still pointing at it. Do all four, in order, every time.

Only close a plan whose work is actually finished and verified (Definition of Done met). If
a stage was dropped or deviated, record that in the plan rather than ticking it clean.

## Steps

1. **Set the done status.** Edit the plan's `**Status:**` line to:
   ```
   **Status:** done (DD/MM/YYYY) — <one-line summary: stages complete + the headline outcome>.
   ```
   Use British DD/MM/YYYY (today, from the environment's current date). If a stage deviated or
   was cut, say so here in a clause rather than pretending it was clean.
2. **Tick every stage marker.** Replace each `## Stage N — … [current]` or `[not started]` (the
   skeleton's three marker states are `[done]`/`[current]`/`[not started]`) with `[done]`, and
   tick the remaining `- [ ]` step checkboxes that were completed. Confirm none are left:
   ```bash
   grep -nE '\[current\]|\[not started\]|^- \[ \]' docs/plans/<name>.md   # should print nothing
   ```
   A genuinely skipped step stays `- [ ]` with a deviation note — don't tick it to silence the grep.
3. **Clear the active-plan pointer.** In `docs/backlog.md`, reset `## Now (this plan)` to:
   ```
   - (none — no active plan)
   ```
   `docs/backlog.md`'s `## Now (this plan)` is this repo's single pointer to the live plan (the
   §3 active-plan pointer); a cold-start session reads it to know nothing is live.
4. **Archive the file.** Move it so history follows — `git mv` if the plan is already tracked,
   plain `mv` if it was created this session and never committed (`git mv` errors on an untracked
   file; the `mv` fallback stages the new path explicitly, since the repo forbids `git add -A`):
   ```bash
   git mv docs/plans/<name>.md docs/plans/archive/<name>.md \
     || { mv docs/plans/<name>.md docs/plans/archive/<name>.md && git add docs/plans/archive/<name>.md; }
   ```
   Optionally add a trailing HTML comment recording archival and any friction worth a backlog
   item, matching the existing archived plans:
   ```
   <!-- Completed in-session; archived under docs/plans/archive/ (§3). -->
   ```

## Out of scope

- Shipping the plan's user-facing outcome to `CHANGELOG.md` — that is `/release`'s job.
- Deciding what runs next — picking the next backlog item is a separate step, not part of closing.
