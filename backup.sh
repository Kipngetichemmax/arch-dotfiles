#!/bin/bash

set -e

cd "$HOME/dotfiles"

echo "Updating package lists..."
pacman -Qqe > pkglist.txt
pacman -Qqm > aurlist.txt

echo "Git status:"
git status

echo
read -rp "Commit message: " msg

git add .

git commit -m "$msg"

git push

echo
echo "✅ Backup complete!"
