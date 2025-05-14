#!/bin/sh

if ip link show nordlynx > /dev/null 2>&1; then
  vpn_status=$(nordvpn status | sed ':a;N;$!ba;s/\n/\\n/g; s/"/\\"/g')
  echo "{\"text\": \"󰦝\", \"class\": \"connected\", \"tooltip\": \"$vpn_status\"}"
else
  vpn_status=$(nordvpn status | head -n 1)
  echo "{\"text\": \"󱦛\", \"class\": \"disconnected\", \"tooltip\": \"$vpn_status\"}"
fi

