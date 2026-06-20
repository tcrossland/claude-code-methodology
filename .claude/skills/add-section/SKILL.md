---
name: add-section
description: Add, remove, or rename a numbered section (§N) or lettered appendix in the methodology, applying the append-only rule and updating every cross-reference and count/range claim. Use whenever a methodology section or appendix is added or removed.
allowed-tools: Read, Glob, Grep, Edit, Write, Bash
---

# Add or remove a methodology section or appendix

Section numbers (`§N`) and appendix letters (A–O) are stable, load-bearing identifiers
(the CLAUDE.md invariant). The hard part is never the prose — it is updating every
cross-reference and every count/range claim so nothing dangles or goes stale. The
consistency hook catches a dangling `§`/`Appendix` *reference*, but it does **not** catch a
stale count ("fifteen") or range ("A–O"), so those are on you.

## Rules

- **Append-only.** A new section takes the next free number; a new appendix the next free
  letter. Never renumber or re-letter to keep things tidy — the number/letter is an
  identifier, not a sort key (ADR 0001). An appendix goes in its thematic file under
  `docs/appendices/`; its letter need not match the file order.
- Sections live in `docs/methodology.md` (before the appendices pointer at the end);
  appendices live in `docs/appendices/*.md`, grouped by type, indexed by `docs/appendices/README.md`.

## Steps

1. **Add the content** in the right place (append the section to `docs/methodology.md`, or the
   appendix to the matching `docs/appendices/` file), and update `docs/appendices/README.md`
   if it is an appendix.
2. **Ripple the count/range claims.** These are *not* hook-checked. The grep is the source of
   truth — run it and update every hit; the list below is a starting checklist, not a complete one
   (carriers drift, so trust the grep):
   ```bash
   grep -rnE 'A–[A-Z]|[0-9]+ drop-in|[Ff]ourteen|[Ff]ifteen|[Ss]ixteen' --include='*.md' . \
     | grep -v docs/local | grep -v docs/plans/archive
   ```
   Usual carriers: `README.md` (the count, the invariant mention, the What's-here entry),
   `CLAUDE.md` (Layout + the invariant), `CHANGELOG.md`, the appendices pointer at the end of
   `docs/methodology.md`, `.claude/agents/code-reviewer.md`, `.claude/rules/definition-of-done.md`,
   `.claude/commands/plan.md`, and the reviewer's
   `.claude/agent-memory/code-reviewer/project-repo-shape.md`.
3. **Add a `CHANGELOG.md` `[Unreleased]` line** if the change is user-facing (most are).
4. **Run the consistency hook** on every edited *in-scope* Markdown file (`docs/`, `README.md`,
   `CHANGELOG.md`, `templates/`; it no-ops on `.claude/`) — confirms no dangling reference:
   ```bash
   printf '{"tool_input":{"file_path":"%s"}}' "$PWD/<file>" \
     | CLAUDE_PROJECT_DIR="$PWD" bash .claude/hooks/docs-consistency.sh; echo "exit=$?"
   ```
5. **Run the `code-reviewer` subagent** on the diff and clear any Critical or Warning before merge.

## Out of scope

- Renumbering or re-lettering existing sections/appendices. If that ever seems necessary, raise
  it as a decision (ADR) — do not do it as a side effect of adding something.
