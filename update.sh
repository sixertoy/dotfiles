#!/usr/bin/env bash

# ########################################
#
# Usage
# ```bash
# source update.sh
# ```
#
# Description:
#
# - install user default shell files for aliases/functions
#

printf "\n"
printf "\33[01;33m"
printf "Copying user's shell configuration in home folder..."
printf "\33[m"
printf "\n"

function copyFiles() {
  rsync --exclude ".git/" \
    --exclude ".DS_Store" \
    --exclude "update.sh" \
    -avh --no-perms . ~;
  source ~/.bashrc;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  copyFiles;
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
  printf "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    copyFiles;
  fi;
fi;

unset copyFiles;

printf "\n"
printf "\33[01;33m"
printf "Files installed\n"
printf "Please change your <username> in ~/.npmrc and ~/.gitconfig files..."
printf "\33[m"
printf "\n"
