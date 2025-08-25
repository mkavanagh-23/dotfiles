#!/bin/bash

# A script to trigger a full system update via paru
# To be used alongside updates-status.sh as an 'on-click' exec
# This script will reset the notification state and force a module refresh when complete

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

post_update_script="$HOME/.scripts/update-timer.sh"

# Run paru interactively
if paru -Syu --review --sudoloop; then
  # Post update script
  if [[ -x "$post_update_script" ]]; then
    "$post_update_script"
    echo -e "\n✅ Update Complete!"
  else
    echo -e "\n❌ Update Complete, but helper script not found or not executable."
    notify-send -u critical "Updates" "Error: Helper script not found or not executable"
  fi
else
  echo -e "\n❌ Update Failed or Cancelled."
  notify-send -u critical "Updates" "Update cancelled or failed"
fi

# Wait for keypress before exiting
echo -e "\nPress any key to continue..."
read -n 1 -s -r

