# .agents/

Registry for the compatibility layer described in [`AGENTS.md`](../AGENTS.md).

## Why symlinks

`AGENTS.md` at the repo root is the single source of truth. Most newer agent tools
(Codex, Cursor, Amp, Jules, ...) read it there directly. The tools that don't yet
look for their own filename in a fixed location can't have that location moved,
so the symlink has to live there, not in here.

| Tool | Expects | Symlinks to |
| --- | --- | --- |
| Claude Code | `/CLAUDE.md` | `AGENTS.md` |
| GitHub Copilot | `/.github/copilot-instructions.md` | `../AGENTS.md` |
| Gemini CLI | `/GEMINI.md` | `AGENTS.md` |
| Codex, Cursor, Amp, Jules, ... | `/AGENTS.md` (native) | no symlink needed |
| Cursor (MCP servers) | `/.cursor/mcp.json` | `../.mcp.json` |

`manifest.txt` in this directory is the machine-readable version of that table.
`scripts/check-agents-symlinks.sh` reads it in CI to make sure none of the symlinks
have drifted: turned into a real file, gone stale, or been deleted.

## Adding support for a new tool

1. Find out what filename/path the tool auto-discovers.
2. `ln -s AGENTS.md <that-path>` (adjust the relative path if it's nested, e.g.
   inside `.github/`).
3. Add a row to the table above and a matching line to `manifest.txt`.
4. Commit. Git stores symlinks natively, no extra tooling needed on macOS/Linux.
   On Windows, symlink support requires Developer Mode or an elevated shell plus
   `git config core.symlinks true`; without it, checkouts may materialize these as
   plain text files containing the link path instead of real symlinks.

## MCP servers: same idea, one exception

[`.mcp.json`](../.mcp.json) at the repo root is the canonical MCP server config
(`filesystem`, `git`). Claude Code and Cursor both read the same `mcpServers`
schema, so Cursor's `.cursor/mcp.json` is just a symlink, tracked in the table
and manifest above like any other agent file.

VS Code doesn't fit the symlink trick: its `.vscode/mcp.json` uses a different
schema (`servers` key instead of `mcpServers`, and an explicit `type` per server
instead of inferring it). That file is *generated*, not symlinked.
`scripts/sync-mcp-configs.sh` regenerates it from `.mcp.json`, and
`scripts/sync-mcp-configs.sh --check` (run in CI) fails the build if it's out of
sync. Add or edit servers in `.mcp.json` only, then run the sync script.
