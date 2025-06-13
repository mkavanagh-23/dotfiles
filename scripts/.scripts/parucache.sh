#!/bin/bash

PKGDIR="$HOME/.cache/paru/pkg"
CLONEDIR="$HOME/.cache/paru/clone"

# Keep 1 version per package
find "$PKGDIR" -mindepth 1 -maxdepth 1 -type d | while read -r pkgpath; do
    pkgname=$(basename "$pkgpath")
    versions=($(ls -1t "$pkgpath"))

    if (( ${#versions[@]} <= 1 )); then
        continue
    fi

    echo "Cleaning $pkgname: keeping ${versions[0]}, removing ${#versions[@]}-1 old version(s)"
    for version in "${versions[@]:1}"; do
        rm -rf "$pkgpath/$version"
    done
done

# Clean old clones (not touched in 30 days)
find "$CLONEDIR" -mindepth 1 -maxdepth 1 -type d -mtime +30 -exec rm -rf {} +

echo "Old clone directories cleaned (older than 30 days)"
