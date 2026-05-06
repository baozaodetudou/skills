# Gstack Decision

Use this when the task is vague, product direction is uncertain, architecture
has meaningful tradeoffs, or the user asks for review before implementation.

## Output Shape

Keep the decision compact:

1. Goal
2. Constraints
3. Options
4. Recommended direction
5. Risks
6. Acceptance criteria

## Review Lenses

- Product: user problem, scope boundary, success signal, workflow fit.
- Engineering: system shape, data flow, dependencies, migration cost.
- Security/Reliability: permissions, secrets, destructive operations,
  recovery path, failure modes.
- QA: observable behavior, edge cases, test strategy, verification command.

## Decision Rules

- Prefer the smallest direction that preserves future options.
- If two options are close, choose the one that fits existing project patterns.
- Mark assumptions explicitly when local code or docs do not prove them.
- For irreversible or expensive actions, stop and ask before execution.
- End with concrete acceptance criteria that can drive implementation.

## Handoff

If the decision should survive future sessions, continue with
`gsd-context.md` and write it into project files.
