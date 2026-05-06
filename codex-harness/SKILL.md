---
name: codex-harness
description: >
  Unified Codex CLI/App harness for combining Gstack-style direction decisions,
  GSD-style project context freezing, and Superpowers-style implementation,
  TDD, debugging, review, and verification. Use when work is ambiguous,
  architectural, multi-step, long-running, risky, needs project rules to be
  stabilized, or the user asks for Superpowers, GSD, Gstack, harness, planning,
  execution workflow, context engineering, QA, or autonomous development.
---

# Codex Harness

## Purpose

Use this skill as the single active workflow entry point for substantial Codex
work. Keep global context small: load only the reference file that matches the
task shape.

## Router

- **Tiny change**: do not use a heavy workflow. Read project rules, edit, verify.
- **Ambiguous direction or product/architecture choice**: read
  `references/gstack-decision.md`.
- **New or drifting project context**: read `references/gsd-context.md`.
- **Planned implementation**: read `references/superpowers-execution.md`.
- **Bug, flaky test, or unclear root cause**: read
  `references/superpowers-debugging.md`.
- **High-risk behavior change**: read `references/superpowers-tdd.md`.
- **Before final completion on non-trivial work**: read
  `references/qa-checklist.md`.

## Default Flow

1. Inspect repository harness files: `AGENTS.md`, `CLAUDE.md`,
   `.claude/settings.local.json`, `.claude/rules/*.md`,
   `.claude/scripts/verify-*.sh`, `docs/DEVELOPMENT.md`,
   `docs/LOCAL_DEVELOPMENT.md`, and `docs/ARCHITECTURE.md`.
2. Classify the task with the router.
3. For ambiguous work: decide first, then freeze context if the decision should
   persist.
4. For implementation: keep plans short unless the task is large enough to need
   on-disk task artifacts.
5. Run the strongest local validation available. Prefer existing project verify
   scripts.
6. Final response must include what changed, what was verified, and any residual
   risk.

## Guardrails

- Do not install or load large framework skill sets by default.
- Do not keep long-term project facts only in conversation. Put durable facts in
  repository files.
- Do not use memory MCP as the primary source of project truth.
- Do not claim completion without command output or a clear reason validation
  could not run.
- For git or GitHub operations, use `$git-safe-ops`.
