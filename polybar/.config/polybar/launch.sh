#!/usr/bin/env bash
killall -q polybar
while pgrep -u $UID -x polybar > /dev/null; do sleep 0.1; done

xrandr | awk '/connected [0-9]/ {print $1}' | while read -r monitor; do
    MONITOR=$monitor polybar main &
done
