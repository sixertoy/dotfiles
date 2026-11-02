#!/usr/bin/env zsh

# Synchronisation interactive macOS (Homebrew + Mackup)
macsync() {
  local action

  print -P "\n%B%F{blue}==>%f%b Vérification des prérequis..."

  # 1. Vérification de Homebrew
  if ! command -v brew >/dev/null 2>&1; then
    print -P "  %F{red}✖ Erreur : Homebrew n'est pas installé.%f"
    print '  Veuillez l'\''installer via : /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    print "  Fin de l'opération.\n"
    return 1
  fi

  # 2. Vérification de Mackup
  if ! command -v mackup >/dev/null 2>&1; then
    print -P "  %F{red}✖ Erreur : Mackup n'est pas installé.%f"
    print "  Veuillez l'installer via : brew install mackup"
    print "  Fin de l'opération.\n"
    return 1
  fi

  # 3. Sécurisation de la variable globale pour utiliser le flag --global
  export HOMEBREW_BUNDLE_FILE_GLOBAL="${HOME}/.Brewfile"

  # 4. Menu interactif
  print "\nQue souhaitez-vous faire ?"
  print -P "  [1] %F{green}Backup%f  (Sauvegarder le Mac actuel vers iCloud)"
  print -P "  [2] %F{yellow}Restore%f (Restaurer iCloud sur ce Mac)"
  print "  [q] Quitter"
  read -r "action?Votre choix [1/2/q] : "

  case "${action}" in
    1|[Bb]ackup)
      print -P "\n%B%F{blue}==>%f%b %F{green}Lancement de la SAUVEGARDE...%f"
      print "\n[1/3] Génération du Brewfile (--global)..."
      brew bundle dump --global --force

      print "\n[2/3] Sauvegarde Mackup vers iCloud..."
      mackup backup --force

      print "\n[3/3] Vérification des liens symétriques..."
      ls -la "${HOME}/.Brewfile" "${HOME}/Library/Mobile Documents/com~apple~CloudDocs/Mackup/.Brewfile" 2>/dev/null

      print -P "\n%F{green}✔ Backup terminé avec succès !%f\n"
      ;;

    2|[Rr]estore)
      print -P "\n%B%F{blue}==>%f%b %F{yellow}Lancement de la RESTAURATION...%f"
      print "\n[1/2] Restauration Mackup depuis iCloud..."
      mackup restore --force

      print "\n[2/2] Installation des paquets via le Brewfile (--global)..."
      brew bundle --global

      print -P "\n%F{green}✔ Restauration terminée avec succès !%f\n"
      ;;

    *)
      print "\nAction annulée.\n"
      ;;
  esac
}
