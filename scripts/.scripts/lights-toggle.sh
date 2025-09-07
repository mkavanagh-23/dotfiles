#!/usr/bin/env bash

# Function to display usage information
usage() {
    echo "Usage: $0 [on|off]"
    echo "  on  - Turn lights on"
    echo "  off - Turn lights off"
    echo "  (no argument) - Toggle lights"
    exit 1
}

# Source the Home Assistant configuration
source "$HOME/.secrets/homeassistant-local"

# Check if an argument was provided
if [ $# -eq 0 ]; then
    # No argument provided - execute original toggle behavior
    ACTION="toggle"
elif [ $# -eq 1 ]; then
    # Convert argument to lowercase for case-insensitive comparison
    ARG=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    
    # Validate the argument
    if [ "$ARG" = "on" ]; then
        ACTION="turn_on"
    elif [ "$ARG" = "off" ]; then
        ACTION="turn_off"
    else
        echo "Error: Invalid argument '$1'. Must be 'on' or 'off'."
        usage
    fi
else
    # Too many arguments
    echo "Error: Too many arguments provided."
    usage
fi

# Execute the curl command with the determined service
curl \
  -H "Authorization: Bearer $HA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"entity_id": ["light.left_lamp_outlet", "light.right_lamp_outlet"]}' \
  "http://$HA_IP/api/services/light/$ACTION"

# Always end with the pkill command
pkill -RTMIN+7 waybar
