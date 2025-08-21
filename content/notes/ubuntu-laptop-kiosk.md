---
title: 'Turn a laptop with Ubuntu into a locked down kiosk - sort of'
date: 2025-08-21T19:35:09+02:00
draft: true
pagefind_index_page: true
---

I had to set up a laptop to run a browser with a single webpage displayed and with all user interactions disabled.

There migth be better hardware and software tools for this, but I had to cook with what I had.

## Preparations

### Get rid of gnome

```terminal
sudo apt purge --auto-remove ubuntu-desktop
```
```terminal
sudo apt purge --auto-remove gnome-shell
```

### Enable ssh for remote management

```terminal
sudo apt install openssh-server
```
```terminal
systemctl enable --now ssh.service
```

## Set up a user that will be used to run stuff

### Automatic login

Create this file: `/etc/systemd/system/getty@tty1.service.d/autologin.conf` with the following content:

```text
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin REPLACE_WITH_USERNAME %I $TERM
```

For subsequent boots the user will be logged in on tty1 without having to type a password.

### Autostart cage

[Cage](https://github.com/cage-kiosk/cage) is a minimal wayland compositor, designed for kiosk usecases.

Append the following lines to ~/.profile:

```shell
[ -z "$SSH_TTY" ] && cage -- firefox --kiosk pulzar.envs.net
```

This way cage will be started after the user logs in, expect on SSH logins.
Firefox will be lauched inside cage, with the `--kiosk` flag which hides UI elements, so only the webpage is displayed on the screen.

## Disable input devices

Firefox kiosk mode does not disable keyboard shortcuts, so it's possible to exit the browser and fall back to the shell.

### Laptop internal keyboard

To disable the laptops own keyboard add the `i8042.nokbd` option to the kernel parameters.
In this case this is set in `/etc/default/grub`:

```text
...
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash i8042.nokbd"
...
```

### USB ports

To disable all USB ports install [usbguard](https://github.com/USBGuard/usbguard):

```terminal
sudo apt install usbguard
```

then enable the usbguard service:

```terminal
systemctl enable usbguard
```

Edit `/etc/usbguard/rules.conf` and delete all lines, leaving the file completely empty.
This is needed, because usbguard generates an allow list based on the currently connected usb devices.
Deleting every rule makes everything disabled.

After rebooting, internal keyboard input and usb device inputs should not work.

## Using an external screen

Cage does not handle multiple dispalys too well, so I had to disable the laptops internal screen and only enable an HDMI monitor.

This is achived with some `video` kernel parameters in `/etc/default/grub`:

```text
...
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash i8042.nokbd video=HDMI-A-1:1920x1080@60 video=eDP-1:d"
...
```
