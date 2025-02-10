#!/bin/sh
set -ex
# Update database and current packages and install desired packages
sudo pacman -Syu --needed --noconfirm\
    kitty git-lfs ripgrep bat neovim xclip zip tree fd zsh gdb qemu-full rustup rust-analyzer nodejs tokei xorriso llvm cmake lld clang ninja nasm ctags mtools perf\
    ttf-fira-mono ttf-fira-code ttf-fira-sans ttf-dejavu ttf-liberation noto-fonts strace mold htop\


# Make ZSH the default shell
chsh -s /usr/bin/zsh
