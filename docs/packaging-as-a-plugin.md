# Packaging the Methodology as a Plugin

*Companion to "A Methodology for Driving Claude Code". Last updated 19/06/2026.*

---

## Why this is the endpoint, not an extra

Everything the methodology builds — the `code-reviewer` and `test-writer` subagents, the git and format hooks, the `.claude/rules/` Definition of Done, the ritual commands (`/plan`, `/accept`, `/retro`, `/release`, `/wrap`), the skills — currently lives scattered across a project's `.claude/` directory and `settings.json`. That works for one repo. The moment you want the same setup in a second project, you are copy-pasting, and the copies drift.

A **plugin** is the smallest unit of distribution for a Claude Code setup: one directory that bundles agents, skills, commands, hooks, and MCP wiring, with a small manifest, installable into any project in one step. So the practical payoff is that your operating model stops being per-project scaffolding and becomes one versioned thing you drop in anywhere.

The strategic payoff matters more, and it is the reason to treat this as the natural conclusion of the whole exercise. An advisory or productised-methodology offering aimed at experienced engineers sells far better as an *installable, opinionated harness* — "here is my Claude Code operating model, `plugin install` it" — than as a document of principles. The methodology doc is the explanation; the plugin is the thing people actually adopt and keep. If you are taking your work in the direction of B2B methodology content, the plugin is the deliverable and the document is the marketing.

> **Versioning note.** Plugin mechanics are moving quickly. The structure below was current as of mid-2026; confirm the manifest schema and directory conventions against the official plugins reference before building, and update Claude Code if `/plugin` is not recognised.

---

## The shape of a plugin

Claude Code prefers **convention over configuration**: get the directory shape right and components are discovered automatically.

```
my-methodology/
├── .claude-plugin/
│   └── plugin.json          # Manifest: name, description, version
├── commands/                # /command macros — one .md file each
│   ├── plan.md
│   ├── accept.md
│   ├── retro.md
│   ├── release.md
│   └── wrap.md
├── agents/                  # Subagents — one .md file each
│   ├── code-reviewer.md
│   └── test-writer.md
├── skills/                  # One subdirectory per skill
│   └── add-importer/
│       └── SKILL.md
├── hooks/
│   └── hooks.json           # Same format as settings.json hooks
├── .mcp.json                # MCP servers, if any
└── scripts/                 # Hook scripts, helpers
    ├── bash-guard.sh
    └── git-guard.sh
```

A minimal manifest:

```json
{
  "name": "my-methodology",
  "description": "An opinionated, file-first Claude Code operating model for solo developers.",
  "version": "0.1.0"
}
```

Three rules that prevent the usual silent failures:

- **Component folders live at the plugin root, never inside `.claude-plugin/`.** Nesting them there makes the plugin load while its components silently vanish — the single most common structural mistake.
- **Use `${CLAUDE_PLUGIN_ROOT}` for every intra-plugin path.** A hook that references `./scripts/git-guard.sh` by an absolute or home-relative path works on your machine and breaks on anyone else's. `${CLAUDE_PLUGIN_ROOT}/scripts/git-guard.sh` is portable.
- **`.claude/rules/` is not a plugin component directory.** Rules are loaded from the project, not bundled the way commands/agents/skills/hooks are. Ship project conventions either as a skill, as instructions in the agents that need them, or as a documented `CLAUDE.md` block your installers paste in. Confirm current behaviour against the reference — this is exactly the kind of detail that shifts between releases.

After install, a plugin's skills and commands are **namespaced** under the plugin name, e.g. `/my-methodology:retro`, which avoids collisions with a project's own.

---

## What to package — and what to leave out

Map straight from the methodology's appendices:

| Methodology piece | Plugin component | Notes |
|---|---|---|
| `code-reviewer`, `test-writer` (Appendix A, B) | `agents/*.md` | See the agent caveat below |
| Project hooks + git guard (Appendix C) | `hooks/hooks.json` + `scripts/` | Hook format is identical to `settings.json` |
| `/plan`, `/accept`, `/retro`, `/release`, `/wrap` (Appendices J–N) | `commands/*.md` | Your rituals |
| `add-importer` and similar (Appendix I) | `skills/<name>/SKILL.md` | Project-agnostic procedures travel well; project-specific ones may not |
| Definition of Done (Appendix E) | a skill, or a documented `CLAUDE.md` block | Not a bundled rules dir |
| Plan / backlog / ADR skeletons (Appendix D, F, G) | a `/scaffold-docs` command, or a skill | Turn the templates into something that writes the files |

**One important agent caveat.** Plugin-shipped subagents support `name`, `description`, `model`, `effort`, `maxTurns`, `tools`, `disallowedTools`, `skills`, `memory`, `background`, and `isolation` (only `worktree`). For security reasons they do **not** support `hooks`, `mcpServers`, or `permissionMode` in frontmatter — those are silently ignored when an agent loads from a plugin. So the `test-writer` agent's frontmatter `PreToolUse` guard (Appendix B) will not travel inside the plugin. Move that guard to the plugin's `hooks/hooks.json` matched on the agent, or keep that agent as a project-level file rather than a plugin component.

**Curate, do not dump.** The fastest way to build a bad plugin is to copy your whole `.claude/` directory into it. That carries your machine-specific paths, personal endpoints, and experiment-grade half-skills into something other people install. A plugin is a product, not a backup of your setup. Decide deliberately what is general (ships) versus what is project-specific or personal (stays local).

---

## Migration path (you already have most of it)

If the methodology is already running in a project, conversion is mechanical:

1. `mkdir -p my-methodology/.claude-plugin` and write `plugin.json`.
2. `cp -r .claude/commands my-methodology/`, same for `agents/` and `skills/`.
3. Move your `settings.json` hooks into `hooks/hooks.json` — the format is the same — and rewrite script paths to `${CLAUDE_PLUGIN_ROOT}/...`.
4. Test locally with the `--plugin-dir` flag (or `/plugin`), checking each component appears and fires before you trust it.
5. When you want others to install it, publish through a **marketplace** — a small catalogue that points at the plugin's source (a GitHub repo is the common host). Installers then run `/plugin install my-methodology@your-marketplace`.

---

## Recommended sequencing

Don't build the whole plugin up front. Run the methodology unpackaged in one real project until the agents, hooks, and a handful of skills have earned their place through actual use — the retro habit (§8) is what tells you which pieces are worth keeping. *Then* package the proven set. A plugin assembled from battle-tested components is a product; one assembled from speculation is a liability you have to maintain.

For the advisory angle specifically, the plugin and the methodology document are a pair: ship the plugin as the adoptable artefact, keep the document as the rationale that explains *why* each component is shaped the way it is. The document earns trust; the plugin earns adoption.
