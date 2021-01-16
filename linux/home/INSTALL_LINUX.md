# Install Linux

1. Se connecter au compte Ubuntu Single Sign-on
1. Activer LivePatch
1. Installer les mise à jour système
1. Installer les mise à jour logiciels depuis le store
1. Configurer les paramèters Ubuntu
  - **Bluetooth**  Souris MX Ergo
  - **Apparence**  mode sombre, afficher le dock sur tous les écrans, afficher le dock en bas, masquer le dock automatiquement
  - **Notifications**  Désactiver sur l'écran de verrouillage
  - **Energie**  Désactiver luminosité automatique
  - **Ecrans**  affichage 1680x1050 (16:10)
  - **Souris et pavé tactile**  Désactiver défilement naturel, Désactiver taper pour cliquer
  - **Média amovibles** Cocher `Ne jamais demander...`
1. Installer l'extension gnome-extensions pour Firefox
1. Installer Opera browser
  - Activer la synchronisation
  - Se connecter à Dashlane

## Development

1. Installer Tilix
  - Changer l'icone en éditant le fichier dans `/usr/share/applications`
  - Importer les préférences
1. Install GIT
  - Ajouter la clé SSH
1. Clone le repository `dotfiles`
1. Arrêter le serveur Apache par défaut
  - `sudo systemctl disable apache2 && sudo systemctl stop apache2`
1. Fira Code fonts
1. ctop.sh
1. NVM
  - `nvm install --lts`
1. Yarn
  - `sudo apt-get update && sudo apt-get install --no-install-recommends yarn`
1. Docker
1. Docker Compose
1. Add ssh key to Gitlab
  - `xclip -sel clip < ~/.ssh/github_rsa.pub`

## Tweaks

https://extensions.gnome.org/

- User themes
- Open weather
- Panel OSD
- Sound input & Output device chooser
- Tweaks in system menu
- System-monitor
  - `sudo apt install gir1.2-gtop-2.0 gir1.2-nm-1.0 gir1.2-clutter-1.0`

## Applications

### Depuis le web

- Atom
- Google chrome
  - Activer la synchronisation
  - Se connecter à Dashlane

### Depuis le store Ubuntu

- ClamTK
- Ajustements (Gnome Tweak)
- Dropbox
- Editeur Dconf `org/gnome/shell/extensions/dash-to-dock`
  - custom-theme-running-dots-color: #FFFFFF
  - dash-max-icon-size: 64
  - extend-height: false
  - show-apps-at-top: true
  - show-trash: true
- Visual Studio Code
- Spotify
- Steam
- Mattermost
- Discord

### Depuis un repository

- Noson
- Sublime Text 3
- Brave Browser

## Spectacle

```bash
# ~/.bashrc
export PATH="/home/matthieu/.bin:$PATH"
```

## keyboard & Shortcuts

### Installer clavier Apple Magic Keyboard

### Shortcuts

## Configuration

### Tilix
