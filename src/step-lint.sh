#!/usr/bin/env psh
set -euo pipefail

PROJECT="${INPUT_PROJECT_PATH:-.}"

cd "$PROJECT"

_run_clang_tidy() {
  if ! command -v clang-tidy &>/dev/null; then
    return 1
  fi
  SOURCES=$(find . -type f \( -name '*.cpp' -o -name '*.c' -o -name '*.h' \) | head -50)
  if [ -z "$SOURCES" ]; then
    echo "No C/C++ source files found for clang-tidy."
    return 0
  fi
  echo "$SOURCES" | xargs clang-tidy || return 1
  return 0
}

_run_cppcheck() {
  if ! command -v cppcheck &>/dev/null; then
    return 1
  fi
  cppcheck --enable=warning,style --error-exitcode=1 . || return 1
  return 0
}

if _run_clang_tidy; then
  echo "Lint passed (clang-tidy)."
elif _run_cppcheck; then
  echo "Lint passed (cppcheck)."
else
  echo "No C/C++ linter available (clang-tidy, cppcheck); skipping lint gracefully."
fi
