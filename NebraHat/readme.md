## Overview

This is a 915MHz SX1262 development board for Amateur Radio (Part 97) use, designed in a Raspberry Pi HAT form factor. It's compatible with the Raspberry Pi 2-5, Nebra Outdoor miner, and other SBCs with Pi-compatible pinouts.

This is a simple “dumb” radio module; the software or "firmware" to drive it runs as an application on the host Raspberry Pi. This gives the end operator the ability to use this with their favorite open-source amateur radio projects (Meshtastic, Lora-APRS, etc.) or develop their own experimental radio software.

This is a pin-compatible drop-in board for the Nebra miner and does not require bodge wires to work like other hats do.

Pinout inspired by Mark Birss's starter edition hat:
https://github.com/markbirss/lora-starter-edition-sx1262-i2c

## Hardware Features

**1 Watt Radio Hat**
* 1 Watt E22 900MHz LoRa radio with TCXO and LNA
* SMA support

**2 Watt Radio Hat**
* 2 Watt E22 900MHz radio with TCXO and LNA
* 5v power rail filtering
* 915MHz bandpass filter
  * 902-926mhz pass band
  * ~3db inserion loss
* Indirect lightning/ESD protection
* Temperature/Humidity Sensor
* RX/TX indicator LEDs
* External RX/TX indicator header support



![Photo of 2w Nebra Hats](/static/IMG_2807.jpeg)

If you wish to keep the original USB hub for wifi or other uses, you can assemble this with extended stacking headers.

![Photo of Nebra Hat in Nebra](/static/IMG_2808.jpeg)
![Photo of Nebra Hat in Nebra with hub](/static/IMG_2809.jpeg)


## SX1262 Power Setting to Output Power Table

**Bandpass Filter Output**

|Power Setting | Output Power (dBm)|
|---|---|
|9 | 29.8|
|8 | 29.6|
|7 | 29.3|
|6 | 28.9|
|5 | 28.5|
|4 | 28.1|
|3 | 27.4|
|2 | 26.9|
|1 | 26|
|0 | 29.8|
|-1 | 24.4|
|-2 | 23.4|
|-3 | 22|
|-4 | 21.3|
|-5 | 20.5|
|-6 | 18.8|
|-7 | 17.8|
|-8 | 16.7|
|-9 | 15.4|

Note power levels may be higher host other then nebra. If using the IPEX connector right on the radio bypassing the filter expect ~3db higher signal level. This is not adviced due to the loss in receve performance.

## Nebra Conversion

Remove the LoRaWAN concentrator (it's not useful for anything but LoRaWAN projects).

Remove the EMMC SD card from the Nebra.

Plug the card into a computer.

Image the card with Raspberry Pi OS using the imaging tool: https://www.raspberrypi.com/software/

The Nebra miner uses a Pi Compute Module 3. Raspberry Pi OS Lite is recommended.

## Meshtastic Usage

Installation: https://meshtastic.org/docs/hardware/devices/linux-native-hardware/

At the "Meshtasticd Configuration" step, use this command to install the config file:

```
wget -O /etc/meshtasticd/config.d/NebraHat_1W.yaml https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main/NebraHat/NebraHat_1W.yaml
```

Install Config for 2-Watt version:
```
wget -O /etc/meshtasticd/config.d/NebraHat_2W.yaml https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main/NebraHat/NebraHat_2W.yaml
```

Install Meshtastic CLI (for your sanity):
```
sudo apt install pipx && pipx install "meshtastic[cli]"
pipx ensurepath
```

To enable Part 97 compliance:
```
meshtastic --set-ham 'CALLSIGN'
```

## License
This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

[![CC BY-NC-SA 4.0](https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

**In plain English:** You are free to use and modify these designs for personal projects and to manufacture boards for yourself. However, you **may not** sell or distribute these designs or any boards made from them for any reason without my explicit written permission.

## Legal Notice
This is **Amateur Radio equipment** under FCC Part 97.

* It is not certified for unlicensed operation.
* Users must comply with all applicable regulations in their jurisdiction.
* While compatible with Meshtastic firmware, operation in the United States requires compliance with FCC Part 97 rules.
