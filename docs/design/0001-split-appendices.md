# ADR 0001 — Split appendices into a grouped companion directory

**Status:** accepted   **Date:** 20/06/2026

## Context
`docs/methodology.md` had grown to ~690 lines, of which ~63% (Appendices A–N) were drop-in
artefacts — subagent definitions, hook scripts, command templates, document skeletons — consulted
by lookup, not read linearly. The narrative (§1–§11) and these artefacts are two different reading
modes fused into one file. A recorded principle (the doc-site backlog item) had said to keep the
methodology a single page "to preserve the load-bearing cross-reference model", on the assumption
that splitting would fracture the section ↔ appendix references. On inspection those references
are all prose, validated by the consistency hook, not markdown anchor links — so the assumption no
longer held. Adding further artefacts (the security checklist) would only deepen the bloat.

## Decision
Move the appendices out of `docs/methodology.md` into `docs/appendices/`, grouped by artefact type
— `subagents.md`, `hooks.md`, `skeletons.md`, `skills-and-commands.md` — with a `README.md` index.
The narrative §1–§11 stays in `methodology.md` with a pointer to the directory. Letters remain
stable, append-only identifiers: a new appendix takes the next free letter (the security checklist
is O) but lives in the file for its kind (O with the skeletons, beside the Definition of Done). The
consistency hook now derives valid section numbers from `methodology.md` and valid appendix letters
from `docs/appendices/*.md`.

## Consequences
- The narrative reads as a coherent ~258-line document; the artefacts are looked up by type.
- New artefacts append cheaply without bloating the narrative, slotting into their thematic file.
- Cross-references between the two now span files, but stay prose and remain hook-validated, so a
  dangling reference is still caught automatically.
- Two locations to keep consistent instead of one, and the range/count claims (A–O, "fifteen")
  ripple across README, `CLAUDE.md`, the reviewer agent and the Definition of Done when a letter
  is added — the price of the load-bearing-letters scheme.
- This reverses the earlier single-page principle; the doc-site backlog item should treat the
  appendices directory as part of the source when that work is taken on.

## Alternatives considered
- **Keep a single page** — rejected: relocates nothing and the bloat only grows; the
  cross-reference fear that motivated it does not apply to prose references.
- **One companion file** (`methodology-appendices.md`) — rejected: relocates the 430-line lump
  without organising it; lookup stays a long scroll.
- **One file per appendix** (fifteen files) — rejected: over-fragments the short skeletons and
  pre-builds the plugin's component layout, which the backlog defers.
