#!/bin/bash

# Get the current VPN status
if nordvpn status | grep -q "Status: Connected"; then
  vpn_option="Disconnect VPN"
else
  vpn_option="Connect VPN"
fi


# Define menu options and corresponding actions
options=(
  "Power"
  "Network Settings"
  "$vpn_option"
  "Scan PCI Devices"
  "New Git Project"
  "Print Screen"
  "Serial Monitor"
  "Screen Shaders"
)

# Create associative array mapping text to actions
declare -A actions
actions["Power"]="~/.scripts/powermenu.sh"
actions["Network Settings"]="ghostty -e 'sleep 0.2 && nmtui'"
actions["$vpn_option"]="~/.scripts/vpn-connect.sh"
actions["Scan PCI Devices"]="sudo ~/.scripts/pcirescan.sh"
actions["New Git Project"]="~/.scripts/gh-new-repo.sh"
actions["Print Screen"]="grimshot --notify savecopy screen"
actions["Serial Monitor"]="~/.scripts/serialmonitor.sh"
actions["Screen Shaders"]="~/.scripts/shadermenu.sh"

# Prompt user using rofi in dmenu mode
choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -p "System Menu" -i -theme oldworld-purple)

# Run the corresponding command if valid choice was made
if [[ -n "$choice" && -n "${actions[$choice]}" ]]; then
  eval "${actions[$choice]}"
fi

