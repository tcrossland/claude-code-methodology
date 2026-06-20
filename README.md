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
- `docs/worked-example.md` — one real task (adding a link-resolution check) traced through the
  loop, end to end.
- `templates/CLAUDE.template.md` — a lean starter `CLAUDE.md` with the conventions baked in.
- `.claude/` — the methodology running live: the five ritual commands (`/plan`, `/accept`,
  `/retro`, `/release`, `/wrap`), the `code-reviewer` subagent, the Definition of Done
  rule, a `PostToolUse` consistency hook (flags dangling §/appendix references, broken
  intra-repo links, and US spellings on edit), and an `add-section` skill (the section/appendix cross-reference
  ripple), all tuned for this docs project (see *Dogfooding*).

## Using it

1. Read `docs/methodology.md`.
2. Drop `templates/CLAUDE.template.md` into a project as `CLAUDE.md` and fill it in.
3. Adopt the loop, the file layout (`docs/plans/`, `docs/design/`, `CHANGELOG.md`) and the
   appendix artefacts (subagents, hooks, skills, commands) as they earn their place, not
   all at once.

## Reading it as a site

The docs render as a [MkDocs Material](https://squidfunk.github.io/mkdocs-material/) site — the
same Markdown, with search and navigation. To build it locally:

```sh
python3 -m venv .venv && .venv/bin/pip install -r requirements.txt
.venv/bin/mkdocs serve   # http://127.0.0.1:8000
```

The site build is optional, never a prerequisite for reading or editing the Markdown (see
`docs/design/0002-publish-as-doc-site.md`). It is not yet deployed: publishing to a neutral
domain waits until the public name is locked. CI carries the build; the deploy step is gated to a
manual run.

## Dogfooding

This repository is built using the methodology it documents. The lean root `CLAUDE.md`, the
docs under `docs/`, the curated root `CHANGELOG.md`, and the contents of `.claude/` (the five
ritual commands, the `code-reviewer` subagent, the Definition of Done rule, the consistency
hook, and the `add-section` skill) are not illustrations; they are how the work here gets done.

They are tuned to a documentation project. The source has no build or test step, and the MkDocs
site is an optional publish build. Verification rests on British English and the
internal-consistency invariant (§ cross-references and appendix letters A–O), enforced by the
`PostToolUse` consistency hook and review rather than a test suite. That tuning doubles as a
worked example: it adapts the appendix drop-ins to a real repo rather than pasting them verbatim.

## Status

Early and evolving. The intended destination is a Claude Code plugin (see the packaging
doc) with the document as its rationale.

## Licence

[Apache-2.0](LICENSE). Permissive: use, modify, and redistribute freely, including
commercially; the methodology spreads by adoption. The licence grants no rights to the
project's name or marks (`LICENSE` §6) and carries an explicit patent grant (§3).
