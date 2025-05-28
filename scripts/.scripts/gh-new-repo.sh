#!/bin/bash

# Define your dmenu prompt below
dmenu_prompt() {
  rofi -dmenu -theme oldworld-blue -p "$1"
}

# Define your projects directory path
project_dir="$HOME/Documents/Projects"

# Get the current git user
if ! gh auth status &>/dev/null; then
  notify-send -u critical "GitHub" "GH CLI is not authenticated."
  exit 1
fi
gh_user=$(gh api user --jq .login)

# Prompt user for project name
project_name=$(dmenu_prompt " Repo Name ")
if [[ -z "${project_name// }" ]]; then
  notify-send -u critical "GitHub" "No repo name supplied."
  exit 1
fi

# Sanitize the input
# Remove characters that are not alphanumeric, dot, dash, or underscore
repo_name=$(echo "$project_name" | tr -cd 'A-Za-z0-9._-')
# Remove leading dashes
repo_name=$(echo "$repo_name" | sed 's/^-*//')
# Reject empty or .git
if [[ -z "$repo_name" || "$repo_name" == ".git" ]]; then
  notify-send -u critical "GitHub" "Invalid repository name."
  exit 1
fi

# Enter the projects directory
cd "$project_dir" || { notify-send "Error" "Projects directory does not exist: $project_dir"; exit 1; }

# Check for existing repo
if [[ -d "$repo_name" ]]; then
  notify-send -u critical "GitHub" "A matching repo already exists."
  exit 1
fi

# Create the project directory and enter it
mkdir "$repo_name"
cd "$repo_name"

# Create the readme
echo "# $repo_name" > "README.md"

# Prompt user for visibility selection
visibility=$(printf "Public\nPrivate" | dmenu_prompt " Visibility ")

# Set the repo_visible flag based on user selection
case "$visibility" in
  Public)
    repo_visible="--public"
    ;;
  Private)
    repo_visible="--private"
    ;;
  *)
    notify-send -u critical "GitHub" "No visibility selected."
    exit 1
    ;;
esac

# Prompt user for description
repo_desc=$(dmenu_prompt " Description ")
if [[ -z "$repo_desc" ]]; then
  notify-send -u critical "GitHub" "No description provided."
  exit 1
fi

# Add description to the readme
echo "$repo_desc" >> "README.md"

# Create the github repo
gh repo create "$repo_name" $repo_visible --description "$repo_desc"

# Initialize and push
git init
git remote add origin git@github.com:$gh_user/$repo_name.git
git branch -M main
git add .
git commit -m "Initial commit"
git push -u origin main

# Notify of success
notify-send "GitHub" "Repository '$repo_name' created and pushed to GitHub."

# Place any post-creation scripts/commands here
# For example, automaticallt spawn a new tmux session in the newly created directory
# Or call another dmenu script for further setup

######### USER SCRIPTS #########

# Open the session in a new terminal
ghostty -e "sleep 0.2 && tms open-session '$repo_name'"
