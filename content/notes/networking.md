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

#### Connect to the vpn

```terminal
nmcli connection up pivpn
```

It might be necessary to restart the NetworkManager service for the new connection to work.

## Lighttpd

### Proxy

#### Create a module config

`/etc/lighttpd/conf-available/15-redlib.conf`:

```
server.modules += ( "mod_proxy" )

$HTTP["host"] =~ "redlib.lan" {
  proxy.server = ( "" =>  ( ( "host" => "192.168.0.111", "port" => "8080" ) ) )
}
```

#### Enable the module

```terminal
sudo lighty-enable-mod
```

#### Reload the lighttpd service

```terminal
sudo service lighttpd force-reload
```
