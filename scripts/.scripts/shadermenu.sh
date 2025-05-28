#!/bin/bash

# Directory containing the shader scripts
SCRIPT_DIR="$HOME/.scripts"  # Adjust if needed

# Create associative array for mapping capitalized titles to script paths
declare -A shader_map

# Collect titles and map them
while IFS= read -r file; do
  filename=$(basename "$file")
  title="${filename#shader-}"
  title="${title%.sh}"
  cap_title="$(tr '[:lower:]' '[:upper:]' <<< "${title:0:1}")${title:1}"
  shader_map["$cap_title"]="$file"
done < <(find "$SCRIPT_DIR" -maxdepth 1 -xtype f -name 'shader-*.sh')

# Display menu and get selection
selected=$(printf '%s\n' "${!shader_map[@]}" | sort | rofi -dmenu -i -p "Select Shader" -theme oldworld-cyan)

# If valid selection, run associated script
if [[ -n "$selected" && -n "${shader_map[$selected]}" ]]; then
  bash "${shader_map[$selected]}"
fi

