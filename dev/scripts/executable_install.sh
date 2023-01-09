#!/bin/sh
set -ex
# Update database and current packages and install desired packages
sudo pacman -Syu --needed --noconfirm\
    base-devel lm_sensors htop kitty ripgrep bat neovim bash-completion man xclip unzip zip unrar tree fd zsh bluez bluez-utils blueman pacman-contrib qbittorrent gparted foot wl-clipboard xorg-xwininfo\
    telegram-desktop signal-desktop\
    vulkan-devel dmenu arandr xorg-xbacklight xorg-xkill perf xfce4-goodies xfce4 mate-extra\
    git gdb qemu-full rustup rust-analyzer nodejs tokei xorriso llvm cmake lld clang evince ninja nasm ctags mtools\
    ttf-fira-mono ttf-fira-code ttf-fira-sans ttf-dejavu ttf-liberation noto-fonts\
    mpv vlc smplayer pavucontrol pulsemixer playerctl\
    libreoffice
# Make ZSH the default shell
chsh -s /usr/bin/zsh
# Install stable toolchain and make it the default one
rustup default stable
# Clone, compile and install paru, an AUR helper
git clone https://aur.archlinux.org/paru.git ~/dev/paru
cd ~/dev/paru
makepkg -si
cd ~
# Update AUR helper and install desired packages
paru -Syyu --needed\
    sway-git wlroots-git kickoff brave-nightly-bin sway-interactive-screenshot\
    acestream-launcher acestream-engine\
    parsec-bin discord

HOME_ROOT_PREFIX=~/root
DWM_DIR=~/.config/dwm
XSESSIONS_DIR=/usr/share/xsessions

cd $DWM_DIR 
sudo make clean install
cd $DWM_DIR/dwmstatus
sudo make clean install
cd ~
sudo cp $HOME_ROOT_PREFIX$XSESSIONS_DIR/dwm.desktop $XSESSIONS_DIR

git clone https://github.com/marler8997/zigup.git ~/dev/zigup
cd ~/dev/zigup

git clone --recurse-submodules https://github.com/zigtools/zls.git ~/dev/zls
cd ~/dev/zls
$ZIG build -Drelease-fast

git clone https://github.com/davidgm94/rise.git ~/dev/rise
