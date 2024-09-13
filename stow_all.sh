#!/bin/bash

echo "Linking config files to '$HOME/'"
for dir in */; do
  # Check if it's a directory (although the `*/` pattern usually ensures this)
  if [ -d "$dir" ]; then
    sleep 0.1
    echo "Stowing files from '$dir' into '$HOME/'"
    dir="${dir%/}"
    #echo "Stow command: stow $dir"
    stow $dir
    if [ $? -eq 0 ]; then
      echo -e "\033[32mSuccessfully stowed '$dir'.\033[0m"
    else
      echo -e "\033[31mStow failed. Please manually run 'stow $dir'.\033[0m"
    fi
  fi
done
