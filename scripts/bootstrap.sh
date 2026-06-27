#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="$HOME/.config"

echo "Creating config directory..."
mkdir -p "$CONFIG"

for path in "$DOTFILES"/*; do
    [ -d "$path" ] || continue

    config=$(basename "$path")

    case "$config" in
        wallpapers|scripts)
           continue
           ;;
    esac

    echo "Processing $config..."

    if [ -d "$CONFIG/$config" ] && [ ! -L "$CONFIG/$config" ]; then
        echo "Backing up existing $config..."
        mv "$CONFIG/$config" "$CONFIG/$config.bak"
    fi

    ln -sfn "$path" "$CONFIG/$config"
done

echo
echo "✅ All symlinks created successfully."
