# Hyprland .dotfiles

Themed with colors based on [OldWorld](https://github.com/dgox16/oldworld.nvim).

Powered by: [Hyprland](https://github.com/hyprwm/Hyprland), [waybar](https://github.com/Alexays/Waybar), [Hyprlock](https://github.com/hyprwm/hyprlock), [wlogout](https://github.com/ArtsyMacaw/wlogout), and [wofi](https://hg.sr.ht/~scoopta/wofi).
<div align="center">
    <img src="https://github.com/mkavanagh-23/dotfiles/blob/6e1c76dc5d8a2f24ccdf0178132c46408530181b/screenshots/oldworld_desktop.png" width="640" height="360"/>
</div>

This directory contains the dotfiles for my system. 
Designed for use on Arch Linux with scripts and packages for a T2 macBook. See the full [T2 Linux project](https://wiki.t2linux.org/).


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
