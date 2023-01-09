#!/bin/sh
set -ex
# Get sway-nvidia helper
paru -S --needed sway-nvidia 
sudo ln -s /dev/null /etc/udev/rules.d/61-gdm.rules
MY_BOOTLOADER_DIR=/boot/loader/entries/
MY_BOOTLOADER_ENTRY_PATH=/boot/loader/entries/$(ls -Art $MY_BOOTLOADER_DIR | head -n1)
echo "$(<$MY_BOOTLOADER_ENTRY_PATH) nvidia-drm.modeset=1" > ~/mynvidiamodeset
sudo cp ~/mynvidiamodeset $MY_BOOTLOADER_ENTRY_PATH
rm -f ~/mynvidiamodeset
