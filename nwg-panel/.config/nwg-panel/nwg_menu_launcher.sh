#!/bin/bash

nwg-menu \
  -s "menu-start.css" \
  -va "top" \
  -ha "left" \
  -fm "thunar" \
  -cmd-lock "swaylock -f --screenshots --effect-blur 7x5 --clock --indicator --ring-color a85d31 --key-hl-color 7a2eb0" \
  -cmd-logout "hyprctl dispatch exit" \
  -cmd-restart "systemctl -i reboot" \
  -cmd-shutdown "systemctl -i poweroff" \
  -term "kitty" \
  -wm "hyprland" \
  -d \
#~ menu styling
#~ -height 300 \
#~ -width 400
#~ -isl 32 \
#~ -iss 16 \
#~ -lang "de" \
#~ -padding 2 \
#~ -mb 10 \
#~ -ml 10 \
#~ -mr 10 \
#~ -mt 10 \
#~ -o "your_output_name" \
#~ -term "alacritty" \
#~ -v \
