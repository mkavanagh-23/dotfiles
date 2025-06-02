#!/bin/bash

# Define your dmenu prompt below
dmenu_prompt() {
  rofi -dmenu -theme oldworld-blue -p "$1"
}

# Define your projects directory path
project_dir="$HOME/Documents/Projects"

# Get the current git user
if ! gh auth status &>/dev/null; then
  notify-send -u critical " GitHub" "GH CLI is not authenticated. Please run 'gh auth login' and try again."
  exit 1
fi
gh_user=$(gh api user --jq .login)
notify-send " GitHub" "Authenticated as user '$gh_user'"

# Prompt user for project name
project_name=$(dmenu_prompt " Repo Name ")
if [[ -z "${project_name// }" ]]; then
  notify-send -u critical " GitHub" "No repo name supplied."
  exit 1
fi

# Sanitize the input
# Replace spaces with underscores
repo_name=$(echo "$project_name" | tr ' ' '_')
# Remove characters that are not alphanumeric, dot, dash, or underscore
repo_name=$(echo "$repo_name" | tr -cd 'A-Za-z0-9._-')
# Remove leading dashes
repo_name=$(echo "$repo_name" | sed 's/^-*//')
# Reject empty or .git
if [[ -z "$repo_name" || "$repo_name" == ".git" ]]; then
  notify-send -u critical " GitHub" "Invalid repository name."
  exit 1
else
  notify-send " Github" "Parsed repo name: '$repo_name'"
fi

# Check for project dir
if [[ ! -d "$project_dir" ]]; then
  notify-send " GitHub" "Could not find existing projects directory"
  mkdir "$project_dir"
  notify-send " GitHub" "Created new projects directory at: '$project_dir'"
fi

# Enter the projects directory
cd "$project_dir"

# Check for existing repo
if [[ -d "$repo_name" ]]; then
  notify-send -u critical " GitHub" "A matching repo already exists."
  exit 1
fi

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
    notify-send -u critical " GitHub" "No visibility selected."
    exit 1
    ;;
esac

# Prompt user for description
repo_desc=$(dmenu_prompt " Description ")
if [[ -z "$repo_desc" ]]; then
  notify-send -u critical " GitHub" "No description provided."
  exit 1
fi

# Create the project directory and enter it
mkdir "$repo_name"
cd "$repo_name"

# Create the readme
echo "# $repo_name" > "README.md"

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
notify-send " GitHub" "Repository '$repo_name' created and pushed to GitHub."

# Place any post-creation scripts/commands here
# For example, automaticallt spawn a new tmux session in the newly created directory
# Or call another dmenu script for further setup

######### USER SCRIPTS #########

# Or open the git repo in your web browser
echo "https://github.com/$gh_user/$repo_name" | wl-copy
notify-send " GitHub" "URL copied to system clipboard."

# Open the session in a new terminal
ghostty -e "sleep 0.2 && tms open-session '$repo_name'"


