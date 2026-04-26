# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- Initial implementation of the C/C++ CI action
- `build_system` input: auto-detects CMake, make, or meson
- `compiler` input: configures the C++ compiler (default `g++`)
- `cmake_flags` input: passes extra flags to the CMake configure step
- `tests_path` input: filter pattern forwarded to `ctest -R`
- Short git hash (`sha-<7chars>`) included in every release alongside semver tags

### Changed
- All step scripts use `#!/usr/bin/env psh` as the shebang
- `setup-psh.sh` detects runner architecture dynamically (amd64 and arm64)

## [0.1.0] - Initial scaffold
