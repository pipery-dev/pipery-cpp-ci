#!/usr/bin/env psh
set -euo pipefail

PROJECT="${INPUT_PROJECT_PATH:-.}"
LOG="${INPUT_LOG_FILE:-pipery.jsonl}"

cd "$PROJECT"

mkdir -p dist

PROJECT_NAME="$(basename "$(pwd)")"
VERSION="${INPUT_VERSION:-0.0.0}"

TARBALL="dist/${PROJECT_NAME}-${VERSION}.tar.gz"
tar -czf "$TARBALL" build/
echo "Package created: $TARBALL"
printf '{"event":"package","status":"success","artifact":"%s"}\n' "$TARBALL" >> "$LOG"
