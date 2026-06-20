# Methodology appendices — skills and commands

Drop-in skill and command definitions for the methodology — the example skill and the five ritual commands. Companion to `../methodology.md`; the full A–O index is in this directory's `README.md`.

## Appendix I — example skill

`.claude/skills/add-importer/SKILL.md`

```markdown
---
name: add-importer
description: Scaffold a new data-source importer following project conventions. Use when adding support for a new external source — a new file format, API, or feed.
allowed-tools: Read, Glob, Grep, Edit, Write, Bash
---

# Add a data-source importer

When asked to add an importer for a new source:

1. Read an existing importer as the template — match its structure rather than
   inventing a new one.
2. Confirm the source format against a real sample before writing any parsing
   code — never guess field order, encoding, or date locale.
3. Implement the parser against the shared importer interface; do not bypass it.
4. Route every record through the project's normal write and validation path;
   never write to the store directly (see the Invariants in CLAUDE.md).
5. Add tests: happy path, empty input, malformed record.
6. Run the suite and report results.

Out of scope: changing the importer interface itself — raise that as a separate
decision (ADR).
```

## Appendix J — `/plan` command

`.claude/commands/plan.md`

```markdown
---
description: Enter plan mode with the house rules — explore read-only, challenge the approach, then present a plan for approval.
---

Enter plan mode for: $ARGUMENTS

Work read-only until I approve a plan. Do not edit files.

1. Explore first. Delegate breadth to the Explore agent, but restate any invariant it
   must respect in the prompt — Explore skips CLAUDE.md (§1). Read the active plan in
   docs/plans/ and the relevant CLAUDE.md invariants yourself before proposing anything.
2. Size the task. If it is a one-line or single-file change with no invariant in play,
   say so and recommend skipping the ceremony — do not manufacture stages for trivial work.
3. Otherwise draft a plan: goal, ordered stages, per-stage steps with acceptance
   criteria, and an explicit out-of-scope list.
4. Challenge it before presenting (§2): argue why this might not be worth building, and
   find the holes in the acceptance criteria. Fold what survives back into the plan.
5. Present the plan through the exit-plan tool. On approval, if the work is multi-stage
   or will not finish this session, write it to docs/plans/<name>.md (Appendix D) and
   point the active-plan line (CLAUDE.md) at it.
```

## Appendix K — `/accept` command

`.claude/commands/accept.md`

```markdown
---
description: Run the Definition of Done against the current diff before calling a change complete.
---

Check the current change against the Definition of Done. Do not declare it done until
every item is verified — you will not do this for me unless asked, so I am asking.

1. Run `git diff` (and `git status`) to see exactly what changed.
2. Walk the Definition of Done in `.claude/rules/definition-of-done.md` item by item.
   For each, state the command you ran or the evidence, and PASS / FAIL — not a vibe.
3. Confirm the current stage's acceptance criteria in the active plan (docs/plans/) are met.
4. If anything FAILS or cannot be verified, stop and report it plainly. Do not work
   around it or soften the wording; list exactly what remains.
5. Only when every item passes, report the change ready — and remind me to advance the
   plan status (Appendix D) and draft any user-facing line into CHANGELOG Unreleased
   (Appendix H).
```

## Appendix L — `/retro` command

`.claude/commands/retro.md`

```markdown
---
description: Run a methodology retro — surface recurring friction and propose config changes.
---

Review what we had to correct repeatedly during this plan. For each recurring issue,
propose the single most durable fix and say where it belongs:

- a CLAUDE.md invariant or convention,
- a `.claude/rules/` entry,
- a PreToolUse/PostToolUse hook,
- a new or amended subagent or skill.

Output a short list of concrete changes only — no narrative. Do not apply them; I will
review first.
```

## Appendix M — `/release` command

`.claude/commands/release.md`

```markdown
---
description: Draft CHANGELOG Unreleased entries from the completed plan and commits.
---

Prepare a changelog update — draft only, do not edit files until I approve.

1. Read the active plan and the commits since the last release tag.
2. Summarise only the user-facing changes, one concise line each.
3. Sort them into Keep a Changelog categories: Added, Changed, Deprecated,
   Removed, Fixed, Security. Omit empty categories.
4. Propose these under `## [Unreleased]` in CHANGELOG.md.
5. If a version was given ($1), also propose renaming Unreleased to
   `## [$1] — <today's date>`.

Exclude internal-only changes (refactors, test scaffolding, doc tweaks) unless an
installer would notice. I will curate before anything is committed.
```

## Appendix N — `/wrap` command

`.claude/commands/wrap.md`

```markdown
---
description: Close out the session — confirm durable records are current, then summarise and name it.
---

End-of-session wrap. Work in order; do not edit files until I confirm each write.

1. Durable records — check and update:
   - Active plan: advance the current stage, tick completed steps, note deviations.
   - CHANGELOG.md: draft any user-facing changes under [Unreleased].
   - Decisions: log any made this session in the plan, or propose an ADR if significant.
2. Retro signal: list anything I had to correct more than once, and propose the single
   durable fix for each (a CLAUDE.md/rules entry, a hook, a subagent, a skill).
3. Pointer summary: one line naming which artefacts this session touched and where
   things landed — not a re-narration of the work.
4. Suggest a session name mirroring the active plan (e.g. add-importer), so the session
   and plan cross-reference.

Produce all of the above yourself from the session and git history. Do not rely on the
native /recap — it may be unavailable in this environment.
```
