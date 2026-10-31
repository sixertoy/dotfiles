# shellcheck shell=bash
# Prompt + écriture de _authToken dans ~/.npmrc (fichier local, pas le template dépôt)

_npmrc_has_auth_token() {
  local npmrc="$1"
  local line value

  [[ -f "$npmrc" ]] || return 1

  while IFS= read -r line || [[ -n "$line" ]]; do
    case "$line" in
      '//registry.npmjs.org/:_authToken='*)
        value="${line#*_authToken=}"
        if [[ -n "$value" && "$value" != *'${'* ]]; then
          return 0
        fi
        ;;
    esac
  done < "$npmrc"
  return 1
}

_npmrc_strip_auth_lines() {
  local npmrc="$1"
  local tmp

  tmp="$(mktemp)"
  grep -vE '^//registry\.npmjs\.org/:_authToken=' "$npmrc" > "$tmp" || true
  mv "$tmp" "$npmrc"
}

ensure_npm_token() {
  local npmrc="${HOME}/.npmrc"
  local token=""
  local tmp

  if [[ ! -f "$npmrc" ]]; then
    log_warn "~/.npmrc absent — skip token npm."
    return 0
  fi

  if _npmrc_has_auth_token "$npmrc"; then
    log_info "Token npm déjà présent dans ~/.npmrc — skip."
    return 0
  fi

  if [[ -t 0 ]]; then
    echo ""
    log_step "Token npm (registry.npmjs.org)"
    log_hint "Laisser vide pour ignorer (packages publics OK)."
    read -rsp "NPM token : " token || true
    echo ""
  else
    log_warn "Pas de TTY — token npm non demandé."
    return 0
  fi

  if [[ -z "$token" ]]; then
    log_warn "Token npm vide — ~/.npmrc sans _authToken."
    return 0
  fi

  # Si encore symlink vers le dépôt : matérialiser avant écriture
  if [[ -L "$npmrc" ]]; then
    tmp="$(mktemp)"
    cp -a "$(readlink "$npmrc")" "$tmp"
    rm -f "$npmrc"
    mv "$tmp" "$npmrc"
    log_ok "Materialize: $npmrc (copie locale)"
  fi

  _npmrc_strip_auth_lines "$npmrc"

  tmp="$(mktemp)"
  {
    echo "# Auth registry — injecté à l'install (ne pas committer)"
    echo "//registry.npmjs.org/:_authToken=${token}"
    echo ""
    cat "$npmrc"
  } > "$tmp"
  mv "$tmp" "$npmrc"
  chmod 600 "$npmrc"
  log_ok "Token npm écrit dans ~/.npmrc"
}
