#!/usr/bin/env bash

source "$HOME/.secrets/homeassistant-local"

curl \
  -H "Authorization: Bearer $HA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"entity_id": ["light.left_lamp_outlet", "light.right_lamp_outlet"]}' \
  "http://$HA_IP/api/services/light/toggle"

pkill -RTMIN+7 waybar
