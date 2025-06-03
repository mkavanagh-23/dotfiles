#!/bin/bash

cache_file="/tmp/waybar_updates_cache.json"
notification_file="/tmp/waybar_updates.notify"

# Run paru interactively
paru -Syu --review --sudoloop

# Invalidate the waybar cache before restarting the module
rm -f "$cache_file"

# Send signal to Waybar to refresh the module
pkill -RTMIN+8 waybar

# Remove the notificaion flag
rm -f "$notification_file"
