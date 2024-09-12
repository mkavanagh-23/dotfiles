#!/bin/bash

pacman_dependencies=(
  "git"
  "stow"
)

for pkg in "${pacman_dependencies[@]}"; do
  if pacman -Qq "$pkg" &> /dev/null; then
    echo "$pkg is installed"
  else
    echo "$pkg is not installed"
  fi
done

for dir in */; do
  # Check if it's a directory (although the `*/` pattern usually ensures this)
  if [ -d "$dir" ]; then
    echo "Stowing files from '$dir' into '$HOME/'"
    dir="${dir%/}"
    echo "Stow command: stow $dir"
    #stow $dir
  fi
done
