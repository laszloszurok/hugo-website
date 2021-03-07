---
title: "aerc - a pretty good email client"
date: 2021-02-24T14:07:04+01:00
draft: true
---

If you are a hardcore commandline user, and you want to manage you email from a terminal window, then you are looking for aerc. Aerc is a simple email client with a curses-like user interface, written
in go.

## Installing aerc

On Arch-based systems:
```terminal
sudo pacman -S aerc
```

You can grab the source code from {{< target-blank title="here" url="https://git.sr.ht/~sircmpwn/aerc" >}}.

To render html emails in aerc, install the following two programs:
```terminal
sudo pacman -S w3m dante
```
