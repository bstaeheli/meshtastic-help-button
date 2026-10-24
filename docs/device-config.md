# Device configuration

App settings that go with the Help Button preset.

- Role `CLIENT`. `TRACKER` with power saving deep-sleeps after a position send and misses the come-home message.
- `device.double_tap_as_button = false`.
- `buzzer_mode = ALL_ENABLED` (default) for the HELP/SOS beep. `DIRECT_MSG_ONLY` silences the beep but not the jingles.
- Position: GPS enabled, broadcast interval 120 s, smart position enabled.
- Primary channel `position_precision` must be greater than 0, otherwise HELP is sent without position.
- Without a GPS fix since boot no position is sent and the text reads `HELP no GPS fix`; after a lost lock the last fix since boot is sent with its age.
- External Notification: enabled, alert on message and bell, PWM buzzer on, nag timeout 30-60 s, ringtone of choice (RTTTL).
- Detection Sensor: **disabled** (must not touch the button GPIO).
- Private primary channel with its own PSK; no MQTT on the tag.

## T1000-E (untested)

- `double_tap_as_button` has no effect: the QMA6100P accelerometer only wakes the screen logic.
- The detection sensor is excluded from the build.
- There is no notification LED; alerts are buzzer only.
- Do not hold the button while plugging in USB, or while the cable is attached during a reboot: the
  bootloader (OTAFIX 2.5 or newer) enters DFU mode instead of starting the firmware.

Parents carry a handheld on the same channel. Texts with the bell character make the
phone notify and the tag ring.
