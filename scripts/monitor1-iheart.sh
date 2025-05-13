#!/usr/bin/env bash

monitorconfig="$HOME/.config/hypr/hyprland.conf.d/monitors.conf"

rm $monitorconfig

ln -s $HOME/.config/hypr/hyprland.conf.d/monitors.d/hyprland-work.conf $monitorconfig

exit 0
