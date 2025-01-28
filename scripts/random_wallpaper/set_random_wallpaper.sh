#!/bin/bash

# Start dbus-launch if necessary
if ! pgrep -x "dbus-launch" > /dev/null; then
    eval $(dbus-launch --sh-syntax)
fi

# Set environment variables for X display
export DISPLAY=:0
export XAUTHORITY=/home/manikuttan/.Xauthority

# Directory containing wallpapers
WALLPAPER_DIR="/home/manikuttan/Pictures/wallpapers"

# Choose a random file from the directory
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Check if the WALLPAPER variable is not empty
if [ -z "$WALLPAPER" ]; then
    echo "No wallpapers found in the directory $WALLPAPER_DIR" >> /home/manikuttan/scripts/set_random_wallpaper.log
    exit 1
fi

# Set the wallpaper using gsettings
gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER"

