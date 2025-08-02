---
title: "Arch Linux Adwaita-dark theme"
date: 2024-07-30T21:44:22+02:00
---

## Install gnome-themes

This package contains the Adwaita-dark theme.

```terminal
sudo pacman -S gnome-themes-extra
```

## Set the following env vars to apply the theme:

```sh
GTK_THEME=Adwaita:dark
GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
QT_QPA_PLATFORMTHEME=gtk3
```

### Possible alternative to `QT_QPA_PLATFORMTHEME`, if the packages `adwaita-qt5` and `adwaita-qt6` are installed from the AUR:

```sh
QT_STYLE_OVERRIDE=adwaita-dark
```

Note that adwaita-qt is not maintained anymore:
https://github.com/FedoraQt/adwaita-qt?tab=readme-ov-file#adwaita-qt-project-is-unmaintained-a-no-longer-actively-developed

## Make sure gtk3 apps pick up the theme:

`~/.config/gtk-3.0/settings.ini`:

```ini
[Settings]
gtk-icon-theme-name = Adwaita
gtk-theme-name = Adwaita
gtk-application-prefer-dark-theme = true
```
