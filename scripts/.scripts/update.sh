#!/bin/bash

# Run paru interactively
paru

# Send signal to Waybar to refresh the module
pkill -RTMIN+8 waybar
