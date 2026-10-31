#!/usr/bin/env zsh

# Basculer vers un réseau Wi-Fi préféré (zsh — tableaux 1-indexés)
function switch-wifi() {
  if [[ -z ${ZSH_VERSION:-} ]]; then
    echo "switch-wifi : zsh requis." >&2
    return 1
  fi

  local INTERFACE="en1"
  local current_ip cleaned_line choice selected_net
  local -a networks
  local i=1

  echo "=== Gestionnaire Wi-Fi ($INTERFACE) ==="
  current_ip=$(ipconfig getifaddr "$INTERFACE")
  if [[ -n "$current_ip" ]]; then
    echo "  -> IP actuelle sur $INTERFACE : $current_ip"
  else
    echo "  -> ⚠️ Pas d'adresse IP active sur $INTERFACE"
  fi
  echo ""

  networks=()
  while IFS= read -r line; do
    cleaned_line=$(echo "$line" | sed 's/^[ *]*//')
    if [[ -n "$cleaned_line" ]]; then
      networks+=("$cleaned_line")
    fi
  done < <(sudo networksetup -listpreferredwirelessnetworks "$INTERFACE" | tail -n +2)

  if [[ ${#networks[@]} -eq 0 ]]; then
    echo "Aucun réseau enregistré trouvé."
    return 1
  fi

  echo "Réseaux enregistrés :"
  for net in "${networks[@]}"; do
    echo "  [$i] $net"
    ((i++))
  done

  echo ""
  echo -n "Choisissez le numéro du réseau à connecter (ou 'q' pour quitter) : "
  read -r choice

  if [[ "$choice" == "q" || "$choice" == "Q" ]]; then
    return 0
  fi

  if [[ "$choice" =~ ^[0-9]+$ ]] && [[ "$choice" -ge 1 ]] && [[ "$choice" -le ${#networks[@]} ]]; then
    selected_net="${networks[$choice]}"
    echo "Connexion en cours à \"$selected_net\" sur $INTERFACE..."

    if sudo networksetup -setairportnetwork "$INTERFACE" "$selected_net"; then
      echo "✅ Basculement réussi vers $selected_net !"
    else
      echo "❌ Échec de la connexion (le réseau est peut-être hors de portée)."
      return 1
    fi
  else
    echo "Choix invalide."
    return 1
  fi
}
