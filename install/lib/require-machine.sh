# shellcheck shell=bash
# Valide ubuntu|macos ; log le fichier appelant (BASH_SOURCE)

require_machine() {
  local machine="${1:-}"
  local from

  case "$machine" in
    ubuntu | macos) return 0 ;;
    *)
      from="$(basename "${BASH_SOURCE[1]:-unknown}")"
      log_err "machine invalide (ubuntu|macos), reçu: ${machine:-<vide>} [$from]"
      return 1
      ;;
  esac
}
