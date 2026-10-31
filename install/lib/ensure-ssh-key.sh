# shellcheck shell=bash
# Vérifie la présence de la clé privée SSH (ne génère rien)

ensure_ssh_key() {
  local key="${HOME}/.ssh/id_ed25519"
  local doc="${DOTFILES_ROOT:-$HOME/.dotfiles}/docs/SSH.md"

  if [[ -f "$key" ]]; then
    chmod 600 "$key" 2>/dev/null || true
    log_ok "Clé SSH privée présente (~/.ssh/id_ed25519)."
    return 0
  fi

  log_warn "Clé SSH privée absente : ~/.ssh/id_ed25519"
  log_hint "Restaurer depuis ta sauvegarde — voir ${doc}"
  log_hint "Ne pas régénérer : le .pub versionné / GitHub ne matcherait plus."
}
