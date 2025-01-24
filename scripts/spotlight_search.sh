#!/bin/bash

# Add debug mode
set -x

# Get screen dimensions with fallback values
SCREEN_WIDTH=$(xdotool getdisplaygeometry 2>/dev/null | awk '{print $1}') || SCREEN_WIDTH=1920
SCREEN_HEIGHT=$(xdotool getdisplaygeometry 2>/dev/null | awk '{print $2}') || SCREEN_HEIGHT=1080


# Define favorite applications
FAVORITES="brave
code
cursor
sublime
slack
alacritty
postman
"

# Get list of applications (handling spaces in names)
APPS=$(find /usr/share/applications ~/.local/share/applications -name "*.desktop" -exec sh -c 'basename "$1" .desktop' sh {} \; 2>/dev/null)

# Combine lists keeping favorites at top
ALL_ITEMS=$(echo "${FAVORITES}"; echo "${APPS}" | sort -u | grep -vF "${FAVORITES}")

# Use rofi for input with auto-completion
INPUT=$(echo "$ALL_ITEMS" | rofi -dmenu \
    -theme-str 'window {width: 500px; height: 300px; border-radius: 8px;}' \
    -theme-str 'element {padding: 5px;}' \
    -theme-str 'element selected {background-color: #2f2f2f;}' \
    -theme-str 'inputbar {padding: 5px; children: [entry, close-button];}' \
    -theme-str 'entry {padding: 5px; placeholder: "Spotlight Search"; blink: false;}' \
    -theme-str 'close-button {padding: 5px; action: "kb-cancel"; str: ""; }' \
    -theme-str 'mainbox {children: [inputbar, listview];}' \
    -theme-str 'listview {scrollbar: false; dynamic: true; lines: 5;}' \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -matching normal \
    -sort false \
    -sorting-method fzf \
    -location 0 \
    -hover-select \
    -me-select-entry "" \
    -me-accept-entry "MousePrimary") || exit 1

# Debug output
echo "Selected input: $INPUT" >&2

# Check if input is not empty and dialog wasn't cancelled
if [ -n "${INPUT}" ]; then
    # Check if it's a .desktop file (application)
    app_path=$(find /usr/share/applications ~/.local/share/applications -type f -name "*${INPUT}*.desktop" 2>/dev/null | head -n 1)
    
    # Debug output
    echo "Found app path: $app_path" >&2
    
    if [ -n "${app_path}" ] && which xdg-open > /dev/null; then
        # Get the window class from the .desktop file
        window_class=$(grep -i "^StartupWMClass" "${app_path}" | cut -d= -f2)
        
        # If no window class specified, use the app name
        if [ -z "${window_class}" ]; then
            window_class="${INPUT}"
        fi
        
        # Try to focus existing window
        if wmctrl -x -a "${window_class}" 2>/dev/null; then
            echo "Focused existing window for ${window_class}" >&2
        else
            # Launch new instance if no existing window found
            gtk-launch "$(basename "${app_path}" .desktop)" || notify-send "Error" "Failed to launch ${INPUT}"
        fi
    else
        # If it's not an app, launch web search directly
        nohup brave --new-tab "https://www.google.com/search?q=${INPUT}" >/dev/null 2>&1 &
    fi
fi

exit  s#!/bin/bash

# Get screen dimensions with fallback values
SCREEN_WIDTH=$(xdotool getdisplaygeometry 2>/dev/null | awk '{print $1}') || SCREEN_WIDTH=1920
SCREEN_HEIGHT=$(xdotool getdisplaygeometry 2>/dev/null | awk '{print $2}') || SCREEN_HEIGHT=1080

# Define favorite applications
FAVORITES="brave
code
gnome-terminal
firefox
nautilus"

# Get list of applications (handling spaces in names)
APPS=$(find /usr/share/applications -name "*.desktop" -exec sh -c 'basename "$1" .desktop' sh {} \;)

# Combine lists keeping favorites at top
ALL_ITEMS=$(echo "${FAVORITES}"; echo "${APPS}" | sort -u | grep -vF "${FAVORITES}")

# Use rofi for input with auto-completion
INPUT=$(echo "$ALL_ITEMS" | rofi -dmenu \
    -theme-str 'window {width: 500px; height: 300px; border-radius: 8px;}' \
    -theme-str 'element {padding: 5px;}' \
    -theme-str 'element selected {background-color: #2f2f2f;}' \
    -theme-str 'inputbar {padding: 5px; children: [entry, close-button];}' \
    -theme-str 'entry {padding: 5px; placeholder: "Spotlight Search"; blink: false;}' \
    -theme-str 'close-button {padding: 5px; action: "kb-cancel"; str: ""; }' \
    -theme-str 'mainbox {children: [inputbar, listview];}' \
    -theme-str 'listview {scrollbar: false; dynamic: true; lines: 5;}' \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -matching normal \
    -sort false \
    -sorting-method fzf \
    -location 0 \
    -hover-select \
    -me-select-entry "" \
    -me-accept-entry "MousePrimary")

# Check if input is not empty and dialog wasn't cancelled
if [ -n "${INPUT}" ]; then
    # Check if it's a .desktop file (application)
    app_path=$(find /usr/share/applications -type f -name "*${INPUT}*.desktop" 2>/dev/null | head -n 1)
    if [ -n "${app_path}" ] && which xdg-open > /dev/null; then
        gtk-launch "$(basename "${app_path}" .desktop)" || notify-send "Error" "Failed to launch ${INPUT}"
        # notify-send "Launching application" "${INPUT}"
    else
        # If it's not an app, search in Brave
        nohup brave --new-tab "https://www.google.com/search?q=${INPUT}" >/dev/null 2>&1 &
        # notify-send "Searching web" "${INPUT}"
    fi
fi

exit 0