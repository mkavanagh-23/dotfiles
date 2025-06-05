#!/bin/bash

# A script to trigger a full system update via paru
# To be used alongside updates-status.sh as an 'on-click' exec
# This sctipt will reset the notification state and force a module refresh when complete

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

post_update_script="$HOME/.scripts/update-timer.sh"

# Run paru interactively
paru -Syu --review --sudoloop || {
  notify-send -u critical "Updates" "Update cancelled or failed"
  exit 1
}

# Post update script
if [[ -x "$post_update_script" ]]; then
  "$post_update_script"
else
  notify-send -u critical "Updates" "Helper script not found or not executable"
  exit 2
fi
