#!/bin/bash

# Run paru interactively
paru -Syu --review --sudoloop

# Invalidate the waybar cache before restarting the module
rm -f /tmp/waybar_updates_cache.json

# Send signal to Waybar to refresh the module
pkill -RTMIN+8 waybar
