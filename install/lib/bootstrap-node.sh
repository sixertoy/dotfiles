# shellcheck shell=bash
# Installe Node LTS + yarn via fnm (idempotent ; nécessite ensure_fnm)

bootstrap_node() {
  local machine="${1:-}"
  local shell_name

  require_machine "$machine" || return 1

  if command -v node >/dev/null 2>&1 && command -v yarn >/dev/null 2>&1; then
    log_info "Node ($(node -v)) et Yarn ($(yarn -v)) déjà présents — skip bootstrap."
    return 0
  fi

  ensure_fnm "$machine"

  if ! command -v fnm >/dev/null 2>&1; then
    if [[ -x "${HOME}/.local/share/fnm/fnm" ]]; then
      export PATH="${HOME}/.local/share/fnm:${PATH}"
    elif [[ -x "${HOME}/Library/Application Support/fnm/fnm" ]]; then
      export PATH="${HOME}/Library/Application Support/fnm:${PATH}"
    fi
  fi

  if ! command -v fnm >/dev/null 2>&1; then
    log_err "fnm introuvable après tentative d'installation."
    return 1
  fi

  # Mapping OS → shell interactif (setup.sh tourne en bash même sur macOS)
  case "$machine" in
    macos) shell_name="zsh" ;;
    *) shell_name="bash" ;;
  esac

  eval "$(fnm env --shell "$shell_name")"
  fnm install --lts
  fnm use lts-latest
  fnm default lts-latest

  if ! command -v yarn >/dev/null 2>&1; then
    npm install -g yarn --allow-scripts=yarn
  fi

  log_ok "Node ($(node -v)) et Yarn ($(yarn -v)) prêts."
}
