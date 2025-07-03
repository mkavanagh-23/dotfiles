#!/usr/bin/env bash

shaderconfig="$HOME/.config/hypr/hyprland.conf.d/shader.conf"

rm $shaderconfig

ln -s $HOME/.config/hypr/hyprland.conf.d/shaders/dark.conf $shaderconfig

notify-send "Hyprland" "Blue light filter enabled"

exit 0
