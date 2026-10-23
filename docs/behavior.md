# Behavior

Preset behavior of the Help Button firmware (`rak_wismeshtag_sos`).

| Button gesture | Stock behavior | Preset behavior |
| --- | --- | --- |
| Any press while a melody plays (nag or hint tune) | single press stops a nag | stops the melody at button-down; a nag also sends `\x07OK` and beeps; the rest of that press does nothing |
| Click, or hold and release under 3 s | single press stops a nag; otherwise nothing | `\x07HELP` plus position, beep |
| Double click or rapid multi-press | double: position; triple: GPS toggle; four: mute | `\x07SOS` plus position, beep |
| Release after 3 to 10 s | shutdown after 3.9 s | nothing sent; short hint jingle (C5 E5 G5 E5 C5) means "not sent" |
| Release after 10 s or more | shutdown after 3.9 s (only after 30 s uptime) | switch off with the stock shutdown melody, only if uptime was over 30 s, else nothing |
| HELP or SOS again within 30 s | n/a | short "boop", nothing sent |

While the button is held from 3 s on, eight rising notes (C3 to C4, 200 ms each, at about 3.0, 4.0, 4.9,
5.9, 6.9, 7.9, 8.8 and 9.8 s) count up to the shutdown; releasing stops the melody. The tag switches off
on release, not while held (a held pin would wake the nRF52 again). Timings have 50-100 ms polling jitter.

The press decides on the state at button-down: a bell text arriving during the press does not turn
HELP into OK. A hold released while a nag is running does nothing (no hint over a nag).

HELP and SOS have separate 30 s windows. `\x07OK` is never rate-limited. The stock double-press ping,
triple-press GPS toggle and four-press mute are unreachable with this preset. Devices with a screen keep
the stock behavior.

## Rules

- Texts are broadcast on channel index 0, port `TEXT_MESSAGE_APP`, priority `HIGH`, `want_ack = false`, and delivered to a connected phone as well.
- The bell character (`0x07`) is part of all texts so phones and buzzers alert.
- Texts: the preset sends `\x07HELP` / `\x07SOS` / `\x07OK`.
- HELP and SOS carry a map link after the text, e.g. `\x07HELP https://osm.org/go/0C0WCb6VB--?m ±25m`,
  and ` 4min old` (or `2h old`, `3d old`) when the last fix is older than 120 s. The link is an
  OpenStreetMap shortlink computed on the tag (no network); the separate position packet is still sent.
  Accuracy is about 5 m per HDOP (PDOP as fallback), rounded to 5 m, and left out if neither is known;
  the map zoom (12 to 18) follows it.
- The link never reveals more than the position packet: no link if the primary channel's
  `position_precision` is 0 or there was no fix since boot; with reduced precision the link points to
  the same truncated position and the `±` is at least the precision radius (e.g. 365 m at 16 bits).
- The link is left out if the text would exceed the packet payload; `\x07OK` never has a link.

## Known limitations

- If the regional hourly duty-cycle limit is exhausted (e.g. EU_868), the firmware drops the message silently although the tag beeps.
- Audible confirmation needs `buzzer_mode` `ALL_ENABLED` (the default).
- `SEND_ALERT` / `SEND_ALERT2` (unlike the `ACK_OR_*` actions) do not stop a running nag.
- Times are `uint16_t` milliseconds in the stock button code (max 65 s).
- Design risk: the `\x07OK` ack contains the bell, so other tags with this preset on the same
  channel start nagging. A sibling's press then acknowledges instead of sending HELP.

## Come home

Any incoming message containing the bell character makes the tag play its ringtone via the
External Notification module (works on stock firmware). A press stops the alarm and
replies with the acknowledgement text. It does not send a help message.

## Build flags

The flags in `config/help-button.ini` map 1:1 to `UserButtonActionsConfig`:
`UBA_SINGLE_PRESS`, `UBA_DOUBLE_PRESS`, `UBA_MULTI_PRESS`, `UBA_ALERT_TEXT`, `UBA_ALERT2_TEXT`,
`UBA_ACK_TEXT`, `UBA_ALERT_WITH_POSITION`, `UBA_ALERT_MIN_INTERVAL_SECS` (per level),
`UBA_HOLD_ALERT_MAX_MS` (3000), `UBA_LONG_PRESS_SHUTDOWN_MS` (10000, max 65535).
`scripts/build.sh` fills texts and times from validated parameters (`HB_*`, see the script header).
Texts are 1-40 characters of `A-Za-z0-9.,!?-` (no spaces). The bell is emitted as the octal escape
`\007`, so any text may follow. `-D UBA_ACK_TEXT=nullptr` disables the ack message.
Without `MESHTASTIC_USER_BUTTON_ACTIONS=1` the firmware equals stock.
