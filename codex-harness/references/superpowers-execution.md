# Superpowers Execution

Use this for implementation after direction is clear.

## Flow

1. Clarify only blocking requirements.
2. Inspect local harness files and relevant source.
3. Write a short plan for substantial work.
4. Implement in small, reviewable changes.
5. Validate after meaningful increments.
6. Fix validation failures before moving on.
7. Summarize changed files and verification.

## Planning Scale

- Small: no on-disk plan; use a short internal checklist.
- Medium: use the normal Codex plan tool in chat.
- Large or resumable: create `.codex-tasks/<task>/SPEC.md`,
  `TODO.csv`, and `PROGRESS.md`, or use `$taskmaster` when available.

## Execution Rules

- Prefer existing project patterns over new abstractions.
- Keep edits scoped to the requested behavior.
- Use `apply_patch` for manual edits.
- Use project verify scripts before generic test commands.
- Do not leave needed long-running processes active at final response.

## Review Point

Before finalizing, compare the implementation against:

- original request
- accepted direction or plan
- project harness files
- tests and validation output
