#!/usr/bin/env bash

theme="$HOME/.config/rofi/wifi.rasi"

notify() {
    notify-send -i network-wireless "Wi-Fi" "$1"
}

error() {
    notify-send -u critical -i network-wireless-offline "Wi-Fi" "$1"
}

wifi_enabled() {
    [ "$(nmcli radio wifi)" = "enabled" ]
}

main_menu() {

    while true; do

        if wifi_enabled; then
            toggle="󰖪  Turn Wi-Fi Off"
        else
            toggle="󰖩  Turn Wi-Fi On"
        fi

        choice=$(printf \
"󰖩  Available Networks
󰑐  Refresh
%s
󰁮  Exit" \
"$toggle" | rofi -dmenu -i -p "Wi-Fi" -theme "$theme")

        case "$choice" in

            *"Available Networks"*)
                network_menu
                ;;

            *"Refresh"*)
                nmcli device wifi rescan >/dev/null
                notify "Network list refreshed."
                ;;

            *"Turn Wi-Fi On"*)
                nmcli radio wifi on
                notify "Wi-Fi enabled."
                ;;

            *"Turn Wi-Fi Off"*)
                nmcli radio wifi off
                notify-send -i network-wireless-offline "Wi-Fi" "Wi-Fi disabled."
                ;;

            ""|*"Exit"*)
                exit 0
                ;;
        esac

    done
}

network_menu() {

    while true; do

        networks=$(
            nmcli -t -f SSID,SIGNAL,SECURITY device wifi list |
            sort -t: -k2 -rn |
            awk -F: '!seen[$1]++'
        )

        menu=$(
            echo "$networks" |
            while IFS=: read -r ssid signal security; do

                [ -z "$ssid" ] && continue

                if [ "$signal" -ge 80 ]; then
                    icon="󰤨"
                elif [ "$signal" -ge 60 ]; then
                    icon="󰤥"
                elif [ "$signal" -ge 40 ]; then
                    icon="󰤢"
                else
                    icon="󰤟"
                fi

                lock=""
                [ -n "$security" ] && lock=" 󰌾"

                     printf "%s %s%s|%s\n" "$icon" "$ssid" "$lock" "$security"

            done
        )

        display=$(echo "$menu" | cut -d'|' -f1)
        display="$display
󰁮  Back"

        chosen=$(printf "%s\n" "$display" | rofi -dmenu -i -p "Wi-Fi Networks" -theme "$theme")

        case "$chosen" in
            ""|*"Back"*)
                return
                ;;
        esac
        
        ssid=$(echo "$chosen" | sed -E 's/^.[ ]//; s/ 󰌾$//')

        security=$(echo "$menu" | grep -F "$chosen" | cut -d'|' -f2)


        if nmcli -t -f NAME connection show | grep -Fxq "$ssid"; then

            if nmcli connection up "$ssid" >/dev/null; then
                notify "Connected to $ssid"
            else
                error "Failed to connect."
            fi

            return
        fi

        if [ -z "$security" ]; then

            if nmcli device wifi connect "$ssid" >/dev/null; then
                notify "Connected to $ssid"
            else
                error "Failed to connect."
            fi

            return

        else

            password=$(rofi -dmenu -password \
                -p "Password for $ssid" \
                -theme "$theme")

            [ -z "$password" ] && continue

            if nmcli device wifi connect "$ssid" password "$password" >/dev/null; then
                notify "Connected to $ssid"
            else
                error "Wrong password or connection failed."
            fi

            return

        fi

    done
}

main_menu
