# Pipery C/C++ CI

CI pipeline for C/C++: SAST, SCA, lint, build, test, versioning, packaging, release, reintegration

## Status

- Owner: `pipery-dev`
- Repository: `pipery-cpp-ci`
- Marketplace category: `continuous-integration`
- Current version: `0.1.0`

## Usage

```yaml
name: Example
on: [push]

jobs:
  run-action:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-cpp-ci@v0
        with:
          project_path: .
```

## Inputs

### Core

| Name | Default | Description |
|---|---|---|
| `project_path` | `.` | Path to the project source tree. |
| `config_file` | `.github/pipery/config.yaml` | Path to Pipery config file. |
| `log_file` | `pipery.jsonl` | Path to the JSONL log file written during the run. |
| `build_system` | `auto` | Build system: `auto`, `cmake`, `make`, or `meson`. |
| `compiler` | `g++` | C++ compiler to use (e.g. `g++`, `clang++`). |
| `cmake_flags` | `` | Extra flags passed to the CMake configure step. |

### Credentials

| Name | Default | Description |
|---|---|---|
| `github_token` | `` | GitHub token for release and reintegration steps. |

### Pipeline controls (skip flags)

| Name | Default | Description |
|---|---|---|
| `skip_sast` | `false` | Skip SAST step. |
| `skip_sca` | `false` | Skip SCA step. |
| `skip_lint` | `false` | Skip lint step. |
| `skip_build` | `false` | Skip build step. |
| `skip_test` | `false` | Skip test step. |
| `skip_versioning` | `false` | Skip versioning step. |
| `skip_packaging` | `false` | Skip packaging step. |
| `skip_release` | `false` | Skip release step. |
| `skip_reintegration` | `false` | Skip reintegration step. |

### Versioning & release

| Name | Default | Description |
|---|---|---|
| `version_bump` | `patch` | Version bump type: `patch`, `minor`, or `major`. |
| `target_branch` | `main` | Target branch for reintegration. |

### Testing

| Name | Default | Description |
|---|---|---|
| `tests_path` | `` | Test filter pattern passed to `ctest -R` or equivalent. |

## Steps

| Step | Skip flag | What it does |
|---|---|---|
| Lint | `skip_lint` | Runs `clang-tidy` on C/C++ sources, falls back to `cppcheck`, or skips gracefully |
| SAST | `skip_sast` | Static analysis via `pipery-steps sast --language cpp` |
| SCA | `skip_sca` | Dependency vulnerability scan via `pipery-steps sca --language cpp` |
| Build | `skip_build` | Auto-detects CMake / make / meson; copies binaries to `dist/` |
| Test | `skip_test` | Runs `ctest`, `make test`, or `meson test` depending on build system |
| Versioning | `skip_versioning` | Bumps version via `pipery-steps version`, writes to `GITHUB_OUTPUT` |
| Packaging | `skip_packaging` | Creates a release tarball: `dist/<name>-<version>.tar.gz` |
| Release | `skip_release` | Publishes GitHub release with `sha-<shortsha>` in the title |
| Reintegration | `skip_reintegration` | Merges release branch back to `target_branch` |

## Development

This repository is managed with `pipery-tooling`.

```bash
pipery-actions test --repo .
pipery-actions release --repo . --dry-run
```
