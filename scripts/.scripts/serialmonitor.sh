#!/bin/bash

# First menu: Select device from /dev starting with ttyACM or ttyUSB (case-insensitive)
device=$(ls /dev | grep -E -i '^tty(ACM|USB)' | sort | rofi -dmenu -p "Serial Device:" -theme oldworld-green)
[[ -z "$device" ]] && exit 1  # Exit if nothing selected

# Second menu: Select baud rate (edit this list as needed)
baudrate=$(printf "9600\n19200\n38400\n57600\n115200\n230400\n" | rofi -dmenu -p "Serial Baudrate:" -theme oldworld-green)
[[ -z "$baudrate" ]] && exit 1  # Exit if nothing selected

# Launch screen with selected device and baud rate
ghostty -e 'sleep 0.2 && screen "/dev/$device" "$baudrate"'

