#!/bin/bash

"$HOME/Documents/Projects/waybar-weather/waybar_weather" >> "/tmp/weather.log" 2>&1
cat /tmp/waybar-weather.json
