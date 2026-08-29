#!/usr/bin/env bash
# Regenerates .vscode/mcp.json from the canonical .mcp.json.
#
# Claude Code and Cursor both read the same `mcpServers` schema with the
# transport type inferred from which keys are present, so .cursor/mcp.json
# is just a symlink to .mcp.json. VS Code uses a different schema (`servers`
# key, explicit `type` field), so its file has to be generated instead — see
# .agents/README.md.
#
# Usage:
#   scripts/sync-mcp-configs.sh          # regenerate .vscode/mcp.json
#   scripts/sync-mcp-configs.sh --check  # exit 1 if it's out of sync (for CI)
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
src="$repo_root/.mcp.json"
dest="$repo_root/.vscode/mcp.json"
tmp="$dest.tmp"

mkdir -p "$repo_root/.vscode"

jq '{
  servers: (.mcpServers | with_entries(
    .value += { type: (if .value.url then "http" else "stdio" end) }
  ))
}' "$src" > "$tmp"

if [[ "${1:-}" == "--check" ]]; then
  if [[ ! -f "$dest" ]] || ! diff -q "$dest" "$tmp" >/dev/null 2>&1; then
    echo "FAIL: .vscode/mcp.json is out of sync with .mcp.json — run scripts/sync-mcp-configs.sh"
    rm -f "$tmp"
    exit 1
  fi
  echo "OK: .vscode/mcp.json is in sync with .mcp.json"
  rm -f "$tmp"
else
  mv "$tmp" "$dest"
  echo "Wrote $dest"
fi
