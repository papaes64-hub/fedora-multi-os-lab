#!/usr/bin/env bash
# Wrapper for an EXISTING local OSX-KVM install. It does NOT install macOS.
set -euo pipefail
RUN="${SONOMA_LAUNCHER:-$HOME/OSX-KVM/OpenCore-Run-Plus.sh}"
[[ -f "$RUN" && -x "$RUN" ]] || { echo "Missing executable existing launcher: $RUN" >&2; exit 1; }
exec "$RUN"
