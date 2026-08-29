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

## Optional plugins

Independent, drop-in tools that make agents better at *this specific* job.
None of them are vendored in this repo, and none of their CLIs are installed
by default: install what's useful.

| Plugin | What it does | Link |
| --- | --- | --- |
| **Graft** | Builds a markdown map of the codebase (structure, call graphs, cross-file relationships) so agents get accurate contextual understanding without re-reading the whole tree. Its MCP server is already wired into [`.mcp.json`](./.mcp.json) (see the "MCP Servers" section of [`README.md`](./README.md#mcp-servers)); run `graft init` once to build the graph it reads from. Graft's own published benchmark reports up to 4× cheaper and 3× faster agent runs, and, across 162 controlled runs, +42% token savings, +46% fewer tool calls, and +60% time savings. | [trailhq/Graft](https://github.com/trailhq/Graft) |
| **ponytail** | Pushes agents down a "does this need to exist → already in the codebase → stdlib → native feature → one-liner → build the minimum" decision ladder, to keep generated code small and boring. | [dietrichgebert/ponytail](https://github.com/dietrichgebert/ponytail) |
| **Caveman** | Compresses agent *prose*, not code, into terse, technically-exact fragments. Cuts chat/output tokens without touching code, commands, or error output. | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) |

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
