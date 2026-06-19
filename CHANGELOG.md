# Changelog

All notable, user-facing changes to this methodology. Format: Keep a Changelog;
versions follow SemVer.

## [Unreleased]

The first version of the methodology, not yet released. Everything here is initial content,
so it is all *Added* — there is no prior released state for anything to have *Changed* from,
and the edits made while assembling this version were never separate releases.

### Added
- Methodology reference (`docs/methodology.md`): the file-first operating model in full —
  context architecture (including memory hygiene), the core loop, plan/status persistence, the
  subagent roster, the model/mode matrix, hooks as a CI substitute, sessions/concurrency and git
  hygiene, skills and commands (with the command/skill-vs-subagent distinction and a table
  sequencing the rituals), and solo product discipline. Fourteen drop-in appendices (A–N),
  including the five ritual commands (`/plan`, `/accept`, `/retro`, `/release`, `/wrap`) as a
  contiguous block.
- Plugin packaging companion (`docs/packaging-as-a-plugin.md`) — how to package the methodology
  as a distributable Claude Code plugin, and why that is the endpoint.
- Lean `CLAUDE.md` starter template (`templates/CLAUDE.template.md`).
- The methodology running live in `.claude/`, dogfooded and tuned for this docs project: the five
  ritual commands, the read-only `code-reviewer` subagent, and a path-scoped Definition of Done
  (consistency and descriptive-claim accuracy, no build/test) that `/accept` checks against.
- "Dogfooding" section in `README.md` explaining that the repo is built with its own methodology.
