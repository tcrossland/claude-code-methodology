---
description: Check a change against this project's Definition of Done before calling it complete.
---

Check the current change against the Definition of Done. Do not declare it done until
every item is verified — you will not do this for me unless asked, so I am asking.

1. Run `git diff` (and `git status`) to see exactly what changed.
2. Walk the Definition of Done in `.claude/rules/definition-of-done.md` item by item. For
   each, state the evidence and report PASS / FAIL — not a vibe. (That file is path-scoped,
   so reading the changed files will usually have loaded it already.)
3. If anything FAILS or cannot be verified, stop and report it plainly. Do not work around
   it or soften the wording; list exactly what remains.
4. Only when every item passes, report the change ready.
