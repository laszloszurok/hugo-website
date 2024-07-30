---
title: "Arch Linux Adwaita-dark theme"
date: 2024-07-30T21:44:22+02:00
---

Install gnome-themes, it contains `adwaita-dark`:

```terminal
sudo pacman -S gnome-themes-extra
```

From the AUR install `adwaita-qt5` and `adwaita-qt6` so qt apps can pick up the adwaita-dark theme.

Set the following env vars to apply the themes:

```
GTK_THEME=Adwaita:dark
GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
QT_STYLE_OVERRIDE=adwaita-dark
```
