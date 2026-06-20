# Plan: Publish the methodology as a doc site (MkDocs Material)   (approved 20/06/2026)

**Status:** done (20/06/2026) — all four stages complete; the methodology renders as an optional
MkDocs Material site (`mkdocs build --strict` clean), with gated GitHub Pages CI, ADR 0002, and
the `no build` invariant reconciled. Reviewed clean and merged to main.
<!-- Active plan; pointer set in docs/backlog.md ## Now (this plan). Branch: feat/doc-site. -->

## Context / Goal
Stand up a locally-buildable MkDocs Material site rendering the existing `docs/` Markdown
unchanged, record the toolchain choice and invariant reconciliation in ADR 0002, and scaffold
(but gate) GitHub Pages CI — without committing a final domain, name, or theme before the brand
is locked. From `docs/backlog.md` top "Next" item.

Decisions taken with the user up front: **MkDocs Material**; **scope = decide + scaffold a
buildable site, defer live deploy/domain to brand lock**; **eventual host = GitHub Pages**.

De-risking finding: ADR 0001 already split the appendices and recorded that §N/appendix
cross-references are *prose, not anchor links* — so multi-page rendering needs no content
restructuring; the "single page" worry no longer applies. Only 4 links point outside `docs/`
(`worked-example.md` → `../.claude/...`); one deliberately-broken link
(`worked-example.md:61`) demonstrates the project's own hook and must be tolerated.

## Out of scope
- Live deployment, enabling GitHub Pages, choosing/registering the neutral domain (brand lock).
- The naming/Christen item and rebrand theming beyond Material defaults.
- A Pandoc/PDF deliverable; plugin packaging.
- Restructuring `methodology.md` or the appendices, or §N/appendix renumbering.

## Stage 1 — record the decision; reconcile invariant + DoD   [done]
- [x] Write `docs/design/0002-publish-as-doc-site.md` (0001's Context/Decision/Consequences/
      Alternatives format). Alternatives mdBook / Starlight / Pandoc→PDF rejected with reasons.
- [x] Reconcile CLAUDE.md:4 `no build, no runtime` → source has no build; the MkDocs site is an
      optional publish build, never a prerequisite (pointer to ADR 0002). One clause, stays lean.
- [x] Add a scoped DoD item (`.claude/rules/definition-of-done.md`): `mkdocs build --strict`
      completes cleanly when a published doc / config is touched. (Auto-mode classifier blocked
      this edit on first attempt — flagged by code-reviewer; succeeded on retry.)
- Acceptance: ADR follows house format; invariant no longer contradicts the build; DoD item
  scoped to site changes; British English; no §/appendix references disturbed.

## Stage 2 — scaffold the buildable site   [done]
- [x] `mkdocs.yml` (root): theme material; `docs_dir: docs`; nav Home→Methodology→Worked
      example→Appendices→Packaging; `exclude_docs` for backlog/plans/design/local; extensions
      tables, admonition, toc permalinks, superfences. (Broken links caught by `--strict` in CI.)
- [x] `docs/index.md` — lean front-door landing (framing + routing links).
- [x] `requirements.txt` pinning `mkdocs-material~=9.7`.
- [x] Add `site/` and `.venv/` to `.gitignore`.
- [x] Repoint 5 out-of-`docs/` links in `worked-example.md` to GitHub blob URLs (4× `.claude/`,
      1× `backlog.md` — the latter found via the build's excluded-file notice).
- Acceptance: `mkdocs build` produces `site/`; only the one documented warning; nav correct;
  intra-`docs/` links resolve; landing renders.

## Stage 3 — gate CI; update README and CHANGELOG   [done]
- [x] `.github/workflows/docs.yml`: build/validate (`mkdocs build --strict`) on push+PR; deploy
      job `workflow_dispatch`-only; artifact upload also gated to dispatch (per code-reviewer).
- [x] README: "Reading it as a site" note; deploy deferred pending brand lock.
- [x] CHANGELOG `[Unreleased]` Added entries; CLAUDE.md Layout line for mkdocs.yml/requirements.txt.

## Stage 4 — verify and review   [done]
- [x] `.venv` build verified: `mkdocs build --strict` clean; 10 pages generated, excluded docs
      absent. (Homebrew Python is PEP 668 externally-managed → used a venv.)
- [x] `code-reviewer` subagent on the diff: one Critical (missing DoD item) — fixed; Minors
      addressed/noted. DoD walked.

<!-- Completed and merged to main; archived under docs/plans/archive/ (§3). -->
