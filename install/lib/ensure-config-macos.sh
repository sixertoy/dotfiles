# shellcheck shell=bash
# Applique la config système macOS (hostname, prefs user, partage, énergie).

_macos_defaults_bool() {
  local domain="$1" key="$2" want="$3" label="$4"
  local current want_num

  if [[ "$want" == "true" ]]; then
    want_num=1
  else
    want_num=0
  fi

  current="$(defaults read "$domain" "$key" 2>/dev/null || echo "")"
  if [[ "$current" == "$want_num" ]]; then
    log_ok "$label déjà défini"
    return 0
  fi

  defaults write "$domain" "$key" -bool "$want"
  log_ok "$label"
  _macos_prefs_changed=1
}

_macos_defaults_string() {
  local domain="$1" key="$2" want="$3" label="$4"
  local current

  current="$(defaults read "$domain" "$key" 2>/dev/null || echo "")"
  if [[ "$current" == "$want" ]]; then
    log_ok "$label déjà défini"
    return 0
  fi

  defaults write "$domain" "$key" -string "$want"
  log_ok "$label"
  _macos_prefs_changed=1
}

_macos_ensure_launch_daemon() {
  local label="$1" plist="$2" label_human="$3"
  local loaded=0

  if [[ ! -f "$plist" ]]; then
    log_warn "$label_human : plist absent ($plist) — skip"
    return 0
  fi

  if launchctl print "system/$label" >/dev/null 2>&1; then
    loaded=1
  elif launchctl list 2>/dev/null | grep -q "$label"; then
    loaded=1
  fi

  if [[ "$loaded" -eq 1 ]]; then
    log_ok "$label_human déjà actif"
    return 0
  fi

  log_info "$label_human → ON"
  if sudo launchctl bootstrap system "$plist" 2>/dev/null \
    || sudo launchctl load -w "$plist" 2>/dev/null; then
    log_ok "$label_human activé"
  else
    log_warn "$label_human : échec activation — vérifier Réglages → Partage"
  fi
}

ensure_config_macos() {
  local hostname="apres-le-mini-golf"
  local key current need_set=0
  local scroll_current remotelogin womp
  _macos_prefs_changed=0

  # --- Hostname ---
  for key in ComputerName LocalHostName HostName; do
    current="$(scutil --get "$key" 2>/dev/null || true)"
    if [[ "$current" != "$hostname" ]]; then
      need_set=1
      break
    fi
  done

  if [[ "$need_set" -eq 0 ]]; then
    log_ok "Hostname déjà défini : $hostname"
  else
    log_info "Hostname → $hostname (ComputerName / LocalHostName / HostName)"
    sudo scutil --set ComputerName "$hostname"
    sudo scutil --set LocalHostName "$hostname"
    sudo scutil --set HostName "$hostname"
    log_ok "Hostname défini : $hostname"
  fi

  # --- Prefs utilisateur ---
  scroll_current="$(defaults read -g com.apple.swipescrolldirection 2>/dev/null || echo "")"
  if [[ "$scroll_current" == "0" ]]; then
    log_ok "Défilement naturel OFF déjà défini"
  else
    defaults write -g com.apple.swipescrolldirection -bool false
    log_ok "Défilement naturel → OFF"
    log_warn "Défilement : une déconnexion / reconnexion peut être nécessaire"
    _macos_prefs_changed=1
  fi

  _macos_defaults_bool com.apple.dock minimize-to-application true \
    "Dock : minimiser dans l'icône de l'app"
  _macos_defaults_bool com.apple.dock show-recents false \
    "Dock : apps récentes OFF"
  _macos_defaults_bool -g _HIHideMenuBar false \
    "Barre des menus : auto-masquage OFF"
  _macos_defaults_bool com.apple.controlcenter "NSStatusItem Visible Bluetooth" true \
    "Barre des menus : Bluetooth"
  _macos_defaults_bool com.apple.controlcenter "NSStatusItem Visible Weather" true \
    "Barre des menus : Météo"
  _macos_defaults_string com.apple.finder NewWindowTarget PfHm \
    "Finder : nouvelles fenêtres → dossier de départ"

  current="$(defaults read com.apple.finder NewWindowTargetPath 2>/dev/null || echo "")"
  if [[ "$current" == "file://${HOME}/" ]]; then
    log_ok "Finder : NewWindowTargetPath déjà défini"
  else
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
    log_ok "Finder : NewWindowTargetPath → file://${HOME}/"
    _macos_prefs_changed=1
  fi

  if [[ "$_macos_prefs_changed" -eq 1 ]]; then
    killall Dock SystemUIServer Finder 2>/dev/null || true
  fi

  # --- Services / système ---
  remotelogin="$(sudo systemsetup -getremotelogin 2>/dev/null || true)"
  if [[ "$remotelogin" == *"On"* ]]; then
    log_ok "Session distante (SSH) déjà ON"
  else
    log_info "Session distante (SSH) → ON"
    sudo systemsetup -f -setremotelogin on
    log_ok "Session distante (SSH) activée"
  fi

  _macos_ensure_launch_daemon com.apple.smbd \
    /System/Library/LaunchDaemons/com.apple.smbd.plist \
    "Partage de fichiers (SMB)"

  _macos_ensure_launch_daemon com.apple.screensharing \
    /System/Library/LaunchDaemons/com.apple.screensharing.plist \
    "Partage d'écran"

  womp="$(pmset -g custom 2>/dev/null | awk '/[[:space:]]womp[[:space:]]/{print $2; exit}')"
  if [[ -z "$womp" ]]; then
    womp="$(pmset -g 2>/dev/null | awk '/[[:space:]]womp[[:space:]]/{print $2; exit}')"
  fi
  if [[ "$womp" == "1" ]]; then
    log_ok "Réactiver lors des accès réseau déjà ON"
  else
    log_info "Réactiver lors des accès réseau → ON"
    sudo pmset -a womp 1
    log_ok "Wake-on-LAN (womp) activé"
  fi
}
