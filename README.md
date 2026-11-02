# dotfiles

Configuration shell partagée entre **Linux (Ubuntu)** et **macOS**.

## Prérequis

**Ubuntu**

```bash
sudo apt update
sudo apt install -y git
``` 

**macOS**

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
source ~/.zshrc
brew install git
``` 

## Installation

```bash
git clone git@github.com:sixertoy/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install/setup.sh
```

Pendant l’install (TTY) :
- **npm** : prompt pour le token registry → écrit dans un `~/.npmrc` **local** (copie, pas le template du dépôt). Entrée vide = skip.
- **SSH** : contrôle de `~/.ssh/id_ed25519` ; si absente, warning — voir [docs/SSH.md](docs/SSH.md) pour la restaurer (ne pas régénérer).

**Post-install**

Appliquer la configuration dans le terminal :
- **macOS** : `source ~/.zshrc`
- **Ubuntu** : `source ~/.bash_aliases`

### Usage

Si un ancien `~/.zprofile` non géré contenait déjà `brew shellenv`, le laisser remplacer par le symlink de `setup.sh` pour éviter un PATH en double.

**Maintenance du dossier `dotfiles` grâce à des alias git :**

```bash
dotfiles # → équivalent à git status dans ~/.dotfiles
dotfiles push
dotfiles pull
dotfiles checkout
```

## Structure

```
~/.dotfiles/
├── install/
│   ├── lib/         # scripts utilitaires
│   └── setup.sh     # scripts d'installation
├── files/
│   ├── common/      # fichiers communs ubuntu / macos
│   ├── ubuntu/      # overlay Ubuntu
│   └── macos/       # overlay macOS
├── apps/            # artefacts spécifique apps à importer manuellement
│   ├── astra-monitor/
│   └── vscode/
├── docs/            # guides
└── docker/          # sandbox de test Ubuntu 26.04
```

## Debug via Docker (Ubuntu 26.04)

```bash
yarn build
yarn shell
cd ~/.dotfiles
./install/setup.sh ubuntu
source ~/.bash_aliases
```
