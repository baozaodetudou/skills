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

安装到 Codex：

```bash
mkdir -p ~/.codex/skills
ln -sfn /path/to/skills/codex-harness ~/.codex/skills/codex-harness
```

安装后重启 Codex。使用时可以直接说：

```text
use $codex-harness for this task
```

适合的场景：

- 需求模糊、需要先定方向
- 长任务、跨会话、容易漂移的项目
- 需要先冻结上下文，再进入分步实现
- 需要在执行前后加入 TDD、debug、review、QA 流程

### 推荐本地目录规范

为了避免同一套 skill 被复制多份，推荐只保留一个真源，其他位置只用符号链接暴露：

```text
~/.codex/skills/codex-harness -> /path/to/skills/codex-harness
~/.codex/skills/git-safe-ops  -> /path/to/skills/git-safe-ops
~/.codex/superpowers          # Superpowers 上游真源
~/.agents/skills/superpowers  -> ~/.codex/superpowers/skills
~/.codex/get-shit-done        # GSD 上游真源
~/.claude/skills/gstack       # Gstack 上游真源
```

Codex 的常驻 skill 列表建议保持精简：

- `.system`
- `codex-harness`
- `git-safe-ops`
- `gstack` 主入口

不建议把所有 `gstack-*`、`gsd-*` 或 Superpowers 子技能同时复制进 `~/.codex/skills`。需要时由 `codex-harness` 路由到对应流程，避免启动上下文臃肿和规则冲突。

### Claude Code

优先运行：

```bash
./git-safe-ops/scripts/install-pack.sh --agent claude --target /path/to/project
```

安装结果会在项目根目录生成 `AGENTS.md` 和 `CLAUDE.md`，其中 `CLAUDE.md` 通过 `@AGENTS.md` 复用同一份规则。

### Gemini CLI

优先运行：

```bash
./git-safe-ops/scripts/install-pack.sh --agent gemini --target /path/to/project
```

## 目录结构

```text
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
```

## 说明

- `references/git-rules.md` 是详细规则来源。
- `AGENTS.md`、`CLAUDE.md`、`GEMINI.md` 是针对不同 agent 的项目级适配文件。
- `scripts/git-preflight.sh` 是可直接执行的 `gh` 非交互前置检查。
- `scripts/install-pack.sh` 用来把 pack 正确安装到项目里，避免手工复制导致引用失效。
- `SKILL.md` 和 `agents/openai.yaml` 用于 Codex 的 skill 发现与加载。
