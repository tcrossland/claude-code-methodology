# A File-First Operating Model for Claude Code

*A single-developer discipline for driving Claude Code. Last updated 19/06/2026.*

---

## Operating principle

This is an **operating model**: a file-first way of working you keep running, not a procedure you run once; "the methodology" is the shorthand used for it throughout.

You are not prompting a chatbot; you are engineering a repeatable environment. The model's **attention** and its **context window** are the scarce resources. A good methodology is therefore mostly a set of decisions about two things:

1. **What you persist to files** — so intent survives compaction, session restarts, and your own forgetfulness.
2. **What you enforce deterministically** — so correctness does not depend on the model remembering a rule.

Everything below follows from that. As a solo developer with no CI pipeline, the second point matters more for you than for most: hooks and a review subagent *are* your CI.

> **Versioning note.** Claude Code's surface moves quickly and several features below are version-gated (forks, nested subagents, the `opusplan` setting, `.claude/rules/`). Confirm against your installed version with `claude --version` and the `/help` and `/hooks` menus before relying on any specific mechanic.

---

## 1. Context architecture: what lives where

The governing distinction is **always-loaded vs loaded-on-demand**. `CLAUDE.md` is injected into context on every turn, so it is expensive real estate. Detailed material (architecture, plans, design decisions, and conditional rules) belongs in files under `docs/` and `.claude/rules/` that load only when relevant.

| Layer | File(s) | Loading | What belongs here |
|---|---|---|---|
| Global rules | `~/.claude/CLAUDE.md` | Always, all projects | Personal conventions: language/spelling, commit style, "ask before X", default tooling |
| Project rules + invariants | `./CLAUDE.md` (+ nested `./module/CLAUDE.md`) | Always | Hard constraints/invariants, build/test commands, a pointer to the active plan (one pointer; see §3), links into `docs/`. Nested files append; closest-to-cwd wins. Keep it lean |
| Path-specific / conditional rules | `.claude/rules/*.md` | When the path or rule matches | Anything that applies to *some* of the tree, not all of it, including the Definition of Done |
| Architecture (explanatory) | `docs/architecture.md` | On demand (linked; read when relevant) | Component breakdown, diagrams, data model, rationale: everything that is *not* a must-obey constraint |
| Design decisions | `docs/design/*.md` (ADRs) | On demand | Architecturally significant, costly-to-reverse decisions and their reasoning |
| Plans (status folded in) | `docs/plans/<name>.md` | On demand, stage-granular | Detailed, multi-stage plan; its status lives in the same file (see §3) |
| Skills (procedural) | `.claude/skills/<name>/SKILL.md` | On demand (model- or `/`-invoked) | A reusable *procedure*: how to do a recurring task; the body loads only when invoked (see §10) |
| Agent / persistent memory | `.claude/agent-memory/<agent>/` for `project` scope (or the `user`/`local` equivalent set by the subagent `memory:` field) | Recalled when relevant | Durable, hard-won learnings to carry across sessions, *not* facts the repo, git history, or `CLAUDE.md` already record |

**Keep `CLAUDE.md` lean and stable.** The common failure is letting it accrete into a several-hundred-line dumping ground. Once it is long, two bad things happen: you pay context tax on every turn for rules that rarely fire, and the model deprioritises earlier system-level instructions in long sessions. A useful test: *if a rule would not apply to most turns, it does not belong in `CLAUDE.md`*. Move it to `.claude/rules/` or a doc under `docs/`. Official cost guidance agrees: move instructions from `CLAUDE.md` to skills, and offload processing to hooks.

**Split the architecture document out, but not the invariants with it.** A large architecture document has no business loading on every turn, so the explanatory bulk (components, diagrams, rationale) belongs in `docs/architecture.md`, referenced from `CLAUDE.md`. The trap: `CLAUDE.md` is *guaranteed* in context, whereas a linked doc is read only if Claude opens it. So the *hard constraints* (the rules that must hold on every change) have to stay as a short "Invariants" block in `CLAUDE.md`; a constraint sitting solely behind a link is one Claude will eventually violate because it never read the file. The line to cut along is "rules that must always be obeyed" (`CLAUDE.md`) versus "background consulted when relevant" (`docs/`). One caveat on mechanism: importing a file into `CLAUDE.md` (the `@`-style import) pulls its *full* content into the always-loaded path, reintroducing the cost you are avoiding. For a large doc, use a plain path reference Claude reads on demand, not an import. Confirm import-vs-reference behaviour in your installed version.

**Keep a Working agreement in `CLAUDE.md`.** Alongside the invariants, the project `CLAUDE.md` carries a short *Working agreement* — the how-we-work rules (plan discipline, review-before-merge, verify-don't-assume) that the sections below justify. Cross-project rules that hold regardless of the repo (worktree hygiene, verify-before-asserting) belong in `~/.claude/CLAUDE.md`; project-bound rules that name this repo's commands, branches, or subagents stay in the project file. The canonical text is in the template (`templates/CLAUDE.template.md`); this document explains those rules in the sections that follow rather than reproducing them, so the agreement has one source of truth, not three.

**Treat the memory directory like `CLAUDE.md`, not a journal.** Agent memory (the `memory:` scope, §4) is real persistence, so it earns the same discipline as every layer above: write only the non-obvious, one fact per entry, and don't store what the repo, git history, or `CLAUDE.md` already record. Two hazards are specific to it. A *stale* recalled memory is worse than `CLAUDE.md` drift. It surfaces as authoritative background you may not think to question, so prune on contradiction, and re-verify any memory that names a file, flag, or version before acting on it. And recall is itself a context cost, so a speculative pile of memories taxes every session that triggers them. Periodic consolidation is the memory analogue of the retro (§8): the `consolidate-memory` skill merges duplicates, fixes stale facts, and prunes the index.

**The tool surface is context too.** Every connected MCP server puts its tool definitions into the same scarce window as `CLAUDE.md`. A chatty server's schemas can rival a long instructions file. The scarcity logic from the file layers carries over unchanged: most tools won't fire on most turns, so they shouldn't sit in context up front. Claude Code now does this for you: **Tool Search** is on by default, deferring each server's full schemas and loading only tool *names* until Claude actually reaches for one. You tune it through `ENABLE_TOOL_SEARCH` (`auto:N` switches to a threshold instead, deferring only once the combined tool definitions across all servers would exceed N% of the window; `false` disables deferral entirely) and through `alwaysLoad: true` on a single server in `.mcp.json` to opt that one back into eager loading. Two caveats. Deferral needs a model that supports tool-reference lookups, so a Haiku-backed agent (Explore, §4) falls back to loading everything. And deferral shrinks the *resting* cost, not the *catalogue*. A server you never use is better disabled (`disabledMcpjsonServers`, or simply not connected) than deferred. That last point is also least privilege: the narrowest tool surface is both the cheapest context and the smallest attack surface (§11), and `mcp__<server>__<tool>` allow/deny rules in `settings.json` narrow what a connected server can actually do.

**One subtlety.** The built-in **Explore** and **Plan** subagents deliberately skip your `CLAUDE.md` and git status to stay fast and cheap. So a rule that *must* reach exploration ("ignore `vendor/`") has to be restated in the delegating prompt, not merely parked in `CLAUDE.md`.

---

## 2. The core loop

```
Explore → Plan → Challenge → (persist plan) → Execute → Review → Accept → (update status) → repeat
                                                                                  └─ at phase end: Retro → config changes
```

| Stage | Mechanism |
|---|---|
| Explore | Plan mode (read-only), or let Claude delegate to the read-only **Explore** agent (Haiku) |
| Plan | Still in plan mode; research via the **Plan** subagent; plan presented through the exit-plan tool. Nothing is written until you approve. Codify as `/plan` (Appendix J) |
| Challenge | Adversarial pass *before* you commit to the plan: cast Claude as a sceptic ("what's this missing? why might it not be worth doing?"). The cheap synthesis of the role tension you lose solo (see §8) |
| Persist | Write the approved plan to `docs/plans/<name>.md` *before* execution (see §3) |
| Execute | Drop to an edit-capable mode on a feature branch or worktree |
| Review | Your `code-reviewer` subagent (§4) |
| Accept | Deliberately check the increment against the Definition of Done (see §8) before calling it done; the agent will not do this for you. Codify as `/accept` (Appendix K) |
| Update status | Advance the current stage and record outcome/decisions in the same plan file |

**Plan only when the task merits it.** A one-line fix does not need a plan-mode round trip. That is ceremony. Plan first when the approach isn't obvious: a refactor, an architectural choice, or anything touching an invariant you cannot afford to get wrong. Work that merely spans a few files but is mechanically clear does not need one, and below that bar plan mode is friction. You can set plan mode as the session default and step out of it deliberately, or use it ad hoc. The **Challenge** and **Accept** stages scale the same way: skip them for trivial work, apply them whenever scope or quality is in question.

The loop above is the per-task rhythm. At a coarser grain — when a plan is finished — run a **retro** that turns recurring friction into configuration (§8). That is the one cadence worth keeping, and it is event-driven, not calendar-driven.

*See [a worked example](worked-example.md) for this loop traced end to end through one real change.*

---

## 3. Plans, with status folded in

This is the highest-leverage habit and the one most people skip. Both the main conversation and subagent transcripts compact; sessions restart. If the plan lives only in the conversation, a compaction event can silently drop the half of it the model still needed.

Each non-trivial task gets one file under `docs/plans/`, structured as a sequence of **Stages** worked through in order. Status is folded into that same file rather than split into a separate `STATUS.md`: the current-stage marker, the per-step checkboxes, recorded deviations, and the decision log all live where the work they describe is defined. One file, one source of truth, which removes the classic failure where a separate status file drifts out of step with the plan it is meant to track.

Three things keep this working at scale:

1. **Write the plan before executing.** After plan-mode approval, Claude writes the file — goal, stages, per-stage steps with acceptance criteria, explicit out-of-scope notes.
2. **Load by stage, not whole-file.** A large multi-stage plan reloaded in full on every turn is its own context tax. Structure it so the active stage can be read on its own, and point Claude at that stage during execution rather than the entire document.
3. **Keep one pointer to the active plan.** A single line, e.g. in `CLAUDE.md`, a `docs/plans/README.md`, or a section of your backlog (this repo uses `docs/backlog.md`'s `## Now (this plan)`), naming which plan is live. This is the one job the old separate status file did well: giving a cold-start session somewhere to land so it resumes the right plan rather than guessing.

The payoff is that recovery from a compaction or a fresh session becomes "read the active plan, continue from the current stage" rather than reconstructing intent from a degraded transcript. For a solo workflow with no ticketing system, these plan files *are* your project memory; keep them in the repo so they version alongside the code they describe. When a plan is done, move it to `docs/plans/archive/` and clear the active-plan pointer: completed plans stay versioned as history without crowding the active set a cold-start session has to scan.

A complementary deterministic safeguard: a `PreCompact` hook can re-inject the active stage, and a `PostCompact` hook can confirm it was reloaded, so persistence does not depend on the model choosing to re-read the file.

---

## 4. Subagent roster

The temptation is to build a zoo. Resist it. The built-ins already cover most delegation, and every custom subagent is another `description` Claude must reason about when deciding where to route. **Build a custom subagent only when you keep spawning the same worker, with the same instructions and the same tool restrictions.**

### Built-ins worth knowing

| Agent | Model | Tools | Role |
|---|---|---|---|
| Explore | Haiku | Read-only | Fast file discovery and code search; keeps verbose output out of main context |
| Plan | Inherits | Read-only | Codebase research during plan mode |
| general-purpose | Inherits | All | Multi-step work needing both exploration and modification |

### Custom set for a solo workflow

| Subagent | Tools | Model | Why it earns its place |
|---|---|---|---|
| `code-reviewer` | `Read, Grep, Glob, Bash` (no Edit/Write) | `inherit` | Read-only by design so it cannot "helpfully" rewrite while reviewing. With no PR reviewer, this is your second pair of eyes; on model choice, see the note below |
| `test-writer` | `Read, Edit, Write, Bash` | `sonnet` | Needs write access; scope it to test directories with a `PreToolUse` guard if you want belt-and-braces |
| `db-reader` *(optional)* | `Bash` + `PreToolUse` validator | `haiku` | Only if you have a recurring need to run guarded read-only queries |

### Frontmatter essentials

Only `name` and `description` are required. **The markdown body is the system prompt, not a user prompt**, the single most common mistake. Beyond `tools`/`model`, the fields that matter for this methodology:

- `disallowedTools` — a denylist; often cleaner than an allowlist when you just want "everything except Write/Edit".
- `permissionMode` — `default`, `acceptEdits`, `auto`, `dontAsk`, `bypassPermissions`, or `plan`.
- `memory` — `user`, `project`, or `local`; a persistent learnings directory. `project` is the sensible default so review patterns version with the repo.
- `effort` — `low`, `medium`, `high`, `xhigh`, `max` (availability depends on model).
- `isolation: worktree` — runs the subagent in an isolated copy of the repo, auto-discarded if it makes no changes.

**A recommendation that diverges from common advice:** default your custom agents to `model: inherit` and only pin a model where the task has a clear cost/capability shape (Haiku for mechanical search, Sonnet for analysis). Pinning Opus on a reviewer that runs constantly is a quiet money sink on a solo project. For the *sole* reviewer there is a quality argument too, not just cost: `inherit` makes the review exactly as capable as whatever produced the diff, so your one gate can never silently fall *below* the generator. Its limits are that it cannot rise *above* a cheap generator, and a same-model reviewer shares the author's blind spots, so pin a stronger or different model (or set `CLAUDE_CODE_SUBAGENT_MODEL` for one run) only when you want the review to exceed or diverge from the generator, as on a high-risk diff written on a cheaper model.

See Appendix A and B for drop-in definitions.

---

## 5. Model / mode decision matrix

Current aliases: `opus`, `sonnet`, `haiku`, plus `fable`. You can also pass a full ID such as `claude-opus-4-8` or `claude-sonnet-4-6`. Effort runs `low → medium → high → xhigh → max`. Permission modes: `default`, `acceptEdits`, `auto`, `dontAsk`, `bypassPermissions`, `plan`.

| Task | Model | Effort | Permission mode | Plan first? |
|---|---|---|---|---|
| Architecture / data-model design | `opus` | high–xhigh | `plan` | Yes |
| Gnarly debugging, root-cause hunt | `opus` | high | `plan` → `default` | Usually |
| Default feature work (the workhorse) | `sonnet` | medium | `default`, or `acceptEdits` on a branch | Only for a refactor or unclear approach |
| Mechanical refactor in a known area | `sonnet` | medium | `acceptEdits` (branch/worktree) | No |
| Codebase exploration / search | `haiku` (Explore) | low | `plan` (read-only) | n/a |
| Test writing | `sonnet` | medium | `default` | No |
| Docs / comments / renames | `haiku` | low | `acceptEdits` | No |

**Two opinions.**

- Set the **`opusplan`** model option as your default. It spends the expensive model precisely where reasoning pays off (planning) and drops to the workhorse for execution, with no manual switching. For a cost-conscious solo developer that is close to the right policy out of the box.
- **Avoid `bypassPermissions` as a habit.** It skips prompts and will happily write to protected paths (`.git`, `.claude`, and so on). The disciplined position is `acceptEdits` on a feature branch or in a worktree: you get flow without the foot-gun, and a bad run is one `git restore` (or one checkpoint rewind) away. (For the fuller stance, see §11: least privilege, sandboxing, the guards.)

---

## 6. Hooks: your CI substitute

With no pipeline, hooks are where determinism lives. The model can forget; an exit-code-2 hook cannot. Three tiers:

- **`PreToolUse` guards** — the generalised version of a path/command guard. The hook reads the tool input as JSON on stdin, inspects it, and **exits `2` to block**, feeding the message on stderr back to Claude. Natural matchers: `Bash` (block destructive commands, enforce read-only SQL) and `Edit|Write` (protect paths outside the working area). This is the deterministic backstop that lets you run `acceptEdits` confidently.
- **`PostToolUse`** — matcher `Edit|Write`: run formatter/linter, and a quick build or targeted test. Catches breakage at the moment of edit rather than three steps later. Can run async so it does not block the turn.
- **Session/lifecycle hooks** — `SessionStart` for environment setup; `PreCompact`/`PostCompact` to protect and reload plan context; `SubagentStop` if you want an audit log of delegated work.

Hooks can also be scoped *inside* a subagent's frontmatter (they fire only while that agent runs and are cleaned up afterwards). This is the clean way to make `test-writer` physically unable to write outside `Tests/`, regardless of what it is asked. Use the `$CLAUDE_PROJECT_DIR` prefix for hook script paths so they resolve regardless of working directory. See Appendix C.

---

## 7. Solo-developer discipline

A few things that matter more without a team to catch you:

- **One concern per branch or worktree.** `isolation: worktree` gives a subagent an isolated checkout that is auto-discarded if it makes no changes — ideal for "try this approach without polluting my working tree".
- **Commit at every green checkpoint**, prompted by the `PostToolUse` test hook passing. Your undo granularity is your safety net. Checkpoints/rewind cover in-session mistakes; commits cover the rest. They are complements, not substitutes.
- **Treat `CLAUDE.md` — and the memory directory — as a living spec, not an archive.** Prune stale rules and contradicted memories; a contradicted instruction is worse than a missing one (memory hygiene: §1).
- **The review subagent is non-negotiable** precisely because there is no PR reviewer. Run it before every merge to your main branch.
- **Give Claude something to verify against.** A failing test, a type checker, a build command in `CLAUDE.md`. Verification loops are what turn "looks right" into "is right".

---

## 8. Solo product discipline

The product-owner and scrum-master roles don't vanish when you work alone; they **relocate**. The test for any scrum activity: does it coordinate *multiple humans* (drop it) or *manage scope, uncertainty, and quality* (keep it; those survive a team of one)? PO activities become persisted decision artefacts; SM activities become the work of tuning your human-agent operating system. One reframe: the "team" whose blockers you clear is partly **Claude**.

Four things are worth folding in. Everything else (standups on a cadence, story points, velocity, burndown) is coordination machinery you no longer need, and re-adding it as solo ritual is negative-value busywork.

**Definition of Done: the highest-value import, and it matters *more* with an agent.** Claude declares victory the instant something builds unless the bar is pinned down; this is the verification-loop principle wearing a scrum hat. Keep a project-wide DoD in `.claude/rules/` (Appendix E) and per-stage acceptance criteria in the plan file, so the **Accept** stage checks against an explicit list rather than a vibe.

**A backlog as a persisted, ordered file.** The value is the externalised queue, not the ceremony: priorities out of your head, and a place to point the agent at "the next thing". Keep `docs/backlog.md` (Appendix F): each item tagged type/value/effort with a one-line *why now*. Keep the prioritisation *thinking*; drop the estimation theatre.

**Backlog, plan, and changelog are one lifecycle.** The same unit of work moves through three views: a backlog item (a candidate: *what might happen*), pulled into a plan (committed: *what's happening*, §3), and on completion recorded in the changelog (shipped: *what happened*, user-facing). Tag backlog items by type (`feat`/`fix`/`debt`/`chore`) so they pre-sort into changelog categories; when an item ships, its user-facing outcome lands in the changelog and the backlog line is removed. This closes the loop the methodology otherwise leaves open. It had a record of future and present work, but none of the past.

**The changelog is a curated human artefact, not a generated one.** Adopt Keep a Changelog (categories Added/Changed/Deprecated/Removed/Fixed/Security, an `## [Unreleased]` section on top, SemVer versions below; Appendix H), and keep `CHANGELOG.md` at the repo root, the one deliberate exception to the `docs/` rule, because tools and readers expect it there and a visible changelog signals a maintained project (which matters when you distribute the plugin). Don't auto-generate it from `git log`; have Claude draft Unreleased entries from the finished plan and its Conventional Commits at release time (the `/release` command, Appendix M), then curate. Keep it distinct from its neighbours: the changelog says *what changed, user-facing*; the plan's decision log says *why, internally*; an ADR says *which architectural choice, and its consequences*. The rule of thumb: if a user or installer would care, it's a changelog line; if only a future maintainer would, it isn't.

**The retro is the one ceremony that pays for itself, because here the process *is* the product you're tuning.** Every time you correct Claude twice for the same thing, that's a defect ticket against your configuration. The output is concrete: a `CLAUDE.md` line, a `.claude/rules/` entry, a hook, a subagent. Run it at plan boundaries, not on a calendar.

**Impediment removal becomes context engineering, and the lost role tension can be bought back.** An agent's blockers are removable: missing context (→ the plan, an architecture doc, a `CLAUDE.md` gap), missing tools (→ an MCP server or permission rule), ambiguous spec (→ tighter acceptance criteria). The genuine *loss* solo is independence: you're both judge and advocate. That's when the magpie problem bites, the interesting refactor over the valuable feature. Buy the missing seat back by casting Claude as sceptic at the **Challenge** stage: "argue this isn't worth building", "find the holes in these criteria".

The footprint is small by design: two artefacts (`docs/backlog.md` and a root `CHANGELOG.md`), one rules file (the DoD), and two habits already wired into §2's loop. Anything heavier rebuilds the ceremony you were right to leave behind.

---

## 9. Sessions, concurrency and git hygiene

One rule prevents most of the trouble: **one session, one worktree. Never two sessions in the same working directory.** Git's working tree and index are shared mutable state, so two Claude sessions (or a session and you) pointed at one checkout race on that state: one overwrites the other's edits, a session reads a file the other is mid-changing, or an over-eager `git add -A` sweeps up another session's half-written work.

Isolate with git worktrees. The CLI's `claude -w <branch>` (or `--worktree`) creates a linked worktree on its own branch and scopes the session to it; in-session, "work in a worktree" invokes the `EnterWorktree` tool. The desktop app does this automatically for every new session. The CLI does not, which is where people get caught. For subagents, `isolation: worktree` gives the same per-dispatch guarantee. Add `.claude/worktrees/` to `.gitignore` so worktrees don't show up as untracked files in your main checkout, and note that gitignored config (your `.env`) won't exist in a fresh worktree until you copy it in. A `.worktreeinclude` handles that.

Two boundary rules stop parallel work turning into merge conflicts: **scope worktrees by module, not by task** (so two sessions physically cannot edit the same file), and **rebase rather than merge** between them. Tasks in the same module share one worktree sequentially; only cross-module work goes parallel.

Two deterministic backstops, both reusing machinery already in the methodology:

- A **`git` `PreToolUse` guard** (Appendix C) that blocks `git add -A` / `git add .`, `git commit`, and `git push` unless you approve: the §6 hook pattern pointed at the accidental-commit class. Pair it with `.gitignore` discipline and the security-review plugin for credential leaks (secret hygiene is part of the security stance, §11).
- **Real commits, not checkpoints, as the source of truth.** Claude's rewind/checkpoints don't track bash-driven or *external* changes and aren't a version-control replacement, so in any concurrent setup they will desync. Commit at each green checkpoint and treat rewind as in-session only.

**Session close-out.** A session is ephemeral scratch; the files are the source of truth (§3). So the end-of-session ritual's first job is to guarantee the file-truth is current, with the summary and name as byproducts. Run a `/wrap` (Appendix N) that confirms the durable records are updated (plan status advanced, user-facing changes drafted into `CHANGELOG` Unreleased, decisions logged), captures any retro signal (anything corrected twice → a config change, §8), produces a one-line *pointer* summary naming which artefacts were touched and where things landed, and suggests a name. Keep the summary pointer-shaped: a verbose session summary becomes a fourth record that duplicates the plan, changelog and decision log, and a record that drifts is worse than none.

Name sessions to mirror their plan, so the two cross-reference: a session working `docs/plans/add-importer.md` is named `add-importer`, date-prefixed (`2026-06-18-add-importer`) if you want archived sessions to sort chronologically. The test is that the name is reconstructable from the work. Name and archive only sessions worth finding again; for a five-minute fix, skip it.

`/wrap` deliberately does **not** depend on the native session-recap (`/recap`), which is rollout-flagged, provider-dependent, and skipped in non-interactive modes. A custom command works wherever slash commands do. Session naming and resumption themselves (`claude --continue`, `--resume`, `/resume`, `/branch`) are solid native features you can rely on.

---

## 10. Skills and commands

Two more primitives complete the picture: one extends what Claude *can do*, the other turns your rituals into one-keystroke habits.

**Skills are the third leg of the context model.** `CLAUDE.md` is always-loaded and declarative (*what is true*); `.claude/rules/` is conditional (*what applies here*); a **skill** is on-demand and procedural (*how to do a recurring task*). A skill is a `SKILL.md` under `.claude/skills/<name>/` whose body loads only when invoked: a long playbook costs nothing until it's needed. Claude invokes a skill when its `description` matches the task, or you call it explicitly. The natural candidates are the procedures you'd otherwise re-explain every time: "add a data importer", "handle a Spanish-locale date sample", "run the release checklist", "add a SwiftData migration". Skills can pre-approve their own tools and run inside a subagent (`context: fork`), so a heavy procedure executes without polluting your main context; set `disable-model-invocation` if you want a skill that only ever runs when you ask for it by name. Appendix I is an example.

This is the cleanest home for the institutional knowledge that currently lives only in your head. The test is the same as everywhere else: write a skill once you've performed the procedure by hand twice, not before. A speculative library of skills is the same over-engineering trap as a zoo of subagents.

**Custom slash commands make the methodology's discipline muscle memory.** Right now the loop depends on you remembering to follow it. A command is a saved prompt in `.claude/commands/<name>.md`, invoked as `/<name>`, that can take arguments (`$ARGUMENTS`, `$1`) and run bash or reference files. Codify the rituals: a `/plan` that enters plan mode with your house rules (Appendix J), an `/accept` that runs the Definition of Done against the diff (Appendix K), a `/retro` that runs the "what recurred?" sweep and proposes config changes (Appendix L). One keystroke instead of a remembered intention is the difference between a methodology you follow and one you mean to.

The five ritual commands map onto the loop (§2) and the session lifecycle (§9), and run in this order:

| Command | Run when | Where in the rhythm | Drop-in |
|---|---|---|---|
| `/plan` | starting a non-trivial task | before execution: Explore → Plan → Challenge | Appendix J |
| `/accept` | an increment looks finished | the Accept gate, before you call it done | Appendix K |
| `/retro` | the same correction has recurred | at a plan or phase boundary | Appendix L |
| `/wrap` | closing the session | session end | Appendix N |
| `/release` | cutting a version | event-driven, off the per-task loop | Appendix M |

`/plan` → (execute) → `/accept` is the per-task spine, with `/retro` at the boundary and `/wrap` at session close; `/release` fires only when you version. Skip any of them for trivial work. The commands codify the discipline, they do not mandate it.

**Skills vs commands: who drives.** You invoke a command explicitly; Claude invokes a skill when its description matches. Use commands for *your* rituals (plan, accept, retro), skills for *Claude's* capabilities (the importer, the migration). When something is a reusable capability rather than a personal ritual, prefer a skill: Anthropic is steering capability-bundles toward skills, so they are the more future-proof primitive.

**A command is not a subagent.** A command (or skill) is a prompt that runs in your *current* context; it does not hand work to a subagent unless its body explicitly delegates (via the Agent tool, an `@agent` mention, or `subagent_type`). So a `/review`-style command reviews in the main session. It does **not** dispatch your `code-reviewer` subagent (§4), and running one does not satisfy a "run the review subagent" gate (the working agreement's review-before-merge rule). When you want the isolated, read-only reviewer, invoke the subagent; when you want a command to *trigger* it, have the command delegate, as `/accept` does by checking a Definition of Done that requires the subagent run.

Packaging all of this (agents, hooks, skills, commands, rules) into a single reusable, distributable unit is covered in the companion document, *Packaging the Methodology as a Plugin*.

---

## 11. Security — the trust boundary

A distributed, agentic harness executes code and pulls external content into its context, so it carries a real attack surface. And once you hand it to other people, *"what's your security stance?"* is a question you will be asked. The answer is not a separate discipline: it is least privilege, determinism, and a human at the irreversible boundaries, the habits the rest of this methodology already runs, turned to face the threat surface. Most of the machinery lives in earlier sections; this is the stance that ties it together and draws the line between what the harness does for you and what is yours to add.

**Secret hygiene.** Secrets never live in tracked files, in `CLAUDE.md`, or in anything pasted into context; keys belong in the environment, the OS keychain, or a secret manager, not in a prompt. `.gitignore` discipline and the gitignored `docs/local/` convention keep private material out of the repo; the `git`-guard (§9, Appendix C) is the backstop against an accidental commit; and `/security-review` scans changes for leaked credentials. Claude Code keeps its *own* credentials in the OS keychain, but nothing stops you writing a secret into `CLAUDE.md`, so that rule is yours to hold.

**Least privilege.** Give each agent the narrowest capability that does the job. A subagent's `tools` list is a strict ceiling (§4); the model/mode matrix (§5) defaults to `acceptEdits` on a branch or worktree rather than `bypassPermissions`, which skips prompts and will write to protected paths. Allow/deny permission rules in `settings.json` (deny wins) narrow `Bash`, `Read`, `Write` and `WebFetch` further. Beneath all of it, Bash sandboxing (OS-level filesystem and network isolation; Seatbelt on macOS, bubblewrap on Linux) is defence-in-depth where it is in force: it confines what a shell command can touch *even if a prompt injection has already defeated Claude's judgement*. Permissions stop Claude from *choosing* a dangerous action; the sandbox stops the action from *reaching* what it shouldn't.

**Deterministic guards, which cut both ways.** A `PreToolUse` hook that exits 2 blocks a tool call before it runs (§6); the bash-guard against destructive commands and the git-guard against unreviewed commits (Appendix C) are that pattern. But a hook is arbitrary shell that fires automatically on a tool event, so the mechanism is also an attack vector: a malicious hook in a cloned repo's `.claude/` runs the moment you start work there. The harness's folder-trust prompt (shown on first use of a new directory) is the checkpoint against exactly that, which is why you read it rather than reflexively accept. A hook is a trust boundary, not an isolation boundary.

**Untrusted content and prompt injection.** This is the surface the rest of the methodology does not otherwise cover. Any text the agent ingests (a fetched web page, an MCP tool result, a file, an issue or PR body, a dependency's README) can carry instructions aimed at the agent rather than from you, and an agent that acts on them is an agent that can be steered. The harness gives partial cover: sensitive operations are permission-gated, suspect commands are held for manual approval even when allowlisted, unmatched commands fail closed, and `WebFetch` reasons over fetched content in a separate context so a hostile page cannot directly drive the main session. The rest is yours, and the stance is plain: treat external content as **data, not instructions**; never pipe untrusted input straight into an agent holding write or execute permissions; lean on least privilege, guards and the sandbox so a successful injection has a small blast radius; and keep a human at every irreversible or outward-facing action. *"Review this PR"* where the PR body says *run `rm -rf`* is the canonical trap. It is exactly why the working agreement puts commits, pushes and external sends behind your approval, not the agent's.

**Plugin and MCP trust.** A third-party plugin or MCP server runs arbitrary code in your session (hooks, scripts, tool calls), and Anthropic reviews directory *listings* against publishing criteria but does **not** security-audit the servers themselves. Treat them like any dependency: prefer reviewable source and providers you trust, vet before installing, and read the first-use trust prompt instead of clicking through it. This is also the security case under the advisory positioning (`docs/packaging-as-a-plugin.md`): a methodology whose source is legible earns a trust that an opaque bundle cannot. The *context-cost* side of an MCP server (the window its tool definitions occupy) is a separate, non-security concern, treated in §1.

---

*The drop-in artefacts referenced above (the subagent definitions, project hooks, document skeletons, example skill and ritual commands; Appendices A–O) live under `docs/appendices/`, grouped by type. See `docs/appendices/README.md` for the letter-to-file index.*
