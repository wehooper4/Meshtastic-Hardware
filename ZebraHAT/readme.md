# Zebra Hat: 915MHz LoRa Development Board

## Overview

The Zebra Hat lineup consists of high-performance 915MHz SX1262 development boards designed in a Raspberry Pi HAT form factor. It is compatible with the Raspberry Pi 2-5, Nebra Outdoor miner, and other SBCs with Pi-compatible pinouts.

The board is available in two variants to suit different operational needs:

* **1 Watt Version:** Optimized for general open-source mesh networking. The radio module features a high-performance 915MHz/33cm band RF bandpass filter built-in. This eliminates the need for bulky and expensive cavity filters to remove out-of-band interference from cell towers or UHF TV stations.
* **2 Watt Version:** A high-power variant designed exclusively for Amateur Radio (Ham) applications. No extra filtering is onboard; it is recommended to use external bandpass filters for optimal performance.

As a “dumb” radio module, the firmware to drive it runs as an application on the host Raspberry Pi. This gives operators the flexibility to use the hardware with their favorite open-source projects or develop custom experimental radio software.

## Use Cases

### 1 Watt Model
The 1W version is intended for a wide range of open-source mesh networking projects, including:
* **Meshtastic**
* **Meshcore**
* **Open Source Mesh** projects and experimental data networks.

### 2 Watt Model
The 2W version is restricted to **Amateur Radio use only**, regardless of the software power level settings. It is designed for:
* **Meshtastic (Ham Mode)**
* **LoRa-APRS**
* **High-power Ham Radio** digital experiments.

## Hardware Features

### 1 Watt Radio Hat
* **Radio:** 1 Watt E22P 915MHz LoRa radio with TCXO.
  * **Frontend:** FEM with both PA and LNA.
  * **Filtering:** 902-926MHz Bandpass built-in (RX: SAW filter pre-LNA, SAW filter post-LNA; TX: SAW filter pre-PA, Lowpass filter post-PA).
* **Protection:** Indirect lightning/ESD protection (Polymer device off E22P).
* **Power:** 5V+ Power Rail Filtering.
* **Sensors:** AHT20 Temperature/Humidity Sensor.
* **Expansion:** I2C Socket and GPS Socket.
* **Visuals:** TX indicator LED.
* **Extras:** HAT+ Compatible EEPROM (not yet active), Solderless header.
![Photo of Zebra Hat V1](/static/IMG_3882.jpeg)

### 2 Watt Radio Hat (Amateur Radio Only)
* **Radio:** 2 Watt E22 33CM LoRa radio with TCXO.
  * **Frontend:** Discrete 33dBm+ PA and LNA.
* **Protection:** Indirect lightning/ESD protection (Polymer device off E22).
* **Power:** 5V+ Power Rail Filtering.
* **Sensors:** AHT20 Temperature/Humidity Sensor.
* **Expansion:** I2C Socket and GPS Socket.
* **Visuals:** TX indicator LED.
* **Extras:** HAT+ Compatible EEPROM (not yet active), Solderless header.


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

**1 Watt Version:** Designed for standard open-source mesh networking. Users are responsible for complying with all local regulations regarding frequency use, power output, and antenna gain in their specific jurisdiction.

**2 Watt Version:** This is **Amateur Radio equipment** under FCC Part 97. It is not intended for unlicensed operation. Use of the 2W model, regardless of power settings, requires a valid Amateur Radio license and compliance with part 97 operation.

**Compliance:** The end-user is solely responsible for ensuring that their hardware and software configurations comply with the laws of their local region.
