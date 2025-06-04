#!/bin/bash

# Check for updates from the Official Arch Linux Repositiories as well as the AUR
# and return a json object for use in a custom waybar module

# Setup environment for xdg-portal notifications on Wayland
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

# Set the script vars
cache_file="/tmp/waybar_updates_cache.json"
lock_file="/tmp/waybar_updates.lock"
notification_file="/tmp/waybar_updates_notify"
refresh_stamp="/tmp/waybar_updates_refreshed" # temp file tracks first boot
ttl=10  # Seconds before requiring cache refresh, this helps ensure sync across monitors
main_color="#92a2d5"
aur_color="#90b99f"
last_updated=0
prior_count=0
max_retries=50 # Num times to try to fetch data while waiting to prevent race
waybar_pid=8 # to restart the module when needed

# Check for updates
sleep 0.2  # Give a bit of time at boot
(
  # Script is executed once per monitor - block to prevent race condition
  flock -n 9 || exit 0

  # Check if cache file exists and is fresh
  now=$(date +%s)
  
  if [[ -f "$cache_file" ]]; then
    # Get the time of last update
    last_updated=$(jq -r '.timestamp // 0' "$cache_file" 2>/dev/null)
    # Get the count of last update
    cached_text=$(jq -r '.text // ""' "$cache_file" 2>/dev/null)
    if [[ $cached_text =~ ^([0-9]+) ]]; then
      prior_count="${BASH_REMATCH[1]}"
    fi
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
        --argjson timestamp "$now" \
        '{
          text: $text,
          class: "active",
          tooltip: $tooltip,
          timestamp: $timestamp
        }' > "$cache_file"
      # Check for count change for notification trigger
      if(( update_count > prior_count )); then
        rm -f "$notification_file"
      fi
      # Trigger the notification
      if [[ ! -f "$notification_file" ]]; then
        touch "$notification_file"
        if [[ $update_count -eq 1 ]]; then
          notify-send "󰚰 System Update" "$update_count new update available"
        else
          notify-send "󰚰 System Update" "$update_count new updates available"
        fi
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

    # One-time refresh trigger after first boot
    if [[ ! -f "$refresh_stamp" ]]; then
      touch "$refresh_stamp"
      pkill -RTMIN+$waybar_pid waybar
    fi
  fi
) 9>"$lock_file"

# Build the json output
tries=$max_retries
while (( tries > 0 )); do
  if output=$(jq -cre 'del(.timestamp) | select(.class)' "$cache_file" 2>/dev/null); then # Wait for valid json in the cache
    echo "$output"
    exit 0
  fi
  sleep 0.1
  ((tries--))
done

# If we made it here something went horribly wrong
retries=$((max_retries - tries))
notify-send -u critical "󰚰 updates-status.sh" "Failed to read valid JSON from cache after $retries retries"
echo '{"text": "", "class": "inactive", "tooltip": ""}'  # Fallback JSON
exit 1

