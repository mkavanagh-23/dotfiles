#!/bin/bash

# A script to serve golang docs on localhost:6060

# Start the godocs server
godoc -http=:6060 & >/dev/null 2>&1
GODOC_PID=$!

# Wait a second for initialization
sleep 1

# Open the godocs page
xdg-open "http://localhost:6060" & >/dev/null 2>&1

# Wait another second
sleep 1

# Print prompt
printf "\n"
echo "Go documentation now available at 'http://localhost:6060'"
echo "Press 'q' to quit"

# Read user input one character at a time, without waiting for Enter
while true; do
  read -rsn1 key  # -r: raw mode, -s: silent, -n1: one character
  if [[ "$key" == "q" ]]; then
    echo "Quitting..."
    kill "$GODOC_PID"
    wait "$GODOC_PID" 2>/dev/null
    break
  fi
done
