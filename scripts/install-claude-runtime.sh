#!/bin/sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
REPO_DIR="$(CDPATH= cd -- "${SCRIPT_DIR}/.." && pwd)"
CLAUDE_HOME="${CLAUDE_HOME:-${HOME}/.claude}"
CLAUDE_SKILLS="${CLAUDE_HOME}/skills"
BACKUP_ROOT="${CLAUDE_HOME}/backups"
STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="${BACKUP_ROOT}/${STAMP}_claude_runtime_install"
DRY_RUN=0
CHECK_DEPS=0

usage() {
  cat <<'EOF'
Usage:
  scripts/install-claude-runtime.sh [--claude-home ~/.claude] [--check-deps] [--dry-run]

Copies this repository's skills into the Claude Code runtime:
  ~/.claude/skills/codex-harness (as claude-harness)
  ~/.claude/skills/git-safe-ops

Note: Gstack is already a Claude Code skill and doesn't need installation.
Superpowers and GSD are shared from ~/.codex/ and work with Claude Code.

Options:
  --claude-home     Claude home directory (default: ~/.claude)
  --check-deps      Check dependencies after installation
  --dry-run         Show what would be done without executing
  -h, --help        Show this help message
EOF
}

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

run_cmd() {
  if [ "${DRY_RUN}" -eq 1 ]; then
    printf '[dry-run] %s' "$1"
    shift
    for arg in "$@"; do
      printf ' %s' "${arg}"
    done
    printf '\n'
    return 0
  fi
  "$@"
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --claude-home)
        CLAUDE_HOME="${2:-}"
        [ -n "${CLAUDE_HOME}" ] || fail "--claude-home requires a value"
        CLAUDE_SKILLS="${CLAUDE_HOME}/skills"
        BACKUP_ROOT="${CLAUDE_HOME}/backups"
        BACKUP_DIR="${BACKUP_ROOT}/${STAMP}_claude_runtime_install"
        shift 2
        ;;
      --check-deps)
        CHECK_DEPS=1
        shift
        ;;
      --dry-run)
        DRY_RUN=1
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

backup_path() {
  source_path="$1"
  backup_path="${BACKUP_DIR}${source_path}"
  backup_parent="$(dirname -- "${backup_path}")"
  run_cmd mkdir -p "${backup_parent}"
  run_cmd mv "${source_path}" "${backup_path}"
}

backup_existing() {
  target_path="$1"
  if [ -e "${target_path}" ] || [ -L "${target_path}" ]; then
    backup_path "${target_path}"
  fi
}

install_skill() {
  skill_name="$1"
  target_name="${2:-${skill_name}}"
  source_dir="${REPO_DIR}/${skill_name}"
  target_dir="${CLAUDE_SKILLS}/${target_name}"

  [ -d "${source_dir}" ] || fail "missing skill source: ${source_dir}"

  run_cmd mkdir -p "${CLAUDE_SKILLS}"
  backup_existing "${target_dir}"
  run_cmd mkdir -p "${target_dir}"
  run_cmd rsync -a --exclude '.DS_Store' --exclude '.git' "${source_dir}/" "${target_dir}/"
}

main() {
  parse_args "$@"

  echo "Installing skills to Claude Code runtime..."
  echo ""

  # Install codex-harness as claude-harness for Claude Code
  install_skill "codex-harness" "claude-harness"
  install_skill "git-safe-ops"

  echo ""
  echo "OK: installed Claude Code runtime skills into ${CLAUDE_SKILLS}"
  if [ -d "${BACKUP_DIR}" ]; then
    echo "Backups: ${BACKUP_DIR}"
  fi

  echo ""
  echo "Note: Gstack is already installed as a Claude Code skill at:"
  echo "  ${CLAUDE_SKILLS}/gstack"
  echo ""
  echo "Superpowers and GSD are shared from ~/.codex/ and work with Claude Code."

  if [ "${CHECK_DEPS}" -eq 1 ]; then
    echo ""
    echo "Checking claude-harness dependencies..."
    deps_script="${CLAUDE_SKILLS}/claude-harness/scripts/check-dependencies-claude.sh"
    if [ -x "${deps_script}" ]; then
      "${deps_script}" || true
    else
      echo "WARNING: Dependency check script not found: ${deps_script}"
    fi
  else
    echo ""
    echo "To verify claude-harness dependencies, run:"
    echo "  ${CLAUDE_SKILLS}/claude-harness/scripts/check-dependencies-claude.sh"
  fi
}

main "$@"
