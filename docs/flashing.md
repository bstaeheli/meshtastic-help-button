# Flashing the RAK WisMesh Tag

## Before you start: back up settings

In the Meshtastic app open the device, then Settings and export the configuration
(or use the CLI: `meshtastic --export-config > backup.yaml`). A UF2 update normally keeps
settings; after flashing, verify them (`meshtastic --export-config` and diff against the backup,
or check role, channel PSK and position settings in the app).

## Flash

1. Download `help-button-<version>-mt<upstream>-<env>.uf2` (e.g. `help-button-0.1.0-mt2.7.15-rak_wismeshtag_sos.uf2`) from the release and check it against `SHA256SUMS`
   (`shasum -a 256 -c SHA256SUMS`).
2. Connect the pogo-pin USB cable to the tag.
3. Double-tap the reset button. The tag appears as a USB drive (e.g. `WISBLOCK` or similar).
4. Copy the `.uf2` file to the drive. It reboots by itself when done.
5. Check that the app shows the expected firmware version, pairing and GPS work, then test the button
   as described in the project's test plan.

## Back to stock firmware

Download the official `firmware-rak_wismeshtag-<version>.uf2` for the matching version from the
[Meshtastic releases](https://github.com/meshtastic/firmware/releases) (or use the web flasher at
https://flasher.meshtastic.org) and flash it the same way (double-tap reset, copy the UF2).
Settings are kept; if anything looks odd, restore the backup.

## Recovery

If the drive does not appear after a double-tap, see Meshtastic's
[entering bootloader mode](https://meshtastic.org/docs/getting-started/flashing-firmware/nrf52/entering-bootloader-mode/).

## OTA zip

Releases also include a `-ota.zip`, the standard nRF52 DFU package for Bluetooth updates. Untested here
(entering DFU mode from an iPhone failed); use at your own risk with the USB cable at hand.
