# T1000-E tester checklist

The `tracker-t1000-e_sos` build is untested on hardware. Thank you for testing. Please report in an issue:

- firmware file name
- bootloader version (from `INFO_UF2.TXT` on the drive)
- app version

Attach the serial log (`meshtastic --noproto` or web serial) for any failure.

| # | Test | Expected |
| --- | --- | --- |
| T1 | Flash via the drive (see [flashing.md](flashing.md)) | App shows `2.7.26.<sha>`, settings kept, GPS fix, position broadcast |
| T2 | Power on from off with a short press and with a 2 s hold (no USB) | No HELP is sent at boot |
| T3 | Hold the button while plugging in USB; then boot without holding | Bootloader drive appears (documented); normal boot when not held |
| T4 | Click; click again within 30 s; double click | `HELP` + link + position on the handheld and a beep; second click a boop, nothing sent; double click sends `SOS` |
| T5 | Hold 3-10 s, release | Countdown notes audible from 3 s, hint jingle, nothing sent |
| T6 | Send a bell message to the device | Ringtone nags; a press stops it and sends `OK` |
| T7 | After 30 s uptime hold >= 10 s, release | Shutdown melody, device stays off (no self-wake) for 5 min; a press turns it on again |
| T8 | Hold >= 10 s within 30 s of boot | No shutdown |
| T9 | Indoors after a fix; cold boot indoors | `HELP` carries the `old` age; `HELP no GPS fix` |
| T10 | Battery over 24 h versus stock (optional) | Comparable |

## Confirmed on the WisMesh Tag

Hardware feedback on the Tag, still to be verified on the T1000-E:

- Switching on does not send HELP (relevant to T2).
- The device does not wake by itself after the 10 s shutdown (relevant to T7).
