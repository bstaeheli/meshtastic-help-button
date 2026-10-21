# Upstream proposal: user button actions

Draft for `meshtastic/firmware`. Not implemented in the fork; protobuf changes belong in `meshtastic/protobufs`.

## Motivation

Screen-less trackers cannot send a message on demand, and the need keeps coming back:

- [firmware#4403](https://github.com/meshtastic/firmware/issues/4403) SOS on single press (mining, firefighters)
- [firmware#3561](https://github.com/meshtastic/firmware/issues/3561) SOS on long press (paragliding)
- [firmware#7127](https://github.com/meshtastic/firmware/issues/7127) and [discussion #7949](https://github.com/meshtastic/firmware/discussions/7949) canned messages via button combinations; "bell to device, button acknowledges"
- [firmware#2156](https://github.com/meshtastic/firmware/issues/2156) single button sends first canned message
- [Meshtastic-device#60](https://github.com/meshtastic/Meshtastic-device/issues/60) "I need emergency help" button
- Forum: [Kid Tracker While Hiking](https://meshtastic.discourse.group/t/kid-tracker-while-hiking/2257), [Heltec V3 kids' pagers](https://meshtastic.discourse.group/t/feature-request-heltec-lora32-v3/14889)

The Detection Sensor module cannot share the button GPIO with the button handler, so there is no
configuration-only way today.

## Proposed protobuf

```proto
// In module_config.proto (or device config), names to be agreed with maintainers
message UserButtonConfig {
  enum Action {
    DEFAULT = 0;
    NONE = 1;
    ADHOC_POSITION = 2;
    SEND_ALERT = 3;
    ACK_OR_ALERT = 4;
  }
  bool enabled = 1;
  Action single_press = 2;
  Action double_press = 3;
  string alert_text = 4;            // max 50 bytes; bell prepended by firmware if missing
  bool alert_with_position = 5;
  uint32 alert_min_interval_secs = 6;
  bool send_ack = 7;
  uint32 long_press_shutdown_secs = 8;
}
```

## Mitigating accidental sends

Upstream declined earlier requests mainly over accidental sends on devices without a screen.

- **Opt-in:** guarded by `MESHTASTIC_USER_BUTTON_ACTIONS` (compile-time, default off); with the flag off the binary equals stock. Upstream could make it a runtime `enabled` field, default false.
- **Rate limit:** `alert_min_interval_secs` (preset 30 s); presses inside the window are ignored and logged.
- **Acknowledge logic:** if an External Notification nag is running, the press stops it and sends the ack text instead of an alert. Replying to a "come home" never produces a false alarm.
- **Long-press time:** `long_press_shutdown_secs` (preset 15 s) so the device is not switched off by accident in a pocket or a child's hand.
- Gestures with other stock meanings (double, triple, quadruple press) stay unchanged by default.

## Migration note

Today the config is filled from build flags in one accessor, `userButtonActionsConfig()`.
The build-flag config maps 1:1 to the protobuf fields (`UBA_SINGLE_PRESS` -> `single_press`,
`UBA_ALERT_TEXT` -> `alert_text`, `UBA_ALERT_WITH_POSITION` -> `alert_with_position`,
`UBA_ALERT_MIN_INTERVAL_SECS` -> `alert_min_interval_secs`, `UBA_ACK_TEXT` non-null -> `send_ack`,
`UBA_LONG_PRESS_SHUTDOWN_MS` -> `long_press_shutdown_secs`). Swapping the source to
`moduleConfig` is a one-function change.

## Test plan

1. Flash UF2 (DFU drive). Settings survive.
2. App shows the upstream version; pairing, GPS, position broadcast, external notification work as before.
3. Single press while idle: handheld receives alert text with bell plus a fresh position within seconds; a second press within the interval does nothing.
4. Bell message to the tag: ringtone nags; single press stops it; handheld receives `OK`; no alert sent.
5. Double press still sends ad-hoc position; quadruple press still mutes.
6. Long press shorter than the configured time does nothing; longer shuts down.
7. Flag off: firmware behaves exactly like stock (same tests as stock).
8. Battery over 24 h unchanged versus stock.
Also build `rak_wismeshtag`, `tracker-t1000-e` and one ESP32 target (e.g. `heltec-v3`) with the flag off and on.
