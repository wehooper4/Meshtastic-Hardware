# Ultra hat

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
