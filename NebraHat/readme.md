This is a hat for outdoor Nebra Miners or standard Paspbary Pi's for Meshtastic. Filter is optional, but recomended. It covers spread factors between Medium Slow and Short Fast well, and can still operate on longfast.

Pinout and design inspited by Mark Briss's starter edditon hat:
https://github.com/markbirss/lora-starter-edition-sx1262-i2c

Dont sell these without working out something with me first. Any derviitves shall be at least open scamatic.

Install config for standard hat:
```
wget –O /etc/meshtasticd/config.d/ https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main/NebraHat/NebraHat_1W.yaml
```

Install Config for 2Watt version:
```
wget –O /etc/meshtasticd/config.d/ https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main/NebraHat/NebraHat_2W.yaml
```

