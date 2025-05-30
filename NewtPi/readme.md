Two Watt Pi Hat for Meshtastic usage

* E22-900M33S Radio Module with 33dbm PA and LNA
* High sensitivity ATGM336H GNSS for positioning and timing
* QWIIC connectors for I2C sensors
* Filtered power supply
* Provisions for SMA connector for LORA radio
* DC Fan Outout
* PWM Fan Output
* DC Power in/out header

WARMING: Power limit MUST be set in YAML to prevent PA damage.

Instalation: https://meshtastic.org/docs/hardware/devices/linux-native-hardware/

At step "Meshtasticd Configuration" use this command to install config file:
```
wget –O /etc/meshtasticd/config.d/ https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main//NewtPi/NewtPi-2w.yaml
```

*GPS info:*

GPS on /dev/ttyAMA0 or /dev/ttyS0

PPS on GPIO 4



*Fan info:*

DC fan enable: GPIO 17 (high enable)

PWM fan speed control: GPIO 18
