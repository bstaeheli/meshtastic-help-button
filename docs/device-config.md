# Device configuration

App settings that go with the Help Button preset.

- Role `CLIENT` (not `TRACKER`, which sleeps and misses the come-home message).
- `device.disable_triple_click = true`, `device.double_tap_as_button = false`.
- Position: GPS enabled, broadcast interval 120 s, smart position enabled.
- External Notification: enabled, alert on message and bell, PWM buzzer on, nag timeout 30-60 s, ringtone of choice (RTTTL).
- Detection Sensor: **disabled** (must not touch the button GPIO).
- Private primary channel with its own PSK; no MQTT on the tag.

Parents carry a handheld on the same channel. Texts with the bell character make the
phone notify and the tag ring.
