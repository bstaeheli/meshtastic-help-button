# Changelog

All notable changes to this project are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the project uses [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added (custom builds)
- `custom-build` workflow: build with your own texts and timings from the GitHub mobile app; publishes a pre-release with the OTA zip and UF2.
- `build.sh` takes validated `HB_*` parameters, writes the OTA zip to `dist/`, and emits the bell as an octal escape so any text may follow it.
- OTA (Bluetooth) update instructions in `docs/flashing.md`.

### Added (map link)
- HELP and SOS texts carry an OpenStreetMap link computed on the tag, with accuracy and the age of an
  old fix, e.g. `\x07HELP https://osm.org/go/0C0WCb6VB--?m ±25m 4min old`. It honors the primary
  channel's `position_precision` (no link at 0, truncated position otherwise). Fork updated to `031139d`.
- Node-RED filter classifies texts by their first word and extracts the link.
- After a lost GPS lock, HELP/SOS use the last fix since boot for the link and the position packet, with
  its age (`±25m 7min old`); without any fix since boot the text reads `HELP no GPS fix`. Fork updated to
  `2375c33` (#2).

### Fixed (map link)
- Alert texts are limited to 200 bytes; a 233-byte text was dropped by the router as too large.
- The alert position packet keeps the time of an old fix instead of looking fresh, is sent with HIGH
  priority, and can no longer be cancelled by the next periodic position send. Fork updated to `af64b92`.

### Changed
- Fork updated to `31ad1fd`: click or short hold sends HELP, double or rapid press sends SOS (separate 30 s
  windows; the press decides on the state at button-down), any press stops a playing melody, a 3-10 s hold plays a "not sent" hint, a 10 s hold shuts down on release.
- Preset sets `UBA_DOUBLE_PRESS`, `UBA_MULTI_PRESS` to `ACK_OR_ALERT2`, `UBA_HOLD_ALERT_MAX_MS=3000`, `UBA_LONG_PRESS_SHUTDOWN_MS=10000`.
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
