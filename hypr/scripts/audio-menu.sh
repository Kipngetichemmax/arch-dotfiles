#!/usr/bin/env bash

theme="$HOME/.config/rofi/wifi.rasi"

notify() {
    notify-send -i audio-volume-high "Audio" "$1"
}

main_menu() {
    while true; do

        vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')

        if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED; then
            mute="󰝟  Unmute"
        else
            mute="󰖁  Mute"
        fi

        choice=$(printf \
"󰕾  Volume: %s%%
%s
󰓃  Output Device
󰍬  Input Device
󰁮  Exit" \
"$vol" "$mute" \
| rofi -dmenu -i -p "Audio" -theme "$theme")

        case "$choice" in

            *"Volume:"*)
                volume_menu
                ;;

            *"Mute"*|*"Unmute"*)
                wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
                ;;

            *"Output Device"*)
                output_menu
                ;;

            *"Input Device"*)
                input_menu
                ;;

            ""|*"Exit"*)
                exit 0
                ;;
        esac
    done
}

volume_menu() {

    while true; do

        chosen=$(printf \
"0
10
20
30
40
50
60
70
80
90
100
110
120
󰁮  Back" \
| rofi -dmenu -i -p "Volume %" -theme "$theme")

        case "$chosen" in
            ""|*"Back"*)
                return
                ;;
        esac

        wpctl set-volume @DEFAULT_AUDIO_SINK@ "${chosen}%"
        notify "Volume set to ${chosen}%"
    done
}

output_menu() {

    while true; do

        menu=$(
            wpctl status |
            awk '/Sinks:/,/Sources:/' |
            grep -E '│  \*?  [0-9]+\.' |
            while read -r line; do
                id=$(echo "$line" | grep -oE '[0-9]+\.' | tr -d '.')
                name=$(echo "$line" | sed -E 's/.*[0-9]+\. //; s/\s+\[.*//')

                if echo "$line" | grep -q '\*'; then
                    printf "󰖀 %s|%s\n" "$name" "$id"
                else
                    printf "󰕿 %s|%s\n" "$name" "$id"
                fi
            done
        )

        display=$(echo "$menu" | cut -d'|' -f1)
        display="$display
󰁮  Back"

        chosen=$(printf "%s\n" "$display" | rofi -dmenu -i -p "Output Device" -theme "$theme")

        case "$chosen" in
            ""|*"Back"*)
                return
                ;;
        esac

        id=$(echo "$menu" | grep -F "$chosen" | cut -d'|' -f2)

        [ -n "$id" ] && {
            wpctl set-default "$id"
            notify "Output device changed."
            return
        }
    done
}

input_menu() {

    while true; do

        menu=$(
            wpctl status |
            awk '/Sources:/,/Filters:/' |
            grep -E '│  \*?  [0-9]+\.' |
            while read -r line; do
                id=$(echo "$line" | grep -oE '[0-9]+\.' | tr -d '.')
                name=$(echo "$line" | sed -E 's/.*[0-9]+\. //; s/\s+\[.*//')

                if echo "$line" | grep -q '\*'; then
                    printf "󰍬 %s|%s\n" "$name" "$id"
                else
                    printf "󰍭 %s|%s\n" "$name" "$id"
                fi
            done
        )

        display=$(echo "$menu" | cut -d'|' -f1)
        display="$display
󰁮  Back"

        chosen=$(printf "%s\n" "$display" | rofi -dmenu -i -p "Input Device" -theme "$theme")

        case "$chosen" in
            ""|*"Back"*)
                return
                ;;
        esac

        id=$(echo "$menu" | grep -F "$chosen" | cut -d'|' -f2)

        [ -n "$id" ] && {
            wpctl set-default "$id"
            notify "Input device changed."
            return
        }
    done
}

main_menu
