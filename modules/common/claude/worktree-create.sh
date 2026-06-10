#!/usr/bin/env bash
set -euo pipefail

name="$(jq -er '.name')" || { echo "claude-worktree-create: missing .name in hook input" >&2; exit 1; }
git check-ref-format "refs/heads/trond/$name" || { echo "claude-worktree-create: invalid worktree name: '$name'" >&2; exit 1; }

root="$(git rev-parse --show-toplevel)"
dir="$root/.worktrees/$name"
excl="$(git rev-parse --git-common-dir)/info/exclude"

grep -qxF '.worktrees/' "$excl" 2>/dev/null || printf '.worktrees/\n' >>"$excl"

git -C "$root" worktree prune

if ! git -C "$root" worktree list --porcelain | grep -qxF "worktree $dir"; then
  if git -C "$root" show-ref --quiet --verify "refs/heads/trond/$name"; then
    git -C "$root" worktree add "$dir" "trond/$name" >&2
  else
    base="origin/HEAD"
    git -C "$root" rev-parse --verify -q "$base" >/dev/null 2>&1 || base="HEAD"
    git -C "$root" worktree add -b "trond/$name" "$dir" "$base" >&2
  fi
fi

echo "$dir"
