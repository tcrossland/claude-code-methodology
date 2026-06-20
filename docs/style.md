# House voice

How prose in the public docs should read. The aim is tighter, more authoritative writing. It is
not about hiding that the repo is built with Claude.

Applies to the narrative docs: `methodology.md`, `README.md`, `index.md`, `worked-example.md`.
Reference artefacts under `docs/appendices/` are exempt where their structure or punctuation is
deliberate (skeletons, tables, command definitions).

British English and the §N/appendix consistency rule already bind (see `CLAUDE.md` and the
Definition of Done). This guide covers voice, not those.

## Principles

**Lead with the point.** Put the claim or the change first. Cut throat-clearing openers.
- Before: "It's worth noting that the context window is a scarce resource."
- After: "The context window is scarce."

**Prefer short sentences.** Break a long, qualified sentence into two. A reader should not have
to hold three clauses at once.
- Before: "The plan, which lives in a file so it survives compaction, is loaded by stage rather
  than whole, because reloading it in full taxes the context window on every turn."
- After: "The plan lives in a file so it survives compaction. Load it by stage, not whole: a full
  reload taxes the context window every turn."

**Vary the rhythm.** A run of same-length sentences reads as generated. Set a short sentence
against a longer one. Read it aloud; if the cadence is flat, recast.

**Use em-dashes sparingly.** Reach for a comma, a full stop, or parentheses first. One em-dash in
a paragraph is plenty; three is a tell.
- Before: "Hooks are your CI — deterministic, fast — and they catch what review misses."
- After: "Hooks are your CI: deterministic and fast. They catch what review misses."

**Drop formulaic constructions.** These read as machine cadence; rewrite to a plain declarative:
- "not just X, but Y"
- "it's not X, it's Y"
- the reflexive rule-of-three triad ("fast, cheap, and reliable") where two terms would do
- "Note that", "It's important to", "Simply"

**Cut hedging.** Delete "quite", "fairly", "arguably", "in many cases" unless the qualification
carries real weight. State the claim, or drop it.

**No emoji. No decorative bold.** Bold a term on first definition at most.

## Self-test

Before committing prose, scan for: an em-dash a comma would replace, a "not X but Y", a default
triad, an opening hedge, three same-length sentences in a row. Fix what you find.
