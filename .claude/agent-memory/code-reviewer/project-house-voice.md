---
name: project-house-voice
description: docs/style.md is the house-voice authoring guide; what it governs and how it interacts with the existing invariants
metadata:
  type: project
---

`docs/style.md` ("House voice") is an authoring convention for prose in the narrative public
docs (`methodology.md`, `README.md`, `index.md`, `worked-example.md`). Reference artefacts under
`docs/appendices/` are exempt where structure/punctuation is deliberate. It is `exclude_docs` in
`mkdocs.yml` (not published) and pointed at from `CLAUDE.md` Conventions by one line.

Its rules: lead with the point (no throat-clearing openers), prefer short sentences, vary
rhythm, em-dashes sparingly (one per paragraph max), drop formulaic constructions ("not just X
but Y", "it's not X it's Y", default rule-of-three triads, "Note that"/"It's important to"/
"Simply"), cut hedging ("quite"/"fairly"/"arguably"/"in many cases"), no emoji/decorative bold.

**Why:** the public docs read as AI-generated, which undercut the "human judgement, not vibes"
positioning. The guide gives future prose edits an acceptance criterion. It is explicitly *not*
about hiding that the repo is built with Claude.

**How to apply:**
- When reviewing prose edits to the four narrative docs, check them against these rules, not
  just British-English/§N consistency. The backlog "Tighten the public prose" item (Next) is the
  bounded copy-edit that will apply the guide to existing prose.
- The guide must obey its own rules (it currently does: zero em-dashes in its prose as of the
  20/06/2026 review; em-dashes appear only inside its "Before:" anti-examples). If you edit it,
  re-run the self-test it documents.
- It deliberately *cross-references* the British-English and §N/appendix rules rather than
  restating them — keep it that way to avoid the duplication defect.
- It is internal authoring convention, excluded from the site, so it does not by itself need a
  CHANGELOG line. See [[feedback-recurring-defects]] and [[project-doc-site]].
