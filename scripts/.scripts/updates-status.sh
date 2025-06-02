#!/bin/bash

updates=$(checkupdates 2>/dev/null)
aur_updates=$(paru -Qua 2>/dev/null)
updates=$(printf "%s\n%s" "$updates" "$aur_updates" | grep -v '^$' | sort)

if [[ -n "$updates" ]]; then
  count=$(echo "$updates" | wc -l)
  # Sanitize the updates string for JSON
  sanitized_updates=$(echo "$updates" | sed ':a;N;$!ba;s/\n/\\n/g' | sed 's/"/\\"/g')
  if [[ -n "$aur_updates" ]]; then
    aur_count=$(echo "$aur_updates" | wc -l)
    echo "{\"text\": \"$count ($aur_count) 󰚰\", \"class\": \"active\", \"tooltip\": \"$sanitized_updates\"}"
  else
    echo "{\"text\": \"$count 󰚰\", \"class\": \"active\", \"tooltip\": \"$sanitized_updates\"}"
  fi
else
  echo '{"text": "", "class": "inactive"}'
fi
