# Claude Code 当前配置清单 / Claude Code Current Configuration

## 生成时间 / Generated Time
2026-05-12

---

## 📁 目录结构 / Directory Structure

### Skills 目录
```
~/.claude/skills/
├── gstack/              # 1.1G - 浏览器操作和 QA 测试
├── claude-harness/      # 68K  - 工作流路由
└── git-safe-ops/        # 32K  - Git 安全操作
```

### 依赖目录（独立安装）
```
~/.claude/
├── get-shit-done/       # 10K  - 上下文冻结和项目边界
└── superpowers/         # 100M - 执行、TDD、调试工作流
    └── .claude-plugin/
```

---

## 📋 全局配置 / Global Configuration

### ~/.claude/CLAUDE.md

```markdown
本文档只保留全局补充规则；通用安全、非交互执行和工程规范以工具默认规则为准。

提交一定要中文和英文一起说明

## Git
涉及 git / gh 操作时使用 /git-safe-ops skill。
- 不要在 main / master 直接做重大功能
- 不要对共享分支使用 git reset 或 git push --force
- 撤销已发布提交时使用 git revert

## Workflow Harness
使用 /claude-harness skill 进行工作流路由：
- 方向不明确: 使用 Gstack 决策框架
- 新项目/上下文漂移: 使用 GSD 冻结上下文
- 结构化实现: 使用 Superpowers 执行
- 调试问题: 使用 Superpowers 调试
- 高风险变更: 使用 Superpowers TDD

依赖工具：
- Gstack: ~/.claude/skills/gstack
- GSD: ~/.claude/get-shit-done (独立安装)
- Superpowers: ~/.claude/superpowers (独立安装)

## Project Harness
进入新仓库时优先查：
- AGENTS.md / CLAUDE.md - 项目规则
- .claude/settings.local.json - 项目配置
- .claude/rules/*.md - 路径特定规则
- .claude/scripts/verify-*.sh - 验证脚本
- docs/DEVELOPMENT.md / docs/LOCAL_DEVELOPMENT.md - 开发文档

## Shell
- 当前机器默认 shell 按 zsh 处理
- 在 macOS 上不要默认依赖 /bin/bash 的新特性

## Browser
使用 /gstack skill 进行浏览器操作和 QA 测试

@RTK.md
```

**注意**: CLAUDE.md 中的依赖路径描述还是旧的（共享架构），需要更新。

---

## ⚙️ Settings 配置 / Settings Configuration

### ~/.claude/settings.json

#### 环境变量
```json
{
  "env": {
    "ANTHROPIC_API_KEY": "sk-***",
    "ANTHROPIC_BASE_URL": "https://value.apiqik.online",
    "CLAUDE_CODE_ATTRIBUTION_HEADER": "0",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",
    "DISABLE_ERROR_REPORTING": "1",
    "DISABLE_TELEMETRY": "1",
    "MCP_TIMEOUT": "60000"
  }
}
```

#### 权限配置（14 个）
```json
{
  "permissions": {
    "allow": [
      "Bash",           // Shell 命令执行
      "Edit",           // 文件编辑
      "Glob",           // 文件模式匹配
      "Grep",           // 文件内容搜索
      "Read",           // 文件读取
      "Write",          // 文件写入
      "NotebookEdit",   // Jupyter Notebook 编辑
      "WebFetch",       // 网页抓取
      "WebSearch",      // 网页搜索
      "mcp__context7",  // 库文档查询
      "mcp__open-websearch",  // 开放网页搜索
      "mcp__spec-workflow",   // 规范工作流
      "mcp__memory",    // 知识图谱
      "mcp__pencil"     // 设计工具
    ]
  }
}
```

#### 其他配置
```json
{
  "enableAllProjectMcpServers": true,
  "alwaysThinkingEnabled": true
}
```

---

## 🎯 Skills 详情 / Skills Details

### 1. gstack (1.1G)

**用途**: 浏览器操作和 QA 测试

**功能**:
- 页面导航和交互
- 状态验证
- 截图和 bug 证据收集
- 响应式布局测试
- 表单、上传、对话框测试

**使用**:
```
use /gstack to test the website
```

### 2. claude-harness (68K)

**用途**: 工作流路由

**功能**:
- 根据任务类型自动选择工具
- Gstack: 方向决策
- GSD: 上下文冻结
- Superpowers: 执行工作流

**使用**:
```
use /claude-harness for this task
```

**依赖**:
- `~/.claude/skills/gstack`
- `~/.claude/get-shit-done`
- `~/.claude/superpowers`

### 3. git-safe-ops (32K)

**用途**: Git 和 GitHub CLI 安全操作

**功能**:
- 提交、推送、拉取
- 分支管理
- Git worktree
- GitHub CLI 操作

**使用**:
```
use /git-safe-ops for git operations
```

---

## 🔧 依赖工具 / Dependencies

### 1. Superpowers (100M)

**位置**: `~/.claude/superpowers`

**用途**: 执行、TDD、调试、代码审查

**包含**:
- `.claude-plugin/` - Claude Code plugin 配置
- `hooks/` - Git hooks
- `docs/` - 文档

**主要功能**:
- TDD 工作流
- 调试流程
- 代码审查
- 协作模式

### 2. Get Shit Done (10K)

**位置**: `~/.claude/get-shit-done`

**用途**: 上下文冻结和项目边界管理

**包含**:
- `contexts/` - 上下文配置（dev, research, review）
- `references/` - 参考文档
- `templates/` - 模板
- `workflows/` - 工作流

**主要功能**:
- 上下文冻结
- 项目边界定义
- 工作流管理

---

## 🌐 MCP 服务 / MCP Services

### 已启用的 MCP 服务（5 个）

1. **context7**
   - 用途: 库文档查询
   - 功能: 查询编程库和框架的最新文档

2. **open-websearch**
   - 用途: 开放网页搜索
   - 功能: 搜索网页内容

3. **spec-workflow**
   - 用途: 规范工作流
   - 功能: 管理规范和工作流

4. **memory**
   - 用途: 知识图谱
   - 功能: 存储和检索知识

5. **pencil**
   - 用途: 设计工具
   - 功能: UI/UX 设计

### 项目级 MCP 服务

```json
{
  "enableAllProjectMcpServers": true
}
```

允许项目级 MCP 服务器自动加载。

---

## 📊 配置优化历史 / Configuration Optimization History

### 权限精简
- **之前**: 22 个权限
- **现在**: 14 个权限
- **优化**: -36%

**移除的权限**:
- `BashOutput`, `KillShell`, `SlashCommand`, `Task`, `TodoWrite`
- `mcp__ide`, `mcp__exa`, `mcp__mcp-deepwiki`
- `mcp__Playwright`, `mcp__browser-use`

### MCP 服务精简
- **之前**: 10 个服务
- **现在**: 5 个服务
- **优化**: -50%

**移除的服务**:
- `mcp__ide` - 不常用
- `mcp__exa` - 可用 open-websearch 替代
- `mcp__mcp-deepwiki` - 可用 context7 替代
- `mcp__Playwright` - 使用 gstack 替代
- `mcp__browser-use` - 使用 gstack 替代

---

## ✅ 验证命令 / Verification Commands

### 检查依赖
```bash
~/.claude/skills/claude-harness/scripts/check-dependencies-claude.sh
```

**预期输出**:
```
✓ gstack found at ~/.claude/skills/gstack
✓ get-shit-done found at ~/.claude/get-shit-done
✓ superpowers found at ~/.claude/superpowers
✓ GitHub CLI (gh) installed

✓ All dependencies are installed
```

### 检查 Skills
```bash
ls -lh ~/.claude/skills/
```

### 检查权限
```bash
cat ~/.claude/settings.json | jq '.permissions.allow'
```

### 检查 MCP 服务
```bash
cat ~/.claude/settings.json | jq '.permissions.allow | map(select(startswith("mcp__")))'
```

---

## 🔄 需要更新的配置 / Configuration Updates Needed

### 1. 更新 CLAUDE.md 中的依赖路径

**当前**（错误）:
```markdown
依赖工具：
- Gstack: ~/.claude/skills/gstack
- GSD: ~/.codex/get-shit-done (共享自 Codex)
- Superpowers: ~/.codex/superpowers (共享自 Codex)
```

**应该改为**（正确）:
```markdown
依赖工具：
- Gstack: ~/.claude/skills/gstack
- GSD: ~/.claude/get-shit-done (独立安装)
- Superpowers: ~/.claude/superpowers (独立安装)
```

---

## 📝 使用示例 / Usage Examples

### 工作流路由
```
use /claude-harness for this task
```

### 浏览器测试
```
use /gstack to test the website
```

### Git 操作
```
use /git-safe-ops for git operations
```

### 直接引用工作流
```
Read ~/.claude/skills/claude-harness/references/superpowers-execution.md
```

---

## 📈 总结 / Summary

### 当前状态

✅ **完全配置好，可以立即使用**

**Skills**: 3 个核心 skills
- gstack (浏览器操作)
- claude-harness (工作流路由)
- git-safe-ops (Git 操作)

**依赖**: 独立安装
- Superpowers (执行工作流)
- GSD (上下文冻结)

**配置**: 已优化
- 14 个核心权限 (-36%)
- 5 个 MCP 服务 (-50%)
- 清晰的全局规则

**架构**: 独立安装
- 完全隔离，无环境耦合
- 单环境友好
- 灵活配置

### 待办事项

⚠️ **需要更新 CLAUDE.md**
- 将依赖路径从 `~/.codex/` 改为 `~/.claude/`
- 更新说明为"独立安装"而非"共享自 Codex"
