#!/bin/bash
YAYDIR=~/programs/yay-bin

sudo pacman -S git firefox telegram-desktop signal-desktop lm_sensors htop alacritty kitty wezterm discord gdb neovim ripgrep bat qemu qemu-arch-extra rust-analyzer rustup mpv vlc smplayer nodejs tokei nushell bash-completion libreoffice xorriso llvm cmake ttf-fira-mono ttf-fira-code ttf-fira-sans ttf-dejavu ttf-liberation noto-fonts man dmenu nvidia-settings pavucontrol xclip lld clang evince playerctl unzip zip unrar tree ninja fd zsh arandr bluez bluez-utils nasm ctags xorg-xbacklight pacman-contrib qbittorrent xorg-xkill perf xfce4-goodies xfce4 mate-extra gparted mtools &&\


chsh -s /usr/bin/zsh &&\

git clone https://github.com/marler8997/zigup ~/dev/zigup &&\
yay -S zig-dev-bin &&\
cd ~/dev/zigup && zig build -Drelease-fast -Dfetch &&\
yay -R zig-dev-bin &&\
source update_zig.sh &&\

git clone https://github.com/zigtools/zls.git --recurse-submodules ~/dev/zls &&\
cd ~/dev/zls && ~/dev/zigup/zig-out/bin/zig build -Drelease-fast && cd ~ &&\

git clone https://github.com/nakst/gf.git ~/dev/gf
cd ~/dev/gf && ./build.sh && cd ~ &&\

git clone https://github.com/davidgm94/rise ~/dev/rise &&\

rustup toolchain install stable &&\

sudo pacman -S --needed git base-devel &&\
git clone https://aur.archlinux.org/yay-bin.git $YAYDIR &&\
cd $YAYDIR &&\
makepkg -si &&\
yay -Syyu &&\
yay -S acestream-launcher acestream-engine parsec-bin && cd ~

