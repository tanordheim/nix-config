---
name: worktree
description: Switch into a git worktree while keeping conversation history bound to the launch directory. Use when user invokes /worktree <path> to work in a worktree without losing history when it's removed.
---

1. Resolve <path> (absolute, or relative to launch cwd). Verify with `git -C <path> rev-parse --show-toplevel`.
2. `cd <path>`. Confirm absolute path back to the user in one line.
3. Re-check state: `git status`. Initial gitStatus context reflects the launch cwd and is stale.
4. Operate normally from there. Do not `cd` out of <path> for the rest of the session. If a sub-task needs another directory, use absolute paths or `git -C` / `(cd … && …)` so cwd stays in <path>.

If <path> doesn't exist or isn't a worktree, ask once. Don't guess.
