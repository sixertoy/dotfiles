# shellcheck shell=bash
# Charge files/ubuntu/dconf/*.dconf via dconf load (nom → /chemin/)
# Hors session graphique (Docker headless) : skip si machine-id / bus indisponibles,
# sinon enveloppe avec dbus-run-session.

_dconf_machine_id_ok() {
  local id=""
  if [[ -r /etc/machine-id ]]; then
    id="$(tr -d '[:space:]' < /etc/machine-id)"
  elif [[ -r /var/lib/dbus/machine-id ]]; then
    id="$(tr -d '[:space:]' < /var/lib/dbus/machine-id)"
  fi
  [[ "$id" =~ ^[0-9a-fA-F]{32}$ ]]
}

# En headless : pas de DBUS_SESSION_BUS_ADDRESS → dbus-run-session.
_dconf_load() {
  local path="$1" file="$2"
  if [[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
    dconf load "$path" < "$file"
  elif command -v dbus-run-session >/dev/null 2>&1; then
    dbus-run-session -- dconf load "$path" < "$file"
  else
    return 1
  fi
}

ensure_dconf_ubuntu() {
  local dconf_dir="${DOTFILES_ROOT}/files/ubuntu/dconf"
  local file name stem path count=0

  if ! command -v dconf >/dev/null 2>&1; then
    log_err "dconf introuvable (paquet dconf-cli)."
    return 1
  fi

  [[ -d "$dconf_dir" ]] || return 0

  if ! _dconf_machine_id_ok; then
    log_warn "machine-id invalide ou absent — dconf skip (normal en conteneur headless)."
    return 0
  fi

  if [[ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]] && ! command -v dbus-run-session >/dev/null 2>&1; then
    log_warn "Pas de session D-Bus ni dbus-run-session (paquet dbus-bin) — dconf skip."
    return 0
  fi

  shopt -s nullglob
  for file in "$dconf_dir"/*.dconf; do
    name="$(basename "$file")"
    stem="${name%.dconf}"
    path="/${stem//.//}/"

    log_info "dconf load $path ← $name"
    if ! _dconf_load "$path" "$file"; then
      log_warn "Échec dconf load $path — skip restant."
      shopt -u nullglob
      return 0
    fi
    count=$((count + 1))
  done
  shopt -u nullglob

  if [[ "$count" -eq 0 ]]; then
    log_info "Aucun fichier .dconf dans $dconf_dir — skip."
    return 0
  fi

  log_ok "dconf : $count dump(s) importé(s)."
}
