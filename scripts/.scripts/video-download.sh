#!/bin/bash

# Check if an input file parameter is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <path_to_video_list>"
  exit 1
fi

# Get the input file path from the argument
input_file="$1"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Error: $input_file not found!"
  exit 1
fi

# Loop through each line in the input file and run yt-dlp for each URL
while IFS= read -r video_url; do
  if [ -n "$video_url" ]; then
    echo "Downloading video from: $video_url"
    yt-dlp "$video_url"
  fi
done < "$input_file"
