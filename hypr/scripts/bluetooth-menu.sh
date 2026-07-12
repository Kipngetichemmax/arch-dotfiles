#!/usr/bin/env bash

theme="$HOME/.config/rofi/wifi.rasi"

# Make sure bluetooth is on
if ! bluetoothctl show | grep -q "Powered: yes"; then
    bluetoothctl power on >/dev/null
fi

notify() {
    notify-send -i bluetooth "Bluetooth" "$1"
}

error() {
    notify-send -u critical -i bluetooth "Bluetooth" "$1"
}

main_menu() {
    while true; do
        choice=$(printf "󰂯  Devices\n󰑐  Scan for Devices\n󰓄  Disconnect All\n󰓇  Turn Bluetooth Off\n󰁮  Exit" \
            | rofi -dmenu -i -p "Bluetooth" -theme "$theme")

        case "$choice" in
            *Devices*) devices_menu ;;
            *Scan*) scan_menu ;;
            *Disconnect*)
                bluetoothctl devices Connected | while read -r _ mac _; do
                    bluetoothctl disconnect "$mac" >/dev/null
                done
                notify "All devices disconnected."
                ;;
            *Turn*)
                bluetoothctl power off >/dev/null
                notify-send -i bluetooth-disabled "Bluetooth" "Powered off."
                exit 0
                ;;
            ""|*"Exit"*)
                exit 0
                ;;
        esac
    done
}

devices_menu() {
    while true; do

        devices=$(bluetoothctl devices Paired)

        if [ -z "$devices" ]; then
            notify "No paired devices."
            return
        fi

        menu=$(
            echo "$devices" | while read -r _ mac name; do
                if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
                    printf "󰂱 %s|%s\n" "$name" "$mac"
                else
                    printf "󰂲 %s|%s\n" "$name" "$mac"
                fi
            done
        )

        display=$(echo "$menu" | cut -d'|' -f1)
        display="$display
󰁮 Back"

        chosen=$(printf "%s\n" "$display" | rofi -dmenu -i -p "Paired Devices" -theme "$theme")

        case "$chosen" in
            ""|*"Back"*)
                return
                ;;
        esac

        mac=$(echo "$menu" | grep -F "$chosen" | cut -d'|' -f2)

        [ -z "$mac" ] && continue

        device_actions "$mac" "$chosen"
    done
}

device_actions() {

    mac="$1"
    name="$2"

    while true; do

        if bluetoothctl info "$mac" | grep -q "Connected: yes"; then

            action=$(printf "󰂲 Disconnect\n󰅖 Remove\n󰁮 Back" \
                | rofi -dmenu -i -p "$name" -theme "$theme")

            case "$action" in
                *Disconnect*)
                    bluetoothctl disconnect "$mac" >/dev/null
                    notify "Disconnected."
                    return
                    ;;
                *Remove*)
                    bluetoothctl remove "$mac" >/dev/null
                    notify "Device removed."
                    return
                    ;;
                ""|*"Back"*)
                    return
                    ;;
            esac

        else

            action=$(printf "󰂱 Connect\n󰅖 Remove\n󰁮 Back" \
                | rofi -dmenu -i -p "$name" -theme "$theme")

            case "$action" in
                *Connect*)
                    if bluetoothctl connect "$mac" >/dev/null; then
                        notify "Connected."
                    else
                        error "Failed to connect."
                    fi
                    return
                    ;;
                *Remove*)
                    bluetoothctl remove "$mac" >/dev/null
                    notify "Device removed."
                    return
                    ;;
                ""|*"Back"*)
                    return
                    ;;
            esac

        fi

    done
}

scan_menu() {

    notify "Scanning for 8 seconds..."

    bluetoothctl scan on >/dev/null &
    pid=$!

    sleep 8

    kill "$pid" 2>/dev/null
    bluetoothctl scan off >/dev/null

    while true; do

        devices=$(bluetoothctl devices)

        [ -z "$devices" ] && {
            notify "No devices found."
            return
        }

        menu=$(echo "$devices" | while read -r _ mac name; do
            printf "%s|%s\n" "$name" "$mac"
        done)

        display=$(echo "$menu" | cut -d'|' -f1)
        display="$display
󰁮 Back"

        chosen=$(printf "%s\n" "$display" | rofi -dmenu -i -p "Found Devices" -theme "$theme")

        case "$chosen" in
            ""|*"Back"*)
                return
                ;;
        esac

        mac=$(echo "$menu" | grep -F "$chosen" | cut -d'|' -f2)

        [ -z "$mac" ] && continue

        bluetoothctl pair "$mac" >/dev/null
        bluetoothctl trust "$mac" >/dev/null

        if bluetoothctl connect "$mac" >/dev/null; then
            notify "$chosen connected."
        else
            error "Failed to connect."
        fi

        return

    done
}

main_menu
