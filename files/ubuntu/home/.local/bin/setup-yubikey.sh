#!/usr/bin/env bash
# Génère une clé SSH PIV (slot 9a) sur YubiKey 5C / 5C Nano via ykman,
# vérifie que les secrets d'usine ont été modifiés, exporte la clé publique
# OpenSSH et l'enregistre dans ssh-agent via PKCS#11.
set -euo pipefail

SLOT="${SLOT:-9a}"
ALGORITHM="${ALGORITHM:-ECCP256}"
SUBJECT="${SUBJECT:-CN=SSH Yubikey 5c}"
VALID_DAYS="${VALID_DAYS:-3650}"
PUB_OUT="${PUB_OUT:-$HOME/.ssh/id_yubikey_5c.pub}"
PIN_POLICY="${PIN_POLICY:-once}"
TOUCH_POLICY="${TOUCH_POLICY:-cached}"

resolve_ykcs11() {
  local candidate
  for candidate in \
    /usr/lib/x86_64-linux-gnu/libykcs11.so \
    /usr/lib/aarch64-linux-gnu/libykcs11.so \
    /usr/lib/libykcs11.so \
    /opt/homebrew/lib/libykcs11.dylib
  do
    if [[ -e "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
  return 1
}

die() {
  printf 'erreur: %s\n' "$*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "commande introuvable: $1"
}

check_piv_security() {
  local piv_info
  piv_info="$(ykman piv info 2>/dev/null)" \
    || die "Impossible de lire la YubiKey (vérifiez qu'elle est bien insérée et que pcscd est actif)."

  local has_default=0

  if grep -q "Using default PIN" <<< "$piv_info"; then
    printf '✗ Alerte sécurité : Le code PIN utilise toujours la valeur d usine (123456).\n' >&2
    has_default=1
  fi
  if grep -q "Using default PUK" <<< "$piv_info"; then
    printf '✗ Alerte sécurité : Le code PUK utilise toujours la valeur d usine (12345678).\n' >&2
    has_default=1
  fi
  if grep -q "Using default Management key" <<< "$piv_info"; then
    printf '✗ Alerte sécurité : La Management Key utilise toujours la valeur d usine.\n' >&2
    has_default=1
  fi

  if [[ "$has_default" -eq 1 ]]; then
    cat >&2 <<'EOF'

======================================================================
ARRÊT DU SCRIPT : Votre YubiKey n'est pas sécurisée.
Avant de générer une clé SSH, modifiez les secrets par défaut avec ykman :

  1. Modifier le code PIN (6 à 8 caractères) :
     ykman piv access change-pin

  2. Modifier le code PUK de déblocage (6 à 8 caractères) :
     ykman piv access change-puk

  3. Générer une Management Key aléatoire protégée par votre PIN :
     ykman piv access change-management-key --generate --protect

Relancez ce script une fois ces trois étapes effectuées.
======================================================================
EOF
    exit 1
  fi
}

need_cmd ykman
need_cmd ssh-keygen
need_cmd ssh-add
need_cmd ssh-agent

YKCS11="$(resolve_ykcs11)" || die "libykcs11.so introuvable (installez le paquet ykcs11)"

printf '→ Vérification de la sécurité PIV (PIN, PUK, Management Key)...\n'
check_piv_security
printf '✓ Les codes PIN, PUK et la Management Key ont bien été personnalisés.\n\n'

printf 'Attention : cette opération va écraser définitivement la clé du slot %s.\n' "$SLOT"
read -r -p "Continuer ? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || die "opération annulée par l'utilisateur"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

TMPDIR_WORK="$(mktemp -d "${TMPDIR:-/tmp}/yubikey-setup-5c.XXXXXX")"
cleanup() {
  rm -rf "$TMPDIR_WORK"
}
trap cleanup EXIT

PUB_PEM="$TMPDIR_WORK/pubkey.pem"

printf '→ Génération de la clé %s (slot %s, pin=%s, touch=%s)\n' \
  "$ALGORITHM" "$SLOT" "$PIN_POLICY" "$TOUCH_POLICY"
ykman piv keys generate \
  --algorithm "$ALGORITHM" \
  --pin-policy "$PIN_POLICY" \
  --touch-policy "$TOUCH_POLICY" \
  "$SLOT" "$PUB_PEM"

printf '→ Génération et import du certificat auto-signé (%s, %s jours)\n' "$SUBJECT" "$VALID_DAYS"
ykman piv certificates generate \
  --subject "$SUBJECT" \
  --valid-days "$VALID_DAYS" \
  "$SLOT" "$PUB_PEM"

printf '→ Export de la clé publique OpenSSH (filtrée) vers %s\n' "$PUB_OUT"
ssh-keygen -D "$YKCS11" -e | grep -v "PIV Attestation" > "$PUB_OUT"
chmod 644 "$PUB_OUT"

# Code retour ssh-add -l : 0 (clés présentes), 1 (agent vide), 2 (agent absent)
agent_status=0
ssh-add -l >/dev/null 2>&1 || agent_status=$?

if [[ -z "${SSH_AUTH_SOCK:-}" ]] || [[ "$agent_status" -eq 2 ]]; then
  eval "$(ssh-agent -s)"
  printf '→ ssh-agent démarré dans ce sous-processus\n'
  printf '  Pour le conserver dans votre shell :\n'
  printf '  export SSH_AUTH_SOCK=%q SSH_AGENT_PID=%q\n' \
    "$SSH_AUTH_SOCK" "$SSH_AGENT_PID"
fi

printf '→ Rechargement PKCS#11 (%s) dans ssh-agent — PIN demandé\n' "$YKCS11"
ssh-add -e "$YKCS11" >/dev/null 2>&1 || true
ssh-add -s "$YKCS11"

printf '\nOK. Clé publique prête :\n'
cat "$PUB_OUT"
printf '\nAjoutez-la sur GitHub ou dans authorized_keys, puis testez : ssh -T git@github.com\n'
