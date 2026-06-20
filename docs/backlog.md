# Backlog

Ordered top to bottom; the top item is what gets picked up next. Tag each — type
(feat/fix/debt/chore), value (H/M/L), effort (H/M/L) — with a one-line *why now*. When an
item ships, move its user-facing outcome to `CHANGELOG.md [Unreleased]` and delete the line
here (§8). British English; dates DD/MM/YYYY.

## Now (this plan)
- Publish the methodology as a doc site (MkDocs Material) — see `docs/plans/publish-as-doc-site.md`.

## Next
- (none)

## Later / maybe
- House-voice guide — add a short style note (concision, sentence-length variety, sparing em-dashes,
  no formulaic "not X but Y" triads) to `CLAUDE.md` Conventions or a new `docs/style.md` — chore ·
  value M · effort L — why now: the public docs read as AI-generated (e.g. `methodology.md` runs ~1
  em-dash every 2–3 lines), which undercuts the "human judgement, not vibes" positioning; a standing
  convention gives every future edit a target so tells don't drift back in, and turns the copy-edit
  below into something with an acceptance criterion. Do this first — it's the durable half.
- Tighten the public prose to the house voice — bounded copy-edit of `README.md` and the
  `methodology.md` narrative against the style guide above (leave the appendix artefacts: they're
  reference/skeletons where voice barely matters and dashes sit in code/tables) — debt · value M ·
  effort M — why now: same credibility concern, but framed as "tighten to a tighter, more
  authoritative voice", not "disguise the AI"; acceptance = reviewed against the guide, British
  English and §N/appendix cross-references intact. Depends on the house-voice guide existing.
- Christen the methodology — choose the name and command/plugin namespace — chore · value M · effort L
  — why now: the working name is settled; lock the public name (`plugin.json` `name` plus the
  `/<name>:command` namespace) when the plugin ships, since renaming after publish is costly.
- Build the methodology as a plugin (the stated endpoint — `docs/packaging-as-a-plugin.md`) — feat ·
  value H · effort H — why now: deferred until the unpackaged setup has earned its pieces through
  real use ("Recommended sequencing"); note the Definition of Done must ship as a skill or a
  `CLAUDE.md` block, since a plugin cannot bundle `.claude/rules/` (verified 19/06/2026).

## Parked (with reason)
- (none)
