# Git 操作参考

## 分支与协作策略

- 在 `main` / `master` 上只处理允许直接落地的小 bugfix；不要在共享主分支上开发新功能或大需求。
- 在需要完整功能开发时，使用独立分支，例如 `feature/xxx`，并通过 PR 合并。
- 在需要紧急修复时，使用 `hotfix/xxx` 分支，经 PR 合并后再同步到其他相关分支。
- 在需要并行处理多个分支任务时，优先使用 `git worktree`，避免反复切换一个工作目录。
- 在共享分支上不要使用 `git reset` 或 `git push --force` 改写历史；撤销已发布提交时使用 `git revert`。
- 在提交代码时，提交说明同时写中文和英文。

### worktree 示例

```bash
git worktree add "../msm-assistant-feature-a" -b feature/a
```

## 非交互式 Git 前置检查

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

- 在任何可能触发远端认证的 `git fetch`、`git pull`、`git push` 或 `gh` 命令前，先执行这段检查。
- 若 `gh` 不可用或未认证，立即停止并报告，不要尝试交互式登录。
- 默认提交并推送到当前工作分支；除非用户明确要求，否则不要新建或切换分支。

## 认证方案

### SSH key

```bash
GIT_SSH_COMMAND='ssh -o BatchMode=yes' git push origin HEAD
```

- 优先使用 SSH key。
- 用 `BatchMode=yes` 保证 SSH 不会卡在交互提示上。

### GitHub CLI credential helper

```bash
echo "$GITHUB_TOKEN" | gh auth login --with-token
git config --local credential.helper "!gh auth git-credential"
```

- 适合 CI 或已经使用 `gh` 管理凭证的环境。

### GIT_ASKPASS

```bash
export GIT_ASKPASS=/path/to/script.sh
```

- 仅在确实需要通过脚本注入凭证时使用。
- 不要把 token 或密码写死在脚本里。

### HTTP extraHeader

```bash
GIT_TERMINAL_PROMPT=0 git -c http.extraHeader="Authorization: Bearer $GITHUB_TOKEN" clone https://github.com/OWNER/REPO.git
```

- 适合短生命周期的 CI 命令。
- 不要在日志中打印 token。

## 失败处理

```bash
if ! GIT_TERMINAL_PROMPT=0 git push origin main; then
  echo "ERROR: Non-interactive Git authentication failed." >&2
  exit 1
fi
```

- 让命令以非零退出码失败，不要吞错。
- 不要添加模拟成功、静默降级或交互式兜底路径。

## PR 与保护分支

- 关键分支启用 Branch Protection。
- 通过 PR 合并。
- 至少一名审核者批准。
- 所有必需的 CI 状态检查通过。
- 禁止强制推送。
- PR 说明写清楚变更目的、实现方式和测试步骤。
