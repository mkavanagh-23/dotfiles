#!/bin/sh

if ip link show nordlynx > /dev/null 2>&1; then
  echo '{ "text": "VPN 󰦝", "class": "connected" }'
else
  echo '{ "text": "󱦛", "class": "disconnected" }'
fi

