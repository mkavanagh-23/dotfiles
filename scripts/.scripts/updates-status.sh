#!/bin/bash

# Get total number of updates (repo + AUR)
total_updates=$(paru -Qu | wc -l)

# Get number of AUR updates
aur_updates=$(paru -Qua | wc -l)

# Determine the state for waybar
if [ "$total_updates" -eq 0 ]; then
  echo '{"text": "", "class": "inactive"}'
else
  echo "{\"text\": \"󰚰 $total_updates ($aur_updates)\", \"class\": \"active\"}"
fi
