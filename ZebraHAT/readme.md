New PI and Nebra hat

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
ZebraHAT/ZebraHat.yaml

sudo wget -O /etc/meshtasticd/config.d/ZebraHat.yaml https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main/ZebraHAT/ZebraHat.yaml
