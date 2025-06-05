#!/bin/bash

# Check for updates from the Official Arch Linux Repositiories as well as the AUR
# and return a json object for use in a custom waybar module

# Set the script vars
cache_file="/tmp/waybar_updates_cache.json"
notification_file="/tmp/waybar_updates_notify"
main_color="#92a2d5"
aur_color="#90b99f"
prior_count=0

updates=$(checkupdates 2>/dev/null)
aur_updates=$(paru -Qua 2>/dev/null)

if [[ -f "$cache_file" ]]; then
  # Extract the update count
  cached_text=$(jq -r '.text // ""' "$cache_file" 2>/dev/null)
  if [[ $cached_text =~ ^([0-9]+) ]]; then
    prior_count="${BASH_REMATCH[1]}"
    prior_count=${prior_count:-0}
  fi
fi

# Colorless, sorted
sorted=$(printf "%s\n%s" "$updates" "$aur_updates" | grep -v '^$' | sort)

# Color after sort
tooltip=""
while IFS= read -r line; do
  if echo "$aur_updates" | grep -Fxq "$line"; then
    tooltip+="<span foreground='$aur_color'>$line</span>"$'\n'
  else
    tooltip+="<span foreground='$main_color'>$line</span>"$'\n'
  fi
done <<< "$sorted"

update_count=$(printf "%s" "$sorted" | grep -c .)

# Display updates if available
if (( update_count > 0 )); then
  # Sanitize for JSON
  tooltip="${tooltip%$'\n'}" # trim trailing newline
  tooltip="${tooltip//->/  }" # nerdfont symbols instead of ascii

  # And calculate the update count
  if [[ -n "$aur_updates" ]]; then
    aur_count=$(echo "$aur_updates" | wc -l)
    text="$update_count ($aur_count)  󰚰"
  else
    text="$update_count 󰚰"
  fi

  # Return the json string
  jq -c -n \
    --arg text "$text" \
    --arg tooltip "$tooltip" \
    '{
      text: $text,
      class: "active",
      tooltip: $tooltip
    }' > "$cache_file"
  echo "[$(date)] Found $update_count updates" | systemd-cat -t waybar-updates -p info
else
  jq -c -n \
    '{
      text: "",
      class: "inactive",
      tooltip: ""
    }' > "$cache_file"
fi

# Check for notification reset
if [[ "$update_count" -ne "$prior_count" ]]; then
  if [[ -f "$notification_file" ]]; then
    rm -f "$notification_file"
  fi
  pkill -RTMIN+8 waybar
fi

exit 0
