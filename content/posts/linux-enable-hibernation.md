---
title: "Enable hibernation in linux"
date: 2021-03-19T20:37:24+01:00
toc: true
draft: false
---

(Using GRUB and systemd.)

A more extensive explanation can be found on the [ArchWiki](https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate).

## Requirements

In order to use hibernation, a swap partition or swap file has to be created. Then a special parameter has to be passed to the linux kernel. Lastly, initramfs has to be configured, so that the system can resume from hibernation.

## Kernel parameters

You have to pass the `resume=swap_uuid` parameter to the kernel. Get the UUID of the swap partition with the following command:
```terminal
lsblk -f
```

Copy the UUID of the partition which has the FSTYPE of swap. After that, open `/etc/default/grub` with a text editor and locate the following line:
```text
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"
```

This line is where parameters are passed to the kernel. Add the `resume` option, using the previously obtained UUID. The correct syntax looks like this:
```text
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet resume=UUID=51bce307-d233-4abd-a3e4-50fb56010bff"
```

To apply the changes, regenerate the GRUB config file:
```terminal
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## Modify the initramfs

Open `/etc/mkinitcpio.conf` with a text editor and locate the following line:
```text
HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)
```

You have to add the `resume` hook to this array, somewhere after udev, so the line will be:
```text
HOOKS=(base udev autodetect modconf block filesystems keyboard resume fsck)
```

To apply the changes, regenerate the initramfs presets:
```terminal
sudo mkinitcpio -P
```

## Using hibernation

Reboot for the changes to take effect, then use the following command to hibernate the system:

```terminal
systemctl hibernate
```
