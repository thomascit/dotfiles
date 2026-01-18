#!/bin/sh
# Simple i3lock script using standard i3lock (not i3lock-color)
# Scales wallpaper to screen resolution before locking

WALLPAPER="$HOME/.local/share/wallpaper/wp.png"
LOCKSCREEN="/tmp/lockscreen.png"

# Get screen resolution
RESOLUTION=$(xdpyinfo | grep dimensions | awk '{print $2}')

# Scale wallpaper to fit screen resolution (requires imagemagick)
if command -v convert >/dev/null 2>&1; then
    convert "$WALLPAPER" -resize "$RESOLUTION^" -gravity center -extent "$RESOLUTION" "$LOCKSCREEN"
    i3lock -i "$LOCKSCREEN"
else
    # Fallback to solid color if imagemagick not installed
    i3lock -c 282A36
fi
