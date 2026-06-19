<!--
  CLAUDE.md — starter template.
  Drop in at the project root as `CLAUDE.md`, then fill the < > placeholders.

  KEEP THIS LEAN. This file loads on EVERY turn. If something applies to only part
  of the codebase, or only sometimes, it does NOT belong here:
    - conditional / path-specific rules  -> .claude/rules/
    - explanatory architecture           -> docs/architecture.md (linked below)
    - detailed specs and plans           -> docs/plans/
  A good ceiling is roughly one screen. If it grows past that, move things out.
-->

# <Project name>

<One or two sentences: what this is, who it's for, the single most important constraint.>

## Invariants

<The hard constraints that must hold on EVERY change. Keep these here, in the
always-loaded file — a constraint that lives only behind a link will be violated.
Be specific and short.>
- <e.g. No developer-operated server; all sync is via CloudKit private database.>
- <e.g. All writes go through the double-entry layer; never write a balance directly.>
- <e.g. Minimum deployment target is iOS 18; do not use newer APIs.>

Architecture (components, diagrams, rationale): see `docs/architecture.md`.
Reference it on demand — do not paste it here, and do not `@`-import it (that pulls
the whole document into every turn).

## Commands

<The exact commands Claude should use to verify its work — your verification loop.>
- Build: `<command>`
- Test: `<command>`
- Lint / format: `<command>`
- Run: `<command>`

## Conventions

- <Language/spelling, e.g. British English in user-facing strings and comments.>
- <Code style: point at the formatter rather than restating its rules.>
- Commit style: <e.g. Conventional Commits; imperative mood; one concern per commit.>
- <Anything non-obvious about how the project is laid out.>

## Active plan

<Kept current — a cold-start session lands here to resume the right plan.>
docs/plans/<task-name>.md — Stage <N> of <M>

## Working agreement

These rules govern *how* we work, not what the code does. Global working rules
(worktree hygiene, verify-before-asserting) live in `~/.claude/CLAUDE.md` and apply on
top of these.

- **Plan before you leap.** If the approach isn't obvious — a structural refactor, or
  anything touching an invariant above — drop into plan mode and agree the approach
  before editing. This is cheap; use it freely, even for a one-file change.
- **Persist a plan only when it must outlive the session.** Write `docs/plans/<name>.md`
  when the work is multi-stage or won't finish before the context compacts or you stop —
  that is what the file is for. Otherwise do the thinking and skip the file.
- **One plan file, status folded in.** Each plan is a sequence of Stages worked through
  in order; status (current stage, ticked steps, deviations, decisions) lives in the
  same file. After a compaction or restart, resume from the active plan.
- **Review before merge.** Run the `code-reviewer` subagent on the diff before any merge
  to the main branch. There is no second reviewer; this is it.
- **Verify, don't assume.** Run the commands above to confirm a change works, and check
  it against the Definition of Done, before reporting it done.

## Where to find more

- Architecture: `docs/architecture.md`
- Design decisions (ADRs): `docs/design/`
- Plans (with folded status): `docs/plans/`
- Backlog: `docs/backlog.md`
- Changelog (user-facing, curated): `CHANGELOG.md` (repo root)
- Conditional rules + Definition of Done: `.claude/rules/`
- Subagents: `.claude/agents/` (`code-reviewer`, `test-writer`)
- Skills (procedures) and commands (rituals): `.claude/skills/`, `.claude/commands/`

<!--
  Maintenance: treat this file as a living spec. When a rule goes stale, delete it —
  a contradicted instruction is worse than a missing one.
-->
