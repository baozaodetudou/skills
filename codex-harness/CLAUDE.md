# Codex Harness

Workflow router for substantial development work. Use when tasks are ambiguous,
architectural, multi-step, long-running, or risky.

## Purpose

This provides a unified workflow that combines:
- **Gstack**: Direction decisions and architecture review
- **GSD**: Context freezing and project boundaries
- **Superpowers**: Execution, TDD, debugging, review

## When to Use

- Task is vague or product direction is uncertain
- Architecture has meaningful tradeoffs
- Long-running or multi-session work
- Project context needs to be stabilized
- Need structured TDD, debugging, or review workflow

## Workflow Router

Choose the appropriate workflow based on task shape:

### 1. Tiny Changes
Do not use heavy workflow. Read project rules, edit, verify.

### 2. Ambiguous Direction
**Use Gstack decision framework** when:
- Product direction is uncertain
- Architecture has meaningful tradeoffs
- User asks for review before implementation

Read `.agent-packs/codex-harness/references/gstack-decision.md` for guidance.

### 3. New or Drifting Context
**Use GSD context freezing** when:
- Project is new or context has drifted
- Need to establish project boundaries
- Validation approach needs to be defined

Read `.agent-packs/codex-harness/references/gsd-context.md` for guidance.

### 4. Planned Implementation
**Use Superpowers execution** when:
- Direction is clear and ready to implement
- Need structured implementation workflow

Read `.agent-packs/codex-harness/references/superpowers-execution.md` for guidance.

### 5. Debugging
**Use Superpowers debugging** when:
- Bug, flaky test, or unclear root cause
- Need systematic debugging approach

Read `.agent-packs/codex-harness/references/superpowers-debugging.md` for guidance.

### 6. High-Risk Changes
**Use Superpowers TDD** when:
- High-risk behavior change
- Shared logic or regression-prone code
- Tests are practical and valuable

Read `.agent-packs/codex-harness/references/superpowers-tdd.md` for guidance.

### 7. Before Completion
**Use QA checklist** before finishing non-trivial work.

Read `.agent-packs/codex-harness/references/qa-checklist.md` for guidance.

## Default Flow

1. Inspect repository harness files: `AGENTS.md`, `CLAUDE.md`,
   `.claude/settings.local.json`, `.claude/rules/*.md`,
   `.claude/scripts/verify-*.sh`, `docs/DEVELOPMENT.md`,
   `docs/ARCHITECTURE.md`
2. Classify the task with the router above
3. For ambiguous work: decide first (Gstack), then freeze context (GSD) if
   decision should persist
4. For implementation: keep plans short unless task is large enough to need
   on-disk artifacts
5. Run strongest local validation available
6. Final response must include: what changed, what was verified, any residual
   risk

## Guardrails

- Do not keep long-term project facts only in conversation. Put durable facts
  in repository files.
- Do not claim completion without command output or clear reason validation
  could not run.
- For git or GitHub operations, prefer using git-safe-ops if available.

## Dependencies

This workflow requires:
- Gstack (direction decisions)
- GSD (context freezing)
- Superpowers (execution workflows)

For Codex users, these should be installed in:
- `~/.codex/skills/gstack`
- `~/.codex/get-shit-done`
- `~/.codex/superpowers`

Run `.agent-packs/codex-harness/scripts/check-dependencies.sh` to verify.

## Integration with Other Skills

- Use `git-safe-ops` for safe git operations
- Use project-specific verification scripts when available
- Follow project harness files (`AGENTS.md`, `CLAUDE.md`, etc.)
