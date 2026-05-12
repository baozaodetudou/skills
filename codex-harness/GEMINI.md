# Codex Harness

Workflow router for substantial development work.

## Purpose

Unified workflow combining:
- **Gstack**: Direction decisions
- **GSD**: Context freezing
- **Superpowers**: Execution, TDD, debugging

## Workflow Router

1. **Tiny changes**: Read rules, edit, verify
2. **Ambiguous direction**: Use Gstack (read `references/gstack-decision.md`)
3. **New/drifting context**: Use GSD (read `references/gsd-context.md`)
4. **Implementation**: Use Superpowers (read `references/superpowers-execution.md`)
5. **Debugging**: Use Superpowers (read `references/superpowers-debugging.md`)
6. **High-risk changes**: Use Superpowers TDD (read `references/superpowers-tdd.md`)
7. **Before completion**: Use QA checklist (read `references/qa-checklist.md`)

## Default Flow

1. Inspect repository harness files
2. Classify task with router
3. For ambiguous work: decide first, then freeze context
4. For implementation: keep plans short
5. Run validation
6. Report: what changed, what was verified, residual risk

## Dependencies

Requires:
- Gstack: `~/.codex/skills/gstack`
- GSD: `~/.codex/get-shit-done`
- Superpowers: `~/.codex/superpowers`

Run `scripts/check-dependencies.sh` to verify.
