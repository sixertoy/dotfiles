# shellcheck shell=bash
# Applique la config système macOS (hostname via scutil).

ensure_config_macos() {
  local hostname="apres-le-mini-golf"
  local key current need_set=0

  for key in ComputerName LocalHostName HostName; do
    current="$(scutil --get "$key" 2>/dev/null || true)"
    if [[ "$current" != "$hostname" ]]; then
      need_set=1
      break
    fi
  done

  if [[ "$need_set" -eq 0 ]]; then
    log_ok "Hostname déjà défini : $hostname"
    return 0
  fi

  log_info "Hostname → $hostname (ComputerName / LocalHostName / HostName)"
  sudo scutil --set ComputerName "$hostname"
  sudo scutil --set LocalHostName "$hostname"
  sudo scutil --set HostName "$hostname"
  log_ok "Hostname défini : $hostname"
}
