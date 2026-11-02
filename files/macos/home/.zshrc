#!/usr/bin/env zsh
# Interactif macOS — charge common + macos shell (prompt inclus).

export DOTFILES_OS=macos
export DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/.dotfiles}"

. "$DOTFILES_ROOT/files/common/shell/.load-modules"
