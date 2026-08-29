#!/usr/bin/env bash
# Verifies every symlink listed in .agents/manifest.txt (agent instruction
# files and same-schema config files, e.g. .cursor/mcp.json) exists, points
# at the expected target, and resolves to a real file. Run manually or from CI.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest="$repo_root/.agents/manifest.txt"
status=0

while IFS='|' read -r tool path target; do
  [[ -z "$tool" || "$tool" == \#* ]] && continue
  full_path="$repo_root/$path"

  if [[ ! -L "$full_path" ]]; then
    echo "FAIL [$tool]: $path is not a symlink"
    status=1
    continue
  fi

  actual_target="$(readlink "$full_path")"
  if [[ "$actual_target" != "$target" ]]; then
    echo "FAIL [$tool]: $path -> $actual_target (expected $target)"
    status=1
    continue
  fi

  if [[ ! -f "$full_path" ]]; then
    echo "FAIL [$tool]: $path resolves to a missing file"
    status=1
    continue
  fi

  echo "OK   [$tool]: $path -> $target"
done < "$manifest"

exit "$status"
