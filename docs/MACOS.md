# 🖥️ Installation Mac Mini M6 (Headless)

| Paramètre                        | Valeur               |
| :------------------------------- | :------------------- |
| **Nom complet**                  | Matthieu Lassalvy    |
| **Nom d'utilisateur**            | `matthieu`           |
| **Nom de la machine (Hostname)** | `apres-le-mini-golf` |
| **IP locale (Statique)**         | `192.168.0.200`      |

---

## 1. Configuration macOS (Interface graphique)

### Finder

- [x] **Réglages** → **Général** → _Les nouvelles fenêtres du Finder affichent_ : `matthieu` (Dossier de départ)
- [x] **Réglages** → **Barre latérale** → _Favoris_ : Cocher `Images`

### Réglages Système

#### Réseau & Partage (Prioritaire pour l'accès Headless)

- [x] **Wi-Fi** → **Détails...** → **TCP/IP** → _Configurer IPv4_ : `Manuellement` → `192.168.0.200`
- [x] **Général** → **Partage** :
  - [x] _Partage de fichiers_ : `ON`
  - [x] _Partage d'écran_ : `ON`
  - [x] _Session à distance (SSH)_ : `ON`

#### Énergie & Session (Fonctionnement serveur 24/7)

- [ ] **Énergie** :
  - [ ] _Empêcher la suspension d’activité automatique du Mac quand l’écran est éteint_ : `ON`
  - [ ] _Réactiver lors des accès réseau_ : `ON`
  - [ ] _Démarrer automatiquement après une panne de courant_ : `ON`
- [ ] **Utilisateurs et groupes** → _Ouverture de session automatique_ : Sélectionner `matthieu`
- [x] **Confidentialité et sécurité** → _FileVault_ : `OFF` _(requis pour le redémarrage sans saisie de mot de passe au boot)_
- [x] **Touch ID et mot de passe** → _Apple Watch_ : `ON`
- [ ] **Écran verrouillé** :
  - [ ] _Éteindre l'écran en cas d'inactivité_ : `Après 1 minute`
  - [ ] _Exiger le mot de passe après le début de l'économiseur d'écran ou la désactivation de l'écran_ : `Immédiatement`

#### Affichage, Interface & Périphériques

- [x] **Moniteurs** → _Résolution_ : `1280 x 720`
- [x] **Souris** → _Défilement naturel_ : `OFF`
- [x] **Bureau et Dock** :
  - [x] _Minimiser les fenêtres dans l'icône de l'application_ : `ON`
  - [x] _Afficher les apps suggérées et récentes dans le Dock_ : `OFF`
  - [x] _Widgets_ → _Afficher les widgets sur le bureau_ : `OFF`
- [x] **Barre des menus** :
  - [x] _Masquer et afficher automatiquement la barre des menus_ : `OFF`
  - [x] _Commandes de la barre des menus_ : Afficher `Bluetooth` et `Météo`

#### Notifications & Concentration

- [x] **Notifications** :
  - [x] _Afficher les aperçus_ : `Jamais`
  - [x] _Afficher les notifications lorsque l'écran est en veille_ : `OFF`
- [x] **Concentration** :
  - [x] Créer un nouveau mode `"Headless"` → _Programmation_ : `00:00 à 23:59`

---

## 2. Préparation Système & SSH

- [x] **Créer l'espace de travail et renommer la machine**

```bash
mkdir -p ~/Workspaces

sudo scutil --set ComputerName "apres-le-mini-golf"
sudo scutil --set LocalHostName "apres-le-mini-golf"
sudo scutil --set HostName "apres-le-mini-golf"
```

- [x] **Installer Homebrew**

Sur macOS le shell interactif est **zsh**. L’env login vit dans `~/.zprofile` ; la config interactive (modules dotfiles, prompt) dans `~/.zshrc`. Après `./install/setup.sh macos`, ces deux fichiers sont gérés par le dépôt — ne pas y append manuellement en double.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Session courante (avant le lien géré par les dotfiles) :
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
# Si les dotfiles ne sont pas encore installés, bootstrap temporaire du login env :
# echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> ~/.zprofile
# echo 'export HOMEBREW_BUNDLE_FILE_GLOBAL="$HOME/.Brewfile"' >> ~/.zprofile
```

---

## 3. Applications & Environnement de Développement

- [x] **Installer les applications (Casks) et outils CLI**

Installés automatiquement par `./install/setup.sh macos` depuis :

[`files/macos/packages.ini`](../files/macos/packages.ini) — `[cli]` (formulae) et `[gui]` (casks)

- [x] **Installer Rosetta 2 (nécessaire pour Steam)**

```bash
softwareupdate --install-rosetta --agree-to-license
```

- [x] **Installer et configurer fnm, Node LTS & Yarn**

```bash
# brew install fnm
eval "$(fnm env --shell zsh)"
fnm install --lts
fnm use lts-latest
fnm default lts-latest
npm install -g yarn --allow-scripts=yarn
```

- [x] **Configurer Git, GitHub CLI & Clé SSH**

`~/.ssh/config` et `id_ed25519.pub` sont installés par `setup.sh`. Restaurer la **privée** puis tester — voir [SSH.md](SSH.md).

```bash
# 1. Authentification via navigateur (Protocole : SSH -> https://github.com/login/device)
gh auth login -s admin:public_key

# 2. Trousseau + test (après restauration de ~/.ssh/id_ed25519)
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
ssh -T git@github.com
```

- [ ] **Cloner le dépôt `dotfiles` + `ai-toolkit`**

```bash
gh repo clone sixertoy/dotfiles ~/Workspaces/dotfiles
gh repo clone sixertoy/ai-toolkit ~/Workspaces/ai-toolkit
```

---

## 4. Sauvegarde & Restauration (Mackup & Brewfile)

### Initialisation (Première installation)

- [ ] **Configurer Mackup**

```bash
# brew install mackup
cat << 'EOF' > ~/.mackup.cfg
[storage]
engine = icloud
directory = Mackup
EOF
```

### Sauvegarde (Backup)

- [ ] **Exporter le Brewfile global et sauvegarder vers iCloud**

```bash
# 1. Générer de force le fichier à la racine de votre dossier utilisateur
brew bundle dump --file="$HOME/.Brewfile" --force --verbose

# 2. Relancer Mackup en affichant les détails (verbose) uniquement sur Brewfile
mackup backup --force --verbose

# 3. Vérifier le lien symbolique local ET le fichier dans iCloud
ls -la "$HOME/.Brewfile" "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Mackup/.Brewfile"
```

### Restauration (Sur une nouvelle machine)

- [ ] **Prérequis : Installer Homebrew** _(voir Section 2)_
- [ ] **Installer Mackup et restaurer l'environnement**

```bash
brew install mackup
mackup restore
brew bundle --global
```

---

## 5. Optionnel

- [ ] Installer [Logi Options+](https://www.logitech.com/fr-fr/software/logi-options-plus) _(ou via Homebrew : `brew install --cask logi-options-plus`)_
