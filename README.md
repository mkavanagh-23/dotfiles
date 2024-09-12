# My dotfiles

This directory contains the dotfiles for my system. 
Designed for use on Arch Linux with scripts and packages for a T2 macBook. See the full T2 project [T2 Linux](https://wiki.t2linux.org/).

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
$ git clone git@github.com:mkavanagh-23/dotfiles.git ~/.dotfiles
$ cd ~/.dotfiles
```

Now you can install all files and dependencies by executing the install script

```
$ chmod +x install.sh 
$ ./install.sh 
```

Or use GNU stow to create symlinks to your home directory on a per package basis:

```
$ stow <pkgname>
```
