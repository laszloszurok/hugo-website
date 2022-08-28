---
title: "Installation"
date: 2020-07-03T10:12:02+02:00
draft: false
toc: false
summary: "Contents of this post: Setting up the mirrorlist, Installing the base system"
tags:
  - arch
  - installation
---
More info on the [wiki](https://wiki.archlinux.org/index.php/Installation_guide).

## Setting up the mirrorlist

For faster download speeds choose the appropriate mirrors based on your country. I'm going to use vim to edit the [mirrorlist](https://wiki.archlinux.org/index.php/Mirrors) file.
```terminal
vim /etc/pacman.d/mirrorlist
```

Search for your country and move the lines to the top of the file (uncomment them). Save the file and exit the texteditor.

## Installing the base system

Install the necessary packages and a texteditor of your preference.

```terminal
pacstrap /mnt base linux linux-firmware vim
```
