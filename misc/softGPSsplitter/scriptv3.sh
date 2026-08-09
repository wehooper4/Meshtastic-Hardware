#!/bin/bash
# GPS Splitter and Time Node Deployment Script (V3)
# =================================================
# V3 supersedes scriptv2.sh ("Clean Architecture") by ADDING full multi-constellation
# satellite visibility. Instead of only a minimal GPS subset, the receiver is told
# (via MediaTek PMTK commands) to emit GPS/BeiDou/GLONASS/Galileo GSV+GSA sentence
# streams, and a gps-skyview systemd logger continuously writes every satellite in
# view with its signal level to /tmp/skyview.log.
#
# Everything else matches v2 semantics: Direct PPS, Stratum-1 NTP, Virtual Serial
# Ports for Meshtastic/MeshCore.
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

echo "=== 4. Unlock full satellite visibility on the receiver (NEW in V3) ==="
# The default receiver output may only emit a minimal GPS subset. Send MediaTek PMTK
# commands to the ATGM336H/AT6558 (and compatible) to request ALL satellites:
#   - PMTK314  : output sentence mask (GGA, GSA, GSV=all constellations, RMC, VTG, ZDA)
#   - PMTK220  : 1 Hz update rate
#   - PMTK353  : enable GPS + BeiDou + GLONASS + Galileo tracking
if [ -c /dev/ttyAMA0 ]; then
  stty -F /dev/ttyAMA0 9600 raw 2>/dev/null || true
  printf '$PMTK314,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0*34\r\n' > /dev/ttyAMA0
  printf '$PMTK220,1000*1F\r\n' > /dev/ttyAMA0
  printf '$PMTK353,1,1,1,1,0,0,0,0,0,0*37\r\n' > /dev/ttyAMA0
  echo "   PMTK satellite-visibility enabled on /dev/ttyAMA0"
else
  echo "   WARN: /dev/ttyAMA0 not present (hardware UART not enabled?) — PMTK skipped."
fi

echo "=== 5. Configuring Chrony (NTP & RTC) ==="
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

echo "=== 6. Creating Virtual GPS Ports ==="
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

echo "=== 7. Satellite skyview logger (NEW in V3) ==="
# Continuously stream ALL raw NMEA (incl. every GSV/GSA satellite report) to
# /tmp/skyview.log so you can see every satellite in view and its signal level.
cat << 'EOF' > /etc/systemd/system/gps-skyview.service
[Unit]
Description=GPS full-satellite skyview logger
After=gpsd.service
Requires=gpsd.service

[Service]
Type=simple
ExecStart=/bin/sh -c '/usr/bin/gpspipe -r -n 0 | /usr/bin/tee /tmp/skyview.log'
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "=== 8. Reloading and Enabling Services ==="
systemctl daemon-reload

# Enable native socket activation and restart services
systemctl enable gpsd.socket
systemctl start gpsd.socket
systemctl restart gpsd.service
systemctl restart chrony.service

# Spin up the virtual ports
systemctl enable virtual-gps@1 virtual-gps@2 virtual-gps@3
systemctl start virtual-gps@1 virtual-gps@2 virtual-gps@3

# Spin up the satellite skyview logger
systemctl enable gps-skyview.service
systemctl start gps-skyview.service

echo "=== DEPLOYMENT COMPLETE ==="
echo "Check cgps -s to verify satellite lock."
echo "Check chronyc sources -v to verify the #* PPS lock."
echo "ALL SATELLITES: tail -f /tmp/skyview.log   (GSV/GSA for GPS+BDS+GLONASS+Galileo)"