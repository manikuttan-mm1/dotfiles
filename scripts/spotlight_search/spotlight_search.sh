#!/bin/bash

# Enable debug mode
set -x

# Get screen dimensions with fallback values - using single command with default values
read SCREEN_WIDTH SCREEN_HEIGHT < <(xdotool getdisplaygeometry 2>/dev/null || echo "1920 1080")

# Cache common paths and commands
readonly DESKTOP_PATHS=( "/usr/share/applications" "${HOME}/.local/share/applications" )
readonly CACHE_DIR="${HOME}/.cache/spotlight_search"
mkdir -p "$CACHE_DIR"

# Cache desktop files (refreshed daily)
DESKTOP_CACHE_FILE="${CACHE_DIR}/desktop_files.cache"
if [[ ! -f "$DESKTOP_CACHE_FILE" ]] || [[ $(find "$DESKTOP_CACHE_FILE" -mtime +1) ]]; then
    find "${DESKTOP_PATHS[@]}" -type f -name "*.desktop" 2>/dev/null > "$DESKTOP_CACHE_FILE"
fi
DESKTOP_FILES_CACHE=$(<"$DESKTOP_CACHE_FILE")

# Define favorite applications as an array
FAVORITES=(
    "brave"
    "code" 
    "cursor"
    "sublime"
    "slack"
    "alacritty"
    "postman"
    "calculator"
    "keka-login"  # Added the Keka Login entry
    "chatgpt"
    "HiFx-Wifi"
)
# Adding a custom URL for "Keka Login"
Keka_Login_URL="https://app.keka.com/Account/KekaLogin?returnUrl=/"

# Adding a custom URL for "ChatGPT"
ChatGPT_URL="https://chatgpt.com/"

# Adding a custom URL for "HiFx-Wifi"
HiFx_Wifi_URL="http://192.168.100.1:8090/"

# More efficient icon lookup for favorites
declare -A ICON_CACHE
FAVORITES_WITH_ICONS=""
for fav in "${FAVORITES[@]}"; do
    if [[ -n "${ICON_CACHE[$fav]}" ]]; then
        icon="${ICON_CACHE[$fav]}"
    else
        icon=""
        desktop_patterns=( "${fav}.desktop" "${fav%-*}.desktop" "com.${fav}.${fav^}.desktop" "org.${fav}.${fav^}.desktop" )
        
        for pattern in "${desktop_patterns[@]}"; do
            icon=$(grep -m1 "$pattern" "$DESKTOP_CACHE_FILE" | xargs grep -m1 "^Icon=" 2>/dev/null | cut -d= -f2-)
            [ -n "$icon" ] && break
        done

        # Fallback icon mapping
        if [ -z "$icon" ]; then
            case "$fav" in
                "brave") icon="/home/manikuttan/.config/scripts/spotlight_search/brave.png" ;;
                "code") icon="visual-studio-code" ;;
                "cursor") icon="cursor-editor" ;;
                "sublime") icon="sublime-text" ;;
                "slack") icon="slack" ;;
                "alacritty") icon="Alacritty" ;;
                "postman") icon="postman" ;;
                "calculator") icon="gnome-calculator" ;;
                "keka-login") icon="/home/manikuttan/.config/scripts/spotlight_search/icons8-url-100.png" ;;
                "chatgpt") icon="/home/manikuttan/.config/scripts/spotlight_search/icons8-url-100.png" ;;
                "HiFx-Wifi") icon="/home/manikuttan/.config/scripts/spotlight_search/icons8-url-100.png" ;;
                *) icon="application" ;;
            esac
        fi
        ICON_CACHE[$fav]=$icon
    fi
    
    FAVORITES_WITH_ICONS+="$fav\0icon\x1f$icon\n"
done

# Convert favorites to lowercase and store in an array for checking
FAVORITES_LOWER=()
for fav in "${FAVORITES[@]}"; do
    FAVORITES_LOWER+=("$(echo "$fav" | tr '[:upper:]' '[:lower:]')")
done

# Get list of applications and combine with favorites more efficiently
SNAP_APPS=$(find /snap/bin -type f -executable 2>/dev/null | xargs -I {} basename {} | tr '[:upper:]' '[:lower:]' | \
    while read -r name; do
        # Only include if not in favorites and not already seen
        if [[ ! " ${FAVORITES_LOWER[@]} " =~ " ${name} " ]]; then
            echo "$name"
        fi
    done | sort -u)  # Add sort -u to remove duplicates

# Optimize application listing using cached desktop files
APPS=$(while IFS= read -r desktop_file; do
    if [[ -f "$desktop_file" ]]; then
        # Use awk to extract both Icon and Name in one pass
        eval $(awk -F= '/^(Icon|Name)=/{printf "%s=\"%s\" ", tolower(substr($1,1,1)) substr($1,2), $2}' "$desktop_file")
        name=${name%%_*}
        [[ ! " ${FAVORITES_LOWER[*]} " = *" ${name} "* ]] && \
            echo "$name\0icon\x1f${icon:-application}"
    fi
done < "$DESKTOP_CACHE_FILE" | sort -u -t $'\0' -k1,1)

# Combine items (using awk to ensure uniqueness based on the application name)
ALL_ITEMS=$(printf "%s\n%s\n%s" \
    "$FAVORITES_WITH_ICONS" \
    "$(printf "%s\0icon\x1fapplication\n" "$SNAP_APPS")" \
    "$APPS" | awk -F'\0' '!seen[$1]++ {print $0}')

# Debug output to check available applications
echo "Available applications:" > /tmp/spotlight_debug.log
echo "$ALL_ITEMS" >> /tmp/spotlight_debug.log

# Force focus on rofi with multiple attempts and fallbacks
(
    sleep 0.2
    for i in {1..5}; do
        # Try different window classes/names
        window_id=$(xdotool search --onlyvisible --class "rofi" 2>/dev/null | head -n 1)
        if [ -z "$window_id" ]; then
            window_id=$(xdotool search --onlyvisible --name "rofi" 2>/dev/null | head -n 1)
        fi
        
        if [ -n "$window_id" ]; then
            wmctrl -i -a "$window_id"
            xdotool windowactivate --sync "$window_id"
            xdotool windowfocus --sync "$window_id"
            xdotool key --window "$window_id" Tab
            xdotool key --window "$window_id" BackSpace
            break
        fi
        sleep 0.1
    done
) &

INPUT=$(echo -e "$ALL_ITEMS" | rofi -dmenu \
    -theme-str 'window {width: 500px; height: 300px; border-radius: 8px;}
                element {padding: 5px;}
                element selected {background-color: #2f2f2f;}
                inputbar {padding: 5px; children: [entry, close-button];}
                entry {padding: 5px; placeholder: "Spotlight Search"; blink: false;}
                close-button {padding: 5px; action: "kb-cancel"; str: "";}
                mainbox {children: [inputbar, listview];}
                listview {scrollbar: false; dynamic: true; lines: 5;}
                element-icon {size: 1.5em;}
                textbox-prompt-colon {str: "";}' \
    -matching normal \
    -sort false \
    -sorting-method fzf \
    -location 0 \
    -hover-select \
    -me-select-entry "" \
    -filter "" \
    -show-icons \
    -display-name "" \
    -me-accept-entry "MousePrimary") || exit 1

# Clean up the selected input (remove icon information)
INPUT=$(echo "$INPUT" | cut -d $'\0' -f1)

[ -z "$INPUT" ] && exit 1

# Optimize window search function with caching
declare -A WINDOW_CACHE
switch_to_window() {
    local window_class="$1"
    local window_id
    
    # Use cached window ID if available and valid
    if [[ -n "${WINDOW_CACHE[$window_class]}" ]]; then
        if wmctrl -i -a "${WINDOW_CACHE[$window_class]}" 2>/dev/null; then
            return 0
        fi
    fi
    
    # Cache window list
    local windows=$(wmctrl -l -x)
    window_id=$(echo "$windows" | grep -i "$window_class" | head -n1 | cut -d' ' -f1)
    
    if [ -n "$window_id" ]; then
        WINDOW_CACHE[$window_class]=$window_id
        wmctrl -i -a "$window_id"
        return 0
    fi
    return 1
}

# Handle selected input
if [ -n "${INPUT}" ]; then
    case "${INPUT}" in
        "calculator")
            if ! switch_to_window "gnome-calculator"; then
                nohup gnome-calculator >/dev/null 2>&1 &
            fi
            exit 0
            ;;
        "brave")
            if ! switch_to_window "brave-browser" && ! switch_to_window "Brave-browser"; then
                nohup brave >/dev/null 2>&1 &
            fi
            exit 0
            ;;
        "code")
            if ! switch_to_window "code"; then
                nohup code >/dev/null 2>&1 &
            fi
            exit 0
            ;;
        "sublime")
            if ! switch_to_window "sublime_text" && ! switch_to_window "Sublime_text"; then
                nohup subl >/dev/null 2>&1 &
            fi
            exit 0
            ;;
        "slack")
            if ! switch_to_window "slack"; then
                nohup slack >/dev/null 2>&1 &
            fi
            exit 0
            ;;
        "alacritty")
            if ! switch_to_window "Alacritty"; then
                nohup alacritty >/dev/null 2>&1 &
            fi
            exit 0
            ;;
        "postman")
            if ! switch_to_window "postman"; then
                nohup postman >/dev/null 2>&1 &
            fi
            exit 0
            ;;
        "keka-login")  # Handle Keka Login URL
            nohup xdg-open "$Keka_Login_URL" >/dev/null 2>&1 &
            exit 0
            ;;
        "chatgpt")  # Handle ChatGPT URL
            nohup xdg-open "$ChatGPT_URL" >/dev/null 2>&1 &
            exit 0
            ;;
        "HiFx-Wifi")  # Handle HiFx Wifi URL
            nohup xdg-open "$HiFx_Wifi_URL" >/dev/null 2>&1 &
            exit 0
            ;;
    esac

    # Check if it's a snap application first
    if [ -x "/snap/bin/${INPUT}" ]; then
        if ! switch_to_window "${INPUT}"; then
            nohup "/snap/bin/${INPUT}" >/dev/null 2>&1 &
        fi
        exit 0
    fi
    
    # More efficient application handling
    app_path=$(find /usr/share/applications ~/.local/share/applications -type f -name "*${INPUT}*.desktop" -print -quit 2>/dev/null)
    
    if [ -n "${app_path}" ] && command -v xdg-open >/dev/null; then
        window_class=$(awk -F= '/^StartupWMClass/{print $2}' "${app_path}")
        window_class=${window_class:-$INPUT}
        
        if ! switch_to_window "${window_class}"; then
            gtk-launch "$(basename "${app_path}" .desktop)" || \
            notify-send "Error" "Failed to launch ${INPUT}"
        fi
    else
        # Initialize empty suggestions
        suggestions=""
        # Only get Google suggestions if input doesn't look like a file extension
        if ! [[ "$INPUT" =~ \..+ ]]; then
            suggestions=$(curl -s "http://suggestqueries.google.com/complete/search?output=firefox&q=$(echo "${INPUT}" | jq -sRr @uri)" | jq -r '.[1][]' | sed 's/^/🔍 /')
        fi
        
        # Search for files matching input in home directory only if input contains a file extension
        if [[ "$INPUT" =~ \..+ ]]; then
            file_results=$(find ~/ -iname "*${INPUT}*" -type f 2>/dev/null | head -n 50)
            # Append file results to suggestions
            if [ -n "$file_results" ]; then
                while IFS= read -r line; do
                    if [[ "$line" =~ \.(jpg|jpeg|png|gif|bmp|svg)$ ]]; then
                        # Add newline only if suggestions is not empty
                        [ -n "$suggestions" ] && suggestions+=$'\n'
                        suggestions+="🖼️ $(basename "$line") | ~/${line#$HOME/}"
                    else
                        [ -n "$suggestions" ] && suggestions+=$'\n'
                        suggestions+="📄 $(basename "$line") | ~/${line#$HOME/}"
                    fi
                done <<< "$file_results"
            fi
        fi

        # If there are suggestions, show them in rofi
        if [ -n "$suggestions" ]; then
            # Set placeholder text based on whether we have file results
            if [[ "$suggestions" =~ "📄" ]] || [[ "$suggestions" =~ "🖼️" ]]; then
                placeholder="Search Files and Web"
            else
                placeholder="Google Search"
            fi
            
            selected_query=$(echo "$suggestions" | rofi -dmenu \
                -theme-str 'window {width: 500px; height: 300px; border-radius: 8px;}
                element {padding: 5px;}
                element selected {background-color: #2f2f2f;}
                inputbar {padding: 5px; children: [entry, close-button];}
                entry {padding: 5px; placeholder: "'"$placeholder"'"; blink: false;}
                close-button {padding: 5px; action: "kb-cancel"; str: "";}
                mainbox {children: [inputbar, listview];}
                listview {scrollbar: false; dynamic: true; lines: 5;}
                element-icon {size: 1.5em;}
                textbox-prompt-colon {str: "";}' \
                -matching normal \
                -sort false \
                -sorting-method fzf \
                -location 0 \
                -hover-select \
                -me-select-entry "" \
                -filter "" \
                -me-accept-entry "MousePrimary")

            if [ -n "$selected_query" ]; then
                if [[ "$selected_query" =~ ^(📄|🖼️)[[:space:]] ]]; then
                    # Extract filename which contains the full path
                    filename="${selected_query#* }"
                    # Remove the filename part before the |
                    filepath="${filename#*| }"
                    # Replace ~/ with actual home directory
                    filepath="${filepath/\~\//$HOME/}"
                    
                    if [ -f "$filepath" ]; then
                        nohup xdg-open "$filepath" >/dev/null 2>&1 &
                    fi
                else
                    nohup xdg-open "https://www.google.com/search?q=${selected_query}" >/dev/null 2>&1 &
                fi
            fi
            
        else
            selected_query=$(echo "🔍 Search Google for: ${INPUT}" | rofi -dmenu \
                -theme-str 'window {width: 500px; height: 300px; border-radius: 8px;}
                element {padding: 5px;}
                element selected {background-color: #2f2f2f;}
                inputbar {padding: 5px; children: [entry, close-button];}
                entry {padding: 5px; placeholder: "Google Search"; blink: false;}
                close-button {padding: 5px; action: "kb-cancel"; str: "";}
                mainbox {children: [inputbar, listview];}
                listview {scrollbar: false; dynamic: true; lines: 5;}
                element-icon {size: 1.5em;}
                textbox-prompt-colon {str: "";}' \
                -matching normal \
                -sort false \
                -sorting-method fzf \
                -location 0 \
                -hover-select \
                -me-select-entry "" \
                -filter "" \
                -me-accept-entry "MousePrimary")

            if [ -n "$selected_query" ]; then
                nohup xdg-open "https://www.google.com/search?q=${INPUT}" >/dev/null 2>&1 &
            fi
        fi
    fi
fi

exit 0
