---
name: project-plugin-rules-claim
description: The verified fact that a Claude Code plugin cannot deliver .claude/rules rules, and how it was established
metadata:
  type: project
---

`docs/packaging-as-a-plugin.md` claims a plugin **cannot** deliver `.claude/rules/` rules — so the Definition of Done must ship as a skill, agent instructions, or a `CLAUDE.md` block, never a bundled rules dir. As of 19/06/2026 this is empirically CONFIRMED, not just inferred from doc silence.

Evidence (Claude Code v2.1.181, throwaway plugin + clean project):
- Plugin loaded — namespaced command `/plugin-rules-test:ping` returned PLUGIN_LOADED_OK (load control).
- Rule mechanism works headless — a *project*-level rule fired (PROJECT_RULE_OK) (mechanism control).
- Bundled rules in both `rules/` and `.claude/rules/` did NOT fire.
- Tier 1: the official plugin component reference (plugins-reference.md) exhaustively enumerates components and omits `rules/`.

**Why:** this was the repo's first version-gated claim verified by a full plan ([[docs/plans/verify-plugin-rules-bundling.md]]); the wording must not overstate the controls (a command firing = "its commands did fire" load control; the project rule firing = mechanism control). The full auto-discovered component set is: `.claude-plugin/`, `skills/`, `commands/`, `agents/`, `hooks/`, `.mcp.json`, `.lsp.json`, `monitors/`, `bin/`, `settings.json`.
**How to apply:** if a future edit weakens, dates, or rephrases this bullet, check it still distinguishes the two controls and still names a concrete version + DD/MM/YYYY date. Plugin mechanics move — treat the version as the claim's expiry marker.
