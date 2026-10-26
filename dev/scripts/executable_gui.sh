#!/bin/sh
set -ex

# This is the GUI-needed apps that are installed quickly
yay -Syu --needed --noconfirm xorg-xwininfo qbittorrent telegram-desktop signal-desktop vulkan-devel xorg-xkill gparted mpv vlc smplayer pavucontrol pulsemixer playerctl libreoffice google-chrome glfw
