#!/bin/bash

rofi -dmenu -theme oldworld-blue -p " 󰜏 |  " | xargs -I{} xdg-open https://unduck.link\?q\=\{\}
