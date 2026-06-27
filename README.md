# Arch Linux Dotfiles

My personal Arch Linux configuration for my Lenovo ThinkPad T480.

## Features

- Hyprland
- Waybar
- Neovim
- Kitty
- Mako
- SwayNC
- nwg-bar
- Wallpapers

## Repository Structure

```
hypr/
kitty/
mako/
nvim/
nwg-bar/
swaync/
waybar/
xfce4/

pkglist.txt
aurlist.txt

backup.sh
bootstrap.sh
install.sh
```

## Installation

Clone the repository:

```bash
git clone git@github.com:Kipngetichemmax/arch-dotfiles.git
cd arch-dotfiles
```

Install packages:

```bash
./install.sh
```

Create symlinks:

```bash
./bootstrap.sh
```

## Updating

Whenever I change my configuration:

```bash
./backup.sh
```

This updates:

- pkglist.txt
- aurlist.txt

and pushes all changes to GitHub.

## License

Personal use.
