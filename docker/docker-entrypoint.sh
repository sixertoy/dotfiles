#!/bin/bash
cp -a /mnt/dotfiles ~/.dotfiles
echo "------- Installation -------"
echo "cd ~/.dotfiles"
echo "./install/setup.sh ubuntu"
echo ""
exec "$@"
