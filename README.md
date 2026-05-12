# skills

这个仓库用于存放可复用的 agent skill / instruction pack。

当前已包含：

- `git-safe-ops`：面向 Git 与 GitHub CLI 的安全、非交互式操作规范，覆盖分支策略、认证检查、提交与推送约束、`worktree`、`revert` 和 PR 协作要求。
- `codex-harness`：把 Gstack 的方向决策、GSD 的上下文冻结、Superpowers 的执行流程合并成一套 Codex 工作流路由。

## 支持矩阵

- Codex skill：[`git-safe-ops/SKILL.md`](./git-safe-ops/SKILL.md)
- Codex project instructions：[`git-safe-ops/AGENTS.md`](./git-safe-ops/AGENTS.md)
- Claude Code：[`git-safe-ops/CLAUDE.md`](./git-safe-ops/CLAUDE.md)
- Gemini CLI：[`git-safe-ops/GEMINI.md`](./git-safe-ops/GEMINI.md)
- Codex skill：[`codex-harness/SKILL.md`](./codex-harness/SKILL.md)
- Codex skill metadata：[`codex-harness/agents/openai.yaml`](./codex-harness/agents/openai.yaml)
- Claude Code：[`codex-harness/CLAUDE.md`](./codex-harness/CLAUDE.md)
- Gemini CLI：[`codex-harness/GEMINI.md`](./codex-harness/GEMINI.md)

## 使用方式

推荐安装方式是直接运行安装脚本，而不是手工复制零散文件。

### 安装到项目

```bash
./git-safe-ops/scripts/install-pack.sh --agent all --target /path/to/project
```

这会：

- 把完整 pack 复制到目标项目的 `.agent-packs/git-safe-ops/`
- 按 agent 类型把 `AGENTS.md`、`CLAUDE.md`、`GEMINI.md` 安装到项目根目录

常用选项：

- `--dry-run`：只打印将要执行的复制动作
- `--force`：明确覆盖目标项目里已存在的同名文件

### Codex 作为 skill

把整个 `git-safe-ops` 目录放到 `~/.codex/skills/git-safe-ops/`。

### Codex 作为项目规则

优先运行：

```bash
./git-safe-ops/scripts/install-pack.sh --agent codex --target /path/to/project
```

### Codex Harness

`codex-harness` 是一层工作流路由，不是执行框架本身。它会按任务形态在三者之间切换：

- `Gstack`：先做方向判断、方案评审、风险决策
- `GSD`：固定项目上下文、边界、验证方式
- `Superpowers`：执行、TDD、debug、review、收尾

#### 依赖要求

codex-harness 需要以下外部工具已安装：

- **Gstack**: `~/.codex/skills/gstack` - 方向决策框架
- **GSD**: `~/.codex/get-shit-done` - 上下文冻结和项目边界管理
- **Superpowers**: `~/.codex/superpowers` - 执行、TDD、调试工作流

安装 codex-harness 后，运行依赖检查：

```bash
~/.codex/skills/codex-harness/scripts/check-dependencies.sh
```

如果缺少依赖，脚本会提供安装说明。

#### 安装到 Codex

```bash
mkdir -p ~/.codex/skills
cp -R /path/to/skills/codex-harness ~/.codex/skills/codex-harness
```

或使用一键安装脚本（推荐）：

```bash
./scripts/install-codex-runtime.sh --check-deps
```

安装后重启 Codex。使用时可以直接说：

```text
use $codex-harness for this task
```

#### 安装到项目

```bash
./codex-harness/scripts/install-pack.sh --agent all --target /path/to/project
```

这会：
- 把完整 pack 复制到目标项目的 `.agent-packs/codex-harness/`
- 按 agent 类型把 `AGENTS.md`、`CLAUDE.md`、`GEMINI.md` 安装到项目根目录
- 检查依赖是否已安装（可用 `--skip-deps-check` 跳过）

常用选项：
- `--dry-run`：只打印将要执行的复制动作
- `--force`：明确覆盖目标项目里已存在的同名文件
- `--skip-deps-check`：跳过依赖检查（不推荐）

#### 适合的场景

- 需求模糊、需要先定方向
- 长任务、跨会话、容易漂移的项目
- 需要先冻结上下文，再进入分步实现
- 需要在执行前后加入 TDD、debug、review、QA 流程

### Codex-only 本地目录规范

推荐把 Codex CLI/App 的运行时内容全部放在 `~/.codex` 下，和 `.agents`、`.claude`、`.cc-switch` 等其他工具目录分开。这个仓库只作为发布和编辑来源；安装到 Codex 时使用复制，不使用跨目录软链接。

```text
~/.codex/skills/codex-harness  # 从本仓库复制安装
~/.codex/skills/git-safe-ops   # 从本仓库复制安装
~/.codex/skills/gstack         # Gstack Codex adapter
~/.codex/superpowers           # Superpowers for Codex
~/.codex/get-shit-done         # GSD for Codex
```

Codex 的常驻 skill 列表建议保持精简：

- `.system`
- `codex-harness`
- `git-safe-ops`
- `gstack` 主入口
- `superpowers:*` 由 `~/.codex/superpowers` 提供

不建议把所有 `gstack-*`、`gsd-*` 或 Superpowers 子技能同时复制进 `~/.codex/skills`。需要时由 `codex-harness` 路由到对应流程，避免启动上下文臃肿和规则冲突。

一键安装本仓库内的 Codex skills：

```bash
./scripts/install-codex-runtime.sh --check-deps
```

这会：
- 安装 `codex-harness` 和 `git-safe-ops` 到 `~/.codex/skills/`
- 检查 codex-harness 的依赖（Gstack、GSD、Superpowers）
- 如果缺少依赖，提供安装说明

如果旧环境里存在 `~/.agents/skills/superpowers`、`~/.agents/.skill-lock.json` 或 `~/.cc-switch/skills` 这类跨目录暴露，可以一并移到 `~/.codex/skill-backups/`：

```bash
./scripts/install-codex-runtime.sh --clean-exposed --check-deps
```

安装完成后的边界：

- Codex 使用 `~/.codex/**`
- Claude Code 使用 `~/.claude/**`
- 其他 agent 使用自己的目录
- 不建立 `~/.agents/skills/superpowers -> ~/.codex/superpowers/skills` 这种混用链接

### Claude Code

优先运行：

```bash
./git-safe-ops/scripts/install-pack.sh --agent claude --target /path/to/project
```

安装结果会在项目根目录生成 `AGENTS.md` 和 `CLAUDE.md`，其中 `CLAUDE.md` 通过 `@AGENTS.md` 复用同一份规则。

#### 安装 Codex Harness 到 Claude Code

```bash
# 一键安装到 Claude Code（包含自动安装依赖）
./scripts/install-claude-runtime.sh --install-deps --check-deps
```

这会：
- 安装 `codex-harness` (作为 `claude-harness`) 和 `git-safe-ops` 到 `~/.claude/skills/`
- 自动安装 Superpowers 到 `~/.claude/superpowers`
- 自动安装 GSD 到 `~/.claude/get-shit-done`
- 检查所有依赖是否正确安装

**架构说明**（独立安装）:
- **Gstack**: 已作为 Claude Code skill 安装在 `~/.claude/skills/gstack`
- **GSD**: 独立安装到 `~/.claude/get-shit-done`
- **Superpowers**: 独立安装到 `~/.claude/superpowers`（包含 `.claude-plugin/`）

验证依赖：
```bash
~/.claude/skills/claude-harness/scripts/check-dependencies-claude.sh
```

### Gemini CLI

优先运行：

```bash
./git-safe-ops/scripts/install-pack.sh --agent gemini --target /path/to/project
```

## 目录结构

```text
codex-harness/
├── SKILL.md                    # Codex skill 定义
├── CLAUDE.md                   # Claude Code 支持
├── GEMINI.md                   # Gemini CLI 支持
├── agents/
│   └── openai.yaml            # Codex metadata
├── scripts/
│   ├── check-dependencies.sh  # 依赖检查脚本
│   └── install-pack.sh        # 项目安装脚本
└── references/
    ├── gsd-context.md         # GSD 使用指南
    ├── gstack-decision.md     # Gstack 使用指南
    ├── qa-checklist.md        # QA 检查清单
    ├── superpowers-debugging.md
    ├── superpowers-execution.md
    └── superpowers-tdd.md
git-safe-ops/
├── AGENTS.md
├── CLAUDE.md
├── GEMINI.md
├── SKILL.md
├── agents/
│   └── openai.yaml
├── scripts/
│   ├── git-preflight.sh
│   └── install-pack.sh
└── references/
    └── git-rules.md
scripts/
└── install-codex-runtime.sh   # 一键安装脚本
```

## 说明

- `references/git-rules.md` 是详细规则来源。
- `AGENTS.md`、`CLAUDE.md`、`GEMINI.md` 是针对不同 agent 的项目级适配文件。
- `scripts/git-preflight.sh` 是可直接执行的 `gh` 非交互前置检查。
- `scripts/install-pack.sh` 用来把 pack 正确安装到项目里，避免手工复制导致引用失效。
- `SKILL.md` 和 `agents/openai.yaml` 用于 Codex 的 skill 发现与加载。
