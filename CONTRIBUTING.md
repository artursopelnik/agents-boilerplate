# Contributing

This file is for humans deciding how to set up or extend this boilerplate.
Agent-facing operating instructions live in [`AGENTS.md`](./AGENTS.md); read
that first if you're wiring up an AI coding agent.

## Getting started

1. Use this repo as a template, or clone it and reset the git history.
2. Fill in the real project overview, setup, build/test/lint commands, and
   code style in `AGENTS.md`.
3. Leave the agent symlinks alone. To add support for another tool, see
   [`.agents/README.md`](./.agents/README.md).
4. Edit [`.mcp.json`](./.mcp.json) to add or remove MCP servers, then run
   `scripts/sync-mcp-configs.sh` so VS Code's config picks up the change too.
5. Install the three required plugins below. `AGENTS.md` assumes they're
   active.

## Required plugins

Three plugins this boilerplate is built around, not just references to.
`AGENTS.md` states the contract; these are the actual install commands.

| Plugin | What it does | Install |
| --- | --- | --- |
| **Graft** | Builds a markdown map of the codebase (structure, call graphs, cross-file relationships) so agents get accurate contextual understanding without re-reading the whole tree. Its MCP server already ships in [`.mcp.json`](./.mcp.json) (see the "MCP Servers" section of [`README.md`](./README.md#mcp-servers)). Graft's own published benchmark reports up to 4× cheaper and 3× faster agent runs, and, across 162 controlled runs, +42% token savings, +46% fewer tool calls, and +60% time savings. | `npm install -g @nanonets/graft && graft init` (the `init` step builds the graph its MCP tools read from) |
| **ponytail** | Pushes agents down a "does this need to exist → already in the codebase → stdlib → native feature → one-liner → build the minimum" decision ladder, to keep generated code small and boring. Its philosophy is already embedded as prose in `AGENTS.md`'s Code style section; the plugin adds `/ponytail-review`, `/ponytail-audit`, and `/ponytail-debt` commands. | No npm package. Per agent, e.g. Claude Code: `/plugin marketplace add DietrichGebert/ponytail` then `/plugin install ponytail@ponytail`. Codex, GitHub Copilot CLI, Gemini CLI, and others have their own install line; see [ponytail's README](https://github.com/dietrichgebert/ponytail) for the full matrix. |
| **Caveman** | Compresses agent *prose*, not code, into terse, technically-exact fragments. Cuts chat/output tokens without touching code, commands, or error output. | `npm install -g @caveman-ai/cli && caveman setup --install <agent>`, where `<agent>` is `claude`, `codex`, `gemini`, `aider`, `opencode`, `hermes`, or `openclaw`. See [Caveman's README](https://github.com/JuliusBrussee/caveman) for the full installer, including the single-agent and curl/PowerShell options. |

> ponytail's own docs put it well: *"Caveman shrinks what the agent says;
> ponytail shrinks what it builds."* Graft gives both something accurate to
> work from.

## Ideas not yet in this boilerplate

- Per-directory `AGENTS.md` overrides for monorepos (the spec supports this
  natively: the closer-to-the-file instructions win).
- A `skills/` directory following the Claude Agent Skills format for
  reusable, invokable procedures shared across agents.
- `CODEOWNERS` and an `.editorconfig` so formatting/ownership rules aren't
  only ever described in prose an agent has to re-derive.
