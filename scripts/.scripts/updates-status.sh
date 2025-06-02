#!/bin/bash

# Retrieve the list of package updates
updates=$(checkupdates)

# Check the status to see if we have updates
update_status=$?

if [[ "$update_status" -eq 0 ]]; then
  # Updates are available - return adctive module state
  echo "{\"text\": \"󰚰\", \"class\": \"active\", \"tooltip\": \"Updates Available\"}"
else
  # No updates available - Return inactive module
  if [[ "$update_status" -eq 1 ]]; then
    notify-send "Updates" "Error checking for updates via pacman"
  fi
  echo '{"text": "", "class": "inactive"}'
fi
