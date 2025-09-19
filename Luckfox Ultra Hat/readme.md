<img src="/static/ultra_hat_logo.png" alt="Logo" width="200"> 

## Luckfox Ultra Hat

This is a amiture radio x1262 hat for the Luckfox Ultra seres of SBC's. It's confimred working on the Lyra, but software configuration has not been developed for the others at this time. The Luckfox Ultra platform makes a fantastic inexpensive linux radio base, as it has full 12.5W POE avalible for fixed basestations, and ulra low power consumption for solar ones.

![Photo of Luckfox Ultra Hats](/static/IMG_3499.jpeg)

## How to Buy

[![PayPal Button](https://www.paypalobjects.com/en_US/i/btn/btn_buynowCC_LG.gif)](https://www.paypal.com/ncp/payment/MPGLQUXB9TF82)

This product is made available via a secure PayPal checkout.

## Porkcube the ledgand

Porkcube developed the config and YAML on the no-longer available Ubuntu based image for the eMMC flash:
  - `Ubuntu_Luckfox_Lyra_Ultra_W_eMMC_250417`

Current version is avalible here:
https://forums.luckfox.com/viewtopic.php?t=1760

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

At the "Meshtasticd Configuration" step, use this command to install the config file:

```
wget -O /etc/meshtasticd/config.d/lyra_ultra_hat_1W.yaml https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main/Luckfox%20Ultra%20Hat/lyra_ultra_hat_1W.yaml
```

Install Config for 2-Watt version:
```
wget -O /etc/meshtasticd/config.d/lyra_ultra_hat_2W.yaml https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main/Luckfox%20Ultra%20Hat/lyra_ultra_hat_2W.yaml
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

