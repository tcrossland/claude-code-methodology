# Backlog

Ordered top to bottom; the top item is what gets picked up next. Tag each — type
(feat/fix/debt/chore), value (H/M/L), effort (H/M/L) — with a one-line *why now*. When an
item ships, move its user-facing outcome to `CHANGELOG.md [Unreleased]` and delete the line
here (§8). British English; dates DD/MM/YYYY.

## Now (this plan)
- (none — no active plan)

## Next
- Tighten the public prose to the house voice — bounded copy-edit of `README.md` and the
  `methodology.md` narrative against `docs/style.md` (leave the appendix artefacts: they're
  reference/skeletons where voice barely matters and dashes sit in code/tables) — debt · value M ·
  effort M — why now: same credibility concern, but framed as "tighten to a tighter, more
  authoritative voice", not "disguise the AI"; acceptance = reviewed against the guide, British
  English and §N/appendix cross-references intact.

## Later / maybe
- Christen the methodology — choose the name and command/plugin namespace — chore · value M · effort L
  — why now: the working name is settled; lock the public name (`plugin.json` `name` plus the
  `/<name>:command` namespace) when the plugin ships, since renaming after publish is costly.
- Build the methodology as a plugin (the stated endpoint — `docs/packaging-as-a-plugin.md`) — feat ·
  value H · effort H — why now: deferred until the unpackaged setup has earned its pieces through
  real use ("Recommended sequencing"); note the Definition of Done must ship as a skill or a
  `CLAUDE.md` block, since a plugin cannot bundle `.claude/rules/` (verified 19/06/2026).

## Parked (with reason)
- (none)
