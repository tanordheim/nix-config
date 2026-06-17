#!/usr/bin/env bash
set -euo pipefail

name="$(jq -er '.name')" || { echo "claude-worktree-create: missing .name in hook input" >&2; exit 1; }
git check-ref-format "refs/heads/$name" || { echo "claude-worktree-create: invalid worktree name: '$name'" >&2; exit 1; }

root="$(git rev-parse --show-toplevel)"
dir="$root/.worktrees/$name"
excl="$(git rev-parse --git-common-dir)/info/exclude"

grep -qxF '.worktrees/' "$excl" 2>/dev/null || printf '.worktrees/\n' >>"$excl"

git -C "$root" worktree prune

if ! git -C "$root" worktree list --porcelain | grep -qxF "worktree $dir"; then
  if git -C "$root" show-ref --quiet --verify "refs/heads/$name"; then
    git -C "$root" worktree add "$dir" "$name" >&2
  else
    base="origin/HEAD"
    git -C "$root" rev-parse --verify -q "$base" >/dev/null 2>&1 || base="HEAD"
    git -C "$root" worktree add -b "$name" "$dir" "$base" >&2
  fi
fi

{ [ "${HERDR_ENV:-}" = 1 ] && [ -n "${HERDR_PANE_ID:-}" ] && command -v herdr >/dev/null \
  && herdr agent rename "$HERDR_PANE_ID" "$name"; } >/dev/null 2>&1 || true

if [ -d "$root/.codegraph" ] && [ ! -d "$dir/.codegraph" ]; then
  codegraph init "$dir" >>"${XDG_CACHE_HOME:-$HOME/.cache}/codegraph-autoinit.log" 2>&1 &
fi

echo "$dir"
