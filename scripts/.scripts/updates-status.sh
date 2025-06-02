#!/bin/bash

# Ensure the environment is sane
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
export LANG="en_US.UTF-8"
export HOME="${HOME:-/home/$(whoami)}"
export TMPDIR="${TMPDIR:-/tmp}"

updates=$(checkupdates 2>/dev/null)
aur_updates=$(paru -Qua 2>/dev/null)
updates=$(printf "%s\n%s" "$updates" "$aur_updates" | grep -v '^$')

if [[ -n "$updates" ]]; then
  count=$(echo "$updates" | wc -l)
  # Sanitize the updates string for JSON
  sanitized_updates=$(echo "$updates" | sed ':a;N;$!ba;s/\n/\\n/g' | sed 's/"/\\"/g')
  echo "{\"text\": \"$count 󰚰\", \"class\": \"active\", \"tooltip\": \"$sanitized_updates\"}"
else
  echo '{"text": "", "class": "inactive"}'
fi
