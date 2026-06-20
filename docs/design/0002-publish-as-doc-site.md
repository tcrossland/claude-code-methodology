# ADR 0002 — Publish the methodology as a MkDocs Material site

**Status:** accepted   **Date:** 20/06/2026

## Context
The methodology is public and linked from a content series, and needs an *owned* home — an
advisory front-door — on a neutral domain, rebrandable when the public name is locked (the
"Christen" backlog item). The source is plain Markdown under `docs/`, readable as-is on GitHub,
but a browsable site with search and navigation reads as a product rather than a repo.

Four renderers were on the table (backlog `## Next`): **mdBook** (minimal, book-shaped),
**MkDocs Material** (search and polish), **Starlight** (Astro/JS), and **Pandoc → PDF** (a
document, not a site). All render the existing Markdown, so the source stays Claude-readable
whichever wins.

Two earlier constraints turned out to be weaker than recorded. ADR 0001 already split the
appendices into `docs/appendices/` and established that the §N ↔ appendix cross-references are
*prose, validated by the consistency hook, not markdown anchor links* — so the "keep
`methodology.md` a single page to preserve the cross-reference model" worry does not apply to a
multi-page site, and 0001 explicitly flagged that this work should treat the appendices
directory as part of the source. The remaining tension is the `no build, no runtime` line in
`CLAUDE.md`: a site adds a build step, so the invariant needs reconciling (done alongside this
ADR) rather than quietly broken.

## Decision
Render the site with **MkDocs Material**. Configuration choices:

- `mkdocs.yml` at the repo root; `docs_dir: docs`, so the existing tree is the content source.
- An explicit `nav`: a thin `docs/index.md` landing → the methodology → the worked example →
  the appendices (index + the four grouped files) → the packaging companion. `README.md` stays
  the *repo* landing for GitHub browsers; `index.md` is the *site* front-door, kept lean so the
  two do not drift.
- `exclude_docs` for the working artefacts that are not published reference — `backlog.md`,
  `plans/`, `design/` (these ADRs), and `local/`.
- CI builds with `mkdocs build --strict`, so a genuinely broken intra-repo link fails the build.
  The one deliberately-broken link in `worked-example.md` (`does/not/exist.md`, demonstrating the
  project's own consistency hook) lives inside a code fence, so MkDocs never parses it — no
  special-casing is needed for it.
- The links in `worked-example.md` that point outside `docs_dir` are repointed to absolute
  GitHub blob URLs: the four `../.claude/...` references and the `backlog.md` reference (backlog
  is an excluded working doc). Those files are not in the site, and the canonical place for a
  site reader to view them is the source repo.
- **Host: GitHub Pages**, but **deploy is deferred** until the brand/domain is locked. CI
  carries a build/validate job (push + PR) and a deploy job gated to `workflow_dispatch` only,
  so nothing auto-publishes under a non-final name.

## Consequences
- The repo gains an *optional* build: `pip install -r requirements.txt && mkdocs build`. It is a
  publishing step only — never a prerequisite for reading or editing the Markdown. `CLAUDE.md`
  and the Definition of Done are updated to say exactly that; the DoD gains a build check scoped
  to changes that touch `mkdocs.yml` or published docs.
- `requirements.txt` pins `mkdocs-material`; `site/` is gitignored.
- The GitHub blob URLs hardcode the current repo path (`tcrossland/claude-code-methodology`), so
  they are rework at the rebrand — but they are few and greppable, and the Christen item already
  revisits names. The consistency hook skips absolute/scheme links, so they will not trip it.
- Excluding `design/` means these ADRs are not published; they remain internal rationale, which
  matches their purpose.
- **Ecosystem risk (MkDocs 2.0).** The upstream MkDocs 2.0 rewrite drops plugins and the theming
  API Material depends on; the Material team opposes it and pins `mkdocs<2` (from Material 9.7.5),
  so our `mkdocs-material~=9.7` build is already protected from an accidental upgrade — the
  warning banner the build prints is advocacy, not a break. The long-term fallback, should the
  1.x line stop receiving fixes, is Zensical (the Material team's drop-in replacement) or a
  re-evaluation at the rebrand checkpoint. See
  <https://squidfunk.github.io/mkdocs-material/blog/2026/02/18/mkdocs-2.0/>.

## Alternatives considered
- **mdBook** — rejected: lightest build (single Rust binary) but a plainer look and far less
  theme flexibility for the rebrandable advisory front-door; search and navigation are weaker
  than Material's.
- **Starlight (Astro/JS)** — rejected: would pull a Node/npm toolchain into a repo that has
  none, the heaviest dependency footprint of the three site options, for no benefit Material
  does not already give here.
- **Pandoc → PDF** — rejected: produces a document, not a browsable front-door. A PDF may still
  be worth generating later as a secondary deliverable, but it does not meet the "owned home"
  goal.
