## Overview
The NewtPi is a 2 Watt 915MHz Amateur Radio (Part 97) SX1262 development board in a Raspberry Pi HAT form factor.

This is a simple “dumb” radio module. The software or "firmware" to drive it runs as an application on the host Raspberry Pi or other SBC. This gives the end operator the ability to use this with their favorite open-source amateur radio projects (Meshtastic, LoRa-APRS, etc.) or to develop their own experimental radio software.

## Hardware Features
* E22-900M33S Radio Module with 33dbm PA and LNA
* High sensitivity ATGM336H GNSS for positioning and timing
* I2C breakout QWIIC connectors for sensors, screens, and other I/O
* Filtered power supply
* Low noise 4-layer PCB
* Provisions for SMA connector for LORA radio
* DC Fan Outout
* PWM Fan Output
* DC Power in/out header

![Photo of NewtPi Hat](/static/IMG_2806.jpeg)


**WARNING:** SX1262 power level MUST be set to 8 or lower to prevent PA damage.

## How to Buy

[![PayPal Button](https://www.paypalobjects.com/en_US/i/btn/btn_buynowCC_LG.gif)](https://www.paypal.com/ncp/payment/PNLGPG7BGGWL6)

This product is made available via a secure PayPal checkout.

## Raspberry Pi 40-Pin Header Pinout (HAT)

| Pin | Name         | BCM GPIO | Function / Notes      |
|-----|--------------|----------|-----------------------|
| 1   | +3V3         | –        | Power (3.3 V)          |
| 2   | +5V          | –        | Power (5 V)            |
| 3   | SDA1         | GPIO2    | I²C1 SDA               |
| 4   | +5V          | –        | Power (5 V)            |
| 5   | SCL1         | GPIO3    | I²C1 SCL               |
| 6   | GND          | –        | Ground                 |
| 7   | GPIO4        | 4        | PPS                    |
| 8   | TXD0         | GPIO14   | UART0 TX (pTX)         |
| 9   | GND          | –        | Ground                 |
| 10  | RXD0         | GPIO15   | UART0 RX (pRX)         |
| 11  | GPIO17       | 17       | FAN_EN (high enable)   |
| 12  | GPIO18       | 18       | FAN_PWM                |
| 13  | GPIO27       | 27       |                        |
| 14  | GND          | –        | Ground                 |
| 15  | GPIO22       | 22       |                        |
| 16  | GPIO23       | 23       | RST                    |
| 17  | +3V3         | –        | Power (3.3 V)          |
| 18  | GPIO24       | 24       |                        |
| 19  | GPIO10       | 10       | SPI0_MOSI              |
| 20  | GND          | –        | Ground                 |
| 21  | GPIO9        | 9        | SPI0_MISO              |
| 22  | GPIO25       | 25       |                        |
| 23  | GPIO11       | 11       | SPI0_SCLK              |
| 24  | GPIO8        | 8        | SPI0_CE0_N             |
| 25  | GND          | –        | Ground                 |
| 26  | GPIO7        | 7        |                        |
| 27  | ID_SD        | GPIO0    | HAT+ EEPROM SDA        |
| 28  | ID_SC        | GPIO1    | HAT+ EEPROM SCL        |
| 29  | GPIO5        | 5        |                        |
| 30  | GND          | –        | Ground                 |
| 31  | GPIO6        | 6        |                        |
| 32  | GPIO12       | 12       | RXEN                   |
| 33  | GPIO13       | 13       | TXEN                   |
| 34  | GND          | –        | Ground                 |
| 35  | GPIO19       | 19       |                        |
| 36  | GPIO16       | 16       | IRQ                    |
| 37  | GPIO26       | 26       |                        |
| 38  | GPIO20       | 20       | BUSY                   |
| 39  | GND          | –        | Ground                 |
| 40  | GPIO21       | 21       | NSS                    |

## SX1262 Power Setting to Output Power Table

| Power Setting | Output Power (dBm) |
|---------------|--------------------|
| 9             | 33.4               |
| 8             | 32.9               |
| 7             | 32.2               |
| 6             | 31.7               |
| 5             | 31.2               |
| 4             | 30.7               |
| 3             | 29.6               |
| 2             | 28.9               |
| 1             | 27.8               |
| 0             | FULL BEANS         |
| -1            | 26.0               |
| -2            | 24.9               |
| -3            | 24.0               |
| -4            | 23.0               |
| -5            | 22.2               |
| -6            | 21.0               |
| -7            | 20.0               |
| -8            | 19.0               |
| -9            | 17.7               |

Note that in Meshtastic, "0" is a special reserved power level that sets the radio to full output. If using radiolib or another SX1262 access library, it should be a valid number.

**DO NOT SET THE POWER LEVEL HIGHER THAN 8.** Doing so will damage the PA. If your software package supports capping it, I strongly advise you to do so.

## Meshtastic Usage

Installation: https://meshtastic.org/docs/hardware/devices/linux-native-hardware/

At step "Meshtasticd Configuration" use this command to install config file:
```
wget -O /etc/meshtasticd/config.d/NewtPi-2w.yaml https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main/NewtPi/NewtPi-2w.yaml
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

## GPS information

GPS on /dev/ttyAMA0 or /dev/ttyS0

PPS on GPIO 4



## Enabling Fan Control

Add the following lines to `/boot/config.txt` and reboot.

```text
# On/Off fan on GPIO17 (turns on at 55 °C, off at 50 °C)
dtoverlay=gpio-fan,gpiopin=17,temp=55000,hysteresis=5000

# PWM fan on GPIO18 (multi-speed based on temperature)
dtoverlay=pwm-gpio-fan,fan_gpio=18,fan_temp0=50000,fan_temp0_hyst=5000,fan_temp0_speed=100,fan_temp1=60000,fan_temp1_speed=180,fan_temp2=70000,fan_temp2_speed=255
```

## Legal Notice
This is **Amateur Radio equipment** under FCC Part 97.
* It is not certified for unlicensed operation.
* Users must comply with all applicable regulations in their jurisdiction.
* While compatible with Meshtastic firmware, operation in the United States requires compliance with FCC Part 97 rules.
