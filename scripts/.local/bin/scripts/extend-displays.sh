#!/usr/bin/env bash
LAPTOP=$(xrandr | awk '/^[^ ]+ connected/ { cur=$1; found=0 } /^ / && cur && !found { if ($1=="1920x1080") print cur; found=1 }' | head -1)
EXTERNAL=$(xrandr | awk '/^[^ ]+ connected/ { cur=$1; found=0 } /^ / && cur && !found { if ($1=="2560x1440") print cur; found=1 }' | head -1)

xrandr --output "$EXTERNAL" --mode 2560x1440 --rate 143.97 --primary --output "$LAPTOP" --mode 1920x1080 --rate 300 --right-of "$EXTERNAL"
