#!/usr/bin/env bash

# ########################################
#
# Dotfiles — installation 100 % bash
# Usage: ./setup.sh [ubuntu|macos]
#
# ########################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for f in \
  log \
  require-machine \
  check-dotfiles-root \
  link-file \
  merge-tree \
  link-machine-files \
  parse-ini-section \
  ensure-packages \
  ensure-dconf-ubuntu \
  ensure-fnm \
  ensure-npm-token \
  ensure-ssh-key \
  bootstrap-node
do
  # shellcheck source=/dev/null
  source "$SCRIPT_DIR/lib/${f}.sh"
done

export DOTFILES_ROOT="${DOTFILES_ROOT:-$(pwd)}"
check_dotfiles_root

MACHINE="${1:-}"
if [[ -z "$MACHINE" ]]; then
  log_title "Dotfiles — installation"
  echo ""
  PS3="Quel type de machine ? "
  select MACHINE in ubuntu macos; do
    require_machine "$MACHINE" 2>/dev/null && break
    log_err "Choix invalide."
  done
fi

require_machine "$MACHINE"

log_step "ensure_packages $MACHINE"
ensure_packages "$MACHINE"

log_step "link_machine_files $MACHINE"
link_machine_files "$MACHINE"

log_step "ensure_npm_token"
ensure_npm_token

log_step "ensure_ssh_key"
ensure_ssh_key

if [[ "$MACHINE" == "ubuntu" ]]; then
  log_step "ensure_dconf_ubuntu"
  ensure_dconf_ubuntu
fi

log_step "bootstrap_node $MACHINE"
bootstrap_node "$MACHINE"

activate="bash_aliases"
[[ "$MACHINE" == "macos" ]] && activate="zshrc"

echo ""
log_ok "Installation $MACHINE terminée."
log_hint "Dans ce terminal : source ~/.$activate"
