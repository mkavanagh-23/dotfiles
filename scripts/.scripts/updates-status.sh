#!/bin/bash

# Read the json update string contained in the updates cache file for use in waybar

# Setup environment for xdg-portal notifications on Wayland
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

# Set the script vars
cache_file="/tmp/waybar_updates_cache.json"
notification_file="/tmp/waybar_updates_notify"
init_file="/tmp/waybar_updates_init"

# Wait for updatecheck init
while [ ! -f "$init_file" ]; do
  sleep 1
done

if [[ -f "$cache_file" ]]; then
  if [[ ! -f "$notification_file" ]]; then
    touch "$notification_file"
    # Extract the update count
    cached_text=$(jq -r '.text // ""' "$cache_file" 2>/dev/null)
    if [[ $cached_text =~ ^([0-9]+) ]]; then
      update_count="${BASH_REMATCH[1]}"
      update_count=${update_count:-0}
    fi
    # Check for notification status
    if (( update_count > 0 )); then
      # Trigger the notification
      if [[ $update_count -eq 1 ]]; then
        notify-send "󰚰 System Update" "$update_count new update available"
      else
        notify-send "󰚰 System Update" "$update_count new updates available"
      fi
    fi
  fi
  # Return the updated json string
  cat "$cache_file"
else
  # Return inactive json string in case of errors with our service
  echo '{"text":"","class":"inactive"}'
fi

exit 0
