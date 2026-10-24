# Flashing

## Before you start: back up settings

In the Meshtastic app open the device, then Settings and export the configuration
(or use the CLI: `meshtastic --export-config > backup.yaml`). A UF2 update normally keeps
settings; after flashing, verify them (`meshtastic --export-config` and diff against the backup,
or check role, channel PSK and position settings in the app).

## Flash

1. Download `help-button-<version>-mt<upstream>-<env>.uf2` (e.g. `help-button-0.1.0-mt2.7.15-rak_wismeshtag_sos.uf2`) from the release and check it against `SHA256SUMS`
   (`shasum -a 256 -c SHA256SUMS`).
2. Put the device into bootloader mode so that it appears as a USB drive:
   - RAK WisMesh Tag: connect the pogo-pin USB cable and double-tap the reset button (drive e.g. `WISBLOCK`).
   - Seeed T1000-E (untested): plug in the magnetic USB cable, then press and hold the button as it starts,
     about 3 s; the drive appears a few seconds later (OTAFIX bootloader 2.5 or newer). With an older
     bootloader run `meshtastic --enter-dfu` over USB. See Meshtastic's
     [entering bootloader mode](https://meshtastic.org/docs/getting-started/flashing-firmware/nrf52/entering-bootloader-mode/).
3. Check that the drive is mounted.
4. Copy the `.uf2` file to the drive. It reboots by itself when done.
5. Check that the app shows the expected firmware version, pairing and GPS work, then test the button
   as described in the project's test plan.

## Back to stock firmware

Download the official `firmware-rak_wismeshtag-<version>.uf2` (T1000-E: `firmware-tracker-t1000-e-<version>.uf2`) for the matching version from the
[Meshtastic releases](https://github.com/meshtastic/firmware/releases) (or use the web flasher at
https://flasher.meshtastic.org) and flash it the same way (bootloader mode, copy the UF2).
Settings are kept; if anything looks odd, restore the backup.

## Recovery

If the drive does not appear, see Meshtastic's
[entering bootloader mode](https://meshtastic.org/docs/getting-started/flashing-firmware/nrf52/entering-bootloader-mode/).

## OTA zip

Releases also include a `-ota.zip`, the standard nRF52 DFU package for Bluetooth updates. Untested here
(entering DFU mode from an iPhone failed); use at your own risk with the USB cable at hand.
