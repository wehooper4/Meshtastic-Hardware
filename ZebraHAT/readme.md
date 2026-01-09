
## Overview

This is a 915MHz SX1262 development board for Amateur Radio (Part 97) use, designed in a Raspberry Pi HAT form factor. It's compatible with the Raspberry Pi 2-5, Nebra Outdoor miner, and other SBCs with Pi-compatible pinouts.

The radio module used has a high perfomance 915mhz/33cm band RF bandpass filter built in, eleminating the need for bulky and expensive cavity filters to eleminate out of band interfearece from cell towers or UHF TV stations.

This is a simple “dumb” radio module; the software or "firmware" to drive it runs as an application on the host Raspberry Pi. This gives the end operator the ability to use this with their favorite open-source amateur radio projects (Meshtastic, Lora-APRS, etc.) or develop their own experimental radio software.

This is a pin-compatible drop-in board for the Nebra miner and does not require bodge wires to work like other hats do.


## Hardware Features

**1 Watt Radio Hat**
* 1 Watt E22P 900MHz LoRa radio with TCXO, FEM with both PA and LNA, RF Filtering
  * 902-926mhz Bandpass built in (RX: SAW filter pre LNA, SAW filter post LNA. TX: SAW filter pre-PA, lowpass filter post PA)
* Indirect lightning/ESD protection (Polymer device off E22)
* 5V+ Power Rail Filtering
* AHT20 Temperature/Humidity Sensor
* I2C Socket
* GPS Socket
* TX indicator LED
* HAT+ Compatable EEPROM (not yet active)
* Solderless header

![Photo of Zebra Hat V1](/static/IMG_3882.jpeg)



## How to Buy

[![PayPal Button](https://www.paypalobjects.com/en_US/i/btn/btn_buynowCC_LG.gif)](https://www.paypal.com/ncp/payment/VVUL26AHN7LE8)



This product is made available via a secure PayPal checkout.



## Meshtastic Usage

Installation: https://meshtastic.org/docs/hardware/devices/linux-native-hardware/

For Alpha, use this repo:
```
echo 'deb http://download.opensuse.org/repositories/network:/Meshtastic:/alpha/Debian_13/ /' | sudo tee /etc/apt/sources.list.d/network:Meshtastic:alpha.list
curl -fsSL https://download.opensuse.org/repositories/network:Meshtastic:alpha/Debian_13/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/network_Meshtastic_alpha.gpg > /dev/null
sudo apt update
sudo apt install meshtasticd
```

At the "Meshtasticd Configuration" step, use this command to install the config file:

```
sudo wget -O /etc/meshtasticd/config.d/ZebraHat.yaml https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main/ZebraHAT/ZebraHat.yaml
```

Install Meshtastic CLI (for your sanity):
```
sudo apt install pipx && pipx install "meshtastic[cli]"
pipx ensurepath
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
