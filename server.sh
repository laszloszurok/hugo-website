#!/bin/sh

echo Make sure http traffic is not blocked by the firewall

ip_addr=$(ip -4 addr show wlan0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

hugo server --buildDrafts --bind "$ip_addr" --baseURL http://"$ip_addr"
