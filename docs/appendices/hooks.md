# Methodology appendices — hooks

Drop-in project hooks for the methodology. Companion to `../methodology.md`; the full A–O index is in this directory's `README.md`.

## Appendix C — project hooks

`.claude/settings.json` (excerpt)

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/bash-guard.sh" }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/format-and-test.sh" }
        ]
      }
    ]
  }
}
```

`.claude/hooks/bash-guard.sh` — block a destructive command class

```bash
#!/bin/bash
# Reads the tool call as JSON on stdin; exit 2 blocks and returns stderr to Claude.
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if echo "$COMMAND" | grep -iE '\brm -rf\b|\bgit push --force\b|\bDROP TABLE\b' > /dev/null; then
  echo "Blocked: destructive command. Run it yourself if you really mean it." >&2
  exit 2
fi
exit 0
```

`.claude/hooks/git-guard.sh` — block blanket staging and unreviewed commits/pushes (§9)

```bash
#!/bin/bash
# Add as a second PreToolUse "Bash" hook, or fold into bash-guard.sh.
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Blanket adds sweep up other sessions' files and ignored artefacts.
if echo "$COMMAND" | grep -iE '\bgit add\b.*(-A|\.|--all)\b' > /dev/null; then
  echo "Blocked: stage explicit paths (git add <path>), not the whole tree." >&2
  exit 2
fi

# Commits and pushes go through you, not the agent.
if echo "$COMMAND" | grep -iE '\bgit (commit|push)\b' > /dev/null; then
  echo "Blocked: commits and pushes are reviewed by the human. Summarise the diff instead." >&2
  exit 2
fi
exit 0
```

