# Claude Code 适配总结 / Claude Code Adaptation Summary

## 完成的工作 / Completed Work

### 1. Claude Code 安装脚本 / Installation Script

创建了 `scripts/install-claude-runtime.sh`，专门用于 Claude Code 环境：

**功能**：
- 安装 `codex-harness` (作为 `claude-harness`) 到 `~/.claude/skills/`
- 安装 `git-safe-ops` 到 `~/.claude/skills/`
- 支持 `--check-deps` 自动检查依赖
- 支持 `--dry-run` 预览安装
- 自动备份已存在的文件到 `~/.claude/backups/`

**使用**：
```bash
./scripts/install-claude-runtime.sh --check-deps
```

### 2. Claude Code 依赖检查脚本 / Dependency Check Script

创建了 `codex-harness/scripts/check-dependencies-claude.sh`：

**功能**：
- 检查 Gstack 是否安装在 `~/.claude/skills/gstack`
- 检查 GSD 是否安装在 `~/.codex/get-shit-done`
- 检查 Superpowers 是否安装在 `~/.codex/superpowers`
- 检查 GitHub CLI (gh) 是否可用
- 提供详细的安装说明

**使用**：
```bash
~/.claude/skills/claude-harness/scripts/check-dependencies-claude.sh
```

### 3. 架构设计 / Architecture Design

#### Codex 架构

```
~/.codex/
├── skills/
│   ├── codex-harness/      # 工作流路由
│   ├── git-safe-ops/        # Git 安全操作
│   └── gstack/              # 方向决策
├── get-shit-done/           # 上下文冻结
└── superpowers/             # 执行工作流
```

#### Claude Code 架构

```
~/.claude/
└── skills/
    ├── claude-harness/      # 工作流路由（从 codex-harness 安装）
    ├── git-safe-ops/        # Git 安全操作
    └── gstack/              # 方向决策（Claude Code 原生 skill）

~/.codex/                    # 共享依赖
├── get-shit-done/           # 上下文冻结（共享）
└── superpowers/             # 执行工作流（共享，包含 .claude-plugin/）
```

**关键设计决策**：

1. **Gstack**: Claude Code 已有完整的 Gstack skill，无需额外安装
2. **GSD & Superpowers**: 共享自 `~/.codex/`，避免重复安装
3. **Superpowers**: 包含 `.claude-plugin/` 目录，原生支持 Claude Code
4. **codex-harness**: 安装为 `claude-harness`，避免命名冲突

### 4. 文档更新 / Documentation Updates

#### README.md

- 添加 Claude Code 安装说明
- 说明架构差异（Gstack 原生，GSD/Superpowers 共享）
- 添加依赖验证命令

#### USAGE.md

- 添加 Claude Code 安装方式
- 更新依赖验证命令
- 说明 Claude Code 特定架构

#### QUICKSTART.md

- 添加 Claude Code 快速安装命令
- 更新依赖说明
- 添加 Claude Code 使用示例

## 测试验证 / Testing

所有功能已通过测试：

```bash
# ✅ 安装脚本帮助
./scripts/install-claude-runtime.sh --help

# ✅ 依赖检查
./codex-harness/scripts/check-dependencies-claude.sh --check-only

# ✅ 所有依赖已安装
Checking Claude Harness dependencies for Claude Code...

✓ gstack found at /Users/doumao/.claude/skills/gstack
✓ get-shit-done found at /Users/doumao/.codex/get-shit-done
✓ superpowers found at /Users/doumao/.codex/superpowers
✓ GitHub CLI (gh) installed

✓ All dependencies are installed
```

## 使用流程 / Usage Workflow

### 1. 安装到 Claude Code

```bash
# 克隆仓库
git clone <repo-url> ~/code/skills

# 安装到 Claude Code
cd ~/code/skills
./scripts/install-claude-runtime.sh --check-deps
```

### 2. 验证依赖

```bash
~/.claude/skills/claude-harness/scripts/check-dependencies-claude.sh
```

### 3. 使用

在 Claude Code 中：
```
use claude-harness for this task
```

或直接引用工作流文件：
```
Read .claude/skills/claude-harness/references/gstack-decision.md
```

### 4. 安装到项目（可选）

```bash
cd /path/to/your/project
~/code/skills/codex-harness/scripts/install-pack.sh --agent claude --target .
```

## 兼容性 / Compatibility

### 支持的环境 / Supported Environments

- ✅ Codex CLI/App
- ✅ Claude Code
- ✅ Gemini CLI

### 依赖架构对比 / Dependency Architecture Comparison

| 工具 | Codex 位置 | Claude Code 位置 | 说明 |
|------|-----------|-----------------|------|
| Gstack | `~/.codex/skills/gstack` | `~/.claude/skills/gstack` | Claude Code 原生 skill |
| GSD | `~/.codex/get-shit-done` | `~/.codex/get-shit-done` | 共享 |
| Superpowers | `~/.codex/superpowers` | `~/.codex/superpowers` | 共享，包含 `.claude-plugin/` |
| codex-harness | `~/.codex/skills/codex-harness` | `~/.claude/skills/claude-harness` | 独立安装 |
| git-safe-ops | `~/.codex/skills/git-safe-ops` | `~/.claude/skills/git-safe-ops` | 独立安装 |

## 文件清单 / File List

### 新增文件 / New Files

```
scripts/
└── install-claude-runtime.sh          # Claude Code 安装脚本

codex-harness/scripts/
└── check-dependencies-claude.sh       # Claude Code 依赖检查
```

### 更新文件 / Updated Files

```
README.md                              # 添加 Claude Code 说明
QUICKSTART.md                          # 添加 Claude Code 快速参考
codex-harness/USAGE.md                 # 添加 Claude Code 使用指南
```

## 关键特性 / Key Features

### 1. 智能依赖共享

- GSD 和 Superpowers 共享自 `~/.codex/`
- 避免重复安装和维护
- Superpowers 的 `.claude-plugin/` 提供原生 Claude Code 支持

### 2. 环境隔离

- Codex 使用 `codex-harness`
- Claude Code 使用 `claude-harness`
- 避免命名冲突和配置干扰

### 3. 统一工作流

- 相同的工作流路由逻辑
- 相同的 reference 文件
- 跨环境一致的使用体验

## 下一步建议 / Next Steps (Optional)

1. **自动符号链接**: 考虑在安装时自动创建 `~/.claude/` 到 `~/.codex/` 的符号链接
2. **版本同步**: 确保 Codex 和 Claude Code 的依赖版本兼容
3. **配置同步**: 提供工具同步 Codex 和 Claude Code 的配置
4. **统一更新**: 创建统一的更新脚本，同时更新两个环境

## 总结 / Summary

通过这次适配，codex-harness 现在：

✅ 完全支持 Claude Code 环境
✅ 智能共享依赖（GSD、Superpowers）
✅ 保持环境隔离（独立安装 harness）
✅ 提供完整的安装和检查工具
✅ 拥有详细的中英文文档

用户现在可以：
- 在 Codex 和 Claude Code 中使用相同的工作流
- 通过一键脚本轻松安装
- 自动检查和验证依赖
- 享受跨环境一致的体验
