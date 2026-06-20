# Backlog

Ordered top to bottom; the top item is what gets picked up next. Tag each — type
(feat/fix/debt/chore), value (H/M/L), effort (H/M/L) — with a one-line *why now*. When an
item ships, move its user-facing outcome to `CHANGELOG.md [Unreleased]` and delete the line
here (§8). British English; dates DD/MM/YYYY.

## Now (this plan)
- (none — no active plan)

## Next
- [ ] Consolidate a security stance — secret hygiene, destructive-command guards, `bypassPermissions`
      risk, plugin/MCP trust, and untrusted-content/prompt-injection awareness — feat · value M · effort M
      — why now: security is scattered across §5/§9/Appendices A & C with no single stance, and the
      prompt-injection/untrusted-content surface is a genuine omission (not just consolidation); a
      distributed harness invites the "what's your security stance?" question.
- [ ] Add a tool-surface treatment — when an MCP server earns its place, the always-loaded context
      cost of tool definitions (ties to the operating-principle scarcity thesis) with on-demand
      loading as the mitigation, plus tool allowlisting — feat · value M · effort M — why now: the
      context-cost thesis is left unfinished on the tool side (trust lives in the security item).

## Later / maybe
- Christen the methodology — choose the name and command/plugin namespace — chore · value M · effort L
  — why now: the plugin needs a name (`plugin.json` `name` plus the `/<name>:command` namespace) and
  renaming after publish is costly; settle on a working name now and lock it when the plugin ships.
- Build the methodology as a plugin (the stated endpoint — `docs/packaging-as-a-plugin.md`) — feat ·
  value H · effort H — why now: deferred until the unpackaged setup has earned its pieces through
  real use ("Recommended sequencing"); note the Definition of Done must ship as a skill or a
  `CLAUDE.md` block, since a plugin cannot bundle `.claude/rules/` (verified 19/06/2026).
- Verify the remaining version-gated claims in `docs/methodology.md` (e.g. `@`-import vs plain
  reference, `opusplan`, forks/nested subagents) — debt · value M · effort M — why now: the same
  verify-don't-assume habit that just corrected the plugin-rules claim.
- A worked end-to-end example — one real task traced through the loop (Explore → Plan → Execute →
  Review → Accept → `/wrap`) with the actual files changing — feat · value M/H · effort M — why now:
  the methodology justifies each piece in isolation but never shows the loop running; likely the
  highest-leverage adoption aid, especially for the advisory angle.
- Publish the methodology as a doc site or deliverable — evaluate mdBook (minimal, book-shaped) vs
  MkDocs Material (search/polish; Starlight if JS-preferred; Pandoc → PDF if the deliverable is a
  document, not a site) — feat · value M · effort M — why now: gated on the external-publish/advisory
  decision. All render the existing Markdown (source stays Claude-readable), but each adds a build —
  so revisit the "no build, no runtime" invariant and the DoD when taken on, and keep `methodology.md`
  a single page to preserve the load-bearing cross-reference model.

## Parked (with reason)
- (none)
