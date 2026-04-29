#!/usr/bin/env psh
set -euo pipefail

PROJECT="${INPUT_PROJECT_PATH:-.}"
BUILD_SYSTEM="${INPUT_BUILD_SYSTEM:-auto}"
CMAKE_FLAGS="${INPUT_CMAKE_FLAGS:-}"

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

echo "Building with: $BUILD_SYSTEM"

case "$BUILD_SYSTEM" in
  cmake)
    # shellcheck disable=SC2086
cmake -B build ${CMAKE_FLAGS:-} .
    cmake --build build
    ;;
  make)
    make
    ;;
  meson)
    meson setup build
    meson compile -C build
    ;;
  *)
    echo "ERROR: Could not detect build system (no CMakeLists.txt, Makefile, or meson.build found)." >&2
    exit 1
    ;;
esac

mkdir -p dist
find build -maxdepth 2 -type f -executable ! -name '*.so' ! -name '*.a' -exec cp {} dist/ \; 2>/dev/null || true
echo "Build complete. Artifacts in dist/:"
ls dist/ 2>/dev/null || true
