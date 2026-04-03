提交说明一定要中文和英文一起写。

# Git Safe Ops

Use these rules whenever the task involves `git` or `gh`.

- Keep Git execution non-interactive. Export `GIT_TERMINAL_PROMPT=0` before remote operations.
- Before any remote, auth, or `gh` action, verify that `gh` is installed and authenticated.
- Stay on the current working branch unless the user explicitly asks for a new branch or a switch.
- Do not build major features directly on `main` or `master`; only small explicit bugfixes may land there.
- Do not rewrite shared branch history with `git reset` or `git push --force`; use `git revert` for published commits.
- Prefer `git worktree` when parallel branch work is needed.
- Surface failures clearly. Do not fall back to interactive login, silent degradation, or fake success.

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

If this pack is kept intact, read [`references/git-rules.md`](./references/git-rules.md) for the full policy and command templates.
