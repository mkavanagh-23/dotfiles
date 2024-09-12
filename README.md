# My dotfiles

This directory contains the dotfiles for my system

## Dependencies

Ensure you have the following installed on your system

### Git

```
pacman -S git
```

### Stow

```
pacman -S stow
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
$ git clone git@github.com:mkavanagh-23/dotfiles.git ~/.dotfiles
$ cd ~/.dotfiles
```

You can then use GNU stow to create symlinks to your home directory

```
$ stow <pkgname>
```
