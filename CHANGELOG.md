# Changelog

All notable, user-facing changes to this methodology. Format: Keep a Changelog;
versions follow SemVer.

## [Unreleased]

_Nothing yet._

## [0.1.0] — 20/06/2026

The initial version of *A File-First Operating Model for Claude Code* (the methodology).
Everything here is initial content, so it is all *Added* — there is no
prior released state for anything to have *Changed* from, and the edits made while assembling
this version were never separate releases.

### Added
- Methodology reference (`docs/methodology.md`): the file-first operating model in full —
  context architecture (including memory hygiene), the core loop, plan/status persistence, the
  subagent roster, the model/mode matrix, hooks as a CI substitute, sessions/concurrency and git
  hygiene, skills and commands (with the command/skill-vs-subagent distinction and a table
  sequencing the rituals), solo product discipline, and a security stance (§11).
- Drop-in appendices (`docs/appendices/`): fifteen artefacts (A–O), grouped by type — the
  `code-reviewer`/`test-writer` subagents, project hooks, document skeletons (plan, Definition of
  Done, backlog, ADR, changelog, security checklist), the example skill and the five ritual
  commands (`/plan`, `/accept`, `/retro`, `/release`, `/wrap`).
- Plugin packaging companion (`docs/packaging-as-a-plugin.md`) — how to package the methodology
  as a distributable Claude Code plugin, and why that is the endpoint.
- Worked end-to-end example (`docs/worked-example.md`) — one real task (adding the consistency
  hook's link-resolution check) traced through the loop, Explore → … → `/wrap`.
- Lean `CLAUDE.md` starter template (`templates/CLAUDE.template.md`).
- The methodology running live in `.claude/`, dogfooded and tuned for this docs project: the five
  ritual commands, the read-only `code-reviewer` subagent, and a path-scoped Definition of Done
  (consistency and descriptive-claim accuracy, no build/test) that `/accept` checks against.
- "Dogfooding" section in `README.md` explaining that the repo is built with its own methodology.
- Apache-2.0 licence (`LICENSE`, `NOTICE`): the methodology is free to use, modify, and
  redistribute, including commercially; the `README.md` Licence section records the choice.
- `PostToolUse` consistency hook (`.claude/hooks/docs-consistency.sh`, wired in
  `.claude/settings.json`): on each in-scope Markdown edit it flags dangling `§N`/appendix
  cross-references, broken intra-repo links, and US spellings — the first live hook in the repo,
  dogfooding §6.
- `add-section` skill (`.claude/skills/add-section/SKILL.md`): the repo's first live skill —
  encodes the append-only rule and the cross-reference/count ripple for adding a methodology
  section or appendix, the part of that defect class the consistency hook cannot catch.
- `close-plan` skill (`.claude/skills/close-plan/SKILL.md`): mechanises the §3 plan-close
  sequence — set the done status, tick stage markers, clear the active-plan pointer, archive the
  file — so completion is no longer a hand-done checklist that can be half-applied.
- Plan archiving convention (§3, Appendix D): completed plans move to `docs/plans/archive/` so
  `docs/plans/` shows only live work; they stay versioned as history.
- §1 tool-surface treatment — extends the always-loaded-vs-on-demand scarcity thesis from files to
  MCP tool definitions: the context cost of a server's schemas, Tool Search as the default
  mitigation (`ENABLE_TOOL_SEARCH`, `alwaysLoad`), the disable-vs-defer point, and the least-privilege
  tie to §11. Closes the tool-side gap §11 deliberately left open.
- §11 "Security" — a consolidated security stance: secret hygiene, least privilege and Bash
  sandboxing, deterministic guards (and the inverse risk of hooks), untrusted-content/prompt-injection,
  and plugin/MCP trust. Ties together the least-privilege, hook and git-hygiene mechanisms in
  §4–§6 and §9 (Appendix C), and fills the prompt-injection and trust gaps the methodology
  previously left unaddressed.
