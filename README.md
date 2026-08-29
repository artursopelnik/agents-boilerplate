# Agents Boilerplate

*Keep your agent. Brain big. Context small.*

This isn't a folder of files you copy in. It's a recipe: three steps that get
any repo ready for AI coding agents (Claude Code, Cursor, Codex, Gemini CLI,
GitHub Copilot, Windsurf, ...) without leaving behind a bloated instructions
file that agents reload, and pay for, on every single turn.

Pick your path below, then follow the three steps.

## Path A: New project

Start from an empty repo (or reset the git history of a clone) and work
through steps 1 to 3.

## Path B: Existing project

You already have code, and maybe already have a `CLAUDE.md`, `AGENTS.md`, or
`.github/copilot-instructions.md`. Same three steps, with one difference in
step 3: merge into what you have instead of writing from scratch. Don't run
multiple instruction files that say different things: your agent only reads
one of them, and drift between them is how a boilerplate rots.

## Step 1: Install the plugins

Three plugins this recipe assumes are active, not optional extras:

| Plugin | What it does | Install |
| --- | --- | --- |
| [**Graft**](https://github.com/trailhq/Graft) | Builds a linked map of the codebase (structure, call graphs, cross-file relationships) so agents get accurate context without re-reading the whole tree. Reports up to 4x cheaper, 3x faster runs in its own benchmark. | `npm install -g @nanonets/graft` |
| [**ponytail**](https://github.com/dietrichgebert/ponytail) | Pushes agents down a "does this need to exist -> already in the codebase -> stdlib -> native feature -> one-liner -> build the minimum" decision ladder, so generated code stays small. | Per agent, e.g. Claude Code: `/plugin marketplace add DietrichGebert/ponytail` then `/plugin install ponytail@ponytail`. See [ponytail's README](https://github.com/dietrichgebert/ponytail) for other agents. |
| [**Caveman**](https://github.com/JuliusBrussee/caveman) | Compresses agent *prose*, not code, into terse, technically exact fragments. Cuts chat/output tokens without touching code or commands. | `npm install -g @caveman-ai/cli && caveman setup --install <agent>`, where `<agent>` is `claude`, `codex`, `gemini`, `aider`, `opencode`, `hermes`, or `openclaw`. |

If your agent talks MCP and you want Graft's tools available inside the
agent (not just its CLI), add this to whatever MCP config your agent reads
(`.mcp.json` for Claude Code and Cursor, `.vscode/mcp.json` for VS Code with
its `servers`/`type` schema):

```json
{
  "mcpServers": {
    "graft": {
      "command": "npx",
      "args": ["-y", "@nanonets/graft", "mcp"]
    }
  }
}
```

This is optional. `graft init` in step 2 works from the CLI alone.

## Step 2: Run `graft init`

```bash
graft init
```

This builds the codebase graph Graft's tools and CLI read from. Without it,
Graft has nothing to answer from. Re-run it after large refactors; add
`graft/` to `.gitignore` since it's regenerable, not source of truth.

## Step 3: Write your agent's instructions file

Create the one file your agent actually reads: `CLAUDE.md` for Claude Code,
`GEMINI.md` for Gemini CLI, `.github/copilot-instructions.md` for GitHub
Copilot, `AGENTS.md` for Codex, Cursor, Amp, Jules and anything else that
supports the open `AGENTS.md` convention, or something else entirely if your
agent looks elsewhere. Check your agent's docs if you're not sure which
filename it discovers automatically.

Keep it short. It's loaded on every turn, so every line in it is a
standing cost, not a one-time one. Cover only:

- **Project overview**: one or two sentences, not a spec.
- **Setup / build / test / lint commands**: the exact commands, nothing else.
- **Code style rules that aren't obvious from the code itself.**

Existing project with content already in `CLAUDE.md`, `AGENTS.md`, or
similar? Fold anything still true into this one file and delete the rest.
Don't keep two instruction files with overlapping rules; they will drift.

Optional: if you want the same instructions picked up by more than one
agent, a plain symlink (`ln -s AGENTS.md CLAUDE.md`) keeps them identical
without copy-paste drift. Not required, just avoids duplication if you use
several agents on the same repo.

### Optional: accessibility

For UI work, point your instructions file at
[A11Y.md](https://github.com/fecarrico/A11Y.md), an 18-rule AI behavioral
contract mapped to WCAG 2.2 AA. Drop a copy into the repo root and add one
line to your instructions file: "Follow every rule in `A11Y.md` before
writing or editing any UI component."

## License

MIT. See [`LICENSE`](LICENSE).
