#!/bin/sh
# pandora_modeswitch.sh - Safely switch AIC8800D80 "Pandora" clone (1111:1111) to operational mode.
# Finds the device by VID/PID/product itself (no shell interpolation needed).
set -eu

MODESWITCH=""
for candidate in /usr/sbin/usb_modeswitch /usr/bin/usb_modeswitch /bin/usb_modeswitch; do
    [ -x "$candidate" ] && MODESWITCH="$candidate" && break
done

[ -z "$MODESWITCH" ] && { echo "usb_modeswitch not found" >&2; exit 1; }

CONFIG="/etc/usb_modeswitch.d/1111:1111"
[ -f "$CONFIG" ] || { echo "Config $CONFIG not found" >&2; exit 1; }

# Find the matching device in sysfs (VID=1111, PID=1111, product=88M80*)
for devpath in /sys/bus/usb/devices/*; do
    [ -r "$devpath/idVendor" ] || continue
    [ "$(cat "$devpath/idVendor" 2>/dev/null)" = "1111" ] || continue
    [ "$(cat "$devpath/idProduct" 2>/dev/null)" = "1111" ] || continue
    product=$(cat "$devpath/product" 2>/dev/null)
    case "$product" in 88M80*) ;; *) continue ;; esac
    busnum=$(cat "$devpath/busnum" 2>/dev/null)
    devnum=$(cat "$devpath/devnum" 2>/dev/null)
    case "$busnum" in *[!0-9]*) continue ;; esac
    case "$devnum" in *[!0-9]*) continue ;; esac
    exec "$MODESWITCH" -b "$busnum" -g "$devnum" -c "$CONFIG"
done

echo "No matching Pandora device found" >&2
exit 0
