#!/bin/bash
# Automatic monitor detection and setup for i3
# Sets all connected monitors to their preferred resolution

# Get all connected displays and set them to auto (preferred resolution)
xrandr | grep " connected" | awk '{print $1}' | while read output; do
    xrandr --output "$output" --auto
done
