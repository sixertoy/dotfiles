# 🖥️ Installation Mac Mini M6 (Headless)

| Paramètre                        | Valeur               |
| :------------------------------- | :------------------- |
| **Nom complet**                  | Matthieu Lassalvy    |
| **Nom d'utilisateur**            | `matthieu`           |
| **Nom de la machine (Hostname)** | `apres-le-mini-golf` |
| **IP locale (Statique)**         | `192.168.0.200`      |

## 1. Configuration macOS (Interface graphique)

### Réglages Système

#### Réseau & Partage (Prioritaire pour l'accès Headless)

- [ ] **Wi-Fi** → **Détails...** → **TCP/IP** → _Configurer IPv4_ : `Manuellement` → `192.168.0.200`

- [ ] **Énergie** :
  - [ ] _Empêcher la suspension d’activité automatique du Mac quand l’écran est éteint_ : `ON`
  - [ ] _Démarrer automatiquement après une panne de courant_ : `ON`
- [ ] **Utilisateurs et groupes** → _Ouverture de session automatique_ : Sélectionner `matthieu`
- [ ] **Confidentialité et sécurité** → _FileVault_ : `OFF` _(manuel — requis pour le redémarrage sans saisie de mot de passe au boot)_
- [ ] **Touch ID et mot de passe** → _Apple Watch_ : `ON`
- [ ] **Écran verrouillé** :
  - [ ] _Éteindre l'écran en cas d'inactivité_ : `Après 1 minute`
  - [ ] _Exiger le mot de passe après le début de l'économiseur d'écran ou la désactivation de l'écran_ : `Immédiatement`

#### Affichage, Interface & Périphériques

- [ ] **Moniteurs** → _Résolution_ : `1280 x 720`

#### Notifications & Concentration

- [ ] **Notifications** _(manuel — pas d’équivalent CLI fiable)_ :
  - [ ] _Afficher les aperçus_ : `Jamais`
  - [ ] _Afficher les notifications lorsque l'écran est en veille_ : `OFF`
- [ ] **Concentration** :
  - [ ] Créer un nouveau mode `"Headless"` → _Programmation_ : `00:00 à 23:59`

---

## 3. Applications & Environnement de Développement

- [ ] **Installer les applications (Casks) et outils CLI**

Installés automatiquement par `./install/setup.sh macos` depuis :

[`files/macos/packages.ini`](../files/macos/packages.ini) — `[cli]` (formulae) et `[gui]` (casks headless : antigravity-cli, dropbox).  
Section `[desktop]` : install manuelle — voir [README](../README.md#macos--apps-desktop-manuel).

- [ ] **Configurer Git, GitHub CLI & Clé SSH**

`~/.ssh/config` et `id_ed25519.pub` sont installés par `setup.sh`. Restaurer la **privée** puis tester — voir [SSH.md](SSH.md).

```bash
# 1. Authentification via navigateur (Protocole : SSH -> https://github.com/login/device)
gh auth login -s admin:public_key

# 2. Trousseau + test (après restauration de ~/.ssh/id_ed25519)
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
ssh -T git@github.com
```

## macOS — apps desktop (manuel)

Non installées par `./install/setup.sh`.

- [Antigravity CLI](https://antigravity.google/product/antigravity-cli)
- [Brave Browser](https://brave.com/fr/download/)
- [Cursor](https://cursor.com/fr/download)
- [Google Chrome](https://www.google.com/chrome/)
- [iTerm2](https://iterm2.com/)
- [Logi Options+](https://www.logitech.com/fr-fr/software/logi-options-plus.html)
- [Steam](https://store.steampowered.com/)
- [Sublime Text](https://www.sublimetext.com/download)
- [Visual Studio Code](https://code.visualstudio.com/)

```bash
brew install --cask antigravity-cli brave-browser cursor google-chrome iterm2 logi-options+ steam sublime-text visual-studio-code
```

- [x] **Installer Rosetta 2 (nécessaire pour Steam)**

```bash
softwareupdate --install-rosetta --agree-to-license
```
