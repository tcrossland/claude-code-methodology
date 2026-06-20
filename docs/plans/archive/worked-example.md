# Plan: Worked example — add a link-resolution check, traced through the loop   (approved 20/06/2026)

**Status:** done (20/06/2026) — all four stages complete; Check C (link resolution) live in
`docs-consistency.sh` and the worked-example companion shipped, both reviewer- and DoD-clean.

## Context
Backlog `Now` item: the methodology justifies each piece in isolation but never shows the
loop running. This delivers **two coupled things**: (1) a real, useful change — a third check
in `.claude/hooks/docs-consistency.sh` that enforces the DoD's "links and paths resolve" item;
and (2) a narrative companion doc that traces *that very change* through Explore → Plan →
Challenge → Execute → Review → Accept → `/wrap`. Self-referential by design: the example
documents its own making.

## Blast radius (verified)
- **No appendix touched.** Appendix C (`docs/appendices/hooks.md`) holds *generic example*
  hooks, not the live `docs-consistency.sh` — decoupled by design. No `A–O`/"fifteen" claim moves.
- **No methodology count claim.** §6 mentions PostToolUse generically; the "two checks" wording
  lives only in the hook's own header comment.
- Disturbed cross-references: only the hook header, `CHANGELOG.md:31` (functional description),
  the README "What's here" index, and the new doc's own references.

## Design — Check C (intra-repo markdown link resolution)
- Extract `[text](target)` and `![alt](target)`; **skip fenced code blocks**, external schemes
  (`http(s)://`, `mailto:`, protocol-relative `//`), pure anchors (`#…`), and absolute `/…` paths
  (documented gap).
- Strip trailing `#anchor` and `"title"`; resolve `target` against `dirname($FILE)`; flag if
  `[ -e ]` fails (so directory targets like `docs/appendices/` pass).
- Same **fail-open / POSIX-sh** discipline as A/B: heredoc-fed `while`, no process substitution;
  verify `sh -n`.
- **Skipping fenced code is what lets the example doc show dangling-link samples without flagging
  itself** — the one non-obvious design point.
- Known gaps (document in header): reference-style links `[x][ref]`/`[ref]:`, absolute paths,
  links inside code (intentionally unchecked). A/B stay unchanged (asymmetry noted).

## Stages
**Stage 1 — implement & test Check C   [done]**
- Add Check C + update the header comment ("two defect classes" → three; add limitation notes).
- Acceptance: `sh -n` clean; run under both `bash` and `sh`; run against **every** in-scope `.md`
  → all exit 0 (no false positives on current content); a synthetic `[x](docs/missing.md)` →
  exit 2 with correct line; fail-open cases (no `jq`, missing/out-of-scope/non-md file) → exit 0.

**Stage 2 — write `docs/worked-example.md`   [done]** (Check C caught a `](path)` placeholder
and a mis-targeted `code-reviewer` link in the draft — both fixed; dogfooding in action.)
- Companion doc matching the packaging-doc pattern. Narrate the Stage-1 work through the loop (§2),
  with real excerpts. Illustrative dangling links shown **inside code fences**.

**Stage 3 — wire indexes   [done]** (README + CHANGELOG hook descriptions also updated to name
the third check; methodology §2 pointer added.)
- README "What's here": add the companion line after the packaging entry.
- `CHANGELOG.md [Unreleased]`: amend line 31 to describe the third check; add an Added line for
  the worked-example doc.
- Optional: one pointer from methodology §2 → the worked example.

**Stage 4 — review & accept   [done]** (code-reviewer: 0 Critical/Warning, 1 suggestion applied;
`/accept` DoD walk: all items PASS.)
- `code-reviewer` on the full diff; `/accept` against the DoD; confirm the hook is green on all
  changed docs.

## Out of scope
- Any external/HTTP link checking (lychee etc. deferred).
- Retrofitting code-fence skipping into Checks A/B.
- A new appendix (this is a companion doc, not a drop-in artefact) — no `A–O` ripple.
- Reference-style and absolute-path link support.

## Deviations / decisions
- Scheme exclusion generalised from an enumerated list (`http://`, `mailto:`, …) to "any
  target containing a colon", since colons never occur in this repo's relative paths — this
  also catches `tel:`/`ftp:` without enumerating them. Documented in the hook header limitation (3).
- Stage 1 acceptance all green: `sh -n`/`bash -n` clean; exit 0 on all 10 in-scope docs; broken
  link → exit 2 (correct line) under both bash and sh; fenced-identical link → exit 0; fail-open
  on missing/out-of-repo/non-md/.claude paths.

<!-- Completed in-session 20/06/2026; archived under docs/plans/archive/ (§3). The worked example doubled as the test case for its own subject — Check C flagged a placeholder link in the draft. -->
