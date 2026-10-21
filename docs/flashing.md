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

## Update over Bluetooth (OTA)

Custom builds from the GitHub workflow (see the README) and every release include a
`help-button-<version>-mt<upstream>-<env>-ota.zip`. It is the standard Meshtastic nRF52 DFU
package (`adafruit-nrfutil`), so a phone can install it over Bluetooth without a cable.

Status: the Meshtastic documentation lists RAK nRF52 devices as OTA-capable
([nRF52 OTA](https://meshtastic.org/docs/getting-started/flashing-firmware/nrf52/ota/)). The WisMesh Tag
uses the same bootloader family, but no source confirms the Tag explicitly. Not yet tested here: try it
once with the USB cable at hand.

Risk: a failed OTA update can leave the tag unresponsive until it is re-flashed over USB.
Back up the settings first (see above) and keep the phone awake during the transfer.

1. Download the `-ota.zip` directly on the phone (release asset). Do not unzip it.
2. Connect the phone to the tag over Bluetooth (pair it in the Meshtastic app first).
3. Either use the Meshtastic app (Android: Advanced, Firmware Update; iOS: Settings, Firmware Updates),
   or a DFU app:
   - Android: nRF Connect 4.24.3 (the newer nRF Device Firmware Update 2.3.0 does not work). Scanner tab,
     connect to the tag, tap the DFU icon, choose "Distribution Packet (ZIP)", select the `-ota.zip`.
   - iOS: "nRF Device Firmware Update" from the App Store, select the `-ota.zip`, connect, upload.
     If it fails, enable "Packets Receipt Notification" and lower the number of packets (e.g. 5).
4. The transfer is slow (several minutes). The tag reboots by itself when done.

Recovery if the update fails: put the tag in bootloader mode over USB (double-tap reset, the tag
appears as a USB drive) and copy the `.uf2` as described in "Flash". If the drive does not appear, see
Meshtastic's [entering bootloader mode](https://meshtastic.org/docs/getting-started/flashing-firmware/nrf52/entering-bootloader-mode/).
