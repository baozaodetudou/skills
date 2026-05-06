# QA Checklist

Use before finishing substantial work.

## Required Checks

- Request satisfied without hidden scope expansion.
- Relevant project rules were followed.
- Working tree changes are intentional.
- Tests or verification commands were run, or a concrete reason is recorded.
- User-facing text, UI, CLI output, and errors were checked where touched.
- Config, migrations, secrets, and destructive operations were reviewed.
- Final response names residual risk or says none found.

## Validation Priority

1. Project verify script: `.claude/scripts/verify-*.sh`
2. Package scripts: `npm test`, `pnpm test`, `go test ./...`, etc.
3. Focused command for touched module.
4. Manual inspection only when automation is unavailable.

## Final Response

Keep it short:

- what changed
- verification
- any unresolved risk
