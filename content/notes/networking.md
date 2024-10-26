---
title: "Networking notes"
date: 2024-10-26T22:57:13+02:00
---

## Networkmanager

### Wireguard

#### Add connection

```terminal
sudo nmcli connection import type wireguard file /etc/wireguard/pivpn.conf
```

#### Disable autoconnect

```terminal
nmcli connection modify pivpn autoconnect no
```
