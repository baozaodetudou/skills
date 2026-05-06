# Superpowers TDD

Use this for high-risk behavior, shared logic, regressions, or code paths where
tests are practical.

## RED-GREEN-REFACTOR

1. Write or update a focused failing test.
2. Run it and confirm it fails for the expected reason.
3. Implement the smallest change that passes.
4. Run the focused test.
5. Run the broader relevant validation.
6. Refactor only after tests are green.

## When Not To Force TDD

- Pure styling or copy edits.
- Repo has no workable test harness and creating one is outside scope.
- Emergency operational fixes where reproduction must come first.

If TDD is skipped on risky work, state why and use the strongest available
validation instead.
