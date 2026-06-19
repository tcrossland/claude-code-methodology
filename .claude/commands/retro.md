---
description: Run a methodology retro — surface recurring friction and propose config changes.
---

Review what we had to correct repeatedly during this plan or session. For each recurring
issue, propose the single most durable fix and say where it belongs:

- a CLAUDE.md invariant or convention,
- a `.claude/rules/` entry,
- a `PreToolUse`/`PostToolUse` hook,
- a new or amended subagent, skill, or command under `.claude/`.

This repo is the methodology itself, so a recurring correction is also a signal the
*documented* guidance is unclear — if the fix belongs in `docs/methodology.md` or the
`CLAUDE.template.md` rather than (or as well as) the config, say so.

Output a short list of concrete changes only — no narrative. Do not apply them; I will
review first.
