# Device configuration

App settings that go with the Help Button preset.

- Role `CLIENT`. `TRACKER` with power saving deep-sleeps after a position send and misses the come-home message.
- `device.double_tap_as_button = false`.
- `buzzer_mode = ALL_ENABLED` (default) for the HELP/SOS beep. `DIRECT_MSG_ONLY` silences the beep but not the jingles.
- Position: GPS enabled, broadcast interval 120 s, smart position enabled.
- Primary channel `position_precision` must be greater than 0, otherwise HELP is sent without position.
- Without a GPS fix since boot the position is skipped silently; the text is still sent.
- External Notification: enabled, alert on message and bell, PWM buzzer on, nag timeout 30-60 s, ringtone of choice (RTTTL).
- Detection Sensor: **disabled** (must not touch the button GPIO).
- Private primary channel with its own PSK; no MQTT on the tag.

Parents carry a handheld on the same channel. Texts with the bell character make the
phone notify and the tag ring.
