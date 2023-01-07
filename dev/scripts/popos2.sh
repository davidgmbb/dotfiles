#!/bin/bash

# Copy them into .ssh
chmod 700 ~/.ssh
chmod 644 ~/.ssh/authorized_keys
chmod 644 ~/.ssh/known_hosts
chmod 644 ~/.ssh/config
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

git config --global init.defaultBranch main
git init
git remote add origin git@github.com:davidgm94/david.git

# Make sure you have your SSH password copied
git pull
rm .gitconfig .bashrc
# Fix more merge conflicts if they exist
git pull origin main
