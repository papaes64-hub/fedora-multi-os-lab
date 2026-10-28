#!/usr/bin/env bash
# Basic guardrail, not a substitute for inspecting every file before publishing.
set -euo pipefail
cd "$(dirname "$0")/.."
echo '=== Scripts syntax ==='
for f in scripts/*.sh; do bash -n "$f"; echo "OK: $f"; done
echo '=== File types (manual review required) ==='
find . -type f -not -path './.git/*' -print | sort
if command -v git >/dev/null && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo '=== Check stage before any push ==='
  git status --short
  git diff --cached --stat
fi
printf '\nWARNING: inspect for secrets and identifiers manually; never add personal backups or VM disks.\n'
