---
title: "Enable hibernation in Linux"
date: 2021-03-19T20:37:24+01:00
toc: true
draft: false
---

Using hibernation can be useful if you want to leave your system for a longer period of time, but you want to continue your work where you left off. It is especially handy in case of laptops, as
hibernation can save precious battery power. In this article I'm gonna show you how to enable this feature using a swap partition and GRUB.

Other usecases and a more extensive explanation can be found on the {{< target-blank title="ArchWiki" url="https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate" >}}.

## Requirements

In order to use hibernation, you need to create a swap partition or swap file. If you have that, you have to pass a special parameter to the linux kernel. Lastly, you gonna have to configure the
initramfs to be able to resume from hibernation.

## Kernel parameters

You have to pass the 'resume=**swapdevice**' parameter to the kernel. I suggest using the UUID of the swap partition as the argument. You can obtain that with the following command:
```terminal
lsblk -f
```

Copy the UUID of the partition which has the FSTYPE of swap. After that, open /etc/default/grub with a text editor and locate the following line:
```text
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"
```

This line is where you pass parameters to the kernel. Add the 'resume' option, using the previously obtained UUID. The correct syntax looks like this:
```text
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet resume=UUID=51bce307-d233-4abd-a3e4-50fb56010bff"
```

To apply the changes you have to regenerate the GRUB config file with the following command:
```terminal
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## Modify the initramfs

Open /etc/mkinitcpio.conf with a text editor and locate the following line:
```text
HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)
```

You have to add the 'resume' hook to this array, somewhere after udev, so the line will be:
```text
HOOKS=(base udev autodetect modconf block filesystems keyboard resume fsck)
```

To apply the changes you have to regenerate the initramfs presets with the following command:
```terminal
sudo mkinitcpio -P
```

## Using hibernation

After you finished with the setup process, you have to reboot your computer onece to be able to use hibernation. After that you can use the following command to hibernate your system:
```terminal
systemctl hibernate
```
