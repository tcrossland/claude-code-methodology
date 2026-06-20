# Backlog

Ordered top to bottom; the top item is what gets picked up next. Tag each — type
(feat/fix/debt/chore), value (H/M/L), effort (H/M/L) — with a one-line *why now*. When an
item ships, move its user-facing outcome to `CHANGELOG.md [Unreleased]` and delete the line
here (§8). British English; dates DD/MM/YYYY.

## Now (this plan)
- (none — no active plan)

## Next
- (none)

## Later / maybe
- Christen the methodology — choose the name and command/plugin namespace — chore · value M · effort L
  — why now: the working name is settled; lock the public name (`plugin.json` `name` plus the
  `/<name>:command` namespace) when the plugin ships, since renaming after publish is costly.
- Publish the methodology as a doc site or deliverable — evaluate mdBook (minimal, book-shaped) vs
  MkDocs Material (search/polish; Starlight if JS-preferred; Pandoc → PDF if the deliverable is a
  document, not a site) — feat · value M · effort M — why now: gated on the external-publish/advisory
  decision. All render the existing Markdown (source stays Claude-readable), but each adds a build —
  so revisit the "no build, no runtime" invariant and the DoD when taken on, and keep `methodology.md`
  a single page to preserve the load-bearing cross-reference model.
- Build the methodology as a plugin (the stated endpoint — `docs/packaging-as-a-plugin.md`) — feat ·
  value H · effort H — why now: deferred until the unpackaged setup has earned its pieces through
  real use ("Recommended sequencing"); note the Definition of Done must ship as a skill or a
  `CLAUDE.md` block, since a plugin cannot bundle `.claude/rules/` (verified 19/06/2026).

## Parked (with reason)
- (none)
