#!/bin/bash

set -e
DOTFILES="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$HOME/.config"

echo "Creating config directory..."
mkdir -p "$CONFIG"

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

for config in "${configs[@]}"; do
    echo "Processing $config..."

    if [ -d "$CONFIG/$config" ] && [ ! -L "$CONFIG/$config" ]; then
        echo "Backing up existing $config..."
        mv "$CONFIG/$config" "$CONFIG/$config.bak"
    fi

    ln -sfn "$DOTFILES/$config" "$CONFIG/$config"
done

echo
echo "✅ All symlinks created successfully."
