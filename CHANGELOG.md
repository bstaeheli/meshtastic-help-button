# Changelog

All notable changes to this project are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the project uses [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added (custom builds)
- `custom-build` workflow: build with your own texts and timings from the GitHub mobile app; publishes a pre-release with the OTA zip and UF2.
- `build.sh` takes validated `HB_*` parameters, writes the OTA zip to `dist/`, and emits the bell as an octal escape so any text may follow it.
- OTA (Bluetooth) update instructions in `docs/flashing.md`.

### Changed
- Fork updated to `a8aaf40` (review fixes): every press, rapid multi-press and short hold
  acknowledges a nag or sends help, with a beep; rate-limited presses boop; holding sends HELP after about 0.5 s and a 15 s hold shuts down (also sending one HELP).
- Preset sets `UBA_DOUBLE_PRESS` and new `UBA_MULTI_PRESS` to `ACK_OR_ALERT`.
- Removed the `device.disable_triple_click` advice (no reader in v2.7.26).

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
