## Overview
915mhz Amateur Radio (Part 97) SX1262 development board in Raspberry Pi HAT form factor designe to work with Raspbery Pi 2-5, Nebra Outdoor miner, or other SBC's with pi compatable pinouts. This 

This is a simple “dumb” radio module, the software or "firmware" to drive it run as a application on the host Raspbery PI. This gives the end operator the ability to use this with their favrote open sourve amiture radio projects (Meshtastic, Lora-APRS, ect) or develop their own experimental radio software.

This is a pin compatable drop in board for the Nebra miner, and does not require bodge wires to work like others hats do.

Pinout inspited by Mark Briss's starter edditon hat:
https://github.com/markbirss/lora-starter-edition-sx1262-i2c

## Hardware Features
**1 Watt Hat**
* 1 Watt E22 900mhz Lora radio with TXCO and LNA
* SMA support

**2 Watt Hat**
* 2 Watt E22 900mhz radio with TXCO and LNA
* 5v power rail filtering
* 915mhz bandpass filter
* Indirect lightning/ESD protection
* Temperature/Humidity Sensor
* RX/TX indicator LED's
* External RX/TX indicator header support

![Photo of 2w Nebra Hats](/static/IMG_2807.jpeg)

If you wish to keep the original USB hub for wifi or other uses, you can assembel this with extended stacking headers

![Photo of Nebra Hat in Nebra](/static/IMG_2808.jpeg)
![Photo of Nebra Hat in Nebra with hub](/static/IMG_2809.jpeg)

## Nebra Conversion

Remove LoraWan concentrator (it's not useful for anything but Lorawan projects, and if you're doing that you're doing that why are you looking at amateur radio hardware?)

Remove the EMMC SD card from the nebra

Plug the card into a computer

Image card with rasbarian using the imaging tool: https://www.raspberrypi.com/software/

The Nebra miner uses a Pi compute module 3. Rasbarian lite is recomended.

## Meshtastic Usage

Instalation: https://meshtastic.org/docs/hardware/devices/linux-native-hardware/

At step "Meshtasticd Configuration" use this command to install config file:

```
wget –O /etc/meshtasticd/config.d/NebraHat_1W.yaml https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main/NebraHat/NebraHat_1W.yaml
```

Install Config for 2Watt version:
```
wget -O /etc/meshtasticd/config.d/NebraHat_2W.yaml https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main/NebraHat/NebraHat_2W.yaml
```

Install Meshtastic CLI (for your sanity):
```
sudo apt install pipx && pipx install "meshtastic[cli]"
pipx ensurepath
```

To enable part 97 compliance:
```
meshtastic  --set-ham 'CALLSIGN'
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
