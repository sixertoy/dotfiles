# Install Linux

1. Se connecter au compte Ubuntu Single Sign-on
1. Activer LivePatch
1. Installer les mise à jour système
1. Installer les mise à jour logiciels depuis le store
1. Configurer les paramèters Ubuntu
  - **Bluetooth**
    - Souris MX Ergo
  - **Apparence**
    - Mode sombre
    - Afficher le dock sur tous les écrans
    - Afficher le dock en bas
    - Masquer le dock automatiquement
  - **Notifications**
    - Désactiver sur l'écran de verrouillage
  - **Energie**
    - Désactiver luminosité automatique
  - **Ecrans**
    - Affichage 1680x1050 (16:10)
  - **Souris et pavé tactile**
    - Désactiver défilement naturel
    - Désactiver taper pour cliquer
  - **Média amovibles**
    - Cocher `Ne jamais demander...`

## Applications

### Depuis le web

- [Atom](https://atom.io/)
- [Opera Browser](https://www.opera.com/fr/download)
- [Google chrome](https://www.google.com/chrome/)
- [Dropbox](https://www.dropbox.com/fr/install-linux) 
- [Discord](https://discord.com/)
- [Mattermost](https://docs.mattermost.com/install/desktop.html?src=dl#linux)
- [Dropbox](https://www.dropbox.com/fr/install-linux)
- [Steam](https://store.steampowered.com/about/)

### Depuis le store Ubuntu

- ClamTK
- Tilix
- Gnome Tweak
- Dconf

## Tweaks

https://extensions.gnome.org/

- User themes
- Open weather
- Panel OSD
- Dash To Dock
- Sound input & Output device chooser
- Tweaks in system menu
- System-monitor
  ```
  sudo apt install gir1.2-gtop-2.0 gir1.2-nm-1.0 gir1.2-clutter-1.0
  ```

### Depuis un repository

- [ ] Spotify
  ```
  curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
  echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
  sudo apt-get update && sudo apt-get install spotify-client
  ``` 

- [ ] Sublime Text 3
  ```
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
  sudo apt-get install apt-transport-https
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
  sudo apt-get update
  sudo apt-get install sublime-text
  ```

- [ ] Brave Browser
  ```
  sudo apt install apt-transport-https curl gnupg
  curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
  echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
  sudo apt update
  sudo apt install brave-browser
  ```
  
- [ ] htop
  ```
  sudo apt-get install htop
  ```
  
- [ ] ctop
  ```
  echo "deb http://packages.azlux.fr/debian/ buster main" | sudo tee /etc/apt/sources.list.d/azlux.list
  wget -qO - https://azlux.fr/repo.gpg.key | sudo apt-key add -
  sudo apt update
  sudo apt install docker-ctop
  ```
  
- [ ] NVM
  ```
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
  ```

- [ ] Yarn
  ```
  sudo apt remove cmdtest
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt-get update && sudo apt-get install --no-install-recommends yarn
  ```
  
- [ ] Docker
  ```
  sudo apt-get remove docker docker-engine docker.io containerd runc
  sudo apt-get update
  sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io
  sudo docker run hello-world
  ``` 

- [ ] GIT (update)
  ```
  sudo add-apt-repository -y ppa:git-core/ppa
  sudo apt-get update
  sudo apt-get install git -y
  ```

- [ ] Fira Code Fonts
  ```
  sudo add-apt-repository universe
  sudo apt install fonts-firacode
  ```
  
## SSH Keys

```
sudo apt-get install xclip
ssh-keygen -t rsa -b 4096 -C "<myemail>"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github_rsa
xclip -selection clipboard < ~/.ssh/github_rsa.pub
```

## Development

1. Installer Tilix
  - Changer l'icone en éditant le fichier dans `/usr/share/applications`
  - Importer les préférences
1. Install GIT
  - Ajouter la clé SSH
1. Clone le repository `dotfiles`
1. Arrêter le serveur Apache par défaut
  - `sudo systemctl disable apache2 && sudo systemctl stop apache2`
1. Docker
1. Docker Compose
1. Add ssh key to Gitlab
  - `xclip -sel clip < ~/.ssh/github_rsa.pub`
  
## keyboard & Shortcuts

### Installer clavier Apple Magic Keyboard

### Shortcuts

## Configuration

### Tilix
