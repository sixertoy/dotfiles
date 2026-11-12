# YUBIKEY

## Prérequis

**Ubuntu**

```bash
sudo apt update
sudo apt install -y ykcs11 libpam-u2f
ls -l /usr/lib/x86_64-linux-gnu/libykcs11.so
```

**macOS**

```bash
brew install yubico-piv-tool openssh
ls -l /opt/homebrew/lib/libykcs11.dylib
```

## Configuration des clés SSH

### Yubikey 5C Nano (Headless server)

**Génère la clé privée dans la puce sans exiger de toucher physique**

```bash
ykman piv keys generate -a ECCP256 --pin-policy NEVER --touch-policy NEVER 9e pubkey_5c_nano.pem
```

**Génère le certificat X.509 auto-signé requis par le standard PKCS#11**

```bash
ykman piv certificates generate -s "CN=SSH-GitHub-5C-NANO" 9e pubkey_5c_nano.pem
```

**Convertit la clé publique au format OpenSSH**

```bash
ssh-keygen -i -m PKCS8 -f pubkey_5c_nano.pem > ~/.ssh/id_yubikey_5c_nano.pub
```

**Supprimer le certificat**

```bash
rm pubkey_5c_nano.pem
ykman piv info
ykman piv keys info 9e
```

**Définir les variables d'environnement SSH_ASKPASS**

```bash
chmod 600 ~/.ssh/config
# ~/.zshenv
cat << 'EOF' >> ~/.zshenv
export PATH="/opt/homebrew/bin:$PATH"
export SSH_ASKPASS="$HOME/.local/bin/yubikey-verify-none.sh"
export SSH_ASKPASS_REQUIRE="force"
EOF
source ~/.zshenv
```

**Création du VERIFY_NONE**

```bash
mkdir -p ~/.local/bin
cat << 'EOF' > ~/.local/bin/yubikey-verify-none.sh
#!/bin/sh
echo "VERIFY_NONE"
EOF
chmod 700 ~/.local/bin/yubikey-verify-none.sh
~/.local/bin/yubikey-verify-none.sh # -> VERIFY_NONE
```

**Copiez le contenu :**

```bash
cat ~/.ssh/id_yubikey_5c_nano.pub
```

**Ajouter la clé sur GitHub : Yubikey 5C Nano**

- Sur GitHub, rendez-vous dans Settings → SSH and GPG keys → New SSH key.
- Choisissez Key type : Authentication Key et enregistrez chaque clé publique.

**Tester la connexion**

```bash
ssh -T git@github.com
```

### Yubikey 5C / Yubikey 5C NFC (Machine)

Script installé par `setup.sh` (Ubuntu) : [`yubikey-setup-5c.sh`](../files/ubuntu/home/.local/bin/yubikey-setup-5c.sh)

```bash
~/.local/bin/yubikey-setup-5c.sh
# équivalent après PATH ~/.local/bin :
# yubikey-setup-5c.sh
```

Écrit `~/.ssh/id_yubikey_5c.pub`, démarre un `ssh-agent` si besoin, puis `ssh-add -s` via `libykcs11`. Le PIN sera demandé (génération + agent).

Variables optionnelles : `SLOT`, `ALGORITHM`, `SUBJECT`, `PUB_OUT`, `PIN_POLICY`, `TOUCH_POLICY`.

Équivalent manuel :

```bash
yubico-piv-tool -s 9a -A ECCP256 -a generate -o temp_yubikey.pem --pin-policy=once --touch-policy=cached
yubico-piv-tool -a verify-pin -a selfsign-certificate -s 9a -S "/CN=SSH Yubikey 5c/" -i temp_yubikey.pem -o temp_yubikey-signed.pem
yubico-piv-tool -a import-certificate -s 9a -i temp_yubikey-signed.pem
ssh-keygen -D /usr/lib/x86_64-linux-gnu/libykcs11.so -e > ~/.ssh/id_yubikey_5c.pub
chmod 644 ~/.ssh/id_yubikey_5c.pub
eval "$(ssh-agent -s)"
ssh-add -s /usr/lib/x86_64-linux-gnu/libykcs11.so
rm temp_yubikey-signed.pem temp_yubikey.pem
```

## Tips

**Documentation**

- [PIV certificate slots](https://developers.yubico.com/PIV/Introduction/Certificate_slots.html)
- [Using the YubiKey PIV application for SSH authentication](https://support.yubico.com/s/article/Using-the-YubiKey-PIV-application-for-SSH-authentication)
- [Generating a new SSH key for a hardware security key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key-for-a-hardware-security-key)
- [How to use YubiKey for authentication and sudo on Ubuntu 24.04](https://eve.gd/2026/03/21/how-to-use-yubikey-for-authentication-and-sudo-on-ubuntu-2404/)
- [Ubuntu Linux login guide (U2F)](https://support.yubico.com/s/article/Ubuntu-Linux-login-guide-U2F)

**Reset all PIV data and restore default settings :**

```bash
ykman piv reset
```

**Change the management key :**

Default : 010203040506070801020304050607080102030405060708

```bash
ykman piv access change-management-key
```

**Change the PUK :**

```bash
ykman piv access change-puk --puk 12345678 --new-puk 27061976
```

**Change the PIN :**

```bash
ykman piv access change-pin --pin 123456 --new-pin 11071950
```
