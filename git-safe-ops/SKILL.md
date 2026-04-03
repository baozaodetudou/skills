---
name: git-safe-ops
description: 在执行 Git 或 GitHub CLI 相关操作时使用，包括 `git status`、`git diff`、`git commit`、`git fetch/pull/push`、`git branch/switch`、`git revert`、`git cherry-pick`、`git worktree`、`gh auth status`、PR 准备和 Git 自动化脚本编写。适用于需要遵循安全分支策略、非交互式认证、禁止强推共享分支、保留明确失败信号的仓库协作场景。
---

# Git Safe Ops

## 执行范围

- 在准备执行任何 `git` 或 `gh` 命令前，先按本 skill 的最小流程检查分支、认证和失败处理方式。
- 在需要提交、推送、回滚、创建 `worktree`、编写 Git 自动化脚本或 CI 中配置 Git 认证时，使用本 skill。

## 典型触发

- “先帮我检查 `gh` 登录状态，再把当前分支安全推上去”
- “我要写一个非交互式的 Git 发布脚本”
- “这个提交已经推远端了，帮我安全回滚”
- “我要同时开两个分支开发，用 `git worktree` 搭一下”
- “把这套 Git 规则装到 Codex / Claude / Gemini 项目里”

## 先做判断

- 判断当前任务是不是重大功能或大需求。若是，不要直接在 `main` / `master` 开发。
- 判断当前任务是不是主分支允许直接处理的小 bugfix。若不是，停在当前分支策略上，不要擅自简化流程。
- 判断本次操作会不会访问远端、依赖 `gh`、修改共享分支历史或触发认证。只要答案是会，就先做前置检查。
- 判断用户有没有明确要求新建或切换分支。没有明确要求时，默认留在当前工作分支。

## 最小执行流程

1. 先导出非交互环境变量：
```bash
export GIT_TERMINAL_PROMPT=0
```
2. 只要操作会访问远端或依赖 `gh` 身份，优先直接运行 `scripts/git-preflight.sh`；如果当前环境没有这个脚本，再用下面的检查片段：
```bash
if ! command -v gh >/dev/null 2>&1; then
  echo "ERROR: GitHub CLI (gh) not installed" >&2
  exit 2
fi

if ! gh auth status --hostname github.com >/dev/null 2>&1; then
  echo "ERROR: GitHub CLI (gh) not authenticated" >&2
  exit 3
fi
```
3. 默认在当前分支执行 `status`、`diff`、`commit` 和 `push`，除非用户明确要求分支调整或 `worktree`。
4. 需要撤销已发布提交时，使用 `git revert`，不要对共享分支使用 `git reset` 或 `git push --force`。
5. 让失败直接暴露，不要交互登录，不要吞掉认证错误，不要加模拟成功路径。

## 常用决策

- 需要并行开发多个分支时，优先使用 `git worktree`，不要在同一工作目录来回切换上下文。
- 需要编写 Git 自动化脚本时，使用 `#!/bin/bash` 和 `set -euo pipefail`，并保留非交互式失败退出。
- 需要设置认证方式时，优先使用 SSH key；其次是 `gh` credential helper；只有在合适的 CI 场景下再考虑 `GIT_ASKPASS` 或 `http.extraHeader`。
- 需要提交说明时，同时写中文和英文。
- 需要把这套规则落到真实项目时，优先运行 `scripts/install-pack.sh`，而不是手工复制零散文件。

## 读取资源

- 需要分支策略、认证方案、脚本模板、`worktree` 示例或 PR 约束时，读取 [references/git-rules.md](references/git-rules.md)。
- 需要先做 `gh` 安装与登录检查时，运行 `scripts/git-preflight.sh`。
- 需要把规则安装到某个项目时，运行 `scripts/install-pack.sh`。
