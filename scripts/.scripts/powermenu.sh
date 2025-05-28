#!/bin/bash

# Get the current VPN status
if nordvpn status | grep -q "Status: Connected"; then
  vpn_option="Disconnect VPN"
else
  vpn_option="Connect VPN"
fi


# Define menu options and corresponding actions
options=(
  "Network Settings"
  "$vpn_option"
  "Lock"
  "Logout"
  "Shutdown"
  "Reboot"
  "Print Screen"
  "Serial Monitor"
  "Screen Shaders"
  "Scan PCI Devices"
)

# Create associative array mapping text to actions
declare -A actions
actions["Network Settings"]="ghostty -e 'sleep 0.2 && nmtui'"
actions["$vpn_option"]="~/.scripts/vpn-connect.sh"
actions["Lock"]="sleep 0.2 && hyprlock"
actions["Logout"]="hyprctl dispatch exit && echo '\n'"
actions["Shutdown"]="systemctl poweroff"
actions["Reboot"]="systemctl reboot"
actions["Print Screen"]="grimshot --notify savecopy screen"
actions["Serial Monitor"]="~/.scripts/serialmonitor.sh"
actions["Screen Shaders"]="~/.scripts/shadermenu.sh"
actions["Scan PCI Devices"]="sudo ~/.scripts/pcirescan.sh"

# Prompt user using rofi in dmenu mode
choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -p "System Menu" -i -theme oldworld-purple)

# Run the corresponding command if valid choice was made
if [[ -n "$choice" && -n "${actions[$choice]}" ]]; then
  eval "${actions[$choice]}"
fi
