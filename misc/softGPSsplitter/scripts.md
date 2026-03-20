#!/bin/bash
# N4LMC Master Node Deployment Script
# Configures PPS GPS, Stratum-1 NTP, and Virtual Serial Ports for Meshtastic/MeshCore

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo bash deploy-node.sh)"
  exit
fi

echo "=== 1. Installing Prerequisites ==="
apt-get update
apt-get install -y gpsd gpsd-clients chrony socat pps-tools

echo "=== 2. Configuring Hardware (PPS & UART) ==="
# Find the right boot config file depending on Debian version
BOOT_CONF="/boot/firmware/config.txt"
if [ ! -f "$BOOT_CONF" ]; then
    BOOT_CONF="/boot/config.txt"
fi

grep -qF "dtoverlay=pps-gpio,gpiopin=4" "$BOOT_CONF" || echo "dtoverlay=pps-gpio,gpiopin=4" >> "$BOOT_CONF"
grep -qF "dtoverlay=disable-bt" "$BOOT_CONF" || echo "dtoverlay=disable-bt" >> "$BOOT_CONF"
systemctl disable hciuart

echo "=== 3. Configuring gpsd ==="
cat << 'EOF' > /etc/default/gpsd
START_DAEMON="true"
USBAUTO="false"
DEVICES="/dev/ttyAMA0 /dev/pps0"
GPSD_OPTIONS="-n"
EOF

echo "=== 4. Applying Systemd Overrides for gpsd ==="
systemctl unmask gpsd.socket
systemctl stop gpsd.socket gpsd.service
systemctl disable gpsd.socket

mkdir -p /etc/systemd/system/gpsd.service.d
cat << 'EOF' > /etc/systemd/system/gpsd.service.d/override.conf
[Unit]
Requires=
After=network.target

[Service]
Type=simple
ExecStart=
ExecStart=/usr/sbin/gpsd -N -n /dev/ttyAMA0 /dev/pps0
EOF

echo "=== 5. Configuring Chrony (NTP Server) ==="
CHRONY_CONF="/etc/chrony/chrony.conf"
grep -qF "refclock SHM 0" "$CHRONY_CONF" || sed -i '1s/^/refclock SHM 0 refid NMEA offset 0.200 precision 1e-3\nrefclock SHM 1 refid PPS precision 1e-7 prefer\n\n/' "$CHRONY_CONF"

grep -qF "allow 10.0.0.0/8" "$CHRONY_CONF" || cat << 'EOF' >> "$CHRONY_CONF"

# Allow all standard private network IP ranges
allow 10.0.0.0/8
allow 172.16.0.0/12
allow 192.168.0.0/16
EOF

echo "=== 6. Creating Virtual GPS Ports ==="
cat << 'EOF' > /etc/systemd/system/virtual-gps@.service
[Unit]
Description=Virtual GPS Port %I
After=gpsd.service
Requires=gpsd.service

[Service]
Type=simple
ExecStart=/bin/sh -c '/usr/bin/gpspipe -r | /usr/bin/socat - PTY,link=/tmp/vGPS%i,raw,echo=0,mode=666'
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "=== 7. Reloading and Enabling Services ==="
systemctl daemon-reload
systemctl enable gpsd.service
systemctl enable virtual-gps@1
systemctl enable virtual-gps@2
systemctl enable virtual-gps@3

echo "=== DEPLOYMENT COMPLETE ==="
echo "Please REBOOT the Pi to apply the hardware bootloader changes."
echo "After reboot, check /tmp/vGPS1 to confirm data flow."
