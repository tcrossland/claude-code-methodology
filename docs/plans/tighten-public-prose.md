# Plan: Tighten the public prose to the house voice   (approved 20/06/2026)

**Status:** in progress — Stage 2 (methodology front half). Stage 1 (README) done; voice
calibrated with the user 20/06/2026: keep term–gloss list dashes, light-touch intensity (guide
unchanged).
<!-- Active plan; pointer in docs/backlog.md ## Now. Branch: chore/tighten-prose. -->

## Goal
A bounded, meaning-preserving copy-edit of the four narrative docs against `docs/style.md`, so
the public docs read as authoritative rather than AI-generated. Scope agreed with the user: all
four narrative docs; pause after README to calibrate the voice before the long doc.

## Constraints (every stage)
- Voice only, meaning preserved — re-phrasing, not re-thinking. Leave and flag anything unclear.
- §N / appendix (A–O) cross-references intact (load-bearing); British English; intra-repo links
  resolve; `mkdocs build --strict` clean. The PostToolUse consistency hook backstops these.
- Reduce em-dashes where they're a tell (~1/paragraph is fine); don't zero them.

## Out of scope
- `docs/appendices/` artefacts (style guide exempts them); any content/guidance change; §N/letter
  renumbering.

## Stage 1 — README.md (calibration checkpoint)   [done]
- [x] Edit to the guide; preserve links and structure. (em-dashes 16→7; remaining are list dashes)
- [x] Show the user the diff; calibrated — keep list dashes, light touch; guide unchanged.
- Acceptance: reads against the guide; meaning unchanged; links resolve; British English.

## Stage 2 — methodology.md, front half (Operating principle → §6)   [current]
- [ ] Section pass (heaviest §1); heading em-dashes case-by-case (no `#anchor` targets them).
- Acceptance: voice-only diff; §-refs and the §1 table intact; build --strict clean.

## Stage 3 — methodology.md, back half (§7 → §11)   [not started]
- [ ] Section pass (heaviest §8, §10, §11).
- Acceptance: as Stage 2; full-file build --strict clean.

## Stage 4 — index.md + worked-example.md   [not started]
- [ ] Light pass; leave fenced code, GitHub blob URLs, and the does/not/exist.md demo untouched.
- Acceptance: voice-only; demo and blob URLs unchanged.

## Verification
- Per doc: `git diff` is voice-only; `grep -c '—'` before/after as a sanity check (not a target).
- `.venv/bin/mkdocs build --strict` clean after the methodology edits.
- `code-reviewer` on the full diff before merge (meaning-preservation + obeys the guide).
- CHANGELOG: decide at /accept — lean to one `[Unreleased]` line; non-substantive, so not clear-cut.
