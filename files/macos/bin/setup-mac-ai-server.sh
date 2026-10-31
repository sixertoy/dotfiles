#!/usr/bin/env bash
# ==============================================================================
# Script d'optimisation macOS Headless AI Server (Apple Silicon 32 Go)
# Idempotent : peut être relancé sans effet de bord.
# ==============================================================================

set -euo pipefail

# --- 0. Vérifications de sécurité & Variables ---
if [[ $EUID -eq 0 ]]; then
  echo "❌ ERREUR : Ne lancez pas ce script avec 'sudo'."
  echo "   Exécutez-le avec votre utilisateur standard (./setup-mac-ai-server.sh)."
  echo "   Le script demandera le mot de passe sudo uniquement quand nécessaire."
  exit 1
fi

USER_NAME=$(id -un)
USER_UID=$(id -u)
USER_GROUP=$(id -gn)
USER_HOME="$HOME"
VRAM_LIMIT_MB=28672 # 28 Go (sur 32 Go physiques)

# Détection automatique du binaire Ollama
OLLAMA_BIN=$(command -v ollama || echo "/opt/homebrew/bin/ollama")
if [[ ! -x "$OLLAMA_BIN" ]]; then
  echo "⚠️  Attention : Binaire Ollama introuvable à $OLLAMA_BIN."
  echo "   Assurez-vous qu'Ollama est installé avant de démarrer le service."
fi

echo "🔐 Authentification administrateur requise pour les réglages système..."
sudo -v

# Maintien du ticket sudo actif pendant l'exécution du script
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ==============================================================================
# 1. Gestion de l'énergie (pmset - Serveur 24/7)
# ==============================================================================
echo "⚡ [1/6] Configuration de la gestion d'énergie (pmset)..."

sudo pmset -a sleep 0
sudo pmset -a disksleep 0
sudo pmset -a disablesleep 1
sudo pmset -a womp 1
sudo pmset -a autorestart 1
sudo pmset -a displaysleep 1
sudo pmset -a powernap 0

# ==============================================================================
# 2. Désactivation de Spotlight
# ==============================================================================
echo "🔍 [2/6] Désactivation de l'indexation Spotlight..."

sudo mdutil -a -i off >/dev/null 2>&1 || true
sudo mdutil -a -E >/dev/null 2>&1 || true

# ==============================================================================
# 3. Désactivation des agents et démons superflus (Siri, Analyse, Télémétrie)
# ==============================================================================
echo "🧹 [3/6] Désactivation des services inutiles en mode headless..."

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
  sudo launchctl disable "gui/${USER_UID}/${agent}" 2>/dev/null || true
  launchctl bootout "gui/${USER_UID}/${agent}" 2>/dev/null || true
done

SYSTEM_DAEMONS=(
  "com.apple.analyticsd"
  "com.apple.SubmitDiagInfo"
  "com.apple.ReportCrash.Root"
  "com.apple.backupd"
  "com.apple.backupd-helper"
)

for daemon in "${SYSTEM_DAEMONS[@]}"; do
  sudo launchctl disable "system/${daemon}" 2>/dev/null || true
  sudo launchctl bootout "system/${daemon}" 2>/dev/null || true
done

# Allègement de WindowServer, du Finder et désactivation des màj auto
defaults write com.apple.universalaccess reduceTransparency -bool true
defaults write com.apple.universalaccess reduceMotion -bool true
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write com.apple.dashboard mcx-disabled -bool true
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool false
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool false

# ==============================================================================
# 4. Plafond VRAM GPU (iogpu.wired_limit_mb)
# ==============================================================================
echo "🧠 [4/6] Configuration du plafond VRAM GPU à ${VRAM_LIMIT_MB} Mo (28 Go)..."

sudo sysctl -w iogpu.wired_limit_mb=${VRAM_LIMIT_MB} >/dev/null

VRAM_PLIST="/Library/LaunchDaemons/com.local.gpu-vram-limit.plist"

sudo tee "$VRAM_PLIST" > /dev/null << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.local.gpu-vram-limit</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/sbin/sysctl</string>
        <string>-w</string>
        <string>iogpu.wired_limit_mb=${VRAM_LIMIT_MB}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

sudo chown root:wheel "$VRAM_PLIST"
sudo chmod 644 "$VRAM_PLIST"
sudo plutil -lint "$VRAM_PLIST" >/dev/null

# Idempotence launchd : déchargement préalable si déjà présent
sudo launchctl bootout system/com.local.gpu-vram-limit 2>/dev/null || true
sudo launchctl bootstrap system "$VRAM_PLIST"
sudo launchctl kickstart -k system/com.local.gpu-vram-limit

# ==============================================================================
# 5. Rotation des logs (newsyslog)
# ==============================================================================
echo "📜 [5/6] Configuration de la rotation des logs (newsyslog)..."

# Création préventive des fichiers de logs avec les bons droits
touch /tmp/ollama.out.log /tmp/ollama.err.log
chown "${USER_NAME}:${USER_GROUP}" /tmp/ollama.out.log /tmp/ollama.err.log
chmod 644 /tmp/ollama.out.log /tmp/ollama.err.log

NEWSYSLOG_CONF="/etc/newsyslog.d/ollama.conf"

sudo tee "$NEWSYSLOG_CONF" > /dev/null << EOF
# logfilename          [owner:group]              mode  count  size   when  flags
/tmp/ollama.out.log    ${USER_NAME}:${USER_GROUP}  644   5      10240  *     JN
/tmp/ollama.err.log    ${USER_NAME}:${USER_GROUP}  644   5      10240  *     JN
EOF

sudo chown root:wheel "$NEWSYSLOG_CONF"
sudo chmod 644 "$NEWSYSLOG_CONF"

# ==============================================================================
# 6. Service LaunchAgent Ollama
# ==============================================================================
echo "🦙 [6/6] Déploiement du service LaunchAgent Ollama..."

# Arrêt des éventuelles instances concurrentes (Homebrew ou App GUI)
brew services stop ollama >/dev/null 2>&1 || true
pkill -f "Ollama.app" 2>/dev/null || true

mkdir -p "${USER_HOME}/Library/LaunchAgents"
OLLAMA_PLIST="${USER_HOME}/Library/LaunchAgents/com.user.ollama.plist"

cat << EOF > "$OLLAMA_PLIST"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.ollama</string>
    <key>UserName</key>
    <string>${USER_NAME}</string>
    <key>ProgramArguments</key>
    <array>
        <string>${OLLAMA_BIN}</string>
        <string>serve</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
        <key>HOME</key>
        <string>${USER_HOME}</string>
        <key>OLLAMA_HOST</key>
        <string>0.0.0.0:11434</string>
        <key>OLLAMA_FLASH_ATTENTION</key>
        <string>1</string>
        <key>OLLAMA_KV_CACHE_TYPE</key>
        <string>q8_0</string>
        <key>OLLAMA_KEEP_ALIVE</key>
        <string>24h</string>
        <key>OLLAMA_MAX_LOADED_MODELS</key>
        <string>3</string>
        <key>OLLAMA_NUM_PARALLEL</key>
        <string>2</string>
        <key>OLLAMA_NOPRUNE</key>
        <string>1</string>
    </dict>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>ThrottleInterval</key>
    <integer>5</integer>
    <key>ProcessType</key>
    <string>Interactive</string>
    <key>SoftResourceLimits</key>
    <dict>
        <key>NumberOfFiles</key>
        <integer>65536</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>/tmp/ollama.out.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/ollama.err.log</string>
</dict>
</plist>
EOF

chmod 644 "$OLLAMA_PLIST"
plutil -lint "$OLLAMA_PLIST" >/dev/null

# Idempotence launchd : déchargement préalable si le service tourne déjà
launchctl bootout "gui/${USER_UID}/com.user.ollama" 2>/dev/null || true
launchctl bootstrap "gui/${USER_UID}" "$OLLAMA_PLIST"
launchctl kickstart -k "gui/${USER_UID}/com.user.ollama"

# ==============================================================================
# Résumé de validation
# ==============================================================================
echo ""
echo "✅ Configuration terminée avec succès !"
echo "----------------------------------------------------------------------"
echo " • Plafond VRAM actif   : $(sysctl -n iogpu.wired_limit_mb) Mo"
echo " • Service Ollama (PID) : $(launchctl list | awk '/com.user.ollama/ {print $1}')"
echo " • Rotation newsyslog   : $(sudo newsyslog -nvv -f "$NEWSYSLOG_CONF" | grep -c '/tmp/ollama') fichiers suivis"
echo "----------------------------------------------------------------------"
echo "💡 Conseil : Redémarrez une fois le Mac (sudo reboot) pour finaliser"
echo "   la libération mémoire des démons désactivés."
