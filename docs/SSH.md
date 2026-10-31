# Clé SSH (`id_ed25519`)

Le dépôt versionne la **clé publique** (`files/common/home/.ssh/id_ed25519.pub`) et la `config`. Les `authorized_keys` sont **par OS** (`files/ubuntu|macos/home/.ssh/`). La **clé privée** n’est jamais dans git.

On ne peut **pas** recalculer la privée à partir de la publique. Sur une machine neuve, il faut **restaurer** `~/.ssh/id_ed25519` depuis ta sauvegarde (autre machine, coffre, backup chiffré).

## Après `./install/setup.sh`

`setup.sh` copie `.ssh/` et vérifie la présence de la privée. Si elle manque : warning + renvoi vers ce guide (pas de `ssh-keygen` automatique).

```bash
# 1. Placer la privée (exemple)
chmod 700 ~/.ssh
cp /chemin/vers/backup/id_ed25519 ~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_ed25519

# 2. Vérifier qu’elle correspond au .pub déployé
ssh-keygen -y -f ~/.ssh/id_ed25519 | diff - ~/.ssh/id_ed25519.pub

# 3. Agent + test GitHub
eval "$(ssh-agent -s)"
# ---------------------------
# Ubuntu : 
ssh-add ~/.ssh/id_ed25519
# macOS :
# ssh-add --apple-use-keychain ~/.ssh/id_ed25519
# ---------------------------
ssh -T git@github.com
```

Ne génère une nouvelle paire que si tu comptes **remplacer** la clé partout (GitHub, serveurs, `authorized_keys`).

## `authorized_keys` (accès entrant)

`~/.ssh/authorized_keys` liste les **clés publiques** autorisées à se connecter **vers cette machine** (`ssh user@host`). Ce n’est pas l’identité sortante (GitHub, etc.) : celle-ci utilise `id_ed25519`.

### Dans ce dépôt

- Ubuntu : [`files/ubuntu/home/.ssh/authorized_keys`](../files/ubuntu/home/.ssh/authorized_keys) — contient la publique `id_ed25519` (accès entrant depuis une machine qui a la privée)
- macOS : [`files/macos/home/.ssh/authorized_keys`](../files/macos/home/.ssh/authorized_keys) — overlay dédié (à remplir selon les clients autorisés)
- Installé par `setup.sh` : merge copie de `common/.ssh` puis overlay `ubuntu|macos/.ssh`, permissions durcies (`700` / `600`)
- Les privées restent ignorées par git (voir [`.gitignore`](../.gitignore) : `!.ssh/authorized_keys` + `!.ssh/*.pub`)

Pour autoriser une machine qui possède déjà ta privée `id_ed25519` :

```bash
# Depuis le dépôt — ex. Ubuntu
cat files/common/home/.ssh/id_ed25519.pub >> files/ubuntu/home/.ssh/authorized_keys

# Ou depuis une machine distante
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@host
```

Une ligne = une clé. Commentaires possibles en fin de ligne (comme sur le `.pub`).

### Après modification

1. Éditer / committer l’`authorized_keys` de l’OS concerné (`files/ubuntu|macos/home/.ssh/`)
2. Rejouer `./install/setup.sh` (ou recopier le fichier) sur la machine cible
3. Vérifier :

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
ssh -o IdentitiesOnly=yes -i ~/.ssh/id_ed25519 user@host
```

Si `setup.sh` détecte un `authorized_keys` local différent du template, il le sauvegarde en `.bak` puis écrase avec la copie du dépôt — garder la source de vérité dans le dépôt, pas seulement sur une machine.
