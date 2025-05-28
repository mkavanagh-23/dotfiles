#!/bin/bash

if ! gh auth status &>/dev/null; then
  notify-send "Error" "GitHub CLI is not authenticated."
  exit 1
fi

# Get the repo name from the user
project_name=$(rofi -dmenu -theme oldworld-blue -p " Repo Name ")
if [[ -z "${project_name// }" ]]; then
  notify-send "Cancelled" "No repo name supplied."
  exit 1
fi

# Sanitize the input
# Remove characters that are not alphanumeric, dot, dash, or underscore
repo_name=$(echo "$project_name" | tr -cd 'A-Za-z0-9._-')

# Remove leading dashes
repo_name=$(echo "$repo_name" | sed 's/^-*//')

# Reject empty or .git
if [[ -z "$repo_name" || "$repo_name" == ".git" ]]; then
  notify-send "Cancelled" "Invalid repository name."
  exit 1
fi

# Enter the projects directory
cd "$HOME/Documents/Projects" || { notify-send "Error" "Projects directory not found."; exit 1; }

# Check for existing repos
if [[ -d "$repo_name" ]]; then
  notify-send "Cancelled" "A matching repo already exists."
  exit 1
fi

# Create the project directory and enter it
mkdir "$repo_name"
cd "$repo_name"
echo "# $repo_name" > "README.md"

# Prompt user for visibility selection
visibility=$(printf "Public\nPrivate" | rofi -dmenu -p " Visibility ")

# Set the repo_visible flag based on user selection
case "$visibility" in
  Public)
    repo_visible="--public"
    ;;
  Private)
    repo_visible="--private"
    ;;
  *)
    notify-send "Cancelled" "No visibility selected."
    exit 1
    ;;
esac

# Get the description from the user
repo_desc=$(rofi -dmenu -p " Description ")
if [[ -z "$repo_desc" ]]; then
  notify-send "Cancelled" "No description provided."
  exit 1
fi

# Add description to the readme
echo "$repo_desc" >> "README.md"

# Get the current git user
gh_user=$(gh api user --jq .login)

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
notify-send "Success" "Repository '$repo_name' created and pushed to GitHub."

# Open the session in a new terminal
ghostty -e "sleep 0.2 && tms open-session '$repo_name'"
