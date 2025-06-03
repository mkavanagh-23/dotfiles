#!/bin/bash

# Initial var setup
cache_file="/tmp/waybar_updates_cache.json"
lock_file="/tmp/waybar_updates.lock"
ttl=10  # Time to live in seconds
now=$(date +%s)

# Check if cache file exists and is fresh
if [[ -f "$cache_file" ]]; then
  last_updated=$(jq -r '.timestamp // 0' "$cache_file" 2>/dev/null)
  # If we have a fresh file then return the data and exit
  if (( now - last_updated <= ttl )); then
    jq -c 'del(.timestamp)' "$cache_file"
    exit 0
  fi
fi

# Else update the cache
(
  # Script is executed once per monitor
  # Block to prevent race condition
  flock -n 9 || exit 0

  # Re-check inside lock in case another process beat us to it
  last_updated=$(jq -r '.timestamp // 0' "$cache_file" 2>/dev/null)
  now=$(date +%s)
  if (( now - last_updated > ttl )); then
    updates=$(checkupdates 2>/dev/null)
    aur_updates=$(paru -Qua 2>/dev/null)
    updates=$(printf "%s\n%s" "$updates" "$aur_updates" | grep -v '^$' | sort)
    update_count=$(echo "$updates" | wc -l)
    
    # Display updates if available
    if (( update_count > 0 )); then
      # Sanitize for JSON
      tooltip="$updates"
      if [[ -n "$aur_updates" ]]; then
        aur_count=$(echo "$aur_updates" | wc -l)
        text="$update_count ($aur_count)  󰚰"
      else
        text="$update_count 󰚰"
      fi

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
jq -c 'del(.timestamp)' "$cache_file"
