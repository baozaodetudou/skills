# 架构重新设计 / Architecture Redesign

## 问题分析 / Problem Analysis

### 当前架构的问题

**共享依赖方案**:
```
~/.codex/
├── get-shit-done/       # 共享
└── superpowers/         # 共享
    ├── .claude-plugin/
    └── .codex-plugin/
```

**问题**:
1. ❌ 如果只有 Claude Code，没有 Codex，`~/.codex/` 目录不存在
2. ❌ Superpowers 和 GSD 的配置可能不同（skills、组件、版本）
3. ❌ 环境耦合，一个环境的更新可能影响另一个
4. ❌ 不符合"环境隔离"的设计原则

## 新架构设计 / New Architecture

### 独立安装方案

#### Codex 环境
```
~/.codex/
├── skills/
│   ├── codex-harness/
│   ├── git-safe-ops/
│   └── gstack/
├── get-shit-done/           # Codex 专用
└── superpowers/             # Codex 专用
    └── .codex-plugin/
```

#### Claude Code 环境
```
~/.claude/
├── skills/
│   ├── claude-harness/
│   ├── git-safe-ops/
│   └── gstack/
├── get-shit-done/           # Claude Code 专用
└── superpowers/             # Claude Code 专用
    └── .claude-plugin/
```

### 优势

✅ **完全独立**: 每个环境有自己的依赖
✅ **无耦合**: 一个环境的更新不影响另一个
✅ **灵活配置**: 可以使用不同版本、不同配置
✅ **单环境友好**: 只有 Claude Code 也能正常工作

## 实施方案 / Implementation Plan

### 1. 更新安装脚本

#### install-claude-runtime.sh

添加自动安装 Superpowers 和 GSD：

```bash
install_dependencies() {
  # 检查并安装 Superpowers
  if [ ! -d "${CLAUDE_HOME}/superpowers" ]; then
    echo "Installing Superpowers..."
    git clone https://github.com/obra/superpowers "${CLAUDE_HOME}/superpowers"
  fi
  
  # 检查并安装 GSD
  if [ ! -d "${CLAUDE_HOME}/get-shit-done" ]; then
    echo "Installing Get Shit Done..."
    git clone https://github.com/cyanheads/get-shit-done "${CLAUDE_HOME}/get-shit-done"
  fi
}
```

#### install-codex-runtime.sh

类似地安装到 `~/.codex/`

### 2. 更新依赖检查脚本

#### check-dependencies-claude.sh

检查 Claude Code 专用路径：
```bash
REQUIRED_DEPS=(
  "gstack:${CLAUDE_HOME}/skills/gstack"
  "get-shit-done:${CLAUDE_HOME}/get-shit-done"      # 改为 Claude 专用
  "superpowers:${CLAUDE_HOME}/superpowers"          # 改为 Claude 专用
)
```

#### check-dependencies.sh (Codex)

检查 Codex 专用路径：
```bash
REQUIRED_DEPS=(
  "gstack:${CODEX_HOME}/skills/gstack"
  "get-shit-done:${CODEX_HOME}/get-shit-done"       # Codex 专用
  "superpowers:${CODEX_HOME}/superpowers"           # Codex 专用
)
```

### 3. 更新文档

所有文档更新为独立安装架构。

## 迁移指南 / Migration Guide

### 如果你当前使用共享架构

#### 选项 1: 复制到 Claude Code

```bash
# 复制 Superpowers
cp -R ~/.codex/superpowers ~/.claude/superpowers

# 复制 GSD
cp -R ~/.codex/get-shit-done ~/.claude/get-shit-done
```

#### 选项 2: 重新安装

```bash
# 重新运行安装脚本
./scripts/install-claude-runtime.sh --check-deps --install-deps
```

### 如果你只有 Claude Code

```bash
# 直接安装，会自动安装依赖
./scripts/install-claude-runtime.sh --check-deps --install-deps
```

## 对比 / Comparison

| 方面 | 共享架构 | 独立架构 |
|------|---------|---------|
| 环境隔离 | ❌ 耦合 | ✅ 完全隔离 |
| 单环境支持 | ❌ 需要 Codex | ✅ 独立工作 |
| 配置灵活性 | ❌ 共享配置 | ✅ 独立配置 |
| 版本管理 | ❌ 统一版本 | ✅ 独立版本 |
| 磁盘空间 | ✅ 节省空间 | ❌ 重复安装 |
| 更新影响 | ❌ 相互影响 | ✅ 互不影响 |

## 推荐方案 / Recommendation

**推荐使用独立架构**，因为：

1. ✅ 符合"环境隔离"原则
2. ✅ 支持单环境使用
3. ✅ 配置更灵活
4. ✅ 更新更安全
5. ⚠️ 磁盘空间影响小（Superpowers ~100MB, GSD ~10MB）

## 下一步 / Next Steps

1. 更新 `install-claude-runtime.sh` 支持自动安装依赖
2. 更新 `install-codex-runtime.sh` 支持自动安装依赖
3. 更新依赖检查脚本
4. 更新所有文档
5. 提供迁移脚本
