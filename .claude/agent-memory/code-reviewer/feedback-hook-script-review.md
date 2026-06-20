---
name: feedback-hook-script-review
description: What to check when reviewing the repo's bash hooks (PostToolUse docs-consistency and successors) — portability and scope-gate traps
metadata:
  type: feedback
---

When reviewing shell hooks in `.claude/hooks/`, check these specifically (the first one, `docs-consistency.sh`, shipped 20/06/2026 — see [[project-repo-shape]]):

- **Shebang vs invocation shell.** Hooks are invoked by their executable path from `.claude/settings.json` (`$CLAUDE_PROJECT_DIR/...`), so they run under their shebang — but if the exec bit is ever lost, Claude Code may fall back to `sh`. A bash-only construct (e.g. process substitution `done < <(...)`) is a **parse-time** syntax error under `sh`, so a runtime re-exec guard cannot rescue it → exit 2 on every edit. `docs-consistency.sh` keeps `#!/usr/bin/env bash` but its body is deliberately POSIX sh-clean (heredoc-fed `while`, not process substitution), so it parses and runs identically under both shells. **Verify any new hook with `sh -n hook.sh`.** This is the single most likely way a hook breaks editing.
- **Scope gate uses `$CLAUDE_PROJECT_DIR` (project hook), not `${CLAUDE_PLUGIN_ROOT}`.** Correct for a settings.json hook. When hooks move into the plugin (packaging-as-a-plugin), intra-plugin paths must switch to `${CLAUDE_PLUGIN_ROOT}`.
- **`\b...\b` word boundaries are safe against substring over-match** on BSD/macOS grep (`grayscale` does not match `\bgray\b`, `catalogue` not `\bcatalog\b`, `epicenter` not `\bcenter\b`). Verified on macOS BSD grep. The US-spelling wordlist is curated exact-word data and lives only in `.claude/` (out of scope) so it never self-flags.
- **Known false-negative gaps (acceptable, not defects):** plural `Appendices A & C` is NOT checked (regex is `Appendix [A-Z]` with trailing space). Per-file run means a batch adding both a new section and a forward-ref can transiently flag. Both are documented in the script header.
- **Fail-open discipline is correct:** missing jq, empty/malformed stdin, no file_path, non-existent or out-of-repo file, non-markdown, `.claude/**`, `docs/local/**` all exit 0. A hook that errors/hangs is worse than one that misses — confirm every early-exit path returns 0.

**How to apply:** run the hook directly with synthetic JSON payloads (`printf '{"tool_input":{"file_path":"..."}}' | bash hook.sh; echo $?`) across these cases rather than reasoning about it. Confirm in-scope dangling refs/US spellings give exit 2 and everything else gives exit 0.
