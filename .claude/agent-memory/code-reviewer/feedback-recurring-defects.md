---
name: feedback-recurring-defects
description: The defect classes that actually recur in this prose-heavy methodology repo
metadata:
  type: feedback
---

Defect classes seen in this repo (check these specifically each review):

1. **CHANGELOG entries describing things that aren't in the docs.** The changelog is curated prose, easy to over-claim. Verify each [Unreleased] line against the actual document state — e.g. a claimed "at-a-glance block near the top" that doesn't exist as a block.
2. **Pointers to a target that doesn't contain the referenced thing.** A public doc (README) pointing readers at a doc that doesn't contain the referenced rationale — especially when the real content lives in an internal/untracked note. Seen: the licence README sending readers to `NOTICE` for the no-marks clause that actually lives in `LICENSE` §6 (NOTICE only carries copyright + a pointer to LICENSE). Also the *intra-document* variant — a `(§N)` that resolves to a real section which nonetheless doesn't cover the cited convention: §11 cited "the `docs/local/` convention (§1)" but §1 never mentions `docs/local/` (it's a CLAUDE.md convention). So `§N` resolving to a section is not enough — open the section and confirm it actually covers the thing being attributed to it.
3. **Path/term drift between methodology prose and the live `.claude/` config.** e.g. methodology calls the memory layer `memory/` but `memory: project` resolves to `.claude/agent-memory/`.
4. **Local-config / secrets protection living only in the user's global gitignore, not the repo `.gitignore`.** `settings.local.json` is safe on this machine via `~/.config/git/ignore` but unprotected for any clone.

**Why:** these are the quiet ones — §N and appendix-letter refs are usually correct because they're obviously load-bearing; the prose-accuracy and config-drift mismatches are what slip through.
**How to apply:** don't just check that refs resolve — check that descriptive claims (changelog, README, doc-to-doc pointers) are *true* against current file contents. See [[project-repo-shape]].
