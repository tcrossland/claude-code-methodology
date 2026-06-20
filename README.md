# A File-First Operating Model for Claude Code

Written for experienced solo developers and small teams, it treats the harness as an
engineered environment: the discipline lives in what you persist to files and what you
enforce deterministically, not in clever prompting.

## What's here

- `docs/methodology.md` — the full reference: context architecture, the work loop,
  plan/status persistence, subagents, the model/mode matrix, hooks, sessions/concurrency
  and git hygiene, skills and commands, solo product discipline (backlog, changelog,
  Definition of Done, retro), and a security stance (least privilege, prompt-injection and
  plugin/MCP trust).
- `docs/appendices/` — the fifteen drop-in artefacts (subagents, hooks, document skeletons, the
  example skill and the ritual commands; Appendices A–O), grouped by type. See its `README.md` index.
- `docs/packaging-as-a-plugin.md` — how to package the methodology as a distributable
  Claude Code plugin, and why that's the natural endpoint.
- `templates/CLAUDE.template.md` — a lean starter `CLAUDE.md` with the conventions baked in.
- `.claude/` — the methodology running live: the five ritual commands (`/plan`, `/accept`,
  `/retro`, `/release`, `/wrap`), the `code-reviewer` subagent, the Definition of Done
  rule, a `PostToolUse` consistency hook (flags dangling §/appendix references and US
  spellings on edit), and an `add-section` skill (the section/appendix cross-reference
  ripple) — all tuned for this docs project (see *Dogfooding*).

## Using it

1. Read `docs/methodology.md`.
2. Drop `templates/CLAUDE.template.md` into a project as `CLAUDE.md` and fill it in.
3. Adopt the loop, the file layout (`docs/plans/`, `docs/design/`, `CHANGELOG.md`) and the
   appendix artefacts (subagents, hooks, skills, commands) as they earn their place — not
   all at once.

## Dogfooding

This repository eats its own dogfood: it is built using the methodology it documents. The
lean root `CLAUDE.md`, the docs under `docs/`, the curated root `CHANGELOG.md`, and the
contents of `.claude/` — the five ritual commands, the `code-reviewer` subagent, the
Definition of Done rule, the consistency hook, and the `add-section` skill — are not
illustrations; they are how the work here actually gets done. They are tuned to a
documentation project (no build or test step; verification is British English plus the
internal-consistency invariant — § cross-references
and appendix letters A–O — enforced by the `PostToolUse` consistency hook and review rather
than a suite), which doubles as a worked example of adapting the appendix drop-ins to a real
repo rather than pasting them verbatim.

## Status

Early and evolving. The intended destination is a Claude Code plugin (see the packaging
doc) with the document as its rationale.

## Licence

[Apache-2.0](LICENSE). Permissive — use, modify, and redistribute freely, including
commercially; the methodology spreads by adoption. The licence grants no rights to the
project's name or marks (`LICENSE` §6) and carries an explicit patent grant (§3).
