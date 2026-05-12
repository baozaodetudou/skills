# Codex Harness 使用指南 / Usage Guide

[English](#english) | [中文](#中文)

---

## 中文

### 概述

Codex Harness 是一个工作流路由层，根据任务类型自动选择合适的工具：

- **Gstack**: 方向决策和架构评审
- **GSD (Get Shit Done)**: 上下文冻结和项目边界管理
- **Superpowers**: 执行、TDD、调试、代码审查

### 依赖要求

使用前需要安装以下工具：

1. **Gstack** - 安装到 `~/.codex/skills/gstack`
2. **GSD** - 安装到 `~/.codex/get-shit-done`
3. **Superpowers** - 安装到 `~/.codex/superpowers`
4. **GitHub CLI (gh)** - 用于某些 Gstack 操作

### 安装

#### 方式一：安装到 Codex（推荐）

```bash
# 从 skills 仓库根目录运行
./scripts/install-codex-runtime.sh --check-deps
```

这会：
- 安装 codex-harness 和 git-safe-ops 到 `~/.codex/skills/`
- 自动检查依赖是否已安装
- 如果缺少依赖，提供安装说明

#### 方式二：安装到项目

```bash
# 安装到特定项目
./codex-harness/scripts/install-pack.sh --agent all --target /path/to/project

# 只安装 Claude Code 支持
./codex-harness/scripts/install-pack.sh --agent claude --target /path/to/project

# 只安装 Codex 支持
./codex-harness/scripts/install-pack.sh --agent codex --target /path/to/project
```

### 使用场景

#### 1. 方向不明确的任务

当需求模糊、产品方向不确定、架构有多种选择时：

```
use $codex-harness for this task
```

Codex Harness 会使用 Gstack 进行方向决策，输出：
- 目标和约束
- 可选方案及权衡
- 推荐方向
- 风险分析
- 验收标准

#### 2. 新项目或上下文漂移

当项目是新的或上下文已经漂移时：

```
use $codex-harness to freeze project context
```

Codex Harness 会使用 GSD 冻结上下文：
- 记录当前决策和范围
- 记录项目特定命令
- 记录验证脚本
- 定义所有权边界

#### 3. 结构化实现

当方向明确，需要执行时：

```
use $codex-harness to implement this feature
```

Codex Harness 会使用 Superpowers 执行：
- 检查项目规则
- 创建简短计划
- 小步实现
- 增量验证

#### 4. 调试问题

当遇到 bug、测试失败或不明原因的问题时：

```
use $codex-harness to debug this issue
```

Codex Harness 会使用 Superpowers 调试流程：
- 重现问题
- 追踪根因
- 形成假设
- 验证修复

#### 5. 高风险变更

当进行高风险行为变更时：

```
use $codex-harness with TDD for this change
```

Codex Harness 会使用 Superpowers TDD 流程：
- 先写测试（RED）
- 实现功能（GREEN）
- 重构优化（REFACTOR）

### 验证依赖

安装后，验证所有依赖是否已安装：

```bash
# 如果安装到 Codex
~/.codex/skills/codex-harness/scripts/check-dependencies.sh

# 如果安装到项目
./.agent-packs/codex-harness/scripts/check-dependencies.sh
```

### 故障排除

#### 依赖缺失

如果依赖检查失败，运行：

```bash
~/.codex/skills/codex-harness/scripts/check-dependencies.sh
```

脚本会显示缺失的依赖和安装说明。

#### 跳过依赖检查

如果确定要跳过依赖检查（不推荐）：

```bash
./codex-harness/scripts/install-pack.sh --agent all --target /path/to/project --skip-deps-check
```

---

## English

### Overview

Codex Harness is a workflow router that automatically selects the appropriate tool based on task type:

- **Gstack**: Direction decisions and architecture review
- **GSD (Get Shit Done)**: Context freezing and project boundary management
- **Superpowers**: Execution, TDD, debugging, code review

### Dependencies

The following tools must be installed before use:

1. **Gstack** - Install to `~/.codex/skills/gstack`
2. **GSD** - Install to `~/.codex/get-shit-done`
3. **Superpowers** - Install to `~/.codex/superpowers`
4. **GitHub CLI (gh)** - Used for some Gstack operations

### Installation

#### Option 1: Install to Codex (Recommended)

```bash
# Run from skills repository root
./scripts/install-codex-runtime.sh --check-deps
```

This will:
- Install codex-harness and git-safe-ops to `~/.codex/skills/`
- Automatically check if dependencies are installed
- Provide installation instructions if dependencies are missing

#### Option 2: Install to Project

```bash
# Install to specific project
./codex-harness/scripts/install-pack.sh --agent all --target /path/to/project

# Install Claude Code support only
./codex-harness/scripts/install-pack.sh --agent claude --target /path/to/project

# Install Codex support only
./codex-harness/scripts/install-pack.sh --agent codex --target /path/to/project
```

### Usage Scenarios

#### 1. Ambiguous Direction

When requirements are vague, product direction is uncertain, or architecture has multiple options:

```
use $codex-harness for this task
```

Codex Harness will use Gstack for direction decisions, outputting:
- Goals and constraints
- Options with tradeoffs
- Recommended direction
- Risk analysis
- Acceptance criteria

#### 2. New Project or Context Drift

When the project is new or context has drifted:

```
use $codex-harness to freeze project context
```

Codex Harness will use GSD to freeze context:
- Record current decisions and scope
- Record project-specific commands
- Record validation scripts
- Define ownership boundaries

#### 3. Structured Implementation

When direction is clear and ready to execute:

```
use $codex-harness to implement this feature
```

Codex Harness will use Superpowers execution:
- Check project rules
- Create short plan
- Implement in small steps
- Incremental validation

#### 4. Debugging Issues

When encountering bugs, test failures, or unclear issues:

```
use $codex-harness to debug this issue
```

Codex Harness will use Superpowers debugging workflow:
- Reproduce issue
- Trace root cause
- Form hypothesis
- Verify fix

#### 5. High-Risk Changes

When making high-risk behavior changes:

```
use $codex-harness with TDD for this change
```

Codex Harness will use Superpowers TDD workflow:
- Write test first (RED)
- Implement feature (GREEN)
- Refactor (REFACTOR)

### Verify Dependencies

After installation, verify all dependencies are installed:

```bash
# If installed to Codex
~/.codex/skills/codex-harness/scripts/check-dependencies.sh

# If installed to project
./.agent-packs/codex-harness/scripts/check-dependencies.sh
```

### Troubleshooting

#### Missing Dependencies

If dependency check fails, run:

```bash
~/.codex/skills/codex-harness/scripts/check-dependencies.sh
```

The script will show missing dependencies and installation instructions.

#### Skip Dependency Check

If you're sure you want to skip dependency check (not recommended):

```bash
./codex-harness/scripts/install-pack.sh --agent all --target /path/to/project --skip-deps-check
```
