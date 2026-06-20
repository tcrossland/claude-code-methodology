---
name: project-doc-site
description: The MkDocs Material doc-site landed on feat/doc-site; recurring review checks it introduces
metadata:
  type: project
---

The repo renders `docs/` as a MkDocs Material site (ADR 0002, `docs/design/0002-publish-as-doc-site.md`).
This added the repo's first CI (`.github/workflows/docs.yml`) and reconciled the old
`no build, no runtime` invariant to "the *source* has no build; the site is an optional publish build".

**Why:** the methodology needs an owned advisory front-door; deploy is deferred until the public
name/brand is locked (the "Christen" backlog item).

**How to apply (recurring checks when these areas change):**
- The reconciled wording must stay coherent across four places: `CLAUDE.md` intro, the DoD
  preamble (`.claude/rules/definition-of-done.md`), README "Dogfooding" line, and ADR 0002. If one
  is edited, check the others did not drift back to a bare "no build".
- `mkdocs build --strict` is the gate for any published doc / `mkdocs.yml` / `requirements.txt`
  change. Published = under `docs/` except `backlog.md`, `plans/`, `design/`, `local/` (these are
  `exclude_docs` in mkdocs.yml). Run `.venv/bin/mkdocs build --strict`.
- `docs/worked-example.md` deliberately contains a dangling link (`does/not/exist.md`) inside a
  code fence to demonstrate the consistency hook. It must stay inside a fence — if it ever leaves
  one, `--strict` fails. Confirm by odd fence count before its line.
- The site can't reach files outside `docs_dir`, so `worked-example.md` repoints 5 refs
  (4× `.claude/...`, 1× `backlog.md`) to absolute GitHub blob URLs at
  `tcrossland/claude-code-methodology`. These hardcode the repo path and are known rebrand debt —
  flag if the repo is renamed. Verify they're well-formed and the target files exist.
- CI: deploy job and the upload-pages-artifact step are both gated to `workflow_dispatch`;
  top-level `permissions: contents: read`, write perms (`pages: write`, `id-token: write`) only on
  the deploy job. Pages action pair must stay matched majors (upload v5 / deploy v5). Actions are
  pinned to commit SHAs with version comments — verify a SHA matches its tag via `gh api`.

**MkDocs 2.0 banner** is upstream advocacy, not a build failure; `mkdocs-material~=9.7` pins
`mkdocs<2`. A clean build prints it and still succeeds.
