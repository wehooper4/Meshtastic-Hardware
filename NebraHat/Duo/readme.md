# Nebra Duo Hat: 915MHz Dual LoRa Radio Development Board for Nebra (or other pi's)



## Nebra Outdoor Miner CS1 Enable

The Nebra outdoor miner is missing a wire to enable the second SPI device on the primary spi bus. To use this hat with a Nebra outdoor miner, a minior modfication is needed.

Run a wire as shown below on the bottom of the motherboard.

![Bodge Wire](/static/nebra_bodge.png)

## Versions 

### Nebra Duo

* E22P-915M30S 1W SX1262 filtered radio on SPI0.0
* E80-xxxxxxx LR1121 dual band radio on SPI0.1
* SHT20 Temperature and Humidity Sensor
* GPS Header (PPS on GPIO4)

### Nebra Duo Pro

* E22P-915M30S 1W SX1262 filtered Primary Radio on SPI0.0 w/MMCX connector
* E22P-915M30S 1W SX1262 filtered Primary Radio on SPI0.1 w/MMCX connector
* SHT20 Temperature and Humidity Sensor
* GPS Header (PPS on GPIO4)
* Dual Stage Lightning protection - 300V 0.5 KA gas tube + 1000v DC Blocking cap + 18V 4A 8/20us foldback technology TVS diode
* Ground Bounce Protection (power rail TVS diodes + GPIO resistors)

On this version, atttaching a ground lug between the board and the metal housing is REQUIRED, otherwise the lightning protection will not work.

The onboard lightning protection is targeted at antennas ether directly mounted on the housing or attached via very short coax runs (1M or less) with little opertunity for ground potential differances. The onboard gas tubes are TINY, and not sutible for situations with longer coax runs. In the case of long runs, external protection devices are required at the enclosure entrace. These must be sequanced so they fire before the onboard gas tubes in order to actuall protect the device. Please use a 75v or 90v tube with a maximum impulse spark over value of 700v or less.

## OG Nebra Duo Configuration

At the "Meshtasticd Configuration" step, use this command to install the config file:

```
wget -O /etc/meshtasticd/config.d/NebraHat_Duo_E22P.yaml https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main/NebraHat/Duo/NebraHat_Duo_E22P.yaml
```


```
wget -O /etc/meshtasticd/config.d/NebraHat_Duo_E80.yaml https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main/NebraHat/Duo/NebraHat_Duo_E80.yaml
```

## Nebra Duo Pro Configuration

Recomended configuration is Meshtastic + Meshtastic, or Meshtastic + pyMC

```
wget -O /etc/meshtasticd/config.d/NebraHat_Duo_E22P.yaml https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main/NebraHat/Duo/NebraHat_Duo_E22P.yaml
```
