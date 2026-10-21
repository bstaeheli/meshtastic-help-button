# Behavior

Preset behavior of the KidTag firmware (`rak_wismeshtag_kidtag`, `rak_wismeshtag_sos`).

| Button gesture | Stock behavior | Preset behavior |
| --- | --- | --- |
| Single short press | stops a running external-notification nag; otherwise no visible effect on screen-less devices | if a nag is running: stop it and send the acknowledgement text; otherwise send the help text plus an ad-hoc position, rate-limited |
| Double press | ad-hoc position | unchanged |
| Triple press | toggle GPS | unchanged (disable via `device.disable_triple_click`) |
| Quadruple press | mute/unmute buzzer | unchanged |
| Long press | shutdown after ~5 s | shutdown only after the configured hold time (preset 15 s) |

## Rules

- Help messages are rate-limited (preset 30 s). Presses inside the window are ignored and logged at debug level.
- Texts are broadcast on channel index 0, port `TEXT_MESSAGE_APP`, priority `HIGH`, `want_ack = false`, and delivered to a connected phone as well.
- The bell character (`0x07`) is part of both texts so phones and buzzers alert.
- Texts: both presets (`kidtag`, `sos`) send `\x07HELP` / `\x07OK`.

## Come home

Any incoming message containing the bell character makes the tag play its ringtone via the
External Notification module (works on stock firmware). A single press stops the alarm and
replies with the acknowledgement text. It does not send a help message.

## Build flags

The flags in `config/kidtag.ini` map 1:1 to `UserButtonActionsConfig`:
`UBA_SINGLE_PRESS`, `UBA_DOUBLE_PRESS`, `UBA_ALERT_TEXT`, `UBA_ACK_TEXT`,
`UBA_ALERT_WITH_POSITION`, `UBA_ALERT_MIN_INTERVAL_SECS`, `UBA_LONG_PRESS_SHUTDOWN_MS`.
Without `MESHTASTIC_USER_BUTTON_ACTIONS=1` the firmware equals stock.
