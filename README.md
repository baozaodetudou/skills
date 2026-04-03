# skills

这个仓库用于存放可复用的 agent skill / instruction pack。

当前已包含：

- `git-safe-ops`：面向 Git 与 GitHub CLI 的安全、非交互式操作规范，覆盖分支策略、认证检查、提交与推送约束、`worktree`、`revert` 和 PR 协作要求。

## 支持矩阵

- Codex skill：[`git-safe-ops/SKILL.md`](./git-safe-ops/SKILL.md)
- Codex project instructions：[`git-safe-ops/AGENTS.md`](./git-safe-ops/AGENTS.md)
- Claude Code：[`git-safe-ops/CLAUDE.md`](./git-safe-ops/CLAUDE.md)
- Gemini CLI：[`git-safe-ops/GEMINI.md`](./git-safe-ops/GEMINI.md)

## 使用方式

### Codex 作为 skill

把整个 `git-safe-ops` 目录放到 `~/.codex/skills/git-safe-ops/`。

### Codex 作为项目规则

把 [`git-safe-ops/AGENTS.md`](./git-safe-ops/AGENTS.md) 放到项目根目录。

### Claude Code

把 [`git-safe-ops/CLAUDE.md`](./git-safe-ops/CLAUDE.md) 放到项目根目录，或放到 `./.claude/CLAUDE.md`。

### Gemini CLI

把 [`git-safe-ops/GEMINI.md`](./git-safe-ops/GEMINI.md) 放到项目根目录。

## 目录结构

```text
git-safe-ops/
├── AGENTS.md
├── CLAUDE.md
├── GEMINI.md
├── SKILL.md
├── agents/
│   └── openai.yaml
└── references/
    └── git-rules.md
```

## 说明

- `references/git-rules.md` 是详细规则来源。
- `AGENTS.md`、`CLAUDE.md`、`GEMINI.md` 是针对不同 agent 的项目级适配文件。
- `SKILL.md` 和 `agents/openai.yaml` 用于 Codex 的 skill 发现与加载。
