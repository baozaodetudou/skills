# Codex Harness 快速参考 / Quick Reference

## 一键安装 / One-Command Installation

### Codex

```bash
# 安装到 Codex 并检查依赖
./scripts/install-codex-runtime.sh --check-deps
```

### Claude Code

```bash
# 安装到 Claude Code 并自动安装依赖
./scripts/install-claude-runtime.sh --install-deps --check-deps
```

## 验证安装 / Verify Installation

### Codex

```bash
# 检查依赖
~/.codex/skills/codex-harness/scripts/check-dependencies.sh
```

### Claude Code

```bash
# 检查依赖
~/.claude/skills/claude-harness/scripts/check-dependencies-claude.sh
```

## 使用 / Usage

### 在 Codex 中使用 / Use in Codex

```
use $codex-harness for this task
```

### 在 Claude Code 中使用 / Use in Claude Code

```
use claude-harness for this task
```

或者直接引用工作流文件：
```
Read .claude/skills/claude-harness/references/gstack-decision.md for direction decisions
```

### 安装到项目 / Install to Project

```bash
# 所有环境
./codex-harness/scripts/install-pack.sh --agent all --target /path/to/project

# 仅 Claude Code
./codex-harness/scripts/install-pack.sh --agent claude --target /path/to/project

# 仅 Codex
./codex-harness/scripts/install-pack.sh --agent codex --target /path/to/project
```

## 工作流路由 / Workflow Router

| 任务类型 | 使用工具 | 参考文档 |
|---------|---------|---------|
| 方向不明确 | Gstack | `references/gstack-decision.md` |
| 新项目/上下文漂移 | GSD | `references/gsd-context.md` |
| 结构化实现 | Superpowers | `references/superpowers-execution.md` |
| 调试问题 | Superpowers | `references/superpowers-debugging.md` |
| 高风险变更 | Superpowers TDD | `references/superpowers-tdd.md` |
| 完成前检查 | QA | `references/qa-checklist.md` |

## 依赖 / Dependencies

### Codex

必需：
- `~/.codex/skills/gstack` - 方向决策
- `~/.codex/get-shit-done` - 上下文冻结
- `~/.codex/superpowers` - 执行工作流

### Claude Code

必需：
- `~/.claude/skills/gstack` - 方向决策（Claude Code skill）
- `~/.claude/get-shit-done` - 上下文冻结（独立安装）
- `~/.claude/superpowers` - 执行工作流（独立安装，含 .claude-plugin/）

可选：
- `gh` (GitHub CLI) - 某些 Gstack 操作

## 常用命令 / Common Commands

### Codex

```bash
# 检查依赖
~/.codex/skills/codex-harness/scripts/check-dependencies.sh

# 预览安装
./codex-harness/scripts/install-pack.sh --agent all --target . --dry-run

# 强制覆盖安装
./codex-harness/scripts/install-pack.sh --agent all --target . --force

# 跳过依赖检查（不推荐）
./codex-harness/scripts/install-pack.sh --agent all --target . --skip-deps-check
```

### Claude Code

```bash
# 检查依赖
~/.claude/skills/claude-harness/scripts/check-dependencies-claude.sh

# 预览安装
./codex-harness/scripts/install-pack.sh --agent claude --target . --dry-run

# 强制覆盖安装
./codex-harness/scripts/install-pack.sh --agent claude --target . --force
```

## 文档 / Documentation

- 完整使用指南: `codex-harness/USAGE.md`
- 改进总结: `IMPROVEMENTS.md`
- 主文档: `README.md`

## 支持的环境 / Supported Environments

- ✅ Codex CLI/App
- ✅ Claude Code
- ✅ Gemini CLI

## 故障排除 / Troubleshooting

### 依赖缺失

```bash
# 查看详细安装说明
~/.codex/skills/codex-harness/scripts/check-dependencies.sh
```

### 安装失败

```bash
# 使用 dry-run 查看将要执行的操作
./codex-harness/scripts/install-pack.sh --agent all --target . --dry-run

# 使用 force 覆盖已存在的文件
./codex-harness/scripts/install-pack.sh --agent all --target . --force
```

## 更多信息 / More Information

查看完整文档：
- 英文: `codex-harness/USAGE.md#english`
- 中文: `codex-harness/USAGE.md#中文`
