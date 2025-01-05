#!/bin/sh

if [ ! -d themes/hugo-theme ]; then
    echo "Installing hugo theme"
    git clone https://github.com/laszloszurok/hugo-theme.git themes/hugo-theme
fi

echo "Make sure http traffic is not blocked by the firewall"

for interface in wlp1s0 wlan0; do
    ip_addr=$(ip -4 addr show $interface | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    [ -n "$ip_addr" ] && break
done

hugo server --buildDrafts --bind "$ip_addr" --baseURL http://"$ip_addr"
