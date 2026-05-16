#!/bin/bash

LOCK_IMG=/tmp/lockscreen.png
LAYOUT=$(xkb-switch)

# i3lock (plain)
# i3lock -i /home/nad/pictures/wallpapers/xcx2.jpg

# Take screenshot and blur it, then lock over it
maim "$LOCK_IMG"
convert "$LOCK_IMG" -blur 0x8 "$LOCK_IMG"

i3lock \
    --image="$LOCK_IMG" \
    --indicator \
    --radius=120 \
    --ring-width=6 \
    --ring-color=2c1f0eff \
    --inside-color=2c1f0ecc \
    --line-color=d4bfa0ff \
    --keyhl-color=d4bfa0ff \
    --bshl-color=a07850ff \
    --separator-color=d4bfa0ff \
    --verif-color=f0c060ff \
    --wrong-color=c04030ff \
    --ringver-color=d4bfa0ff \
    --insidever-color=2c1f0ecc \
    --ringwrong-color=c04030ff \
    --insidewrong-color=2c1f0ecc \
    --verif-text="..." \
    --wrong-text="wrong" \
    --clock \
    --time-str="%H:%M" \
    --date-str="%A, %d %B" \
    --greeter-text="$LAYOUT" \
    --greeter-color=d4bfa0ff \
    --greeter-pos="ix:iy+65" \
    --greeter-size=20 \
    --time-color=e8d5b0ff \
    --date-color=d4bfa0ff \
    --time-pos="ix:iy-20" \
    --date-pos="ix:iy+30" \
    --time-size=52 \
    --date-size=24
