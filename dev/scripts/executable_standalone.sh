#!/bin/sh
set -ex
chezmoi init https://github.com/davidgm94/dotfiles.git 
chezmoi apply

~/dev/scripts/base.sh
