# Plan: §11 Security — consolidate the stance   (approved 20/06/2026)

**Status:** done (20/06/2026) — §11 written, consistency wired up, hook + reviewer clean.
<!-- Completed in-session; no active-plan pointer was set. Archived under docs/plans/archive/ (§3). -->>

## Goal
Add a single `## 11. Security` section that consolidates the security material currently
scattered across §4/§5/§6/§9 and Appendices A & C (by cross-reference, not restatement) and
fills the genuine gaps: untrusted-content/prompt-injection, plugin/MCP trust, folder-trust, and
Bash sandboxing. Prose-only — no new appendix — so the A–N invariant is untouched. Appended as
§11 so no existing section renumbers and no §-reference breaks.

Claude Code security facts grounding the section were verified via claude-code-guide against
current docs on 20/06/2026 (folder-trust prompt, Bash sandboxing Seatbelt/bubblewrap, WebFetch
separate-context, command-injection detection, fail-closed Bash, `bypassPermissions` semantics,
MCP/plugin reviewed-for-listing-not-security-audited).

## Out of scope
- A new security-checklist appendix (it would extend the appendix range past N) — deferred;
  sketch shown to the user 20/06/2026 for a later decision.
- An injection-guard hook in Appendix C — prompt injection is not reliably script-detectable;
  a hook there would over-promise.
- The MCP tool-surface **context-cost** treatment — separate backlog item; §11 covers trust only.
- Reworking §5/§6/§9 content beyond the two `(see §11)` pointers.

## Stage 1 — write §11   [done]
- [x] Append `## 11. Security — the trust boundary` after the §10 `---` (methodology.md:241).
- [x] Five threads: secret hygiene; least privilege (+ sandboxing); deterministic guards
      (+ folder-trust, hooks-as-risk); untrusted content / prompt injection; plugin & MCP trust.
- Acceptance: every Claude Code claim matches the verified facts (no invented features); the
  "don't put secrets in CLAUDE.md" caveat is phrased as the methodology's own rule, not
  attributed to the docs; British English ("defence-in-depth"); no instruction merely repeats an
  existing section (cross-reference instead); all §/appendix refs in §11 resolve.

## Stage 2 — wire up consistency   [done]
- [x] Two `(see §11)` pointers: §5 `bypassPermissions`, §9 credential leaks.
- [x] README "What's here" prose list += a security stance; "(A–N)" confirmed unchanged.
- [x] Grep for stale section-count claims — found one in the reviewer's repo-shape memory
      (`§1–§10`); updated to `§1–§11`.
- [x] CHANGELOG `[Unreleased]` Added line.
- [x] Consistency hook clean on every edited file; `code-reviewer` on the diff.

## Deviations
- 20/06/2026, Stage 1 — the consistency hook fired *live* on this plan file and flagged its
  forward-references to §11 (not yet written) and a deliberately-hypothetical checklist appendix
  named with a post-N letter. Both were expected, not defects: the §11 refs resolved once §11 was
  written; the appendix literal was reworded to not imply such an appendix exists. Real signal
  that `docs/plans/` may not belong in the hook's scope (active plans routinely forward-reference,
  and meta-docs *discuss* references) — captured as a backlog candidate.

## Decisions
- 20/06/2026 — prose-only §11, no new appendix — keeps the A–N invariant untouched; the
  checklist drop-in is deferred pending the user's view on the sketch.
- 20/06/2026 — append as §11 rather than insert mid-document — preserves every existing
  §-reference; the alternative (a security section earlier in the flow) would renumber.
