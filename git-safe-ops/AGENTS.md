提交说明一定要中文和英文一起写。

# Git Safe Ops

在执行 `git` 或 `gh` 相关操作时遵循这些规则：

- 默认保持非交互：先导出 `GIT_TERMINAL_PROMPT=0`。
- 只要涉及远端、认证或 `gh`，先检查 `gh` 是否已安装并已登录。
- 默认留在当前工作分支；除非用户明确要求，否则不要新建或切换分支。
- 不要在 `main` / `master` 上直接做重大功能；回滚已发布提交时使用 `git revert`，不要对共享分支使用 `git reset` 或 `git push --force`。
- 需要并行处理多个分支任务时，优先使用 `git worktree`。

## 前置检查

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

需要更完整的规则时，读取 `.agent-packs/git-safe-ops/references/git-rules.md`，或直接运行 `.agent-packs/git-safe-ops/scripts/git-preflight.sh`。
