#!/bin/bash

# Get the list of ignored packages
ignored=$(awk -F '=' '/^IgnorePkg/ {gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}' /etc/pacman.conf)

# Get total number of available updates
updates=$(paru -Qu)

# Get number of available AUR updates
aur_updates=$(paru -Qua | wc -l)

# initialize the counter
update_count=0

# Process each line of the updates
while IFS= read -r line; do
    pkg_name=$(echo "$line" | awk '{print $1}')
    # Skip ignored packages
    if [[ " ${ignored[*]} " == *" ${pkg_name} "* ]]; then
        continue
    else
        ((update_count++))
    fi
done <<< "$updates"

# Determine the state for waybar
if [ "$update_count" -eq 0 ]; then
  echo '{"text": "", "class": "inactive"}'
else
  if [ "$aur_updates" -eq 0 ]; then
    if [ "$update_count" -eq 1 ]; then
      echo "{\"text\": \"󰚰 $update_count\", \"class\": \"active\", \"tooltip\": \"Install $update_count Update\"}"
    else
      echo "{\"text\": \"󰚰 $update_count\", \"class\": \"active\", \"tooltip\": \"Install $update_count Updates\"}"
    fi
  else
    if [ "$update_count" -eq 1 ]; then
      echo "{\"text\": \"󰚰 $update_count ($aur_updates)\", \"class\": \"active\", \"tooltip\": \"Install $update_count AUR Update\"}"
    else
      echo "{\"text\": \"󰚰 $update_count ($aur_updates)\", \"class\": \"active\", \"tooltip\": \"Install $update_count Updates\n($aur_updates AUR)\"}"
    fi
  fi
fi
