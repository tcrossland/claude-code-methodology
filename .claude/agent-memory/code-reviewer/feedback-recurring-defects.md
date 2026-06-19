---
name: feedback-recurring-defects
description: The defect classes that actually recur in this prose-heavy methodology repo
metadata:
  type: feedback
---

Defect classes seen in this repo (check these specifically each review):

1. **CHANGELOG entries describing things that aren't in the docs.** The changelog is curated prose, easy to over-claim. Verify each [Unreleased] line against the actual document state — e.g. a claimed "at-a-glance block near the top" that doesn't exist as a block.
2. **Cross-doc pointers to the wrong doc.** A public doc (README) pointing readers at a doc that doesn't contain the referenced rationale — especially when the real content lives in an internal/untracked note.
3. **Path/term drift between methodology prose and the live `.claude/` config.** e.g. methodology calls the memory layer `memory/` but `memory: project` resolves to `.claude/agent-memory/`.
4. **Local-config / secrets protection living only in the user's global gitignore, not the repo `.gitignore`.** `settings.local.json` is safe on this machine via `~/.config/git/ignore` but unprotected for any clone.

**Why:** these are the quiet ones — §N and appendix-letter refs are usually correct because they're obviously load-bearing; the prose-accuracy and config-drift mismatches are what slip through.
**How to apply:** don't just check that refs resolve — check that descriptive claims (changelog, README, doc-to-doc pointers) are *true* against current file contents. See [[project-repo-shape]].
