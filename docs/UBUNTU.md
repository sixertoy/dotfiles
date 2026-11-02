# Install Ubuntu LTS

## Settings

- **Résolution :** 1680x1050

- **Check EFI Mode**

```bash
[ -d /sys/firmware/efi ] && echo "Session EFI" || echo "Session non-EFI"
```

## Applications (Cli / GUI)

 voir le fichier [`files/ubuntu/packages.ini`](../files/ubuntu/packages.ini)

## Applications

- [ ] [Code (VSCode)](https://code.visualstudio.com/)
- [ ] [Proton VPN](https://protonvpn.com)
- [ ] [Spotify](https://open.spotify.com/download)
- [ ] [Steam](https://store.steampowered.com/)
- [ ] [Sublime Text](https://www.sublimetext.com/download)
- [ ] [Brave Browser](https://brave.com/fr/download/)
- [ ] [Dropbox](https://www.dropbox.com/install-linux)
- [ ] [Google Chrome](https://www.google.com/intl/fr/chrome/gsem/download)
- [ ] [Cursor](https://cursor.com/fr/download)
- [ ] [Handy](https://handy.computer/download)
- [ ] [Docker-ctop](https://github.com/bcicen/ctop)
- [ ] [Docker](https://docs.docker.com/engine/install/ubuntu/)

**Add your user to the docker group :**
- https://docs.docker.com/engine/install/linux-postinstall/#add-your-user-to-the-docker-group

## Optionals Applications

- [ ] [Ventoy](https://www.ventoy.net/en/doc_linux_gui.html)

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
