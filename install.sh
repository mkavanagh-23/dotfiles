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
  "greetd"
  "grim"
  "hypridle"
  "hyprland"
  "hyprlock"
  "hyprpaper"
  "kitty"
  "kvantum"
  "kvantum-qt5"
  "lxappearance"
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

echo "Checking for dependencies..."
pacman_missing=()
pacman_install=" "
# check for pacman dependencies
for pkg in "${pacman_depends[@]}"; do
  sleep 0.2
  if pacman -Qq "$pkg" &> /dev/null; then
    echo -e "\033[32m$pkg is installed. Skipping...\033[0m"
  else
    echo -e "\033[33m$pkg is not installed.\033[0m"
    pacman_missing+=("$pkg")
  fi
done

# check for AUR dependencies
aur_missing=()
aur_install=" "
for pkg in "${aur_depends[@]}"; do
  sleep 0.2
  if pacman -Qq "$pkg" &> /dev/null; then
    echo -e "\033[32m$pkg is installed. Skipping...\033[0m"
  else
    echo -e "\033[33m$pkg is not installed.\033[0m"
    aur_missing+=("$pkg")
  fi
done

echo ""

#install missing pacman packages
pacman_skipped=" "
if [ ${#pacman_missing[@]} -gt 0 ]; then
  echo "Installing pacman dependencies..."
  for pkg in "${pacman_missing[@]}"; do
    sleep 0.2
    read -p "Install $pkg? (Y/n): " choice
    if [[ "$choice" == "n" ]]; then
      pacman_skipped+="$pkg ";
      echo "Not installing $pkg. (Note: this may break config)"
    else
      pacman_install+="$pkg "
    fi
  done
  if [[ -z "$pacman_install" ]]; then
    #echo "pacman command: 'sudo pacman -S $pacman_install'"
    sudo pacman -S $pacman_install
    # Check to see if pacman install was successful
    if [ $? -eq 0 ]; then
      echo "Pacman dependencies installed successfully. Installing AUR dependencies..."
    else
      echo -e "\033[31mPacman installation failed. Please see pacman log for more info and try again.\033[0m"
      echo "Needed packages: $pacman_install"
      echo "Please install manually"
    fi
  fi
else
  echo "All pacman dependencies installed."
fi

echo ""

aur_skipped=" "
if [ ${#aur_missing[@]} -gt 0 ]; then
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
    install_choice=""
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
        echo -e "\033[31mIf you do not wish to use an AUR helper you must ensure the following packages are installed, then re-run the script.\033[0m"
        for pkg in "${aur_missing[@]}"; do
          aur_skipped+="$pkg "
        done
      fi
    done

    if [[ "$install_choice" == "y" ]]; then
      echo "Installing '$selected_manager'..."
      #echo "Installation command: sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/$selected_manager.git && cd $selected_manager && makepkg -si"
      sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/$selected_manager.git && cd $selected_manager && makepkg -si
      if [ $? -eq 0 ]; then
        echo "$selected_manager installation success! Removing temporary build files..."
        cd .. && rm -rf $selected_manager
      else
        echo -e "\033[31m$selected_manager installation failed. Please install an AUR helper (yay/paru) and re-run the script.\033[0m"
      fi
    fi
  fi
  
  yay_installed=$(command_exists yay && echo "yay")
  paru_installed=$(command_exists paru && echo "paru")

  # install AUR dependencies
  if [ -n "$yay_installed" ] || [ -n "$paru_installed" ]; then
    echo "Installing AUR dependencies with $selected_manager..."
    for pkg in "${aur_missing[@]}"; do
      sleep 0.2
      read -p "Install $pkg? (Y/n): " choice
      if [[ "$choice" == "n" ]]; then
        aur_skipped+="$pkg ";
        echo "Not installing $pkg. (Note: this may break config)"
      else
        aur_install+="$pkg "
      fi
    done
    if [[ -z "$aur_install" ]]; then
      #echo "pacman command: 'sudo pacman -S $pacman_install'"
      $selected_manager -S $aur_install
      # Check to see if pacman install was successful
      if [ $? -eq 0 ]; then
        echo "AUR dependencies installed successfully. Linking files..."
      else
        echo -e "\033[31mPacman installation failed. Please see pacman log for more info and try again.\033[0m"
        echo "Needed packages: $aur_install"
        echo "Please install manually"
      fi
    fi
  else
    echo "All AUR dependencies installed. Linking files..."
  fi
fi

echo ""

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

echo "Install complete. Please review console output for errors."

if [[ -z "$pacman_skipped" ]]; then
  echo "Missing pacman dependencies: $pacman_skipped"
fi

if [[ -z "$aur_skipped" ]]; then
  echo "Missing AUR dependencies: $aur_skipped"
fi


