提交说明一定要中文和英文一起写。

# Git Safe Ops

在执行 `git` 或 `gh` 相关操作时，遵循以下规则：

- 默认保持非交互式执行，先导出 `GIT_TERMINAL_PROMPT=0`。
- 只要操作涉及远端、认证或 `gh`，先检查 `gh` 是否已安装并已登录。
- 默认在当前工作分支提交和推送；除非用户明确要求，否则不要新建或切换分支。
- 不要在 `main` / `master` 上开发重大功能；只允许直接处理明确的小 bugfix。
- 不要对共享分支使用 `git reset` 或 `git push --force` 改写历史；撤销已发布提交时使用 `git revert`。
- 需要并行处理多个分支任务时，优先使用 `git worktree`。
- 让失败直接暴露，不要交互登录，不要静默降级，不要伪造成功结果。

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

## 详细参考

读取 [`references/git-rules.md`](./references/git-rules.md) 获取完整规则、认证方案和命令模板。
