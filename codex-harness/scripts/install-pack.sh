#!/bin/bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly SKILL_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
readonly SKILL_NAME="codex-harness"
readonly DEFAULT_PACK_DIR=".agent-packs"

TARGET_DIR=""
AGENT_NAME=""
PACK_DIR="${DEFAULT_PACK_DIR}"
DRY_RUN=0
FORCE=0
SKIP_DEPS_CHECK=0

usage() {
  cat <<'EOF'
Usage:
  install-pack.sh --agent codex|claude|gemini|all --target /path/to/project [options]

Description:
  Install Codex Harness skill pack into a project. This copies the complete
  skill directory and installs agent-specific files (AGENTS.md, CLAUDE.md,
  GEMINI.md) into the project root.

  Codex Harness is a workflow router that delegates to:
  - Gstack: Direction decision framework
  - GSD: Context freezing and project boundaries
  - Superpowers: Execution, TDD, debugging, review

Options:
  --agent              Target agent: codex, claude, gemini, or all
  --target             Target project directory
  --pack-dir           Pack directory name (default: .agent-packs)
  --force              Overwrite existing files
  --skip-deps-check    Skip dependency check (not recommended)
  --dry-run            Show what would be done without executing
  -h, --help           Show this help message

Dependencies:
  This skill requires Gstack, GSD, and Superpowers to be installed in
  ~/.codex/. Run 'scripts/check-dependencies.sh' to verify.
EOF
}

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

run_cmd() {
  if [ "${DRY_RUN}" -eq 1 ]; then
    printf '[dry-run] %q' "$1"
    shift
    for arg in "$@"; do
      printf ' %q' "${arg}"
    done
    printf '\n'
    return 0
  fi
  "$@"
}

ensure_target() {
  [ -n "${TARGET_DIR}" ] || fail "--target is required"
  [ -d "${TARGET_DIR}" ] || fail "target directory does not exist: ${TARGET_DIR}"
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --agent)
        AGENT_NAME="${2:-}"
        shift 2
        ;;
      --target)
        TARGET_DIR="${2:-}"
        shift 2
        ;;
      --pack-dir)
        PACK_DIR="${2:-}"
        shift 2
        ;;
      --skip-deps-check)
        SKIP_DEPS_CHECK=1
        shift
        ;;
      --dry-run)
        DRY_RUN=1
        shift
        ;;
      --force)
        FORCE=1
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        fail "unknown argument: $1"
        ;;
    esac
  done
}

assert_agent() {
  case "${AGENT_NAME}" in
    codex|claude|gemini|all) ;;
    *)
      fail "--agent must be one of: codex, claude, gemini, all"
      ;;
  esac
}

assert_can_write() {
  local target_file="$1"
  if [ -e "${target_file}" ] && [ "${FORCE}" -ne 1 ]; then
    fail "refusing to overwrite existing file without --force: ${target_file}"
  fi
}

check_dependencies() {
  if [ "${SKIP_DEPS_CHECK}" -eq 1 ]; then
    echo "Skipping dependency check (--skip-deps-check)"
    return 0
  fi

  local deps_script="${SCRIPT_DIR}/check-dependencies.sh"
  if [ ! -x "${deps_script}" ]; then
    echo "WARNING: Dependency check script not found or not executable: ${deps_script}"
    echo "Continuing without dependency check..."
    return 0
  fi

  echo "Checking dependencies..."
  if ! "${deps_script}" --check-only; then
    echo ""
    echo "Dependencies are missing. Run the following to see installation instructions:"
    echo "  ${deps_script}"
    echo ""
    echo "Or use --skip-deps-check to install anyway (not recommended)."
    exit 1
  fi
  echo ""
}

install_pack_copy() {
  local pack_target="${TARGET_DIR}/${PACK_DIR}/${SKILL_NAME}"
  run_cmd mkdir -p "$(dirname -- "${pack_target}")"
  if [ -d "${pack_target}" ]; then
    if [ "${FORCE}" -ne 1 ]; then
      fail "refusing to overwrite existing pack without --force: ${pack_target}"
    fi
    run_cmd rm -rf "${pack_target}"
  fi
  run_cmd mkdir -p "${pack_target}"
  run_cmd rsync -a --exclude '.DS_Store' --exclude '.git' "${SKILL_DIR}/" "${pack_target}/"
}

install_file() {
  local source_file="$1"
  local target_file="$2"
  assert_can_write "${target_file}"
  run_cmd mkdir -p "$(dirname -- "${target_file}")"
  run_cmd cp "${source_file}" "${target_file}"
}

install_codex() {
  # For Codex, we only install SKILL.md reference via AGENTS.md
  local agents_content="# Codex Harness

Workflow router for substantial Codex work. Delegates to Gstack (direction),
GSD (context), and Superpowers (execution).

Read \`.agent-packs/${SKILL_NAME}/SKILL.md\` for the complete workflow guide.

## Quick Reference

- **Ambiguous direction**: Use Gstack decision framework
- **New/drifting context**: Use GSD context freezing
- **Implementation**: Use Superpowers execution
- **Debugging**: Use Superpowers debugging
- **High-risk changes**: Use Superpowers TDD
- **Before completion**: Use QA checklist

## Dependencies

Requires:
- \`~/.codex/skills/gstack\`
- \`~/.codex/get-shit-done\`
- \`~/.codex/superpowers\`

Run \`.agent-packs/${SKILL_NAME}/scripts/check-dependencies.sh\` to verify.
"

  if [ "${DRY_RUN}" -eq 1 ]; then
    echo "[dry-run] Would write AGENTS.md to ${TARGET_DIR}/AGENTS.md"
  else
    echo "${agents_content}" > "${TARGET_DIR}/AGENTS.md"
  fi
}

install_claude() {
  install_file "${SKILL_DIR}/CLAUDE.md" "${TARGET_DIR}/CLAUDE.md"
}

install_gemini() {
  install_file "${SKILL_DIR}/GEMINI.md" "${TARGET_DIR}/GEMINI.md"
}

main() {
  parse_args "$@"
  ensure_target
  assert_agent
  check_dependencies
  install_pack_copy

  case "${AGENT_NAME}" in
    codex)
      install_codex
      ;;
    claude)
      install_codex
      install_claude
      ;;
    gemini)
      install_gemini
      ;;
    all)
      install_codex
      install_claude
      install_gemini
      ;;
  esac

  echo "OK: installed ${SKILL_NAME} for ${AGENT_NAME} into ${TARGET_DIR}"
  echo ""
  echo "Next steps:"
  echo "  1. Review ${TARGET_DIR}/.agent-packs/${SKILL_NAME}/SKILL.md"
  echo "  2. Verify dependencies: ${TARGET_DIR}/.agent-packs/${SKILL_NAME}/scripts/check-dependencies.sh"
}

main "$@"
