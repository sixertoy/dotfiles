# bash (Ubuntu) — à sourcer, ne pas exécuter (chargé par le .bashrc natif).
# Customs utilisateur + charge common/ubuntu shell depuis DOTFILES_ROOT.

export LESSCHARSET=utf-8

export DOTFILES_OS=ubuntu
export DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/.dotfiles}"

. "$DOTFILES_ROOT/files/common/shell/.load-modules"
