# Plan: verify whether a plugin can bundle `.claude/rules/`   (started 19/06/2026)

**Status:** done (19/06/2026) — claim CONFIRMED empirically; docs updated; `code-reviewer` clean.
<!-- Completed; the CLAUDE.md active-plan pointer has been cleared. -->

## Result
A plugin **cannot** deliver `.claude/rules/` rules. Tested on Claude Code v2.1.181 with a
throwaway plugin (`/tmp/plugin-rules-test`) carrying always-on rules in both `rules/` and
`.claude/rules/`, plus a control command:
- Plugin loaded ✓ — `/plugin-rules-test:ping` returned `PLUGIN_LOADED_OK`.
- Rule mechanism works headless ✓ — a *project* rule fired (`PROJECT_RULE_OK`).
- Bundled rules silent ✗ — in a clean project with the plugin enabled, neither bundled rule fired.
Plugin-loaded + mechanism-works + bundled-rules-silent ⟹ confirmed. Matches Tier 1 (the
component reference omits `rules/`). The `.claude/rules/` bullet was firmed to a verified,
dated claim and gained a fuller-component-set note; the DoD component-map row already said
"ship as a skill or `CLAUDE.md` block, not a bundled rules dir" and needed no change.

## Goal
Confirm or correct `docs/packaging-as-a-plugin.md` (the `.claude/rules/` bullet and the DoD
component-map row), which claim a plugin cannot bundle `.claude/rules/` (so the Definition of Done must ship as a skill or a
`CLAUDE.md` block). Two sub-questions: (a) is `rules/` an auto-discovered plugin component
directory like `commands/`/`agents/`/`skills/`/`hooks/`? (b) can a plugin deliver rules at all?

## Out of scope
- How *this repo's* own DoD is delivered — it is a project-level rule and works regardless.
- Building the actual methodology plugin (separate, future work).

---

## Stage 1 — Tier 1: authoritative doc + changelog check   [done]
- [x] `claude-code-guide` subagent: is `rules/` in the official plugin component-directory
      list? Any changelog entry adding plugin-bundled rules?
- Acceptance: an authoritative statement (with citation) on (a), and on whether the docs
  say anything about (b). Per our own lesson, doc silence on a negative is *inconclusive*.
- **Finding (19/06/2026, docs current today):** the plugin component list (plugins-reference.md)
  authoritatively enumerates `.claude-plugin/`, `skills/`, `commands/`, `agents/`, `hooks/`,
  `.mcp.json`, `.lsp.json`, `monitors/`, `bin/`, `settings.json` — `rules/` is absent. No manifest
  field, skill/agent path, or changelog entry delivers bundled rules. This is an *exhaustive*
  enumeration (not mere silence), so it strongly supports the claim — Stage 3 confirms empirically.
- **Bonus:** that list is richer than `docs/packaging-as-a-plugin.md`'s "shape of a plugin" diagram
  (which omits `.lsp.json`, `monitors/`, `bin/`, `settings.json`) — a separate staleness to fix in Stage 4.

## Stage 2 — Tier 2: scaffold the empirical test   [done]
- [x] Build `/tmp/plugin-rules-test/` (throwaway, outside the repo): `plugin.json`,
      `rules/marker.md` (path-scoped + a unique marker token), `commands/ping.md` as control.
- [x] Scratch project `/tmp/rules-test-project/` with a `foo.txt` matching the rule's glob.
- Acceptance: files ready, plus exact install/observe commands recorded below.

## Stage 3 — run the empirical test   [done]
- [x] Drove the desktop-bundled CLI headless (`claude -p --plugin-dir …`) after a one-off CLI
      login; ran load-control, plugin-rule test (clean project), and project-rule control.
- Acceptance: met — see Result above. (Done in-process rather than as a hand-off, once the
  bundled binary was located and authenticated.)

## Stage 4 — update docs per findings   [done]
- [x] Amended `docs/packaging-as-a-plugin.md`: the `.claude/rules/` bullet (rules claim, now
      verified + dated) and a fuller-component-set note after the plugin-shape diagram.
- [x] `code-reviewer` on the diff — clean (no Critical/Warning).
- Acceptance: met — the bullet reflects verified behaviour with the version (v2.1.181) and date noted.

---

## Run/observe instructions (Stage 3)
See `/tmp/plugin-rules-test/HOWTO.txt` (written in Stage 2).

## Deviations
- 19/06/2026, Stage 3 — no `claude` on PATH; the desktop app (Claude.app) bundles the CLI at
  `…/Application Support/Claude/claude-code/2.1.181/claude.app/Contents/MacOS/claude`. That binary
  runs headless but reports "Not logged in" — desktop auth isn't shared with a terminal CLI, so the
  in-process headless run is blocked without a separate `claude /login`. Tier 2 is therefore gated on
  a one-off CLI login. Tier 1 evidence (exhaustive component reference omitting `rules/`) stands as
  the primary basis; deciding whether that suffices or to do the empirical run.

## Decisions
- 19/06/2026 — verify both sub-questions; treat Tier 1 doc-silence as inconclusive for a
  negative and rely on the Tier 2 empirical control to decide. Because [[verify-version-gated-claude-code-claims]].
