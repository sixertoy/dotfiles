# shellcheck shell=bash
# Installe fnm selon la machine (curl Ubuntu / brew macOS)

_ensure_fnm_ubuntu() {
  if ! command -v unzip >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y unzip
  fi

  if command -v fnm >/dev/null 2>&1; then
    return 0
  fi

  if [[ ! -x "${HOME}/.local/share/fnm/fnm" ]]; then
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
  fi

  export PATH="${HOME}/.local/share/fnm:${PATH}"
}

_ensure_fnm_macos() {
  if ! command -v brew >/dev/null 2>&1; then
    log_err "Homebrew requis pour installer fnm sur macOS."
    return 1
  fi

  if command -v fnm >/dev/null 2>&1; then
    return 0
  fi

  brew install fnm
}

ensure_fnm() {
  local machine="${1:-}"
  require_machine "$machine" || return 1
  case "$machine" in
    ubuntu) _ensure_fnm_ubuntu ;;
    macos) _ensure_fnm_macos ;;
  esac
}
