#!/bin/bash

# Define menu options and corresponding actions
options=(
  "Lock"
  "Logout"
  "Shutdown"
  "Reboot"
)

# Create associative array mapping text to actions
declare -A actions
actions["Lock"]="sleep 0.2 && hyprlock"
actions["Logout"]="hyprctl dispatch exit && echo '\n'"
actions["Shutdown"]="systemctl poweroff"
actions["Reboot"]="systemctl reboot"

# Prompt user using rofi in dmenu mode
choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -p "Power Menu" -i -theme oldworld-purple)

# Run the corresponding command if valid choice was made
if [[ -n "$choice" && -n "${actions[$choice]}" ]]; then
  eval "${actions[$choice]}"
fi
