#!/bin/bash

if nordvpn status | grep -q "Status: Connected"; then
  nordvpn disconnect
else
  # Get list of countries
  mapfile -t country_list < <(nordvpn countries | awk '{for(i=1;i<=NF;++i) print $i}')

  # Create an associative array and map display values to actual values
  declare -A country_map
  for c in "${country_list[@]}"; do
    pretty="${c//_/ }"
    country_map["$pretty"]="$c"
  done

  # Get the selection from the user
  display_country=$(printf '%s\n' "${!country_map[@]}" | sort | rofi -i -dmenu -p "󰦝 Country  ")

  # Exit if no country selected
  [[ -z "$display_country" ]] && notify-send "NordVPN" "No valid country selected" && exit 1
 
  # Map the selection back to the actual value
  country="${country_map[$display_country]}"

  #Get the cities for the selected country
  mapfile -t city_list < <(nordvpn cities "$country" | awk '{for(i=1;i<=NF;++i) print $i}')

  # Create an associative array for city values
  declare -A city_map
  for c in "${city_list[@]}"; do
    pretty="${c//_/ }"
    city_map["$pretty"]="$c"
  done

  # Get the selection from the user
  display_city=$(printf '%s\n' "${!city_map[@]}" | sort | rofi -i -dmenu -p "󰦝 City  ")

  # Exit if no city selected
  [[ -z "$display_city" ]] && notify-send "NordVPN" "No valid city selected" && exit 1

  # Map the selection back to the actual value
  city="${city_map[$display_city]}"

  # Connect to selected city VPN
  nordvpn connect "$city"
fi
