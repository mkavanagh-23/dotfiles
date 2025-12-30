#!/usr/bin/env bash

# Load variables to use later
source "$HOME/.secrets/homeassistant-local"
connected_ssid=$(iwctl station "$WIFI_INTERFACE" show | awk '/Connected network/ {print $NF}')

# Scan for networks on the wifi interface
iwctl station "$WIFI_INTERFACE" scan >/dev/null 2>&1
sleep 2

# Check if we are home
if iwctl station "$WIFI_INTERFACE" get-networks | awk '{print $1}' | grep -Fxq "$WIFI_SSID" \
   || [[ "$connected_ssid" == "$WIFI_SSID" ]]; then
  
  # Function to get entity state
  get_entity_state() {
      local entity_id="$1"
      curl -s \
          -H "Authorization: Bearer $HA_API_KEY" \
          -H "Content-Type: application/json" \
          "http://$HA_IP/api/states/$entity_id" | \
      jq -r '.state // "unknown"'
  }
  
  # Get states of both lights
  left_lamp_state=$(get_entity_state "light.left_lamp_outlet")
  right_lamp_state=$(get_entity_state "light.right_lamp_outlet")
  
  # Determine overall status and appropriate display
  tooltip="Left: $left_lamp_state, Right: $right_lamp_state"
  if [[ "$left_lamp_state" == "on" && "$right_lamp_state" == "on" ]]; then
      status="on"
      text="Both On"
      class="lights-on"
  elif [[ "$left_lamp_state" == "off" && "$right_lamp_state" == "off" ]]; then
      status="off" 
      text="Both Off"
      class="lights-off"
  elif [[ "$left_lamp_state" == "on" || "$right_lamp_state" == "on" ]]; then
      status="on"
      text="Mixed"
      class="lights-on"
  else
      status="unknown"
      text="Unknown"
      tooltip="ERROR: Unknown Light Status"
      class="lights-unknown"
  fi
  
  # Output JSON for Waybar
  jq -cn \
      --arg text "$text" \
      --arg alt "$status" \
      --arg tooltip "$tooltip" \
      --arg class "$class" \
      '{
          "text": $text,
          "alt": $alt,
          "tooltip": $tooltip,
          "class": $class
      }'
else
  echo '{}'
fi
