#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "==> Checking for Arch Linux..."

if ! command -v pacman >/dev/null 2>&1; then
    echo "This script only works on Arch Linux."
    exit 1
fi

echo "==> Updating system..."
sudo pacman -Syu

echo "==> Installing official packages..."
sudo pacman -S --needed - < "$DOTFILES/pkglist.txt"

if command -v yay >/dev/null 2>&1; then
    echo "==> Installing AUR packages..."
    yay -S --needed - < "$DOTFILES/aurlist.txt"
else
    echo
    echo "⚠️ yay is not installed."
    echo "Install yay first, then run:"
    echo "yay -S --needed - < $DOTFILES/aurlist.txt"
fi

echo
echo "==> Creating symlinks..."
"$DOTFILES/bootstrap.sh"

echo
echo "✅ Installation complete!"
