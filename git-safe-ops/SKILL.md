---
name: git-safe-ops
description: 用于 Git 或 GitHub CLI 操作，包括提交、推送、拉取、回滚、分支切换、`git worktree`、`gh auth status` 和 Git 自动化脚本编写。适用于需要非交互执行、共享分支安全和明确失败信号的场景。
---

# Git Safe Ops

## 何时使用

- 在执行 `git` / `gh` 命令时使用。
- 在写 Git 自动化脚本或 CI 里的 Git 步骤时使用。

## 核心规则

- 默认保持非交互：先导出 `GIT_TERMINAL_PROMPT=0`。
- 默认留在当前工作分支；除非用户明确要求，否则不要擅自新建或切换分支。
- 不要在 `main` / `master` 上直接做重大功能；已发布提交要回滚时用 `git revert`，不要对共享分支用 `git reset` 或 `git push --force`。
- 需要并行处理多个分支任务时，优先使用 `git worktree`。
- 提交说明同时写中文和英文。

## 前置检查

```bash
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

## 详细规则

- 需要认证方案、脚本模板、`worktree` 示例或 PR 约束时，读取 [references/git-rules.md](references/git-rules.md)。
