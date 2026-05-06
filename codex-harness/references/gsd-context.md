# GSD Context

Use this when project rules, architecture, validation, or status must persist
across sessions. The repository is the source of truth.

## Files

Prefer these files, depending on project size:

- `AGENTS.md`: agent-facing project rules and harness behavior.
- `CLAUDE.md`: optional compatibility shim, usually pointing to `AGENTS.md`.
- `docs/DEVELOPMENT.md`: local setup, commands, validation, common workflows.
- `docs/ARCHITECTURE.md`: system boundaries, data flow, important decisions.
- `.claude/scripts/verify-all.sh`: one command that validates the project.
- `.claude/rules/*.md`: path-specific rules only when genuinely useful.

## Context Freeze Checklist

1. Record the current decision and scope.
2. Record project-specific commands, not generic guesses.
3. Record validation scripts and known limitations.
4. Record ownership boundaries and files that should not be edited casually.
5. Keep global instructions out of project files unless the project truly needs
   a stricter local rule.

## Writing Rules

- Keep files short and operational.
- Prefer commands that work in `zsh` on macOS.
- If a project already has verify scripts, reuse them instead of inventing new
  commands.
- Do not copy rules from a different stack without adapting them.
- Avoid memory MCP for project facts; durable facts go into files.

## Minimum AGENTS.md Template

```md
# Project Harness

## Context
Read `docs/DEVELOPMENT.md` before non-trivial changes.

## Validation
Run `zsh .claude/scripts/verify-all.sh` before final response when files change.

## Git
Commit messages must include both Chinese and English.
Do not force-push shared branches.
```
