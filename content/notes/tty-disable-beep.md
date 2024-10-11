---
title: "Disable beep on Linux TTY"
date: 2024-10-11T22:39:22+02:00
---

## List loaded kernel modules

```terminal
lsmod
```

## Unload the pcspkr and snd_pcsp kernel modules

```terminal
sudo modprobe --remove pcspkr snd_pcsp
```

## Permanently disable loading the modules

`/etc/modprobe.d/nobeep.conf`:

```text
blacklist pcspkr
blacklist snd_pcsp
```
