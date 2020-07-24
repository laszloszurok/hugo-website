---
title: "Pre-Installation"
date: 2020-07-04T17:09:50+02:00
draft: false
toc: true
summary: "Contents of this post: Settings and configurations to prepare the installation. (internet, time and date, partitioning, etc.)"
tags:
  - arch
  - pre-install
---
## Connecting to the internet

I have a wireless card in my laptop, but it is not working in a live enviroment due to driver problems. I am going to fix it after the installation. For now I'm going to use my phone to share its wifi connection with the machine through usb. For this to work we need to start a program called [dhcpcd](https://wiki.archlinux.org/index.php/Dhcpcd).
```terminal
dhcpcd 
```

Now you can plug in your phone and share its internet connection with the laptop. Test the connection with the following command.
```terminal
ping archlinux.org
```

## Time and date

Update the system clock with [timedatectl](https://wiki.archlinux.org/index.php/System_time#System_clock).
```terminal
timedatectl set-ntp true
```

## Partitioning the disk

I am using [fdisk](https://wiki.archlinux.org/index.php/Fdisk) to create my partitions. Use [lsblk](https://wiki.archlinux.org/index.php/Device_file) to get the appropriate device names. (eg. /dev/sda)
```terminal
fdisk /path/to/device
```

For UEFI:

1. **g** - for a new GUID Partition Table
2. **n** - for the efi partition, partition number: default, first sector: default, last sector: +512M
3. **n** - for a swap partition (optional), partition number: default, first sector: default, last sector: +8G (in my case)
4. **n** - for the root partition, partition number: default, first sector: default, last sector: default
5. **w** - to write the changes on the disk

For MBR:

1. **o** - for a new DOS Partition Table
2. **n** - for a swap partition (optional), partition number: default, first sector: default, last sector: +8G (in my case)
3. **n** - for the root partition, partition number: default, first sector: default, last sector: default
4. **w** - to write the changes on the disk

## Creating filesystems

Use the device name in the paths (eg. mkfs.ext4 /dev/sda3)

If you created an efi partition:
```terminal
mkfs.fat -F32 /path/to/efi/partition
```

If you created a swap partition:
```terminal
mkswap /path/to/swap/partition
```

For the root partition:
```terminal
mkfs.ext4 /path/to/root/partiton
```

## Mounting the partitons

Now we are going to attach the created partitions to the existing filesystem.

First the root partition:
```terminal
mount /path/to/root/partition /mnt
```

If you created an efi partiton:
```terminal
mkdir /mnt/boot
```
```terminal
mkdir /mnt/boot/EFI
```
```terminal
mount /path/to/efi/partition /mnt/boot/EFI
```

If you created a swap partiton:
```terminal
swapon /path/to/swap/partition
``` 
