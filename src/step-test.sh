#!/usr/bin/env psh
set -euo pipefail

PROJECT="${INPUT_PROJECT_PATH:-.}"
BUILD_SYSTEM="${INPUT_BUILD_SYSTEM:-auto}"
TESTS_PATH="${INPUT_TESTS_PATH:-}"

cd "$PROJECT"

_detect_build_system() {
  if [ -f "CMakeLists.txt" ]; then
    echo "cmake"
  elif [ -f "meson.build" ]; then
    echo "meson"
  elif [ -f "Makefile" ]; then
    echo "make"
  else
    echo "unknown"
  fi
}

if [ "$BUILD_SYSTEM" = "auto" ]; then
  BUILD_SYSTEM="$(_detect_build_system)"
fi

echo "Running tests with: $BUILD_SYSTEM"

case "$BUILD_SYSTEM" in
  cmake)
    if [ -n "$TESTS_PATH" ]; then
      ctest --test-dir build -R "$TESTS_PATH"
    else
      ctest --test-dir build
    fi
    ;;
  make)
    make test
    ;;
  meson)
    meson test -C build
    ;;
  *)
    echo "No known test runner detected; skipping tests."
    ;;
esac
