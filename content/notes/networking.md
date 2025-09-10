---
title: "Networking notes"
date: 2024-10-26T22:57:13+02:00
pagefind_index_page: true
---

## Set static IP for Ubuntu server

[ubuntu networking docs](https://documentation.ubuntu.com/server/explanation/networking/configuring-networks/)

### Edit netplan config files

#### Static config

Create a new config file in `/etc/netplan`:

```terminal
cd /etc/netplan
```
```terminal
sudoedit 99_config.yaml
```

add the following content:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp1s0: # replace with actual interface name (check with 'ip addr')
      addresses:
        - 192.168.1.4/24 # replace with desired static ip
      routes:
        - to: default
          via: 192.168.1.1 # replace with actual default gw address
      nameservers:
        addresses: [192.168.1.1, 1.1.1.1] # replace with desired dns server addresses
```

#### Disable DHCP

Edit `/etc/netplan/50-cloud-init.yaml` if exists and set dhcp to `false`:

```yaml
network:
  version: 2
  ethernets:
    enp1s0:
      dhcp4: false
```

### Apply the netplan config

```terminal
sudo netplan apply
```

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

### Analyze surrounding wireless networks

```terminal
nmcli device wifi rescan
```

```terminal
nmcli device wifi list
```

#### Watch and sort networks by channel

```terminal
watch "nmcli -fields "CHAN,BARS,SIGNAL,SSID" device wifi list | sort -n"
```

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

## Some networking terms

### PON

Passive Optical Network: A network that uses unpowered devices to carry signals.

#### GPON

Gigabit capable PON.

### ONT/OLT/ONU

Optical Network Terminal / Optical Line Terminal / Optical Network Unit: Basically a modem for fibre-optic networks.
The end of the line for the optical network.

### Fibre media converter

A networking device that can convert between different media types, like twisted pair to fibre optic cabling.

### PPPoE

Point-to-Point Protocol over Ethernet: Authenticates the user with a username and a password to the ISP.

## Netcat

### Send data from one device to an other on the same network

#### Start listening on the receiving end and write incoming data to 'file'

```terminal
nc -l -p 1234 > file < /dev/null
```

#### Estabilish connection on the sending end

```terminal
nc 192.168.1.5 1234
```

Type something and press return.
The line will be written to the file on the other end.
Firewalls will of course block this if the port is not open.

## .home.arpa special-use domain

https://datatracker.ietf.org/doc/html/rfc8375

## Download a large file with wget

This makes wget continously retry the download on http/network errors.
The `--continue` flag makes sure that the already downloaded content is kept on disk and the download will continue where it was left off.

```sh
while true; do
    if wget 'https://some.url/file.ext' --output-document 'file.ext' --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 --continue; then
        break
    fi
    sleep 1
done
```
