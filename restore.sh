#!/bin/bash

set -e

CONFIG="$HOME/.config"

configs=(
    hypr
    kitty
    mako
    nvim
    nwg-bar
    swaync
    waybar
    xfce4
)

echo "Restoring backed up configs..."

for config in "${configs[@]}"; do
    if [ -d "$CONFIG/$config.bak" ]; then
        echo "Restoring $config..."

        rm -rf "$CONFIG/$config"
        mv "$CONFIG/$config.bak" "$CONFIG/$config"
    fi
done

echo
echo "✅ Restore complete!"
