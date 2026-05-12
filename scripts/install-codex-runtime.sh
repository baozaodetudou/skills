#!/bin/sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
REPO_DIR="$(CDPATH= cd -- "${SCRIPT_DIR}/.." && pwd)"
CODEX_HOME="${CODEX_HOME:-${HOME}/.codex}"
CODEX_SKILLS="${CODEX_HOME}/skills"
BACKUP_ROOT="${CODEX_HOME}/skill-backups"
STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="${BACKUP_ROOT}/${STAMP}_codex_runtime_install"
DRY_RUN=0
CLEAN_EXPOSED=0
CHECK_DEPS=0

usage() {
  cat <<'EOF'
Usage:
  scripts/install-codex-runtime.sh [--codex-home ~/.codex] [--clean-exposed] [--check-deps] [--dry-run]

Copies this repository's Codex skills into the Codex runtime:
  ~/.codex/skills/codex-harness
  ~/.codex/skills/git-safe-ops

Existing runtime entries are moved to ~/.codex/skill-backups/<timestamp> first.

Options:
  --codex-home      Codex home directory (default: ~/.codex)
  --clean-exposed   Clean up old exposed skill paths from other tools
  --check-deps      Check codex-harness dependencies after installation
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
      --codex-home)
        CODEX_HOME="${2:-}"
        [ -n "${CODEX_HOME}" ] || fail "--codex-home requires a value"
        CODEX_SKILLS="${CODEX_HOME}/skills"
        BACKUP_ROOT="${CODEX_HOME}/skill-backups"
        BACKUP_DIR="${BACKUP_ROOT}/${STAMP}_codex_runtime_install"
        shift 2
        ;;
      --clean-exposed)
        CLEAN_EXPOSED=1
        shift
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
  source_dir="${REPO_DIR}/${skill_name}"
  target_dir="${CODEX_SKILLS}/${skill_name}"

  [ -d "${source_dir}" ] || fail "missing skill source: ${source_dir}"

  run_cmd mkdir -p "${CODEX_SKILLS}"
  backup_existing "${target_dir}"
  run_cmd mkdir -p "${target_dir}"
  run_cmd rsync -a --exclude '.DS_Store' --exclude '.git' "${source_dir}/" "${target_dir}/"
}

clean_exposed_skill_paths() {
  for path in \
    "${HOME}/.agents/skills/superpowers" \
    "${HOME}/.agents/.skill-lock.json" \
    "${HOME}/.cc-switch/skills"
  do
    if [ -e "${path}" ] || [ -L "${path}" ]; then
      backup_path "${path}"
    fi
  done

  if [ -d "${HOME}/.agents/skills" ]; then
    if [ "${DRY_RUN}" -eq 1 ]; then
      run_cmd rmdir "${HOME}/.agents/skills"
    else
      rmdir "${HOME}/.agents/skills" 2>/dev/null || true
    fi
  fi
}

main() {
  parse_args "$@"

  install_skill "codex-harness"
  install_skill "git-safe-ops"

  if [ "${CLEAN_EXPOSED}" -eq 1 ]; then
    clean_exposed_skill_paths
  fi

  echo "OK: installed Codex runtime skills into ${CODEX_SKILLS}"
  if [ -d "${BACKUP_DIR}" ]; then
    echo "Backups: ${BACKUP_DIR}"
  fi

  if [ "${CHECK_DEPS}" -eq 1 ]; then
    echo ""
    echo "Checking codex-harness dependencies..."
    deps_script="${CODEX_SKILLS}/codex-harness/scripts/check-dependencies.sh"
    if [ -x "${deps_script}" ]; then
      "${deps_script}" || true
    else
      echo "WARNING: Dependency check script not found: ${deps_script}"
    fi
  else
    echo ""
    echo "To verify codex-harness dependencies, run:"
    echo "  ${CODEX_SKILLS}/codex-harness/scripts/check-dependencies.sh"
  fi
}

main "$@"
