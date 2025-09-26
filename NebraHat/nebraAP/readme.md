Information for using the stock USB stick in the nebra as an AP. this lets you admin the thing on the top of towers from your phone. Capatave portal to the software of your choice (ie Meshtastic) as well.

## Load driver

```
wget -O ~/rtl8188eus_1.0-1_arm64.deb https://github.com/wehooper4/Meshtastic-Hardware/raw/refs/heads/main/NebraHat/nebraAP/rtl8188eus_1.0-1_arm64.deb

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
## Make an AP
```
# Configuration Variables
AP_SSID="mesh-admin"
AP_PASS="meshtastic"
AP_CON_NAME="mesh-admin-ap"
WIFI_INTERFACE="wlan0"
WIFI_CHANNEL="6"
WIFI_BAND="bg"

# Create the file (using 'tee' for sudo permission to write to a file)
sudo tee setup_pi_ap.sh > /dev/null << 'EOF'
#!/bin/bash
echo "--- Starting Raspberry Pi AP Setup Script ---"

# 1. Install required packages
echo "1. Installing 'hostapd' (required by NetworkManager for AP mode)..."
sudo apt update -y
sudo apt install hostapd -y

# Check if hostapd is installed but disable/stop it, as NetworkManager will manage it
if sudo systemctl is-enabled --quiet hostapd; then
    echo "   Stopping and disabling standalone hostapd service."
    sudo systemctl stop hostapd
    sudo systemctl disable hostapd
fi

# 2. Restart NetworkManager
echo "2. Restarting NetworkManager to load new components."
sudo systemctl restart NetworkManager
sleep 5

# 3. Clean up any existing conflicting connection profile
echo "3. Deleting old profile if it exists to ensure a clean setup."
sudo nmcli connection delete "${AP_CON_NAME}" 2>/dev/null

# 4. Create the new, stable AP connection profile
echo "4. Creating new AP connection profile: ${AP_CON_NAME} (${AP_SSID})."
sudo nmcli connection add \
    type wifi \
    ifname "${WIFI_INTERFACE}" \
    con-name "${AP_CON_NAME}" \
    ssid "${AP_SSID}" \
    mode ap \
    ipv4.method shared \
    wifi.band "${WIFI_BAND}" \
    wifi.channel "${WIFI_CHANNEL}" \
    wifi-sec.key-mgmt wpa-psk \
    wifi-sec.psk "${AP_PASS}"

# Check for connection creation success
if [ $? -ne 0 ]; then
    echo "❌ ERROR: Failed to create the NetworkManager connection profile. Exiting."
    exit 1
fi

# 5. Activate the hotspot connection
echo "5. Activating the hotspot..."
sudo nmcli connection up "${AP_CON_NAME}"

# 6. Check activation status
if [ $? -eq 0 ]; then
    echo "--------------------------------------------------------"
    echo "✅ Success! Hotspot '${AP_SSID}' is now active."
    echo "   Password: ${AP_PASS}"
    echo "--------------------------------------------------------"
else
    echo "--------------------------------------------------------"
    echo "❌ Failure! Hotspot activation failed."
    echo "   Check logs with: journalctl -xe | grep NetworkManager"
    echo "--------------------------------------------------------"
fi
EOF

# Make the file executable and run it
echo "--- Making script executable and running it. ---"
chmod +x setup_pi_ap.sh && sudo ./setup_pi_ap.sh
```
## Dualband Upgrade

Info here for "better" alternive USB sticks.

https://github.com/morrownr/USB-WiFi/blob/main/home/USB_WiFi_Adapters_that_are_supported_with_Linux_in-kernel_drivers.md#ac580--ac600--ac650---usb-2---24-ghz-and-5-ghz-wifi-5
