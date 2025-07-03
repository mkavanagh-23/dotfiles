#!/usr/bin/env bash

shaderconfig="$HOME/.config/hypr/hyprland.conf.d/shader.conf"

rm $shaderconfig

ln -s $HOME/.config/hypr/hyprland.conf.d/shaders/none.conf $shaderconfig

notify-send "Hyprland" "Screen shader disabled"

exit 0
