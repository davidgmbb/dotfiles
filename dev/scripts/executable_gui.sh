#!/bin/sh
set -ex

# This is the GUI-needed apps that are installed quickly
yay -Sy --noconfirm xorg-xwininfo qbittorrent telegram-desktop signal-desktop vulkan-devel xorg-xkill gparted mpv vlc smplayer pavucontrol pulsemixer playerctl libreoffice discord parsec-bin google-chrome
