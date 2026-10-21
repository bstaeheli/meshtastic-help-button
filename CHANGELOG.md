# Changelog

All notable changes to this project are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the project uses [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Fixed
- String build flags in `config/help-button.ini` use the escaping that reaches the compiler as `"\x07HELP"`.
- `scripts/build.sh` restores the fork `platformio.ini` on exit and skips fetch when the ref is present locally.

### Added
- Project scaffold: build preset `rak_wismeshtag_sos`,
  build/export/rebase scripts, CI, and documentation.
- Pinned fork base `v2.7.26.54e0d8d` and fork commit; patches exported to `patches/`.
- CI `test` job running the fork's `test_user_button_actions` unit tests.
- Documentation of long-press timing, known limitations and string-flag escaping.
- SemVer release scheme; UF2 names include the project and upstream Meshtastic versions.
