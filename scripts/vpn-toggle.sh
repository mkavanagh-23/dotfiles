#!/bin/sh

if ip link show nordlynx > /dev/null 2>&1; then
  nordvpn disconnect
else
  nordvpn connect us
fi

