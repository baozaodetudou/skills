提交说明一定要中文和英文一起写。

# Git Safe Ops

Apply these rules whenever the task touches `git` or `gh`.

- Run Git in non-interactive mode. Export `GIT_TERMINAL_PROMPT=0` before remote operations.
- Before any remote, auth, or `gh` command, check that `gh` exists and is authenticated.
- Stay on the current branch unless the user explicitly requests a branch change.
- Do not develop major features directly on `main` or `master`; only small explicit bugfixes may be done there.
- Do not rewrite shared history with `git reset` or `git push --force`; use `git revert` for published commits.
- Prefer `git worktree` when working on multiple branches in parallel.
- Expose failures clearly. Do not use interactive login, silent fallbacks, or mock success paths.

## Preflight

```bash
#!/bin/bash
set -euo pipefail

export GIT_TERMINAL_PROMPT=0

if ! command -v gh >/dev/null 2>&1; then
  echo "ERROR: GitHub CLI (gh) not installed" >&2
  exit 2
fi

if ! gh auth status --hostname github.com >/dev/null 2>&1; then
  echo "ERROR: GitHub CLI (gh) not authenticated" >&2
  exit 3
fi
```

## Detailed Reference

If this pack is used as-is, keep [`references/git-rules.md`](./references/git-rules.md) alongside this file for the full policy and command templates.
