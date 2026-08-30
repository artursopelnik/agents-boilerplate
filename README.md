# Agents Boilerplate

*Keep your agent. Brain big. Context small.*

I work as a freelancer and alongside teams on larger enterprise projects. This
is the setup I've settled on, written down so I stop re-deciding it on every new
repo. It isn't a folder of files you copy in. It's a recipe: four steps that get
any repo ready for AI coding agents (Claude Code, Cursor, Codex, Gemini CLI,
GitHub Copilot, Windsurf, ...) without leaving behind a bloated instructions
file that the agent reloads, and pays for, on every single turn.

1. Install three plugins, once per machine.
2. Run `graft init`, once per repo.
3. Write one short instructions file.
4. Commit skills and subagents in project scope, so the whole team gets them.

## Features

* **Token efficient by default:** [Graft](https://github.com/NanoNets/Graft),
  [Caveman](https://github.com/JuliusBrussee/caveman) and
  [ponytail](https://github.com/dietrichgebert/ponytail) are required plugins. They
  cut what the agent reads, what it writes, and how much it invents. Graft's own
  162-run benchmark reports 42% fewer uncached input tokens, 46% fewer tool
  calls and 60% lower latency per task, accuracy unchanged at 93%. Caveman's own
  54-run Claude Code benchmark reports 33.2% fewer input tokens with all 18
  correctness checks passing. Vendor numbers on vendor harnesses: a direction,
  not a promise.

* **Accessibility when you need it:**
  [A11Y.md](https://github.com/fecarrico/A11Y.md) adds an 18-rule AI behavioral
  contract mapped to WCAG 2.2 AA, scoped to your UI files so it costs nothing
  elsewhere.

## Step 1: Install the plugins (once per machine)

Not optional extras; the recipe assumes they're active. Install once, globally,
and they apply to every project. Already have them? Skip to step 2.

### [Graft](https://github.com/NanoNets/Graft): accurate context without re-reading the tree

A linked map of the codebase (structure, call graphs, cross-file relationships)
so agents don't walk the whole tree to answer a question. Plain markdown in your
repo, not an index to keep warm.

```bash
npm install -g @nanonets/graft
```

### [Caveman](https://github.com/JuliusBrussee/caveman): fewer tokens per turn

Two parts. The command installs the proxy, which compresses what the agent
*reads* (logs, tool output, files) before every provider call, with byte-exact
recovery. The original skill compresses what it *writes* and installs
separately. Neither touches code or commands.

```bash
npm install -g @caveman-ai/cli
caveman setup --install <agent>
```

`<agent>`: `claude`, `codex`, `gemini`, `aider`, `opencode`, `hermes`,
`openclaw`.

### [ponytail](https://github.com/dietrichgebert/ponytail): less code in the first place

A decision ladder (does this need to exist -> already in the codebase -> stdlib
-> native feature -> one-liner -> build the minimum) that keeps generated code
small.

```
/plugin marketplace add DietrichGebert/ponytail
/plugin install ponytail@ponytail
```

Claude Code commands; other agents in
[ponytail's README](https://github.com/dietrichgebert/ponytail).

## Step 2: Run `graft init` (once per repo)

Caveman and ponytail patch the agent itself and are already active everywhere.
Graft is the exception: its map is repo-specific.

```bash
cd your-project
graft init
```

Re-run after large refactors. `graft/` is a regenerable cache, not source of
truth; current versions gitignore it for you.

`graft init` also registers Graft's MCP server in `.mcp.json` and leaves
existing entries alone. Claude Code loads it after a restart. Its tools
(`graft_ask`, `graft_callers`, `graft_grep`, `graft_skeleton`, `graft_map`,
`graft_check`) read from the graph, so they answer with nothing until the build
has run.

Deliberately absent: `filesystem` and `git` servers. Their tool definitions sit
in context on every turn and duplicate what your agent already does natively.
Same ladder ponytail applies to code, one rung earlier.

## Step 3: Write the instructions file

Your agent reads one specific file, and it isn't `README.md`. This file is for
humans; mixing the two makes both worse.

| Agent | File it reads |
| --- | --- |
| Claude Code | `CLAUDE.md` |
| Codex, Cursor, Amp, Jules, and anything else on the open `AGENTS.md` convention | `AGENTS.md` |
| Gemini CLI | `GEMINI.md` |
| GitHub Copilot | `.github/copilot-instructions.md` |

One `AGENTS.md` carrying every agent's rules sounds efficient and isn't. Claude
Code doesn't read that name, so on its own the file is invisible rather than
expensive. Wire it up and the bill starts: every agent pays for every other
agent's rules, on every single turn, and gets nothing back for it. In a monorepo
you also lose lazy loading: Claude Code pulls a subdirectory's `CLAUDE.md` only
when it reads files there. Keep the shared file to what's true for every agent
and put the rest in that agent's own file.

Fastest first draft: write a real README, then generate from it. In Claude Code,
`/init` reads the codebase and proposes a `CLAUDE.md` you can trim; `/doctor`
proposes trims later, once the file has grown. Generate, then cut.

Keep it short. It's loaded on every turn, so every line is a standing cost.
Cover only:

- **Project overview**: one or two sentences, not a spec.
- **Setup / build / test / lint commands**: the exact commands, nothing else.
- **Code style rules that aren't obvious from the code itself.**
- **A handful of working rules**: the corrections you'd otherwise type into chat
  every session. Concrete enough to check.

<details>
<summary>Starter template</summary>

```markdown
# <project>

<One or two sentences: what this is and what it does.>

## Commands

- Install: `...`
- Dev: `...`
- Test: `...`
- Lint: `...`

## Conventions

- No em dashes or en dashes in prose you write (commit messages, comments,
  docs, PR descriptions). Use a comma, a colon, parentheses, or two sentences.
  Hyphens in compound words are fine. Don't rewrite dashes in existing files or
  in text I gave you.
- <Anything else that can't be inferred by reading the code.>

## Working rules

- If the requirements are ambiguous, ask before writing any code.
- After finishing a change, list the edge cases and suggest tests that cover
  them.
- For a bug, first write a test that reproduces it, then fix until it passes.
```

</details>

**Already have content in `CLAUDE.md`, `AGENTS.md`, or similar?** Fold what's
still true into the one file and delete the rest. Two files with overlapping
rules will drift.

**Several agents on one repo?** Keep `AGENTS.md` as the shared file and import
it from `CLAUDE.md`, with anything Claude-specific below the import:

```markdown
@AGENTS.md

## Claude Code

<Only what applies to Claude Code and nothing else.>
```

A symlink (`ln -s AGENTS.md CLAUDE.md`) does the same job, but needs
Administrator rights or Developer Mode on Windows. Either way, run `/context`
in the next session and check that `CLAUDE.md` appears under Memory files.

### Optional: accessibility

For UI work, drop [A11Y.md](https://github.com/fecarrico/A11Y.md) into the repo
root and point your instructions file at it. In Claude Code, put the pointer in
`.claude/rules/a11y.md` instead, so it enters context only when Claude touches a
matching file:

```markdown
---
paths:
  - "src/**/*.{tsx,jsx,vue,svelte}"
---

Follow every rule in `A11Y.md` before writing or editing any UI component.
```

## Step 4: Commit skills and subagents (once per repo)

Steps 1 to 3 set up the agent, this one sets up your team. Both stay out of
context until needed: a skill loads when its description matches the task, a
subagent works in its own window and reports back a result, not a transcript.

| What | Where in Claude Code | Scope |
| --- | --- | --- |
| Skill | `.claude/skills/<name>/SKILL.md` | committed, whole team |
| Subagent | `.claude/agents/<name>.md` | committed, whole team |
| Either, personal | `~/.claude/skills/`, `~/.claude/agents/` | just you, every project |

Commit the project versions. The ones under `~/.claude/` travel with you and
with nobody else. Other agents have their own paths; check their docs. Keep the
set small: one skill per task you'd otherwise re-explain ("how we add an
endpoint here", "how we write a migration"), and only the subagents this repo
actually uses.

## License

MIT. See [`LICENSE`](LICENSE).
