# A File-First Operating Model for Claude Code

A single-developer discipline for driving Claude Code. It treats the harness as an engineered
environment: the discipline lives in **what you persist to files** and **what you enforce
deterministically**, not in clever prompting. Written for experienced solo developers and small
teams.

## Start here

- **[The methodology](methodology.md)** — the full reference: context architecture, the work
  loop, plan and status persistence, subagents, the model/mode matrix, hooks as a CI substitute,
  sessions and git hygiene, skills and commands, solo product discipline, and a security stance.
- **[Worked example](worked-example.md)** — one real task traced end to end through the loop.
- **[Appendices](appendices/README.md)** — the drop-in artefacts: subagents, hooks, document
  skeletons, the example skill, and the ritual commands.
- **[Packaging as a plugin](packaging-as-a-plugin.md)** — how the methodology becomes a
  distributable Claude Code plugin, and why that is the endpoint.

## Using it

1. Read [the methodology](methodology.md).
2. Drop the starter `CLAUDE.md` template into a project and fill it in.
3. Adopt the loop, the file layout, and the appendix artefacts as they earn their place, not
   all at once.

The source is plain Markdown, readable on its own; this site renders it. It is licensed
Apache-2.0: free to use, modify, and redistribute, including commercially.
