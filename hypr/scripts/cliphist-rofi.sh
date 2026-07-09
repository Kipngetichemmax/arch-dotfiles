#!/usr/bin/env bash
# Clipboard history picker: cliphist + rofi with image thumbnails
# ~/.config/hypr/scripts/cliphist-rofi.sh

set -euo pipefail

cache_dir="$HOME/.cache/cliphist-rofi"
mkdir -p "$cache_dir"

# Remove cached thumbnails for entries no longer in cliphist
mapfile -t current_ids < <(cliphist list | cut -f1)
for f in "$cache_dir"/*.png; do
    [[ -e "$f" ]] || continue
    id="$(basename "$f" .png)"
    keep=false
    for cid in "${current_ids[@]}"; do
        [[ "$cid" == "$id" ]] && keep=true && break
    done
    [[ "$keep" == false ]] && rm -f "$f"
done

# Build the rofi input: image entries get an icon field pointing to a decoded thumbnail
selected=$(
    cliphist list | while IFS=$'\t' read -r id content; do
        line="$id"$'\t'"$content"
        if [[ "$content" == *"binary data"* ]]; then
            img="$cache_dir/$id.png"
            [[ -f "$img" ]] || cliphist decode "$id" > "$img" 2>/dev/null
            printf '%s\x00icon\x1f%s\n' "$line" "$img"
        else
            printf '%s\n' "$line"
        fi
    done | rofi -dmenu -show-icons -theme "$HOME/.config/rofi/cliphist.rasi" -p "󰅍 Clipboard"
)

[[ -z "$selected" ]] && exit 0

echo "$selected" | cliphist decode | wl-copy
