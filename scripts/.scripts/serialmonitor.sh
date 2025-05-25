#!/bin/bash

# First menu: Select device from /dev starting with ttyACM or ttyUSB (case-insensitive)
device=$(ls /dev | grep -E -i '^tty(ACM|USB)' | sort | rofi -dmenu -p "Serial Device:")
[[ -z "$device" ]] && exit 1  # Exit if nothing selected

# Second menu: Select baud rate (edit this list as needed)
baudrate=$(printf "9600\n19200\n38400\n57600\n115200\n230400\n" | rofi -dmenu -p "Serial Baudrate:")
[[ -z "$baudrate" ]] && exit 1  # Exit if nothing selected

# Launch screen with selected device and baud rate
exec screen "/dev/$device" "$baudrate"

