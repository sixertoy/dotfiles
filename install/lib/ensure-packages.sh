# shellcheck shell=bash
# Installe les paquets OS (apt Ubuntu / brew macOS) depuis packages.ini [cli]/[gui]

_ensure_packages_ubuntu() {
  local list_file="${DOTFILES_ROOT}/files/ubuntu/packages.ini"
  local cli=() gui=() packages=()

  parse_ini_section "$list_file" cli cli || return 1
  parse_ini_section "$list_file" gui gui || return 1
  packages=("${cli[@]}" "${gui[@]}")

  if [[ ${#packages[@]} -eq 0 ]]; then
    log_err "Aucune entrée [cli]/[gui] dans $list_file"
    return 1
  fi

  log_info "apt : ${#packages[@]} paquet(s) depuis packages.ini"
  sudo apt-get update
  sudo apt-get install -y -- "${packages[@]}"
  log_ok "Paquets apt installés."
}

_ensure_packages_macos() {
  local list_file="${DOTFILES_ROOT}/files/macos/packages.ini"
  local cli=() gui=()

  if ! command -v brew >/dev/null 2>&1; then
    log_err "Homebrew requis (voir README / docs/MACOS.md)."
    return 1
  fi

  parse_ini_section "$list_file" cli cli || return 1
  parse_ini_section "$list_file" gui gui || return 1

  if [[ ${#cli[@]} -eq 0 && ${#gui[@]} -eq 0 ]]; then
    log_err "Aucune entrée [cli]/[gui] dans $list_file"
    return 1
  fi

  log_info "brew : ${#cli[@]} formule(s), ${#gui[@]} cask(s)"
  if [[ ${#cli[@]} -gt 0 ]]; then
    brew install "${cli[@]}"
  fi
  if [[ ${#gui[@]} -gt 0 ]]; then
    brew install --cask "${gui[@]}"
  fi
  log_ok "Paquets Homebrew installés."
}

ensure_packages() {
  local machine="${1:-}"
  require_machine "$machine" || return 1
  case "$machine" in
    ubuntu) _ensure_packages_ubuntu ;;
    macos) _ensure_packages_macos ;;
  esac
}
