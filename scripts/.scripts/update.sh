#!/bin/bash

# Run paru interactively
paru -Syu --confirm

# Send signal to Waybar to refresh the module
pkill -RTMIN+8 waybar
