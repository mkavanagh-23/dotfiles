#!/usr/bin/env bash

shaderconfig="$HOME/.config/hypr/hyprland.conf.d/shader.conf"

rm $shaderconfig

ln -s $HOME/.config/hypr/hyprland.conf.d/shaders/chromatic.conf $shaderconfig

notify-send "Hyprland" "Chromatic screen shader enabled"

exit 0
