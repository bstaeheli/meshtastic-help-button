# Help Button

One-button help for screen-less Meshtastic trackers. A single press sends a help message
(bell character plus text) with the current position on the primary channel. If the
tracker is playing a "come home" melody, the same press stops it and tells the sender
instead, so the press doubles as an acknowledgement.

Example use case: a child on a campsite carries a small tracker. One press means "I need
help"; when the parents trigger the "come home" alert, one press confirms the child heard it.

The firmware change is a small, opt-in, generic "user button actions" feature, kept on a
fork branch that is written to be proposed upstream to
[`meshtastic/firmware`](https://github.com/meshtastic/firmware). This repository holds the
build presets, scripts, CI and documentation. See [docs/upstream-proposal.md](docs/upstream-proposal.md).

## Supported devices

| Device | Variant | Preset |
| --- | --- | --- |
| RAK WisMesh Tag | `rak_wismeshtag` | `rak_wismeshtag_sos` |

More trackers are added only after a hardware test.

## Flashing

Download the `.uf2` from the [releases](../../releases) and follow
[docs/flashing.md](docs/flashing.md). Then apply the settings in
[docs/device-config.md](docs/device-config.md).

## Usage for parents

- Any press (single, double, rapid) when the tag is quiet: "I need help". You get a message and the position.
- When the tag plays its melody: come home. One press stops it and tells you the child heard it.
- Holding the button for 15 seconds or more switches the tag off. You notice because positions stop.

Details: [docs/behavior.md](docs/behavior.md). Forwarding alerts via MQTT: [docs/node-red.md](docs/node-red.md).

## Build

Requires Python 3 and git.

```sh
python3 -m venv .venv && . .venv/bin/activate
pip install -r requirements.txt
scripts/build.sh                       # builds the preset, output in dist/
scripts/build.sh rak_wismeshtag_sos    # one preset
FORK_DIR=~/src/firmware scripts/build.sh   # use an existing local checkout
```

`scripts/build.sh` checks out the fork at the commit in `FORK_REF`, appends
`config/help-button.ini` to its `platformio.ini`, builds, and writes UF2 files and
`SHA256SUMS` to `dist/`. `UPSTREAM_VERSION` is the stable Meshtastic tag the fork branch is based on.
`scripts/export-patches.sh` regenerates `patches/` and `scripts/rebase.sh <tag>` moves the fork branch to a new upstream tag.
Custom texts: see the escaping note in `config/help-button.ini` (quadruple backslash; `UBA_ACK_TEXT=nullptr` disables the ack).

## Versioning

- Releases use their own SemVer tags `vMAJOR.MINOR.PATCH`, starting at `v0.1.0`. MAJOR stays 0 until the feature is hardware-tested and stable.
- MINOR: new behavior, presets or config fields. PATCH: fixes and pure rebases onto a newer Meshtastic patch release.
- The firmware version shown in the app stays upstream's `2.x.y.<sha>`; the sha is the fork commit of our build.
- UF2 names: `help-button-<version>-mt<upstream>-<env>.uf2`, e.g. `help-button-0.1.0-mt2.7.15-rak_wismeshtag_sos.uf2`.

## Related upstream discussions

The need is long-standing; upstream declined it as a default mainly because of accidental
sends on devices without a screen. This design is opt-in, rate-limited and acknowledges
running notifications.

| Reference | Topic | Status |
| --- | --- | --- |
| [firmware#4403](https://github.com/meshtastic/firmware/issues/4403) | SOS on single press of the user button | closed, not planned |
| [firmware#3561](https://github.com/meshtastic/firmware/issues/3561) | SOS on long press, T-Echo | closed, wontfix |
| [firmware#7127](https://github.com/meshtastic/firmware/issues/7127) | Canned messages on T1000-E via button combinations | moved to discussion |
| [firmware discussion #7949](https://github.com/meshtastic/firmware/discussions/7949) | Same, continued | open |
| [firmware#2156](https://github.com/meshtastic/firmware/issues/2156) | Single select button sends first canned message | closed, not planned |
| [Meshtastic-device#60](https://github.com/meshtastic/Meshtastic-device/issues/60) | "I need emergency help" button (2020) | closed |
| [Forum: Kid Tracker While Hiking](https://meshtastic.discourse.group/t/kid-tracker-while-hiking/2257) | Same use case | discussion |
| [Forum: Heltec V3 kids' pagers](https://meshtastic.discourse.group/t/feature-request-heltec-lora32-v3/14889) | Same use case | discussion |

## License

GPL-3.0, see [LICENSE](LICENSE). Meshtastic is a registered trademark of Meshtastic LLC; this project is not affiliated with it.
