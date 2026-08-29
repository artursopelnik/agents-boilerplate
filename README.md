# Agents Boilerplate

A small, opinionated boilerplate for repositories built with AI coding agents: Claude Code, GitHub Copilot, Cursor, Codex, Gemini CLI, Windsurf, and whatever comes next.

## Features

* **One source of truth:** `AGENTS.md` is the canonical instruction file. Agent specific files are symlinked to it, so instructions never drift.
* **Consistent MCP tooling:** One `.mcp.json` provides the same `filesystem` and `git` tools across MCP capable agents. VS Code's config is generated automatically.
* **Token efficient by default:** Optional [Caveman](https://github.com/JuliusBrussee/caveman), [Graft](https://github.com/trailhq/Graft), and [ponytail](https://github.com/dietrichgebert/ponytail) plugins reduce noise, improve codebase context, and keep changes minimal.
* **Accessibility from the start:** [A11Y.md](https://github.com/fecarrico/A11Y.md) provides an 18 rule AI behavioral contract for validating UI changes.

## The Idea

Every coding agent has its own conventions for instructions. Maintaining multiple copies of the same rules inevitably leads to drift.

This boilerplate keeps **one canonical `AGENTS.md`** and symlinks agent specific files such as `CLAUDE.md`, `GEMINI.md`, and `.github/copilot-instructions.md` to it.

Edit `AGENTS.md` once. Every agent gets the same instructions.

Tools that support `AGENTS.md` natively, such as Codex, Cursor, Amp, and Jules, work without additional setup.

## Structure

```text
.
├── AGENTS.md                              # canonical instructions
├── CONTRIBUTING.md                        # onboarding, plugins, roadmap
├── CLAUDE.md -> AGENTS.md                 # Claude Code
├── GEMINI.md -> AGENTS.md                 # Gemini CLI
├── .mcp.json                              # canonical MCP config
├── .cursor/
│   └── mcp.json -> ../.mcp.json           # Cursor
├── .vscode/
│   └── mcp.json                           # generated, do not edit
├── .github/
│   ├── copilot-instructions.md -> ../AGENTS.md
│   └── workflows/
│       ├── check-agents-symlinks.yml
│       └── check-mcp-config.yml
├── .agents/
│   ├── README.md
│   └── manifest.txt
├── scripts/
│   ├── check-agents-symlinks.sh
│   └── sync-mcp-configs.sh
├── LICENSE
└── README.md
```

## Quickstart

1. **Use this repo as a template** or clone it and reset the Git history.
2. **Edit `AGENTS.md`** with your project's overview, setup, build, test, lint commands, and coding conventions.
3. **Leave the symlinks alone.** To add another agent, see [`.agents/README.md`](.agents/README.md).
4. **Configure MCP servers** in `.mcp.json`, then run `scripts/sync-mcp-configs.sh`.
5. **Optionally install the plugins** below and add [`A11Y.md`](https://github.com/fecarrico/A11Y.md). See [`CONTRIBUTING.md`](CONTRIBUTING.md) for details.

## MCP Servers

`.mcp.json` ships with two zero config servers:

| Server       | Provides                      |
| ------------ | ----------------------------- |
| `filesystem` | Repo scoped read/write access |
| `git`        | Status, diff, log, and blame  |

Claude Code and Cursor read the config natively. VS Code uses a generated `.vscode/mcp.json` because its schema differs.

## Optional Plugins

| Plugin                                                      | Purpose                                                                       |
| ------------------------------------------------------------ | ------------------------------------------------------------------------------ |
| [**Graft**](https://github.com/trailhq/Graft)                | Gives agents accurate, linked codebase context without re reading everything. |
| [**ponytail**](https://github.com/dietrichgebert/ponytail)   | Encourages the smallest correct implementation.                               |
| [**Caveman**](https://github.com/JuliusBrussee/caveman)      | Compresses agent output into terse, technically precise prose.                |

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for setup details.

## License

MIT. See [`LICENSE`](LICENSE).
