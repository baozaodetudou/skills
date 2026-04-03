#!/bin/bash
set -euo pipefail

export GIT_TERMINAL_PROMPT=0

if ! command -v gh >/dev/null 2>&1; then
  echo "ERROR: GitHub CLI (gh) not installed" >&2
  exit 2
fi

if ! gh auth status --hostname github.com >/dev/null 2>&1; then
  echo "ERROR: GitHub CLI (gh) not authenticated" >&2
  exit 3
fi

echo "OK: gh is installed and authenticated."
