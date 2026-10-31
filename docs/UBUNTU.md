# Install Ubuntu LTS

## Settings

- **Résolution :** 1680x1050

- **Check EFI Mode**

```bash
[ -d /sys/firmware/efi ] && echo "Session EFI" || echo "Session non-EFI"
```


## Applications (Cli / GUI)

Installées automatiquement par `./install/setup.sh ubuntu` depuis :

[`files/ubuntu/packages.ini`](../files/ubuntu/packages.ini) — sections `[cli]` et `[gui]`

## Applications (Store)

- [ ] Brave Browser
- [ ] Code (VSCode)
- [ ] Proto VPN
- [ ] Spotify
- [ ] Steam
- [ ] Sublime Text

## Applications (Web)

- [ ] [Dropbox](https://www.dropbox.com/install-linux)
- [ ] [Google Chrome](https://www.google.com/intl/fr/chrome/gsem/download)
- [ ] [Cursor](https://cursor.com/fr/download)
- [ ] [Handy](https://handy.computer/download)
- [ ] [Docker-ctop](https://github.com/bcicen/ctop)
- [ ] [Docker](https://docs.docker.com/engine/install/ubuntu/)

```bash
# Manage Docker as a non-root user
sudo groupadd docker
sudo usermod -aG docker $USER
# > Log out and log back
newgrp docker
docker run hello-world
```

## Optionals Applications

- [ ] Grub Customizer

```bash
# save current grub configuration
sudo cp -Rp /etc/grub.d /etc/grub.d.ori
```


- [ ] Balena Etcher

```bash
# download .deb file from
# https://github.com/balena-io/etcher/releases/
sudo apt install
sudo apt install ./balena-etcher_******_amd64.deb
```

- [ ] USB Disc Creator

```bash
sudo apt update
sudo apt install usb-creator-gtk
sudo apt-cache policy usb-creator-gtk
```

## GNOME Extensions

- [Astra-monitor](https://extensions.gnome.org/extension/6682/astra-monitor/)
- [Bluetooth Battery Meter](https://extensions.gnome.org/extension/6670/bluetooth-battery-meter/)
- [Color Picker](https://extensions.gnome.org/extension/3396/color-picker/)
- [Clipboard Indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)
- [Tweaks in system menu](https://extensions.gnome.org/extension/1653/tweaks-in-system-menu/)
- [Night Light Slider](https://extensions.gnome.org/extension/7846/night-light-slider/)
- [Emoji Copy](https://extensions.gnome.org/extension/6242/emoji-copy/)
- [Open weather](https://extensions.gnome.org/extension/750/openweather/)

**Incompatibles with >= 24.04 :**

- [Sound input & Output device chooser](https://extensions.gnome.org/extension/906/sound-output-device-chooser/)

## Linux Tips

- DConf

Importés automatiquement par `./install/setup.sh ubuntu` depuis [`files/ubuntu/dconf/`](../files/ubuntu/dconf/) :
le nom du fichier encode le chemin (`org.gnome.dconf` → `dconf load /org/gnome/`).

```bash
# Mettre à jour un dump depuis la machine
dconf dump /org/gnome/ > files/ubuntu/dconf/org.gnome.dconf
dconf dump /org/gtk/gtk4/settings/ > files/ubuntu/dconf/org.gtk.gtk4.settings.dconf
```

