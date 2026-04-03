#!/bin/bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly SKILL_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
readonly SKILL_NAME="git-safe-ops"
readonly DEFAULT_PACK_DIR=".agent-packs"

TARGET_DIR=""
AGENT_NAME=""
PACK_DIR="${DEFAULT_PACK_DIR}"
DRY_RUN=0
FORCE=0

usage() {
  cat <<'EOF'
Usage:
  install-pack.sh --agent codex|claude|gemini|all --target /path/to/project [--pack-dir .agent-packs] [--force] [--dry-run]
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
  install_file "${SKILL_DIR}/AGENTS.md" "${TARGET_DIR}/AGENTS.md"
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
}

main "$@"
