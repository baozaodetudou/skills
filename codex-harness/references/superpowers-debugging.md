# Superpowers Debugging

Use this for bugs, flaky tests, failing CI, unexpected behavior, or unclear root
cause.

## Flow

1. Reproduce or identify the failing signal.
2. State the expected behavior and actual behavior.
3. Trace from symptom to boundary: UI/API, service, data, dependency, config.
4. Form the smallest falsifiable hypothesis.
5. Add or run a targeted test/log/check.
6. Fix the root cause, not only the symptom.
7. Run regression validation.

## Anti-Patterns

- Do not make multiple unrelated changes before proving the cause.
- Do not rely on timing sleeps when a condition-based wait exists.
- Do not delete tests to make a failure disappear.
- Do not claim a fix when only unrelated commands passed.

## Evidence Standard

Final answer should say:

- what failed
- what caused it
- what changed
- what command now proves the fix
