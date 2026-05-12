#!/bin/bash
set -euo pipefail

# Codex Harness 依赖检查脚本
# 检查 Gstack、GSD、Superpowers 是否已安装

readonly CODEX_HOME="${CODEX_HOME:-${HOME}/.codex}"
readonly REQUIRED_DEPS=(
  "gstack:${CODEX_HOME}/skills/gstack"
  "get-shit-done:${CODEX_HOME}/get-shit-done"
  "superpowers:${CODEX_HOME}/superpowers"
)

MISSING_DEPS=()
CHECK_ONLY=0

usage() {
  cat <<'EOF'
Usage:
  check-dependencies.sh [--check-only]

Description:
  Check if Codex Harness dependencies are installed:
  - Gstack (direction decision framework)
  - GSD/Get Shit Done (context freezing)
  - Superpowers (execution, TDD, debugging)

Options:
  --check-only    Only check, don't prompt for installation
  -h, --help      Show this help message

Exit codes:
  0 - All dependencies installed
  1 - Missing dependencies (with --check-only)
  2 - User declined installation
EOF
}

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

check_dependency() {
  local dep_name="$1"
  local dep_path="$2"

  if [ -d "${dep_path}" ]; then
    echo "✓ ${dep_name} found at ${dep_path}"
    return 0
  else
    echo "✗ ${dep_name} not found at ${dep_path}"
    MISSING_DEPS+=("${dep_name}:${dep_path}")
    return 1
  fi
}

check_gh_cli() {
  if ! command -v gh >/dev/null 2>&1; then
    echo "✗ GitHub CLI (gh) not installed"
    echo ""
    echo "GitHub CLI is required for some Gstack operations."
    echo "Install: https://cli.github.com/"
    return 1
  else
    echo "✓ GitHub CLI (gh) installed"
    return 0
  fi
}

prompt_installation() {
  local dep_name="$1"

  echo ""
  echo "Missing dependency: ${dep_name}"
  echo ""

  case "${dep_name}" in
    gstack)
      echo "Gstack provides direction decision framework for ambiguous tasks."
      echo "Installation: Clone from the Gstack repository to ${CODEX_HOME}/skills/gstack"
      echo ""
      echo "Example:"
      echo "  git clone <gstack-repo-url> ${CODEX_HOME}/skills/gstack"
      ;;
    get-shit-done)
      echo "GSD (Get Shit Done) provides context freezing and project boundary management."
      echo "Installation: Clone from the GSD repository to ${CODEX_HOME}/get-shit-done"
      echo ""
      echo "Example:"
      echo "  git clone https://github.com/cyanheads/get-shit-done ${CODEX_HOME}/get-shit-done"
      ;;
    superpowers)
      echo "Superpowers provides execution, TDD, debugging, and review workflows."
      echo "Installation: Clone from the Superpowers repository to ${CODEX_HOME}/superpowers"
      echo ""
      echo "Example:"
      echo "  git clone https://github.com/cyanheads/superpowers ${CODEX_HOME}/superpowers"
      ;;
  esac
}

main() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --check-only)
        CHECK_ONLY=1
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

  echo "Checking Codex Harness dependencies..."
  echo ""

  local all_ok=1
  for dep in "${REQUIRED_DEPS[@]}"; do
    IFS=':' read -r dep_name dep_path <<< "${dep}"
    if ! check_dependency "${dep_name}" "${dep_path}"; then
      all_ok=0
    fi
  done

  echo ""
  check_gh_cli || true

  if [ "${all_ok}" -eq 1 ]; then
    echo ""
    echo "✓ All dependencies are installed"
    exit 0
  fi

  if [ "${CHECK_ONLY}" -eq 1 ]; then
    echo ""
    echo "Missing dependencies detected. Run without --check-only for installation instructions."
    exit 1
  fi

  echo ""
  echo "=========================================="
  echo "Installation Instructions"
  echo "=========================================="

  for dep in "${MISSING_DEPS[@]}"; do
    IFS=':' read -r dep_name dep_path <<< "${dep}"
    prompt_installation "${dep_name}"
    echo ""
  done

  echo "After installing dependencies, run this script again to verify."
  exit 2
}

main "$@"
