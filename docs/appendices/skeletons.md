# Methodology appendices — document skeletons

Drop-in document skeletons for the methodology — plan, Definition of Done, backlog, ADR, changelog, and the security checklist. Companion to `../methodology.md`; the full index is in this directory's `README.md`.

## Appendix D — plan file with folded status

`docs/plans/<task-name>.md`

```markdown
# Plan: <task name>   (approved DD/MM/YYYY)

**Status:** in progress — Stage 2 of 3
<!-- The active-plan pointer (e.g. in CLAUDE.md, docs/plans/README.md, or your backlog) names this file. -->

## Goal
<one or two sentences>

## Out of scope
- <thing we are deliberately not doing>

---

## Stage 1 — <name>   [done]
- [x] <step> — files: <paths>
- [x] <step>
- Acceptance: <how we knew the stage was done>

## Stage 2 — <name>   [current]
- [x] <step>
- [ ] <step> — files: <paths>
- Acceptance: <criteria for this stage>

## Stage 3 — <name>   [not started]
- [ ] <step>
- Acceptance: <criteria>

---

## Deviations
- DD/MM/YYYY, Stage 2 — changed X because Y.

## Decisions
- DD/MM/YYYY — <decision> — because <reason>.
  <!-- If architecturally significant and costly to reverse, promote to docs/design/ as an ADR. -->
```

Active-plan pointer — a single line kept current, e.g. in `CLAUDE.md`:

```markdown
## Active plan
docs/plans/<task-name>.md — Stage 2 of 3
```

On completion, set `**Status:** done (DD/MM/YYYY)`, clear the active-plan pointer, and move the
file to `docs/plans/archive/`. The plan stays versioned as project history; only its location
changes, so `docs/plans/` shows just what is live.

## Appendix E — Definition of Done

`.claude/rules/definition-of-done.md`

```markdown
# Definition of Done

A change is not done until ALL of these hold. Do not report a task complete
until you have checked each one and can say which command or evidence confirms it.

- [ ] Builds cleanly (`<build command>`).
- [ ] Tests pass, including new tests for the changed behaviour (`<test command>`).
- [ ] `code-reviewer` subagent run on the diff, with no Critical findings outstanding.
- [ ] No new lint/format violations (`<lint command>`).
- [ ] Project invariants in CLAUDE.md still hold.
- [ ] Active plan in `docs/plans/` updated: current stage advanced, items ticked or deviations recorded.
- [ ] Docs/comments updated if the public surface changed.

If any item cannot be met, stop and say so rather than working around it.
```

## Appendix F — `docs/backlog.md` skeleton

```markdown
# Backlog

Ordered top to bottom. The top item is what gets picked up next.
Tag each item — type: feat/fix/debt/chore, value: H/M/L, effort: H/M/L — and a
one-line "why now". Optional ID (BL-NN) only if you want plans or commits to
reference items. When an item ships, move its user-facing outcome to CHANGELOG.md
(Unreleased), then delete the line here.

## Now (this plan)
- [ ] <item> — feat — value: H, effort: M — why now: <reason>

## Next
- [ ] <item> — fix — value: M, effort: L — why now: <reason>

## Later / maybe
- <item> — debt — <one line; deliberately not committing yet>

## Parked (with reason)
- <item> — parked DD/MM/YYYY because <reason>
```

## Appendix G — ADR skeleton

`docs/design/NNNN-<slug>.md`. Write one only when the decision is costly to reverse and likely to be questioned later; lighter decisions stay in the plan file's decision log.

```markdown
# ADR NNNN — <title>

**Status:** accepted   **Date:** DD/MM/YYYY
<!-- later: superseded by ADR-NNNN -->

## Context
<the forces at play; what made this decision necessary>

## Decision
<what we chose, stated plainly>

## Consequences
<what this makes easier, what it makes harder, what we are now committed to>

## Alternatives considered
- <option> — rejected because <reason>
```

## Appendix H — `CHANGELOG.md` skeleton (repo root)

Keep a Changelog format; versions follow SemVer. Curated by hand from drafts.

```markdown
# Changelog

All notable, user-facing changes. Format: Keep a Changelog; versions follow SemVer.

## [Unreleased]
### Added
- <new feature an installer or user would notice>
### Fixed
- <bug fix>

## [0.2.0] — DD/MM/YYYY
### Added
- <feature>
### Changed
- <behaviour change>
### Removed
- <removed feature>

## [0.1.0] — DD/MM/YYYY
### Added
- Initial release.
```

## Appendix O — security checklist

Run when you add a tool, plugin or MCP server, change permissions, or before you distribute — not every task. Each item is the actionable form of a thread in §11.

- [ ] **Secrets** — none in tracked files, `CLAUDE.md`, or pasted context; keys in environment / OS keychain / secret manager; `.gitignore` and the gitignored `docs/local/` convention cover private material; `/security-review` clean on the diff.
- [ ] **Least privilege** — each subagent's `tools` list is the minimum it needs; permission mode is `acceptEdits` on a branch or worktree, not `bypassPermissions`; deny rules cover the paths and commands that must never run; Bash sandboxing in force where available.
- [ ] **Guards wired** — `PreToolUse` bash-guard (destructive commands) and git-guard (blanket staging, unreviewed commit or push) present and firing.
- [ ] **Untrusted content** — nothing auto-acts on fetched, tool-returned, issue or PR text without a human at the irreversible or outward-facing step; external content is treated as data, not instructions.
- [ ] **Third-party trust** — every installed plugin and MCP server is from a reviewable, trusted source, vetted before install; first-use trust prompts read, not clicked through.
- [ ] **Hooks reviewed** — no unreviewed hook in a cloned `.claude/`; hook scripts are yours or audited.
