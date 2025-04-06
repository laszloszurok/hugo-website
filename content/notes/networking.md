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

## NGINX

### Proxy

#### Create a site config

`/etc/nginx/sites-available/redlib`:

```nginx
server {
    listen 80;
    listen [::]:80;

    server_name redlib.lan;

    location / {
        proxy_pass http://localhost:5001;
    }
}
```

#### Enable the site

```terminal
sudo ln -sf /etc/nginx/sites-available/redlib /etc/nginx/sites-enabled/redlib
```

#### Restart the nginx service

```terminal
sudo systemctl restart nginx.service
```

## Lighttpd

### Proxy

#### Create a module config

`/etc/lighttpd/conf-available/15-redlib.conf`:

```lighttpd
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

IPv4addr=<ip>/24
IPv4gw=<gw-ip>
pivpnNET=<ip>
subnetClass=24
pivpnNETv6="<ip>"
subnetClassv6=64

...
```

Set `AllowedIPs` in the wireguard client config based on the above values:

```text
...

AllowedIPs = <IPv4gw>/24, <pivpnNET>/24, <pivpnNETv6>/64

...
```

This way all the traffic that wants to go to `AllowedIPs` will be routed through the VPN.
The rest of the traffic will be routed as usual, without going through the VPN.

#### PiHole + PiVPN fix

I have PiHole and PiVPN installed together, with PiHole as the DNS server.
With this setup I experienced connection issues when using split tunneling with the above configuration.
The DNS resolution would stop working seemingly at random.
Executing `nmcli connection up pivpn` would fix the issue for a short while.

Setting only the IP address of the raspberry pi in the `AllowedIPs` field, the issue is gone.

```text
...

AllowedIPs = <IPv4addr>

...
```

Maybe one day I will debug what causes DNS resolution to fail with the first config, but this solution seemingly does not have any limitations that would affect my usage of the tunnel and it works consistently.
