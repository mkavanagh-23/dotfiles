# Hyprland .dotfiles

Flavored with [Catppuccin](https://github.com/catppuccin/catppuccin), [Rose Pine](https://github.com/rose-pine/rose-pine-theme), and [Noto Fonts](https://notofonts.github.io/).

Powered by: [Hyprland](https://github.com/hyprwm/Hyprland), [waybar](https://github.com/Alexays/Waybar), [Hyprlock](https://github.com/hyprwm/hyprlock), [wlogout](https://github.com/ArtsyMacaw/wlogout), and [wofi](https://hg.sr.ht/~scoopta/wofi).
<div align="center">
    ![arch screenshot](https://raw.githubusercontent.com/mkavanagh-23/dotfiles/master/screenshots/screenshot3.png)
</div>

This directory contains the dotfiles for my system. 
Designed for use on Arch Linux with scripts and packages for a T2 macBook. See the full [T2 Linux project](https://wiki.t2linux.org/).

Hyprlock config adapted from [MrVivekRajan](https://github.com/MrVivekRajan/Hyprlock-Styles)'s great collection of styles. See the linked repository for more great ones!

<details>
  <summary>More screenshots:</summary>
    <div align="center">
      ![arch screenshot](https://raw.githubusercontent.com/mkavanagh-23/dotfiles/master/screenshots/screenshot1.png)
      ![arch screenshot](https://raw.githubusercontent.com/mkavanagh-23/dotfiles/master/screenshots/screenshot4.png)
      ![arch screenshot](https://raw.githubusercontent.com/mkavanagh-23/dotfiles/master/screenshots/screenshot2.png)
      ![arch screenshot](https://raw.githubusercontent.com/mkavanagh-23/dotfiles/master/screenshots/screenshot5.png)
      ![arch screenshot](https://raw.githubusercontent.com/mkavanagh-23/dotfiles/master/screenshots/screenshot7.png)
    </div>
</details>

## Dependencies

Ensure you have the following installed on your system:

### Git

```
pacman -S git
```

### Stow

These files use [GNU Stow](https://www.gnu.org/software/stow/) to manage dotfiles in the user's home directory. Dotfiles are stored in '~/.dotfiles' with each package's files stored in a respective directory. Dotfiles are then symlinked into the user's home directory with the 'stow' command.

```
pacman -S stow
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git:

```
git clone git@github.com:mkavanagh-23/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

Now you can install all files and dependencies by executing the install script

```
chmod +x install.sh 
./install.sh 
```

Or use GNU stow to create symlinks to your home directory on a per package basis:

```
stow <pkgname>
```

## Notes

Config styles are stored in a directory named after their respective app.
The structure of this directory mirrors that of the user's home directory.
You can manually install config files by moving the contents of each wanted app's directory to $HOME.
