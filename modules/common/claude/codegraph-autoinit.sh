#!/usr/bin/env bash
# Background-init codegraph the first time Claude opens a repo whose working
# directory is under the allowed code root (passed as $1). No-ops if the repo
# is already a codegraph project. Concurrent inits serialize at codegraph's
# SQLite/WAL + daemon layer, so no external lock is needed here.
set -euo pipefail

allowed="${1:-}"
[ -n "$allowed" ] || exit 0

input="$(cat 2>/dev/null || true)"
cwd="$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null || true)"
[ -n "$cwd" ] || cwd="$PWD"

case "$cwd/" in
  "$allowed"/*) ;;
  *) exit 0 ;;
esac

root="$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null || true)"
[ -n "$root" ] || exit 0
[ ! -d "$root/.codegraph" ] || exit 0

codegraph init "$root" >>"${XDG_CACHE_HOME:-$HOME/.cache}/codegraph-autoinit.log" 2>&1 &
exit 0
