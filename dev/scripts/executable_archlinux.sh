#!/bin/bash

sudo pacman -S git firefox telegram-desktop signal-desktop lm_sensors htop alacritty kitty wezterm discord gdb neovim ripgrep bat qemu qemu-arch-extra rust-analyzer rustup mpv vlc smplayer nodejs tokei nushell bash-completion libreoffice xorriso llvm cmake ttf-fira-mono ttf-fira-code ttf-fira-sans ttf-dejavu ttf-liberation noto-fonts man i3 i3-wm i3lock i3blocks i3status dmenu nvidia-settings pavucontrol xclip lld clang evince playerctl unzip zip rar tree ninja fd

rustup toolchain install stable

pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git ~/yay-bin
cd ~/yay-bin
makepkg -si
yay -Syyu
yay -S acestream-launcher acestream-engine



