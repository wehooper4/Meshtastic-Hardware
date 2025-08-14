Information for using the stock USB stick in the nebra as an AP. this lets you admin the thing on the top of towers from your phone. Capatave portal to the software of your choice (ie Meshtastic) as well.

## Load driver

```
wget -O https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main/NebraHat/nebraAP/rtl8188eus_1.0-1_arm64.deb ~/rtl8188eus_1.0-1_arm64.deb

sudo dpkg -i ~/rtl8188eus_1.0-1_arm64.deb
```

## Blacklist old driver
```
echo "blacklist rtl8xxxu" | sudo tee /etc/modprobe.d/rtl8xxxu.conf
sudo dpkg -i rtl8188eus_1.0-1_arm64.deb
sudo modprobe 8188eu
sudo reboot
...after reboot
basename $(readlink /sys/class/net/wlan0/device/driver)
...should display 8188eu
```
