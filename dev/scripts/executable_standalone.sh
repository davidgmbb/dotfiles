#!/bin/sh
set -ex
chezmoi init https://github.com/davidgmbb/dotfiles.git
chezmoi apply

~/dev/scripts/base.sh
