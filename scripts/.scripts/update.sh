#!/bin/bash

# A script to trigger a full system update via paru
# To be used alongside updates-status.sh as an 'on-click' exec
# This sctipt will reset the notification state and force a module refresh when complete

# Set the cached filepaths
cache_file="/tmp/waybar_updates_cache.json"
notification_file="/tmp/waybar_updates_notify"
waybar_pid=8

# Run paru interactively
paru -Syu --review --sudoloop

# Invalidate the cache before restarting the module
rm -f "$cache_file"

# Send signal to Waybar to refresh the module
pkill -RTMIN+$waybar_pid waybar

# Remove the notificaion flag
rm -f "$notification_file"
