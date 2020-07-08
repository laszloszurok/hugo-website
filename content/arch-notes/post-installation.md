---
title: "Post-Installation"
date: 2020-07-02T10:14:55+02:00
draft: false
toc: false
images:
tags:
  - untagged
---
## Chroot into the installed system

With the [chroot](https://wiki.archlinux.org/index.php/Chroot) command you leave the live enviroment and enter the newly installed system.

    ❯ arch-chroot /mnt

## Timezone and locale

Choose your [timezone](https://wiki.archlinux.org/index.php/System_time#Time_zone):

    ❯ ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime

Run [hwclock](https://wiki.archlinux.org/index.php/System_time#Hardware_clock) to generate /etc/adjtime:

    ❯ hwclock --systohc

Uncomment the needed [locales](https://wiki.archlinux.org/index.php/Locale) in /etc/locale.gen (in my case en_US.UTF-8):

    ❯ vim /etc/locale.gen

Generate the locales:
    
    ❯ locale-gen

Set the LANG variable in locale.conf:

    ❯ echo LANG=en_US.UTF-8 >> /etc/locale.conf

## Network configuration

Choose a [hostname](https://wiki.archlinux.org/index.php/Network_configuration#Set_the_hostname) (in my case arch):

    ❯ echo arch >> /etc/hostname

To edit the [hosts](https://wiki.archlinux.org/index.php/Network_configuration#Local_hostname_resolution) file:

    ❯ vim /etc/hosts

Enter the following information (replace arch with your hostname):
```text
127.0.0.1   localhost
::1         localhost
127.0.1.1   arch.localdomain    arch
```

## Installing important packages

    ❯ pacman -S grub efibootmgr networkmanager network-manager-applet wireless_tools wpa_supplicant dhcpcd os-prober mtools dosfstools base-devel linux-headers

* **grub**: the bootloader we are going to use
* **efibootmgr**: only needed if you installed the system in UEFI mode
* **networkmanager, network-manager-applet, wireless-tools, wpa_supplicant, dhcpcd**: networking tools
* **os-prober**: needed if you want to dualboot this system with an other OS later
* **mtools, dosfstools**: filesystem tools
* **base-devel, linux-headers**: package groups which include basic libraries that you will probably need later

## Setting up GRUB (Grand Unified Bootloader)

Installing [GRUB](https://wiki.archlinux.org/index.php/GRUB):

UEFI:

    ❯ grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB

MBR (use the device name the system is installed on):

    ❯ grub-install --target=i386-pc /dev/sda

Creating the configuration file:

    ❯ grub-mkconfig -o /boot/grub/grub.cfg

## User account settings

More info on the [wiki](https://wiki.archlinux.org/index.php/Users_and_groups).

Set the root password:

    ❯ passwd

Create a user (replace username with your own username):

    ❯ useradd -m username

Set a password for the new user:

    ❯ passwd username

Add the user to some important groups (no spaces after the commas):

    ❯ usermod -aG wheel,audio,video,optical,storage username

To let the new user gain root privileges when needed, we have to edit a file called sudoers. Open the file with the following command:

    ❯ visudo

Uncomment this line:
```bash
%wheel ALL=(ALL) ALL
```

Save and exit the editor.

## Exiting and rebooting

To exit the installation back to the live enviroment:

    ❯ exit

To unmount all partitions:

    ❯ umount -a

Ignore the warning messages about the busy partitions.

Now reboot the system and log in with the user account you created previously.

    ❯ reboot

## Network services and WiFi

Starting and eanbling [network](https://wiki.archlinux.org/index.php/Network_configuration) services.

```
❯ systemctl enable --now NetworkManager
```
```
❯ systemctl enable --now dhcpcd
```

As I mentioned my wireless card is not working yet, I'm going to fix it now.

Installing pre-requirements:
   
    ❯ sudo pacman -S dkms git

Installing the wireless driver:

```
❯ git clone https://github.com/lwfinger/rtlwifi_new.git -b extended
```
```
❯ cd rtlwifi_new
```
```
❯ make
```
```
❯ sudo make install
```

Installing the driver as a [kernel module](https://wiki.archlinux.org/index.php/Kernel_module) with [dkms](https://wiki.archlinux.org/index.php/Dynamic_Kernel_Module_Support), so it will be rebuilt automatically at kernel updates:

```
❯ sudo dkms add ./rtlwifi_new
```
```
❯ sudo dkms install rtlwifi-new/0.6
```
Settings for the antenna:

    ❯ sudo modprobe -r rtl8723de && sudo modprobe rtl8723de ant_sel=2

## Setting up a graphical enviroment (xorg)

First of all we are going to install graphical drivers.

For Intel cards:

    ❯ sudo pacman -S xf86-video-intel

For AMD cards:

    ❯ sudo pacman -S xf86-video-amdgpu

Then we are going to install [xorg](https://wiki.archlinux.org/index.php/Xorg).

    ❯ sudo pacman -S xorg

We need to install the package called [xorg-xinit](https://wiki.archlinux.org/index.php/Xinit) as well:

    ❯ sudo pacman -S xorg-xinit

I am going to install my build of [DWM](https://wiki.archlinux.org/index.php/Dwm), which needs the following two fonts to work properly:

    ❯ sudo pacman -S ttf-font-awesome ttf-dejavu

I'm cloning all my suckless builds, config files and scripts from my github. My scripts may or may not work on your machine, as some of them are specific to the hardware in my laptop.
    
    ❯ git clone https://github.com/laszloszurok/suckless-arch.git

Move the content of the cloned directory directly to you home folder, then go into the folder suckless-builds/dwm and execute the following command:

    ❯ sudo make install

Execute the above command for all of my suckless builds to install them. Now that DWM is installed we need a way to launch it. For this, you have to copy a configuration file to your home folder and edit it, as follows:

    ❯ cp /etc/X11/xinit/xinitrc /home/youruser/.xinitrc

Replace 'youruser' with your username. Open the copied file and delete the last five lines containing twm, xclock, etc. Replace it with with the following:
```bash    
exec dwm
```

Save the file and exit the editor. Now you should be able to launch dwm with the following command:

    ❯ startx

Make sure you have a terminal emulator installed before running startx. If you installed all of my suckless builds you have [st](https://wiki.archlinux.org/index.php/St).
