# Spotlight Search for Linux

A macOS-like spotlight search for Linux with application launching, URL handling, and Google search integration.

## Quick Start

1. Install dependencies:
```bash
sudo apt update && sudo apt install rofi xdotool wmctrl curl jq x11-xserver-utils libnotify-bin
```

2. Create and setup script:
copy spotlight_search.sh to ~/.config/scripts/spotlight_search.sh

3. Set keyboard shortcut:
- Open Settings → Keyboard → Keyboard Shortcuts
- Add new shortcut: `~/.config/scripts/spotlight_search.sh`
- Set preferred key (e.g., Super+Space)

## Features

- 🚀 Fast application launcher
- 🔍 Google search integration
- 🖥️ Smart window switching
- 🎯 Multi-monitor support
- 🌐 Custom URL handling
- ⭐ Favorites quick access
- 🎨 Customizable theming

## Customization

### Add Favorite Apps
Edit `~/.config/scripts/spotlight_search.sh`:
```bash
FAVORITES=(
    "brave"
    "code"
    "slack"
    # Add your favorites
)
```

### Custom URLs
```bash
# Add your URLs
Custom_URL="https://example.com"
```

### Icons
Place custom icons in `~/.config/scripts/`:
- brave.png
- icons8-url-100.png

## Usage

- Launch: Press configured shortcut (default: Super+Space)
- Search: Start typing for:
  - Applications
  - Favorites
  - URLs
  - Google search
- Select: Arrow keys or mouse
- Execute: Enter or click

## Troubleshooting

- **No icons**: Check icon paths and theme
- **Window switching fails**: Verify window classes
- **Script won't launch**: Check permissions and dependencies
