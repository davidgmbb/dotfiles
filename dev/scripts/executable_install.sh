#!/bin/sh
set -ex
# Update database and current packages and install desired packages
sudo pacman -Syu --needed --noconfirm\
    base-devel lm_sensors htop kitty ripgrep bat neovim bash-completion man xclip unzip zip unrar tree fd zsh qbittorrent gparted xorg-xwininfo\
    telegram-desktop signal-desktop\
    vulkan-devel dmenu arandr xorg-xbacklight xorg-xkill perf \
    git gdb qemu-full rustup rust-analyzer nodejs tokei xorriso llvm cmake lld clang evince ninja nasm ctags mtools\
    ttf-fira-mono ttf-fira-code ttf-fira-sans ttf-dejavu ttf-liberation noto-fonts\
    mpv vlc smplayer pavucontrol pulsemixer playerctl\
    libreoffice

git clone --recurse-submodules https://github.com/zigtools/zls.git ~/dev/zls
git clone https://github.com/davidgm94/rise.git ~/dev/rise

# Make ZSH the default shell
chsh -s /usr/bin/zsh
# Install stable toolchain and make it the default one
rustup default stable

# Update AUR helper and install desired packages
yay -Syyu --needed\
    acestream-launcher acestream-engine\
    parsec-bin discord\
    zig-dev-bin

cd ~/dev/zls
zig build -Drelease-fast
