#!/bin/bash

# These commands should be run after the environment variables are set

# Quit the terminal
brew install neovim ripgrep bat qemu zig rust-analyzer
# Twice because the first one might fail
brew install neovim ripgrep bat qemu zig rust-analyzer

git clone --recurse-submodules git@github.com:davidgm94/zls.git /home/david/dev/zls
cd /home/david/dev/zls
git checkout 0.9.0
zig build -Drelease-fast

# Install kityy as the default terminal emulator
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/kitty 500

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
