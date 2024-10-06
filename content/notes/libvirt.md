---
title: "Libvirt notes"
date: 2024-10-06T09:45:46+02:00
---

## Packages on Arch Linux

```terminal
sudo pacman -S libvirt virt-install virt-viewer iptables-nft dnsmasq edk2-ovmf libosinfo
```

## Get OS variants

```terminal
osinfo-query os
```

or

```terminal
virt-install --osinfo list
```

## Create a VM with virt-install

### From an iso file

```terminal
virt-install \
    --name archvm \
    --memory 2048 \
    --vcpus 2 \
    --disk size=8 \
    --cdrom archlinux-2024.10.01-x86_64.iso \
    --os-variant archlinux
```

### From a qcow2 image

```terminal
virt-install \
    --name archvm \
    --memory 2048 \
    --vcpus 2 \
    --disk Arch-Linux-x86_64-basic-20241001.267073.qcow2 \
    --import \
    --os-variant archlinux
```

## List VMs

```terminal
virsh list
```

## Access a running VM with GUI

```terminal
virt-viewer archvm
```

## Delete VM

```terminal
virsh destroy archvm
```
```terminal
virsh undefine archvm
```
