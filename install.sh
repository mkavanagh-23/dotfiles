#!/bin/bash

pacman_depends=(
  "git"
  "stow"
  "bat"
  "bluez"
  "bluez-utils"
  "brightnessctl"
  "btop"
  "discord"
  "duf"
  "eza"
  "fastfetch"
  "firefox"
  "fzf"
  "grim"
  "hypridle"
  "hyprland"
  "hyprlock"
  "hyprpaper"
  "kitty"
  "kvantum"
  "kvantum-qt5"
  "lxappearance"
  "ly"
  "mako"
  "neovim"
  "networkmanager"
  "noto-fonts-cjk"
  "noto-fonts-emoji"
  "noto-fonts-extra"
  "nwg-menu"
  "pipewire-alsa"
  "pipewire-pulse"
  "qt5ct"
  "qt6ct"
  "starship"
  "thunar"
  "tldr"
  "ttf-font-awesome"
  "ttf-noto-nerd"
  "vim"
  "waybar"
  "wl-clipboard"
  "wlogout"
  "wofi"
  "yazi"
  "zoxide"
  "zsh"
)

aur_depends=(
  "betterdiscord-installer"
  "grimshot"
  "hyprpicker"
  "pwvucontrol"
  "rose-pine-cursor"
  "rose-pine-gtk-theme-full"
  "rose-pine-hyprcursor"
  "wlogout"
)

pacman_install=""
echo "Checking for dependencies..."
for pkg in "${pacman_depends[@]}"; do
  sleep 0.2
  if pacman -Qq "$pkg" &> /dev/null; then
    echo "$pkg is installed. Skipping..."
  else
    echo "$pkg is not installed."
    pacman_install+="$pkg "
  fi
done

aur_install=""
for pkg in "${aur_depends[@]}"; do
  sleep 0.2
  if pacman -Qq "$pkg" &> /dev/null; then
    echo "$pkg is installed. Skipping..."
  else
    echo "$pkg is not installed."
    aur_install+="$pkg "
  fi
done

if [ -z "$pacman_install" ]; then
  echo "Installing pacman dependencies..."
  echo "pacman command: 'sudo pacman -S $pacman_install'"
  #sudo pacman -S $pacman_install
  # Check to see if pacman install was successful
  if [ $? -eq 0 ]; then
    echo "Pacman dependencies installed successfully. Installing AUR dependencies..."
  else
    echo "Pacman installation failed. Please see pacman log for more info and try again."
    echo "Needed packages: $pacman_install"
    exit 1
  fi
else
  echo "All pacman dependencies installed. Checking AUR dependencies..."
fi

if [ -z "$aur_install" ]; then
  #Check if an AUR helper is installed
  command_exists() {
    command -v "$1" >/dev/null 2>&1
  }

  yay_installed=$(command_exists yay && echo "yay")
  paru_installed=$(command_exists paru && echo "paru")

  echo "Checking for AUR helper..."
  # Determine the appropriate action based on which commands are installed
  if [ -n "$yay_installed" ] && [ -n "$paru_installed" ]; then
    # Both yay and paru are installed
    echo "Both yay and paru are installed."
    # Loop until valid input
    while true; do
      read -p "Which package manager would you like to use? (yay/paru): " choice
      if [[ "$choice" == "yay" || "$choice" == "paru" ]]; then
        selected_manager="$choice"
        echo "You selected $selected_manager."
        break
      else
        echo "Invalid choice. Please select a valid choice, or press ctrl-c to exit."
      fi
    done
  elif [ -n "$yay_installed" ]; then
    # Only yay is installed
    selected_manager="yay"
    echo "Success: yay is installed."
  elif [ -n "$paru_installed" ]; then
    # Only paru is installed
    selected_manager="paru"
    echo "Success: paru is installed."
  else
    # Neither yay nor paru is installed
    while true; do
      read -p "Neither yay nor paru is installed. Would you like to install one? (y/n): " install_choice
      if [[ "$install_choice" == "y" ]]; then
        read -p "Which package manager would you like to install? (yay/paru): " choice
          if [[ "$choice" == "yay" || "$choice" == "paru" ]]; then
            selected_manager="$choice"
            echo "You selected $selected_manager."
            break
          else
            echo "Invalid choice. Please select a valid choice, or press ctrl-c to exit."
          fi
      else
        echo "If you do not wish to use an AUR helper you must ensure the following packages are installed, then re-run the script."
        echo "AUR dependencies: $aur_install"
        exit 1
      fi
    done

    echo "Installing '$selected_manager'..."
    echo "Installation command: sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/$selected_manager.git && cd $selected_manager && makepkg -si"
    #sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/$selected_manager.git && cd $selected_manager && makepkg -si
    if [ $? -eq 0 ]; then
      echo "$selected_manager installation success! Removing temporary build files..."
      #cd .. && rm -rf $selected_manager
    else
      echo "$selected_manager installation failed. Please install an AUR helper (yay/paru) and re-run the script."
      exit 1
    fi
  fi
  
  echo "Installing AUR dependencies with $selected_manager..."
  echo "aur command: '$selected_manager -S $aur_install'"
else
  echo "All AUR dependencies installed."
fi

for dir in */; do
  # Check if it's a directory (although the `*/` pattern usually ensures this)
  if [ -d "$dir" ]; then
    sleep 0.2
    echo "Stowing files from '$dir' into '$HOME/'"
    dir="${dir%/}"
    echo "Stow command: stow $dir"
    #stow $dir
  fi
done
