# Claude Code Methodology

This repository is the methodology itself: reference docs, a CLAUDE.md template, and
(eventually) a Claude Code plugin. It is a documentation project — no build, no runtime.

## Invariants

- British English throughout (DD/MM/YYYY, £/€ before figures).
- Keep this file lean; it loads every turn. Detailed material lives under `docs/`.
- Docs live under `docs/`; the curated changelog stays at the repo root as `CHANGELOG.md`.
- The methodology must stay internally consistent: section cross-references (§N) and
  appendix letters (A–O) are load-bearing — update them together when editing.

## Layout

- `docs/methodology.md` — the main reference (narrative §1–§11).
- `docs/appendices/` — the drop-in artefacts (Appendices A–O), grouped by type; `README.md` indexes them.
- `docs/packaging-as-a-plugin.md` — plugin packaging companion.
- `templates/CLAUDE.template.md` — the starter template artefact.
- `CHANGELOG.md` — user-facing changes (Keep a Changelog, SemVer).
- `docs/backlog.md` — ordered candidate work (§8 / Appendix F).

## Conventions

- Commits: Conventional Commits, imperative mood, one concern per commit. The methodology is
  the product, so type by what changed for a reader — `feat` new guidance/artefact, `fix`
  corrected guidance, `refactor` restructuring, `chore` repo plumbing; reserve `docs` for
  trivial infra. Types mirror the backlog's feat/fix/debt/chore (§8) and pre-sort into
  CHANGELOG categories at `/release`.
- Internal/private material lives in gitignored `docs/local/`; never name or describe its
  contents in tracked files or commit messages — use neutral "local" terminology.

## Working agreement

These rules govern *how* we work, not what the code does. Global working rules
(worktree hygiene, verify-before-asserting) live in `~/.claude/CLAUDE.md` and apply on
top of these.

- **Plan before you leap.** If the approach isn't obvious — a structural refactor, or
  anything touching an invariant above — drop into plan mode and agree the approach
  before editing. This is cheap; use it freely, even for a one-file change.
- **Persist a plan only when it must outlive the session.** Write `docs/plans/<name>.md`
  when the work is multi-stage or won't finish before the context compacts or you stop —
  that is what the file is for (§3). Otherwise do the thinking and skip the file.
- **One plan file, status folded in.** Each plan is a sequence of Stages worked through
  in order; status (current stage, ticked steps, deviations, decisions) lives in the
  same file. After a compaction or restart, resume from the active plan.
- **Review before merge.** Run the `code-reviewer` subagent on the diff before any merge
  to the main branch. There is no second reviewer; this is it.
- **Verify, don't assume.** Run the commands above to confirm a change works, and check
  it against the Definition of Done, before reporting it done.
