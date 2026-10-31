#!/usr/bin/env zsh
# Login shell macOS — PATH / Homebrew / env (pas de modules interactifs).
# L’interactif vit dans ~/.zshrc → .load-modules.

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv zsh)"
fi

export HOMEBREW_BUNDLE_FILE_GLOBAL="${HOMEBREW_BUNDLE_FILE_GLOBAL:-$HOME/.Brewfile}"
