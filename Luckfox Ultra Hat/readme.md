
# Ultra hat

This is a amiture radio x1262 hat for the Luckfox Ultra seres of SBC's. 

## Porkcube the ledgand

The following edits are for the no-longer available Ubuntu based image for the eMMC flash:
  - `Ubuntu_Luckfox_Lyra_Ultra_W_eMMC_250417`

## For Luckfox Lyra Ultra W:

Make sure these lines are present in `/etc/luckfox.conf` to enable SPI, reboot required to take effect:
```
SPI0_STATUS=1
SPI0_SPEED=20000000
SPI0_SCLK_RM_IO=8
SPI0_MISO_RM_IO=7
SPI0_MOSI_RM_IO=6
SPI0_CS_RM_IO=10
```

`/etc/meshtasticd/config.d/lyra_ultra_hat.yaml` `meshtasticd` cfg:
```
---
Lora:
  Module: sx1262
  DIO2_AS_RF_SWITCH: true
  DIO3_TCXO_VOLTAGE: true
  CS: 10
  IRQ: 5
  Busy: 11
  Reset: 9
  RXen: 14

  spidev: spidev0.0 #pins are (CS=10, CLK=8, MOSI=6, MISO=7)
  spiSpeed: 2000000

General:
  MACAddressSource: eth0
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

