#!/bin/bash
# GPS Splitter and Time Node Deployment Script (V2 - Clean Architecture)
# Configures Direct PPS, Stratum-1 NTP, and Virtual Serial Ports for Meshtastic/MeshCore
# Note: config.txt hardware configs assumed already baked into base Trixie image.

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo bash deploy-node.sh)"
  exit
fi

echo "=== 1. Installing Prerequisites ==="
apt-get update
apt-get install -y gpsd gpsd-clients chrony socat pps-tools

echo "=== 2. System & Port Prep ==="
# Kill rogue login prompts on the hardware UART that fight gpsd for the port
systemctl stop serial-getty@ttyAMA0.service 2>/dev/null
systemctl disable serial-getty@ttyAMA0.service 2>/dev/null

# Fix Debian 13 privilege drop so the gpsd user can read the serial port
usermod -aG dialout gpsd

# Disable Bluetooth UART just to ensure no contention
systemctl disable hciuart 2>/dev/null || true

echo "=== 3. Configuring gpsd ==="
# Point directly at the verified Pi 5 hardware pins
cat << 'EOF' > /etc/default/gpsd
START_DAEMON="true"
USBAUTO="false"
DEVICES="/dev/ttyAMA0"
GPSD_OPTIONS="-n"
EOF

echo "=== 4. Configuring Chrony (NTP & RTC) ==="
CHRONY_CONF="/etc/chrony/chrony.conf"

# Backup original config
cp "$CHRONY_CONF" "${CHRONY_CONF}.bak"

# 1. Add NMEA (via gpsd SHM) for the base second
# 2. Add Direct PPS for the microsecond tick
# 3. Add rtcsync to discipline the Pi 5 hardware RTC
sed -i '1s/^/refclock SHM 0 refid NMEA offset 0.200 precision 1e-3\nrefclock PPS \/dev\/pps0 refid PPS precision 1e-7 prefer\nrtcsync\n\n/' "$CHRONY_CONF"

# Allow local mesh network queries
grep -qF "allow 10.0.0.0/8" "$CHRONY_CONF" || cat << 'EOF' >> "$CHRONY_CONF"

# Allow all standard private network IP ranges
allow 10.0.0.0/8
allow 172.16.0.0/12
allow 192.168.0.0/16
EOF

echo "=== 5. Creating Virtual GPS Ports ==="
# These provide the fake serial ports for Meshtasticd
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

echo "=== 6. Reloading and Enabling Services ==="
systemctl daemon-reload

# Enable native socket activation and restart services
systemctl enable gpsd.socket
systemctl start gpsd.socket
systemctl restart gpsd.service
systemctl restart chrony.service

# Spin up the virtual ports
systemctl enable virtual-gps@1 virtual-gps@2 virtual-gps@3
systemctl start virtual-gps@1 virtual-gps@2 virtual-gps@3

echo "=== DEPLOYMENT COMPLETE ==="
echo "Check cgps -s to verify satellite lock."
echo "Check chronyc sources -v to verify the #* PPS lock."
