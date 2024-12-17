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

## PiVPN

### Split tunneling

Get network addresses from pivpn `setupVars.conf`:

```terminal
cat /etc/pivpn/wireguard/setupVars.conf
```

```text
...

IPv4addr=192.168.0.111/24
IPv4gw=192.168.0.1
pivpnNET=10.232.117.0
subnetClass=24
pivpnNETv6="fd11:5ee:bad:c0de::"
subnetClassv6=64

...
```

Set `AllowedIPs` in the wireguard client config based on the above values:

```text
...

AllowedIPs = 192.168.0.1/24, 10.232.117.0/24, fd11:5ee:bad:c0de::/64

...
```

This way all the traffic that wants to go to `AllowedIPs` will be routed through the VPN.
The rest of the traffic will be routed as usual, without going through the VPN.
