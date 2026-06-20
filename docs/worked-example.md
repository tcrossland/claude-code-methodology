# A Worked Example: Adding a Link-Resolution Check

*Companion to "A File-First Operating Model for Claude Code". Last updated 20/06/2026.*

---

The methodology justifies each piece in isolation but never shows the loop turning. This is
one real task — adding a third check to the repository's consistency hook — traced through
the core loop (§2) with the actual artefacts that changed. It is deliberately
self-referential: the change described here is the change that produced the very check now
guarding this file. Read it as a retrospective, not a tutorial.

## The task

The [Definition of Done](../.claude/rules/definition-of-done.md) lists *"Links and paths
resolve — intra-repo references point at files that exist."* The repository already enforces
two of its consistency rules deterministically through a `PostToolUse` hook (§6),
[`docs-consistency.sh`](../.claude/hooks/docs-consistency.sh): it flags dangling `§N`/Appendix
cross-references (Check A) and US spellings (Check B). But link resolution was still a *manual*
check — caught, if at all, by the human or the reviewer. The task: close that gap by adding
**Check C**, so a link whose target file does not exist fails at edit time.

## Explore

Read-only first (§2). The question that decided the shape of the work was not "how do I check
links" but "what does adding a check disturb?" Two findings changed the plan:

- The hook's check count lives **only in its own header comment** — no methodology section
  states "two checks", so adding a third ripples almost nowhere in the prose.
- Appendix C ([`appendices/hooks.md`](appendices/hooks.md)) holds *generic example* hooks, not
  the live script — the two are decoupled by design. So the change touches **no appendix and no
  `A–O` count claim**. That single fact shrank the blast radius from "fifteen cross-referenced
  files" to "the hook, the changelog line, and one index entry".

The lesson the methodology keeps making: the expensive part of a docs change is the
cross-reference graph, so map it *before* editing, not after.

## Plan, and Challenge

The plan was persisted to `docs/plans/worked-example.md` because the work
was multi-stage (§3). Before committing to it, the **Challenge** pass (§2) earned its keep twice:

- *Is reusing an off-the-shelf checker the right call?* Mature, permissively-licensed tools
  exist (lychee, markdown-link-check). They were **rejected**: each needs a runtime (a Rust
  binary or an npm install), which reintroduces exactly the toolchain the repository's "no
  build, no runtime" invariant forbids — for a job that is ~20 lines of shell against the local
  filesystem. Build-vs-reuse went to *build*, because the dependency cost exceeded what it saved.
- *Will the new check flag this very document?* A worked example about broken links must be able
  to *show* a broken link. That hole in the acceptance criteria drove the one non-obvious design
  decision below.

## Execute

Check C extracts inline links, skips anything that is not a relative path, resolves the target
against the edited file's directory, and flags a miss — mirroring the existing checks' fail-open,
POSIX-sh discipline. The design point that fell out of the Challenge pass: **fenced code blocks
are blanked before extraction**, so an illustrative dangling link inside a fence is ignored. That
is what lets this paragraph show one without the hook flagging the page:

```markdown
See [the missing doc](does/not/exist.md) — outside a fence this would fail Check C.
```

The core of the addition:

```sh
stripped=$(awk '/^[[:space:]]*```/ { f = !f; print ""; next } { if (f) print ""; else print }' "$FILE")
c_hits=$(printf '%s\n' "$stripped" | grep -noE '\]\([^)]*\)' 2>/dev/null || true)
# ... strip ]( ) wrapper, "title", and #fragment; skip schemes/absolute; then:
[ -e "$DIR/$target" ] || findings="${findings}  broken link '${target}' — no such file (line ${ln})\n"
```

## Review and Accept

The change was verified by *running it*, not by reasoning about it (§8) — the acceptance gate
the agent will not apply for you. Synthetic JSON payloads exercised every path: a broken link
gives the expected feedback,

```
docs-consistency: issues in docs/example.md:
  broken link 'does/not/exist.md' — no such file (line 3)
```

while the same link inside a fence, every real in-scope document, and all fail-open cases
(missing file, out-of-repo path, non-Markdown, `.claude/`) exit cleanly. The check parses and
runs identically under `bash` and `sh`.

Then the [`code-reviewer`](../.claude/agents/code-reviewer.md) subagent (§4, Appendix A) read
the diff, and the work was checked against the [Definition of
Done](../.claude/rules/definition-of-done.md) — codified as `/accept` (Appendix K) — before being
called done.

## Wrap

The loop closes where the [backlog](backlog.md) opened it: a manual Definition-of-Done line is
now a deterministic gate, and the friction that motivated it ("the reviewer keeps catching broken
links by hand") became configuration rather than a recurring note — the retro move (§8). The
session is named to match its plan and archived (`/wrap`, Appendix N), so the thread is
recoverable. That is the whole rhythm: explore the blast radius, plan and challenge, execute the
small thing, verify it for real, accept against an explicit bar, and fold the lesson back into
the tools.
