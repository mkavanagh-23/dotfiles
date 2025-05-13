#!/bin/sh

if ip link show nordlynx > /dev/null 2>&1; then
  vpn_status=$(nordvpn status | sed ':a;N;$!ba;s/\n/\\n/g; s/"/\\"/g')
  echo "{\"text\": \"VPN 󰦝\", \"class\": \"connected\", \"tooltip\": \"$vpn_status\"}"
else
  echo "{\"text\": \"󱦛\", \"class\": \"disconnected\", \"tooltip\": \"Connect to VPN\"}"
fi

