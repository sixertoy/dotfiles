# 🎙️ Handy

**Guide complet de configuration de la dictée vocale avec Handy sous Ubuntu (Wayland)**

Sous Ubuntu 24.04 (Wayland), les restrictions de sécurité empêchent les applications tierces d'écouter les raccourcis globaux en arrière-plan et de simuler la frappe au clavier.
Ce guide explique comment contourner ces limitations en compilant `ydotool` et en utilisant un script externe pour injecter le texte dicté avec **Handy**.

## Étape 1 : Installation de Handy et wl-clipboard

1. **Installer l'utilitaire de presse-papiers pour Wayland :**

```bash
sudo apt update
sudo apt install wl-clipboard -y
```

2. **Installer Handy :**

- Téléchargez la dernière version de [Handy](https://handy.computer/download).

- Si c'est un AppImage, rendez-le exécutable : `chmod +x Handy-*.AppImage`.

- Lancez l'application, installez le modèle Whisper `Parakeet TDT 0.6B v3` ou un autre modèle gérant le Français

1. **Configurer Handy :**

| Setting                      | Value                            |
| ---------------------------- | -------------------------------- |
| `Raccourci de transcription` | `ctrl+space`                     |
| `Comportement du raccourci`  | `basculer`                       |
| `Langue`                     | `french`                         |
| `Démarré masqué`             | `true`                           |
| `Lacer au démarrage`         | `true`                           |
| `Overlay`                    | `aucune`                         |
| `Décharger le modèle`        | `après 15 minutes`               |
| `Méthode de collage`         | `script externe`                 |
|                              | `/home/matthieu/.handy/paste.sh` |

## Étape 2 : Compilation et installation de ydotool

Le paquet `ydotool` fourni par défaut dans les dépôts d'Ubuntu 24.04 est incomplet (le démon `ydotoold` est manquant).
Il est donc impératif de le compiler depuis les sources.

**1. Nettoyer les éventuelles anciennes installations :**

```bash
sudo apt purge ydotool -y
sudo apt autoremove -y
```

**2. Installer les dépendances de compilation :**

```bash
sudo apt install -y build-essential cmake pkg-config libevdev-dev scdoc git
```

**3. Cloner le dépôt et compiler :**

```bash
git clone https://github.com/ReimuNotMoe/ydotool.git
cd ydotool
mkdir build
cd build
cmake ..
make
sudo make install
```

_Les exécutables `ydotool` et `ydotoold` sont désormais installés dans `/usr/local/bin/`._

## Étape 3 : Gestion des droits et création du service systemd

Pour que `ydotool` puisse fonctionner sans demander le mot de passe administrateur à chaque fois et sans subir les nettoyages de dossiers temporaires, nous allons créer un service système robuste.

**1. Créer le fichier de service :**
Copiez-collez l'intégralité de ce bloc dans votre terminal :

```bash
sudo bash -c 'cat > /etc/systemd/system/ydotoold.service <<EOF
[Unit]
Description=Ydotool daemon

[Service]
Environment="YDOTOOL_SOCKET=/tmp/.ydotool_socket"
ExecStart=/usr/local/bin/ydotoold
ExecStartPost=/bin/sleep 1
ExecStartPost=/bin/chmod 666 /tmp/.ydotool_socket
Restart=always

[Install]
WantedBy=multi-user.target
EOF'
```

**2. Activer et démarrer le démon :**

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now ydotoold
```

**3. Autoriser votre utilisateur (Groupe input) :**

```bash
sudo usermod -aG input $USER
```

_(⚠️ Vous devrez fermer votre session Ubuntu et vous reconnecter, ou redémarrer, pour que ce droit soit appliqué)._

## Étape 4 : Création du script d'injection (External Paste)

Ce script fera le pont entre Handy et Wayland. Il copiera le texte transcrit en mémoire, puis demandera à `ydotool` de simuler physiquement les touches `Ctrl + V`.

**1. Créer le fichier script :**

```bash
nano ~/.config/handy/paste.sh
```

**2. Insérer le code suivant :**

```bash
#!/bin/bash
exec > /tmp/handy-debug.log 2>&1
set -x

# 1. Copier le texte transcrit par Handy dans le presse-papiers
echo -n "$1" | wl-copy

# 2. Pause pour laisser à Wayland le temps de synchroniser le presse-papiers
sleep 0.1

# 3. Indiquer où se trouve le point de communication de ydotoold
export YDOTOOL_SOCKET="/tmp/.ydotool_socket"

# 4. Simuler Ctrl(29) + V(47) en signaux matériels
# Format : 29:1 (Ctrl enfoncé), 47:1 (V enfoncé), 47:0 (V relâché), 29:0 (Ctrl relâché)
ydotool key 29:1 47:1 47:0 29:0
# ydotool key ctrl+v
```

_(Sauvegardez avec `Ctrl+O`, `Entrée`, puis `Ctrl+X`)._

**3. Rendre le script exécutable :**

```bash
chmod +x ~/.config/handy/paste.sh
```

**4. Configurer Handy :**

- Ouvrez les paramètres de Handy (Settings).

- Allez dans la section **Action / Output**.

- Sélectionnez l'option **External Script**.

- Dans le champ _Script path_, indiquez le chemin absolu vers votre script : `/home/VOTRE_NOM_UTILISATEUR/.config/handy/paste.sh`.

## Étape 5 : Configuration du raccourci clavier global

Sous Wayland, Handy ne peut pas "écouter" votre clavier en arrière-plan. Il faut déléguer cette tâche à Ubuntu.

1. Allez dans les **Paramètres** d'Ubuntu > **Clavier** > **Raccourcis clavier** > **Raccourcis personnalisés**.

2. Cliquez sur **Ajouter un raccourci**.

3. Remplissez les champs :
   - **Nom :** Activer la dictée Handy

   - **Commande :** `handy --toggle-transcription` _(Remplacez "handy" par le chemin absolu de votre fichier .AppImage si vous utilisez ce format)._

4. Définissez votre combinaison de touches (ex: `Super + O`).

🎉 **C'est terminé !** Placez votre curseur dans n'importe quel éditeur de texte (comme Sublime Text), appuyez sur votre raccourci, parlez, et réappuyez : le texte s'écrira instantanément.
