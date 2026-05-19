#!/usr/bin/env bash
killall -q polybar
while pgrep -u $UID -x polybar > /dev/null; do sleep 0.1; done

if [[ -z "${POLYBAR_MODULES_RIGHT:-}" ]] && ls /sys/class/power_supply/BAT* &>/dev/null; then
    export POLYBAR_MODULES_RIGHT="volume battery"
elif [[ -z "${POLYBAR_MODULES_RIGHT:-}" ]]; then
    export POLYBAR_MODULES_RIGHT="volume"
fi

# Match lines with "connected" and a resolution (e.g. 2560x1440+0+0), skipping
# outputs that are connected but inactive (no resolution in the line).
xrandr | awk '/connected/ && /[0-9]+x[0-9]+\+/ {print $1}' | while read -r monitor; do
    MONITOR=$monitor polybar main &
done
