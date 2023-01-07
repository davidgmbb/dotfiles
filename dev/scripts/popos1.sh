#!/bin/bash

# Install Signal - we are going to need for key information retrieval
# NOTE: These instructions only work for 64 bit Debian-based
# Linux distributions such as Ubuntu, Mint etc.

# 1. Install our official public software signing key
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

# 2. Add our repository to your list of repositories
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
  sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
# 1. Install brew
sudo apt update && sudo apt upgrade
# Install basic software
sudo apt install snapd telegram-desktop lm-sensors htop alacritty kitty signal-desktop discord gdb gdb-multiarch
# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Install Acestream
sudo snap install acestreamplayer

# Install Bitwarden in Firefox, login into Firefox and get the SSH keys
# Adjust touchpad if applicable
