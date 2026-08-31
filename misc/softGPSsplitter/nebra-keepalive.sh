#!/usr/bin/env bash
#===============================================================================
# nebra-keepalive.sh
#
# Bulletproof remote-access keepalive for Nebra/HAT-style CM3 LoRa towers.
# Reboots the box ONLY if it would otherwise strand you — no site visit needed.
#
# PURPOSE
#   These towers run headless on cell/LAN with two ways for YOU to reach them:
#     * Tailscale  (remote SSH/management mesh)
#     * Pi Connect (Raspberry Pi OOB remote shell)
#   If BOTH die and stay dead, you have no way back in short of driving out.
#   This watchdog detects that and self-heals with a reboot.
#
# DESIGN PRINCIPLES (do NOT violate):
#   1. NEVER reboot for a mere network outage. A tower may be offline and must
#      keep doing its LoRa/mesh job. Only reboot when remote ACCESS is lost.
#   2. Reboot only when BOTH remote-access paths are down, CONSECUTIVELY, for a
#      sustained window (default 8-12 h) — so transients/GPS/chrony stalls never
#      false-trip it.
#   3. Pair with the CM3 HARDWARE watchdog (systemd RuntimeWatchdogSec) which
#      catches a true kernel hang in ~1 min. This script is the slow, careful
#      layer for "box is up but you can't get in" — the exact failure a hardware
#      watchdog can't see.
#
# USAGE
#   Install script + systemd timer/service (examples at bottom / see README):
#     /usr/local/sbin/nebra-keepalive.sh     (this file)
#     /etc/systemd/system/nebra-keepalive.service
#     /etc/systemd/system/nebra-keepalive.timer   (OnCalendar=*:0/10)
#   Overrides via /etc/nebra-keepalive.conf:
#     WINDOW_HOURS=8     # sustained both-down window before reboot
#     CHECK_MIN=10       # timer interval
#
# AUTHORS: Floodwave Systems / wehooper4
# LICENSE: MIT
#===============================================================================
set -u

STATE=/var/lib/nebra-keepalive/count
CONF=/etc/nebra-keepalive.conf
WINDOW_HOURS=${WINDOW_HOURS:-8}        # sustained both-down before reboot (8-12)
CHECK_MIN=${CHECK_MIN:-10}             # systemd timer interval
[ -f "$CONF" ] && . "$CONF"
mkdir -p "$(dirname "$STATE")"

log(){ logger -t nebra-keepalive "$@"; }

#--- 1) Is Tailscale reachable? -----------------------------------------------
# tailscaled active + tailscale CLI can see our own node (robust even when the
# tun iface reports UNKNOWN, which is normal on headless after `tailscale up`).
ts_up=0
if systemctl is-active tailscaled >/dev/null 2>&1; then
  if timeout 8 /usr/bin/tailscale status 2>/dev/null | grep -qE "100\." ||
     timeout 8 /usr/bin/tailscale ip     2>/dev/null | grep -qE "100\."; then
    ts_up=1
  fi
fi

#--- 2) Is Pi Connect reachable? == signed in ---------------------------------
pc_up=0
if timeout 8 rpi-connect status 2>/dev/null | grep -qi "Signed in: yes"; then
  pc_up=1
fi

#--- Any single remote-access path up => box is reachable, reset counter -------
if [ "$ts_up" = 1 ] || [ "$pc_up" = 1 ]; then
  rm -f "$STATE" 2>/dev/null
  exit 0
fi

#--- BOTH down: start/advance the sustained counter ---------------------------
[ -f "$STATE" ] || { echo 0 > "$STATE"; exit 0; }
count=$(cat "$STATE")
count=$((count+1))
echo "$count" > "$STATE"

needed=$(( WINDOW_HOURS * 60 / CHECK_MIN ))
log "Tailscale+PiConnect both down (hit $count/$needed)"
if [ "$count" -ge "$needed" ]; then
  log "Remote access lost for ${WINDOW_HOURS}h - rebooting to self-heal"
  sync
  systemctl reboot --no-block 2>/dev/null || true
fi
exit 0

#===============================================================================
# SYSTEMD UNITS (install these alongside the script)
#===============================================================================
# nebra-keepalive.service
#-----------------------------
#[Unit]
#Description=Nebra remote-access keepalive - reboot if Tailscale+PiConnect both dead
#After=network-online.target
#
#[Service]
#Type=oneshot
#ExecStart=/usr/local/sbin/nebra-keepalive.sh
#TimeoutStartSec=60
#TimeoutStopSec=90
#User=root
#
#[Install]
#WantedBy=multi-user.target
#
# nebra-keepalive.timer
#-----------------------------
#[Unit]
#Description=Nebra keepalive check timer (every 10 min)
#
#[Timer]
#OnCalendar=*:0/10
#OnBootSec=2min
#RandomizedDelaySec=1min
#Persistent=true
#
#[Install]
#WantedBy=timers.target
#
# Install:
#   sudo install -m755 nebra-keepalive.sh /usr/local/sbin/
#   sudo cp nebra-keepalive.{service,timer} /etc/systemd/system/
#   sudo systemctl daemon-reload
#   sudo systemctl enable --now nebra-keepalive.timer
#================================================================================