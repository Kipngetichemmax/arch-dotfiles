#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

cd "$DOTFILES"

echo "Updating package lists..."

pacman -Qqen > pkglist.txt
pacman -Qqem > aurlist.txt

git add .

if git diff --cached --quiet; then
    echo
    echo "✅ No changes to back up."
    exit 0
fi

echo
git status

echo
read -rp "Commit message (leave blank for automatic): " msg

if [ -z "$msg" ]; then
    msg="Backup $(date '+%Y-%m-%d %H:%M')"
fi

git commit -m "$msg"

git push

echo
echo "✅ Backup complete!"
