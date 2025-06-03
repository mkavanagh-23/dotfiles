#!/bin/bash

# Set up variables
cache_file="/tmp/waybar_updates_cache.json"
lock_file="/tmp/waybar_updates.lock"
ttl=10  # Seconds before requiring cache refresh, this helps ensure sync across monitors

sleep 0.2  # Let the dust settle at login
(
  # Script is executed once per monitor
  # Block to prevent race condition
  flock -n 9 || exit 0

  # Check if cache file exists and is fresh
  now=$(date +%s)
  
  if [[ -f "$cache_file" ]]; then
    last_updated=$(jq -r '.timestamp // 0' "$cache_file" 2>/dev/null)
  else
    last_updated=0
  fi

  if (( now - last_updated > ttl )); then
    updates=$(checkupdates 2>/dev/null)
    aur_updates=$(paru -Qua 2>/dev/null)

    # Colorless, sorted
    sorted=$(printf "%s\n%s" "$updates" "$aur_updates" | grep -v '^$' | sort)

    # Color after sort
    tooltip=""
    while IFS= read -r line; do
      if echo "$aur_updates" | grep -Fxq "$line"; then
        tooltip+="<span foreground='#90b99f'>$line</span>"$'\n'
      else
        tooltip+="<span foreground='#92a2d5'>$line</span>"$'\n'
      fi
    done <<< "$sorted"

    update_count=$(printf "%s" "$sorted" | grep -c .)

    # Display updates if available
    if (( update_count > 0 )); then
      # Sanitize for JSON
      tooltip="${tooltip%$'\n'}" # trim trailing newlinw
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
        --argjson timestamp "$now" \
        '{
          text: $text,
          class: "active",
          tooltip: $tooltip,
          timestamp: $timestamp
        }' > "$cache_file"

      # One-time refresh trigger after first boot
      refresh_stamp="/tmp/waybar_updates_refreshed" # temp file tracks first boot
      if [[ ! -f "$refresh_stamp" ]]; then
        touch "$refresh_stamp"
        pkill -RTMIN+8 waybar
      fi
    else
      jq -c -n \
        --argjson timestamp "$now" \
        '{
          text: "",
          class: "inactive",
          tooltip: "",
          timestamp: $timestamp
        }' > "$cache_file"
    fi
  fi
) 9>"$lock_file"


# Output JSON result
# Retry output read if cache is not immediately valid
tries=20
while (( tries > 0 )); do
  if [[ -f "$cache_file" ]] && jq -e '.text' "$cache_file" &>/dev/null; then
    jq -c 'del(.timestamp)' "$cache_file"
    exit 0
  fi
  sleep 0.1
  ((tries--))
done

