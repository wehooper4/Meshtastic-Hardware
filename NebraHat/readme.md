Lora Hats for use with Raspbery Pi 2-5, the Nebra Outdoor miner, or other SBC's with pi compatable pinouts to convert them to Meshtastic.

Pinout and design inspited by Mark Briss's starter edditon hat:
https://github.com/markbirss/lora-starter-edition-sx1262-i2c

**Dont sell these without working out something with me first.** Any derivitives shall be at least open scamatic.

**1 Watt Hat**
* 1 Watt E22 900mhz Lora radio with TXCO and LNA
* SMA support

**2 Watt Hat**
* 2 Watt E22 900mhz radio with TXCO and LNA
* 5v power rail filtering
* 915mhz bandpass filter
* Lightning/ESD protection
* Temperature/Humidity Sensor
* RX/TX indicator LED's
* external RX/TX indicator header support

![Photo of 2w Nebra Hats](/static/IMG_2807.jpeg)

If you wish to keep the original USB hub for wifi or other uses, you can assembel this with extended stacking headers

![Photo of Nebra Hat in Nebra](/static/IMG_2808.jpeg)
![Photo of Nebra Hat in Nebra with hub](/static/IMG_2809.jpeg)

Install config for standard hat:
```
wget –O /etc/meshtasticd/config.d/ https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main/NebraHat/NebraHat_1W.yaml
```

Install Config for 2Watt version:
```
wget –O /etc/meshtasticd/config.d/ https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main/NebraHat/NebraHat_2W.yaml
```

