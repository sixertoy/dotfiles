# Linux Tips

## Pair Apple Magic Keyboard A1644

- Open Terminal
- `sudo bluetoothctl`
- `power on`
- `agent KeyboardOnly`
- `default-agent`
- `pairable on`
- Power on Keyboard
- `scan on`
- Keyboard MAC Address should be like **Magic Keyboard**
- Copy MAC Address
- `trust <mac_address>`
- `pair <mac_address>`
- Open Ubuntu settings
- Select & Connect Keyboard
- Confirm PIN

## Secure Boot

**Check EFI Mode**

`[ -d /sys/firmware/efi ] && echo "Session EFI" || echo "Session non-EFI"`

# Atom

**Export packages list**

`apm list --installed --bare > package-list.txt`

**Import packages list**

`apm install --packages-file package-list.txt`

## Tilix

**Export config**

`dconf dump /com/gexperts/Tilix/ > tilix.dconf`

**Import Config**

`dconf load /com/gexperts/Tilix/ < tilix.dconf`

## Custom Shortcuts

https://askubuntu.com/questions/26056/where-are-gnome-keyboard-shortcuts-stored

## Overview Shortcuts

**Disable**

`gsettings set org.gnome.mutter overlay-key ""`

**Enable**

`gsettings set org.gnome.mutter overlay-key "Super_L"`


## Atom Shortcuts

**Duplicate lines**

`ctrl+shift+d`

**Split bloc into lines**

`ctrl+shift+l`

**Multicursor Line by Line**

`alt+shift+up/down`

**Select next hightlighted word**

`ctrl+d`

## Touchpad

https://doc.ubuntu-fr.org/touchpad#configurer_les_gestes
