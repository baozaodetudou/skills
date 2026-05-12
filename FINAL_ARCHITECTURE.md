# 最终架构说明 / Final Architecture Documentation

## 🎯 架构设计原则 / Architecture Design Principles

### 独立安装，环境隔离 / Independent Installation, Environment Isolation

每个 AI 助手环境（Codex、Claude Code、Gemini）都有自己独立的依赖安装，互不干扰。

---

## 📁 目录结构 / Directory Structure

### Codex 环境
```
~/.codex/
├── skills/
│   ├── codex-harness/      # 工作流路由
│   ├── git-safe-ops/        # Git 安全操作
│   └── gstack/              # 方向决策
├── get-shit-done/           # 上下文冻结（Codex 专用）
└── superpowers/             # 执行工作流（Codex 专用）
    └── .codex-plugin/
```

### Claude Code 环境
```
~/.claude/
├── skills/
│   ├── claude-harness/      # 工作流路由
│   ├── git-safe-ops/        # Git 安全操作
│   └── gstack/              # 方向决策（原生 skill）
├── get-shit-done/           # 上下文冻结（Claude Code 专用）
└── superpowers/             # 执行工作流（Claude Code 专用）
    └── .claude-plugin/
```

---

## ✅ 为什么选择独立安装 / Why Independent Installation

### 问题：共享依赖架构的缺陷

如果使用共享架构（所有环境共享 `~/.codex/` 下的依赖）：

1. ❌ **单环境不友好**: 只有 Claude Code 时，`~/.codex/` 目录不存在
2. ❌ **环境耦合**: 一个环境的更新会影响另一个环境
3. ❌ **配置冲突**: Superpowers 和 GSD 在不同环境可能需要不同配置
4. ❌ **版本冲突**: 不同环境可能需要不同版本的依赖
5. ❌ **Skills 差异**: Superpowers 的 skills 和组件在不同环境可能不同

### 解决方案：独立安装架构

每个环境独立安装依赖：

1. ✅ **完全独立**: 每个环境有自己的依赖副本
2. ✅ **无耦合**: 一个环境的更新不影响另一个
3. ✅ **灵活配置**: 可以使用不同版本、不同配置
4. ✅ **单环境友好**: 只有 Claude Code 也能正常工作
5. ✅ **Skills 隔离**: 每个环境可以有自己的 skills 和组件

---

## 🚀 安装方式 / Installation Methods

### Codex 环境

```bash
# 安装到 Codex（包含自动安装依赖）
./scripts/install-codex-runtime.sh --check-deps

# 注意：Codex 的依赖安装脚本待实现
# 当前需要手动安装 Superpowers 和 GSD 到 ~/.codex/
```

### Claude Code 环境

```bash
# 完整安装（推荐）
./scripts/install-claude-runtime.sh --install-deps --check-deps
```

这会：
1. 安装 `claude-harness` 和 `git-safe-ops` 到 `~/.claude/skills/`
2. 自动克隆 Superpowers 到 `~/.claude/superpowers`
3. 自动克隆 GSD 到 `~/.claude/get-shit-done`
4. 验证所有依赖是否正确安装

---

## 🔍 依赖检查 / Dependency Check

### Codex

```bash
~/.codex/skills/codex-harness/scripts/check-dependencies.sh
```

检查：
- `~/.codex/skills/gstack`
- `~/.codex/get-shit-done`
- `~/.codex/superpowers`

### Claude Code

```bash
~/.claude/skills/claude-harness/scripts/check-dependencies-claude.sh
```

检查：
- `~/.claude/skills/gstack`
- `~/.claude/get-shit-done`
- `~/.claude/superpowers`

---

## 📊 对比分析 / Comparison

| 方面 | 共享架构 | 独立架构 ✅ |
|------|---------|------------|
| 环境隔离 | ❌ 耦合 | ✅ 完全隔离 |
| 单环境支持 | ❌ 需要 Codex | ✅ 独立工作 |
| 配置灵活性 | ❌ 共享配置 | ✅ 独立配置 |
| 版本管理 | ❌ 统一版本 | ✅ 独立版本 |
| Skills 管理 | ❌ 共享 skills | ✅ 独立 skills |
| 磁盘空间 | ✅ 节省空间 | ⚠️ 重复安装 |
| 更新影响 | ❌ 相互影响 | ✅ 互不影响 |

**磁盘空间影响**：
- Superpowers: ~100MB
- GSD: ~10MB
- 总计: ~110MB × 环境数量

对于现代硬件，这个空间开销是可以接受的，换来的是更好的隔离性和灵活性。

---

## 🔄 迁移指南 / Migration Guide

### 从共享架构迁移到独立架构

如果你之前使用共享架构（依赖在 `~/.codex/`），现在想迁移到独立架构：

#### 方式一：复制现有安装

```bash
# 复制到 Claude Code
cp -R ~/.codex/superpowers ~/.claude/superpowers
cp -R ~/.codex/get-shit-done ~/.claude/get-shit-done

# 验证
~/.claude/skills/claude-harness/scripts/check-dependencies-claude.sh
```

#### 方式二：重新安装

```bash
# 重新运行安装脚本
./scripts/install-claude-runtime.sh --install-deps --check-deps
```

---

## 🎯 使用示例 / Usage Examples

### 工作流路由

#### Codex
```
use $codex-harness for this task
```

#### Claude Code
```
use /claude-harness for this task
```

### 直接使用工具

#### Gstack（浏览器操作）
```
use /gstack to test the website
```

#### Git 安全操作
```
use /git-safe-ops for git operations
```

---

## 📚 相关文档 / Related Documentation

| 文档 | 用途 |
|------|------|
| `README.md` | 主文档，安装和使用说明 |
| `QUICKSTART.md` | 快速参考指南 |
| `ARCHITECTURE_REDESIGN.md` | 架构重新设计说明 |
| `CLAUDE_VERIFICATION.md` | Claude Code 配置验证 |
| `CLAUDE_CLEANUP.md` | 环境整理总结 |

---

## ✨ 总结 / Summary

### 核心原则

**独立安装，环境隔离**

每个 AI 助手环境都有自己独立的依赖安装：
- ✅ Codex → `~/.codex/`
- ✅ Claude Code → `~/.claude/`
- ✅ Gemini → `~/.gemini/`（待实现）

### 优势

1. **完全独立**: 无环境耦合
2. **单环境友好**: 只有一个环境也能工作
3. **灵活配置**: 不同版本、不同配置
4. **更新安全**: 互不影响
5. **Skills 隔离**: 每个环境独立管理

### 当前状态

✅ **Claude Code 环境已完全配置好**

- Skills: gstack, claude-harness, git-safe-ops
- 依赖: GSD, Superpowers（独立安装）
- 配置: CLAUDE.md, settings.json（已优化）
- 工具: 安装脚本、依赖检查脚本

可以立即使用！🎉
