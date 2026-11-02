# shellcheck shell=bash
# Vérifie que le dépôt est dans ~/.dotfiles et exporte DOTFILES_ROOT

check_dotfiles_root() {
  local expected="$HOME/.dotfiles"
  local actual="${DOTFILES_ROOT:-}"

  if [[ -z "$actual" ]]; then
    actual="$(cd "$(dirname "${BASH_SOURCE[1]}")/.." && pwd)"
  fi

  if [[ "$(cd "$actual" && pwd)" != "$(cd "$expected" && pwd 2>/dev/null || echo "")" ]]; then
    log_err "Le dépôt doit être cloné dans $expected (actuel: $actual)."
    log_err "Exemple: git clone git@github.com:sixertoy/dotfiles.git ~/.dotfiles"
    return 1
  fi

  export DOTFILES_ROOT="$expected"
}
