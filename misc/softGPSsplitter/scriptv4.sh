#!/bin/bash
# GPS Splitter and Time Node Deployment Script (V4)
# =================================================
# V4 fixes two bugs found in V3 during field validation on SASS2 (2026-08):
#
#   1. gpsd MUST run with -b (readonly). Without -b, gpsd's u-blox driver writes
#      config to the ATGM336H/AT6558 and flips a clean-NMEA module into UBX-binary,
#      which KILLS the NMEA/GSV feed (meshtasticd then reports "No GNSS Module").
#   2. PMTK commands do NOTHING on the ATGM336H (MediaTek message sniffing confirms
#      the module ignores $PMTK...). Satellite visibility is enabled the correct way:
#      a volatile u-blox CSG-MSG to emit GSV (0xf0 0x03), applied via pyserial while
#      gpsd is stopped — never written to flash (avoids the baud-corruption brick).
#
# Also: PPS is OPTIONAL. These tower boards have no PPS pin; the PPS refclock is only
#       added if /dev/pps0 exists. gpsd DEVICES lists just ttyAMA0 (+ pps0 when present).
#
# Everything else matches v3: Stratum-1 NTP over NMEA, Virtual Serial Ports for
# Meshtastic/MeshCore, and a gps-skyview logger. May require a REBOOT after run.

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo bash scriptv4.sh)"
  exit 1
fi

echo "=== 1. Installing Prerequisites ==="
apt-get update
apt-get install -y gpsd gpsd-clients chrony socat pps-tools python3 python3-serial 2>/dev/null || \
apt-get install -y gpsd gpsd-clients chrony socat pps-tools python3 2>/dev/null

echo "=== 2. System & Port Prep ==="
# Kill rogue login prompts on the hardware UART that fight gpsd for the port —
# MASK it so it can't come back and re-grab ttyAMA0 after a reboot.
systemctl stop serial-getty@ttyAMA0.service 2>/dev/null
systemctl disable serial-getty@ttyAMA0.service 2>/dev/null
systemctl mask    serial-getty@ttyAMA0.service 2>/dev/null || true

# Fix Debian 13 privilege drop so the gpsd user can read the serial port
usermod -aG dialout gpsd

# Disable Bluetooth UART just to ensure no contention
systemctl disable hciuart 2>/dev/null || true

# Detect PPS (optional — absent on the CM3 tower boards)
PPS_DEV=""
[ -c /dev/pps0 ] && PPS_DEV="/dev/pps0"
echo "   PPS device: ${PPS_DEV:-none (NMEA-only timing)}"
GPSD_DEVICES="/dev/ttyAMA0${PPS_DEV:+ $PPS_DEV}"

echo "=== 3. Configuring gpsd (READONLY -b) ==="
# -b is CRITICAL: never let gpsd reconfigure the ATGM336H. Without it gpsd's u-blox
# driver writes config and flips the module into UBX-binary, killing NMEA/GSV.
cat << 'EOF' > /etc/default/gpsd
START_DAEMON="true"
USBAUTO="false"
DEVICES="__GPSD_DEVICES__"
GPSD_OPTIONS="-n -b"
EOF
sed -i "s|__GPSD_DEVICES__|${GPSD_DEVICES}|" /etc/default/gpsd

echo "=== 4. Enable satellite visibility — volatile GSV (NOT PMTK) ==="
# The ATGM336H IGNORES PMTK. The correct way to get GSV is a volatile u-blox CFG-MSG
# (0x06 0x01) for message 0xf0 0x03 (GSV) on UART1. Volatile only — NO CFG-CFG SAVE,
# so a power-cycle always returns to safe factory NMEA and we never risk the baud-
# corruption that bricks the module.
if [ -c /dev/ttyAMA0 ]; then
  # Free the port from gpsd/socket first so pyserial can own it briefly
  systemctl stop gpsd.service gpsd.socket 2>/dev/null
  systemctl mask gpsd.socket 2>/dev/null || true
  python3 - <<'PYEOF'
import serial, time
try:
    s = serial.Serial('/dev/ttyAMA0', 9600, timeout=1)
except Exception as e:
    print(f"   WARN: could not open ttyAMA0: {e}")
    raise SystemExit(0)
# CFG-MSG (0x06 0x01): enable GSV (0xf0 0x03) rate 1 on UART1.
# payload: [msgClass, msgId, rateOnUSBRate0, rateOnUart1, ..., rateOnUart6]
# NOTE: this is the 7-byte short form used by these modules.
payload = [0x06, 0x01, 0xf0, 0x03, 0, 1, 0, 0, 0, 0, 0]  # 11 bytes incl class/id
# Build UBX frame (class 0x06, id 0x01, len = len(payload)-2)
data = bytes([0xb5, 0x62, 0x06, 0x01, (len(payload)-2) & 0xff, ((len(payload)-2)>>8) & 0xff])
data += bytes(payload[2:])
# CK_A, CK_B
ck_a = ck_b = 0
for b in data[2:]:
    ck_a = (ck_a + b) & 0xff
    ck_b = (ck_b + ck_a) & 0xff
data += bytes([ck_a, ck_b])
s.write(data)
time.sleep(0.5)
s.close()
print("   GSV enable (0xf0 0x03) sent VOLATILE via CFG-MSG")
PYEOF
  systemctl unmask gpsd.socket 2>/dev/null || true
  systemctl start gpsd.socket 2>/dev/null || true
else
  echo "   WARN: /dev/ttyAMA0 not present (hardware UART not enabled?) — GSV skipped."
fi

echo "=== 5. Configuring Chrony (NTP & RTC) ==="
CHRONY_CONF="/etc/chrony/chrony.conf"
cp "$CHRONY_CONF" "${CHRONY_CONF}.bak$(date +%s)" 2>/dev/null || true

# NMEA refclock (via gpsd SHM 0) for the base second.
# PPS refclock ONLY if /dev/pps0 exists (tower boards have none).
if [ -n "$PPS_DEV" ]; then
  sed -i '1s/^/refclock SHM 0 refid NMEA offset 0.200 precision 1e-3\nrefclock PPS \/dev\/pps0 refid PPS precision 1e-7 prefer\nrtcsync\n\n/' "$CHRONY_CONF"
  echo "   chrony: NMEA + PPS refclocks (PPS present)"
else
  sed -i '1s/^/refclock SHM 0 refid NMEA offset 0.200 precision 1e-3\nrtcsync\n\n/' "$CHRONY_CONF"
  echo "   chrony: NMEA-only refclock (no PPS pin)"
fi

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

echo "=== 7. Satellite skyview logger ==="
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

systemctl enable gpsd.socket
systemctl start gpsd.socket
systemctl restart gpsd.service
systemctl restart chrony.service

systemctl enable virtual-gps@1 virtual-gps@2 virtual-gps@3
systemctl start virtual-gps@1 virtual-gps@2 virtual-gps@3

systemctl enable gps-skyview.service
systemctl start gps-skyview.service

echo "=== DEPLOYMENT COMPLETE ==="
echo "Verify gpsd is readonly:  pgrep -af gpsd   (must show -b)"
echo "Check satellite lock:     cgps -s"
echo "Check NTP source:         chronyc sources -v"
echo "ALL SATELLITES:           tail -f /tmp/skyview.log"
echo "NOTE: If the module was previously flipped to UBX-binary by a non -b gpsd,"
echo "      power-cycle the box to return it to factory NMEA, then re-run this script."