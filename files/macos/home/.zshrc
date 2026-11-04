#!/usr/bin/env zsh
# Interactif macOS — charge common + macos shell (prompt inclus).

# Garantit que tout ajout ultérieur au PATH (par .load-modules) reste unique
typeset -U path PATH

export DOTFILES_OS=macos
export DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/.dotfiles}"

# Chargement sécurisé des modules partagés
if [[ -f "$DOTFILES_ROOT/files/common/shell/.load-modules" ]]; then
  . "$DOTFILES_ROOT/files/common/shell/.load-modules"
fi
