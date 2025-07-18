#!/usr/bin/env bash

shaderconfig="$HOME/.config/hypr/hyprland.conf.d/shader.conf"

rm $shaderconfig

ln -s $HOME/.config/hypr/hyprland.conf.d/shaders/crt.conf $shaderconfig

notify-send "Hyprland" "CRT screen shader enabled"

exit 0
