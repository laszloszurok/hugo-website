---
title: "Libvirt notes"
date: 2024-10-06T09:45:46+02:00
pagefind_index_page: true
---

## Packages on Arch Linux

```terminal
sudo pacman -S libvirt virt-install virt-viewer qemu-full iptables-nft dnsmasq edk2-ovmf libosinfo
```

## Libvirt system level vs session level

By default the `virsh` and `virt-*` commands will use the `qemu:///session` connection, which launches an unprivileged libvirtd instance (the process name is `virtqemud` on Arch) running as the current user. There is a system level libvirtd instance launched by systemd.

### Differences

Session level virtual machines use qemu user networking, which might have worse performance than the system level networking.
The system libvirtd instance has the necessary permissions to use proper networking via bridges or virtual networks.
VM autostart on host boot only works for the system level VMs.

The graphical frontend `virt-manager` uses `qemu:///system` by default and virtual machines running in unprivileged sessions won't show up on the GUI.

### Use the system level instance

To use the systemwide libvirtd instance `--connect qemu:///system` has to be specified in the commands.
The user has to be a member of the `libvirt` group.

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
    --boot uefi \
    --os-variant archlinux
```

### From a qcow2 image

```terminal
virt-install \
    --name archvm \
    --memory 2048 \
    --vcpus 2 \
    --disk Arch-Linux-x86_64-basic-20241001.267073.qcow2 \
    --boot uefi \
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
