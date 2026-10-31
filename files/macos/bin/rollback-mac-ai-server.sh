#!/usr/bin/env bash
# ==============================================================================
# Script de Rollback - Restauration des paramètres d'usine macOS
# Annule les optimisations du script setup-mac-ai-server.sh
# ==============================================================================

set -euo pipefail

# --- 0. Vérifications de sécurité & Variables ---
if [[ $EUID -eq 0 ]]; then
  echo "❌ ERREUR : Ne lancez pas ce script avec 'sudo'."
  echo "   Exécutez-le avec votre utilisateur standard (./rollback-mac-ai-server.sh)."
  exit 1
fi

USER_UID=$(id -u)
USER_HOME="$HOME"

echo "🔐 Authentification administrateur requise pour la restauration système..."
sudo -v

# Maintien du ticket sudo actif pendant l'exécution
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ==============================================================================
# 1. Restauration de la gestion d'énergie (Valeurs par défaut Mac mini)
# ==============================================================================
echo "⚡ [1/6] Restauration des paramètres d'énergie par défaut (pmset)..."

sudo pmset -a disablesleep 0
sudo pmset -a sleep 1
sudo pmset -a disksleep 10
sudo pmset -a displaysleep 10
sudo pmset -a womp 1
sudo pmset -a autorestart 0
sudo pmset -a powernap 1

# ==============================================================================
# 2. Réactivation de l'indexation Spotlight
# ==============================================================================
echo "🔍 [2/6] Réactivation de Spotlight..."

sudo mdutil -a -i on >/dev/null 2>&1 || true

# ==============================================================================
# 3. Réactivation des agents utilisateurs, démons et préférences GUI
# ==============================================================================
echo "🔄 [3/6] Réactivation des services macOS (Siri, Analyse, Continuité, MàJ)..."

USER_AGENTS=(
  "com.apple.mediaanalysisd"
  "com.apple.photoanalysisd"
  "com.apple.photolibraryd"
  "com.apple.assistantd"
  "com.apple.siriknowledged"
  "com.apple.corespeechd"
  "com.apple.parsecd"
  "com.apple.sharingd"
  "com.apple.rapportd"
  "com.apple.replayd"
  "com.apple.ScreenTimeAgent"
  "com.apple.UsageTrackingAgent"
  "com.apple.homed"
  "com.apple.CloudPhotosConfiguration"
)

for agent in "${USER_AGENTS[@]}"; do
  sudo launchctl enable "gui/${USER_UID}/${agent}" 2>/dev/null || true
done

SYSTEM_DAEMONS=(
  "com.apple.analyticsd"
  "com.apple.SubmitDiagInfo"
  "com.apple.ReportCrash.Root"
  "com.apple.backupd"
  "com.apple.backupd-helper"
)

for daemon in "${SYSTEM_DAEMONS[@]}"; do
  sudo launchctl enable "system/${daemon}" 2>/dev/null || true
done

# Restauration des animations, transparence et comportements Finder/Session
defaults delete com.apple.universalaccess reduceTransparency 2>/dev/null || true
defaults delete com.apple.universalaccess reduceMotion 2>/dev/null || true
defaults delete NSGlobalDomain NSAutomaticWindowAnimationsEnabled 2>/dev/null || true
defaults delete com.apple.dashboard mcx-disabled 2>/dev/null || true
defaults delete com.apple.loginwindow TALLogoutSavesState 2>/dev/null || true
defaults delete com.apple.desktopservices DSDontWriteNetworkStores 2>/dev/null || true
defaults delete com.apple.desktopservices DSDontWriteUSBStores 2>/dev/null || true

# Réactivation des mises à jour automatiques macOS
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool true

# ==============================================================================
# 4. Suppression du plafond VRAM personnalisé (Retour à la gestion auto 75%)
# ==============================================================================
echo "🧠 [4/6] Réinitialisation de la limite VRAM GPU (Mode automatique Apple)..."

VRAM_PLIST="/Library/LaunchDaemons/com.local.gpu-vram-limit.plist"

sudo launchctl bootout system/com.local.gpu-vram-limit 2>/dev/null || true
sudo rm -f "$VRAM_PLIST"

# 0 = Rend la main au noyau XNU pour gérer dynamiquement la limite (~75% de la RAM)
sudo sysctl -w iogpu.wired_limit_mb=0 >/dev/null

# ==============================================================================
# 5. Suppression de la règle newsyslog et des logs temporaires
# ==============================================================================
echo "📜 [5/6] Nettoyage de la configuration newsyslog..."

sudo rm -f /etc/newsyslog.d/ollama.conf
sudo rm -f /tmp/ollama.out.log* /tmp/ollama.err.log*

# ==============================================================================
# 6. Suppression du LaunchAgent Ollama personnalisé
# ==============================================================================
echo "🦙 [6/6] Arrêt et suppression du LaunchAgent Ollama personnalisé..."

OLLAMA_PLIST="${USER_HOME}/Library/LaunchAgents/com.user.ollama.plist"

launchctl bootout "gui/${USER_UID}/com.user.ollama" 2>/dev/null || true
rm -f "$OLLAMA_PLIST"

# ==============================================================================
# Résumé de validation
# ==============================================================================
echo ""
echo "✅ Restauration terminée avec succès !"
echo "----------------------------------------------------------------------"
echo " • Plafond VRAM (0 = Auto) : $(sysctl -n iogpu.wired_limit_mb)"
echo " • Statut Spotlight        : $(mdutil -s / | awk -F': ' '/Indexing/ {print $2}')"
echo "----------------------------------------------------------------------"
echo "💡 Important : Redémarrez le Mac (sudo reboot) pour que macOS relance"
echo "   proprement tous les agents système et graphiques par défaut."
