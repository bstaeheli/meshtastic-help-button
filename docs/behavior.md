# Behavior

Preset behavior of the Help Button firmware (`rak_wismeshtag_sos`).

| Button gesture | Stock behavior | Preset behavior |
| --- | --- | --- |
| Single press, double press, any rapid multi-press, or holding the button | single press stops a nag; double press sends a position; triple toggles GPS; four presses mute the buzzer | all identical: if a nag runs, stop it, send `\x07OK` and beep; otherwise send `\x07HELP` plus position (no replies requested) and beep |
| Press within 30 s after a sent alert | n/a | short "boop", nothing sent |
| Hold of 15 s or more | shutdown after 3.9 s (only after 30 s uptime, on release) | shutdown, released after 30 s uptime; the HELP already went out at about 0.5 s, so switching off also sends one HELP |

Holding the button sends HELP after about 0.5 s. Keep holding for 15 s (the lead-up melody ends at
the shutdown point) to switch off.

The stock double-press ping, triple-press GPS toggle and four-press mute are unreachable with this
preset.
Devices with a screen keep the stock behavior.

## Rules

- Help messages are rate-limited (preset 30 s). Presses inside the window are ignored and logged at debug level.
- Texts are broadcast on channel index 0, port `TEXT_MESSAGE_APP`, priority `HIGH`, `want_ack = false`, and delivered to a connected phone as well.
- The bell character (`0x07`) is part of both texts so phones and buzzers alert.
- Texts: the preset sends `\x07HELP` / `\x07OK`.

## Known limitations

- If the regional hourly duty-cycle limit is exhausted (e.g. EU_868), the firmware drops the HELP silently although the tag beeps.
- Audible confirmation needs `buzzer_mode` `ALL_ENABLED` (the default).
- `SEND_ALERT` (unlike `ACK_OR_ALERT`) does not stop a running nag.
- The hold time is a `uint16_t` in milliseconds (max 65535).
- Design risk: the `\x07OK` ack contains the bell, so other tags with this preset on the same
  channel start nagging. A sibling's press then acknowledges instead of sending HELP.

## Come home

Any incoming message containing the bell character makes the tag play its ringtone via the
External Notification module (works on stock firmware). A press stops the alarm and
replies with the acknowledgement text. It does not send a help message.

## Build flags

The flags in `config/help-button.ini` map 1:1 to `UserButtonActionsConfig`:
`UBA_SINGLE_PRESS`, `UBA_DOUBLE_PRESS`, `UBA_MULTI_PRESS`, `UBA_ALERT_TEXT`, `UBA_ACK_TEXT`,
`UBA_ALERT_WITH_POSITION`, `UBA_ALERT_MIN_INTERVAL_SECS`, `UBA_LONG_PRESS_SHUTDOWN_MS`.
String flags need the quadruple-backslash form used in `config/help-button.ini`
(`-D UBA_ALERT_TEXT=\"\\\\x07HELP\"`). `\x` escapes are greedy: text after the bell must not
start with a hex digit (`\x07ALARM` breaks). `-D UBA_ACK_TEXT=nullptr` disables the ack message.
Without `MESHTASTIC_USER_BUTTON_ACTIONS=1` the firmware equals stock.
