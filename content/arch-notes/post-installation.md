---
title: "Post-Installation"
date: 2020-07-02T10:14:55+02:00
draft: false
toc: true
images:
tags:
  - arch
  - post-install
---

## Generating the filesystem table

Creating the [fstab](https://wiki.archlinux.org/index.php/Fstab) file:
```terminal
❯ genfstab -U /mnt >> /mnt/etc/fstab
```

## Chroot into the installed system

With the [chroot](https://wiki.archlinux.org/index.php/Chroot) command you leave the live enviroment and enter the newly installed system.
```terminal
❯ arch-chroot /mnt
```

## Timezone and locale

Choose your [timezone](https://wiki.archlinux.org/index.php/System_time#Time_zone):
```terminal
❯ ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime
```

Run [hwclock](https://wiki.archlinux.org/index.php/System_time#Hardware_clock) to generate /etc/adjtime:
```terminal
❯ hwclock --systohc
```

Uncomment the needed [locales](https://wiki.archlinux.org/index.php/Locale) in /etc/locale.gen (in my case en_US.UTF-8):
```terminal
❯ vim /etc/locale.gen
```

Generate the locales:
```terminal
❯ locale-gen
```

Set the LANG variable in locale.conf:
```terminal
❯ echo LANG=en_US.UTF-8 >> /etc/locale.conf
```

## Network configuration

Choose a [hostname](https://wiki.archlinux.org/index.php/Network_configuration#Set_the_hostname) (in my case arch):
```terminal
❯ echo arch >> /etc/hostname
```

To edit the [hosts](https://wiki.archlinux.org/index.php/Network_configuration#Local_hostname_resolution) file:
```terminal
❯ vim /etc/hosts
```

Enter the following information (replace arch with your hostname):
```text
127.0.0.1   localhost
::1         localhost
127.0.1.1   arch.localdomain    arch
```

## Installing important packages
```terminal
❯ pacman -S grub efibootmgr networkmanager network-manager-applet wireless_tools wpa_supplicant dhcpcd os-prober mtools dosfstools base-devel linux-headers
```

* **grub**: the bootloader we are going to use
* **efibootmgr**: only needed if you installed the system in UEFI mode
* **networkmanager, network-manager-applet, wireless-tools, wpa_supplicant, dhcpcd**: networking tools
* **os-prober**: needed if you want to dualboot this system with an other OS later
* **mtools, dosfstools**: filesystem tools
* **base-devel, linux-headers**: package groups which include basic libraries that you will probably need later

## Setting up GRUB (Grand Unified Bootloader)

Installing [GRUB](https://wiki.archlinux.org/index.php/GRUB):

UEFI:
```terminal
❯ grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB
```

MBR (use the device name the system is installed on):
```terminal
❯ grub-install --target=i386-pc /dev/sda
```

Creating the configuration file:
```terminal
❯ grub-mkconfig -o /boot/grub/grub.cfg
```

## User account settings

More info on the [wiki](https://wiki.archlinux.org/index.php/Users_and_groups).

Set the root password:
```terminal
❯ passwd
```

Create a user (replace username with your own username):
```terminal
❯ useradd -m username
```

Set a password for the new user:
```terminal
❯ passwd username
```

Add the user to some important groups (no spaces after the commas):
```terminal
❯ usermod -aG wheel,audio,video,optical,storage username
```

To let the new user gain root privileges when needed, we have to edit a file called sudoers. Open the file with the following command:
```terminal
❯ visudo
```

Uncomment this line:
```bash
%wheel ALL=(ALL) ALL
```

Save and exit the editor.

## Exiting and rebooting

To exit the installation back to the live enviroment:
```terminal
❯ exit
```

To unmount all partitions:
```terminal
❯ umount -a
```

Ignore the warning messages about the busy partitions.

Now reboot the system and log in with the user account you created previously.
```terminal
❯ reboot
```

## Network services and WiFi

Starting and eanbling [network](https://wiki.archlinux.org/index.php/Network_configuration) services.
```terminal
❯ systemctl enable --now NetworkManager
```

As I mentioned my wireless card is not working yet, I'm going to fix it now.

Installing pre-requirements:
```terminal
❯ sudo pacman -S dkms git
```

Installing the wireless driver:
```terminal
❯ git clone https://github.com/lwfinger/rtw88.git
```
```terminal
❯ cd rtw88
```
```terminal
❯ make
```
```terminal
❯ sudo make install
```

Installing the driver as a [kernel module](https://wiki.archlinux.org/index.php/Kernel_module) with [dkms](https://wiki.archlinux.org/index.php/Dynamic_Kernel_Module_Support), so it will be rebuilt automatically at kernel updates:
```terminal
❯ sudo dkms add ./rtw88
```
```terminal
❯ sudo dkms install rtlwifi-new/0.6
```

## Accessing the AUR

The [Arch User Repository](https://wiki.archlinux.org/index.php/Arch_User_Repository) - as the name suggests - is a repository which contains software made by the community. You can not access this repository directly with pacman. You have to install
a software called an AUR helper to be able to install packages from this repo. My favourite one is [yay](https://github.com/Jguer/yay). You can install it with the following commands:

```terminal
❯ git clone https://aur.archlinux.org/yay.git
``` 
```terminal
❯ cd yay
``` 
```terminal
❯ makepkg -si
``` 

## Setting up a graphical enviroment (xorg)

First of all we are going to install graphical drivers.

For Intel cards:
```terminal
❯ sudo pacman -S xf86-video-intel
```

For AMD cards:
```terminal
❯ sudo pacman -S xf86-video-amdgpu
```

Then we are going to install [xorg](https://wiki.archlinux.org/index.php/Xorg).
```terminal
❯ sudo pacman -S xorg
```

We need to install a package called [xorg-xinit](https://wiki.archlinux.org/index.php/Xinit) as well:
```terminal
❯ sudo pacman -S xorg-xinit
```

I am going to install my build of [DWM](https://wiki.archlinux.org/index.php/Dwm), which needs the following two fonts to work properly:
```terminal
❯ sudo pacman -S ttf-font-awesome ttf-dejavu
```

I'm cloning all my suckless builds, config files and scripts from my github. I'm using a git bare repository to manage my config- and other files in my home folder. 

If you want my configs just clone the repo from the below link as you normally would and then place its content to your home folder. 

My scripts may or may not work on your machine, as some of them are specific to the hardware in my laptop.

So in my case:
```terminal
❯ git clone --separate-git-dir=$HOME/.myconf https://github.com/laszloszurok/suckless-arch.git $HOME/myconf-tmp
```
This clones my files to a temporary directory and creates a bare repo in my home folder. We need the temporary directory because if the home folder is not empty we can't clone directly into it with this command. Now we have to move the files from myconf-tmp to the home folder:
```terminal
❯ mv ~/myconf-tmp/* ~/myconf-tmp/.[!.]* ~/
```
This moves every file - including hidden ones - to the home dir. We don't need the tmp folder anymore and there is a .git file that we can remove too:
```terminal
❯ rm -r ~/myconf-tmp/ ~/.git
```
```terminal
❯ alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
```
```terminal
❯ config config status.showUntrackedFiles no
```

The .myconf folder will be the bare repo. This is a great way of managing config files, because you can basicly forget about it after the setup. You don't have to deal with the .myconf folder, just leave it there in your home directory. With the alias, you can use commands like this to manage your files:
```terminal
❯ config status
```
```terminal
❯ config add .bashrc
```
```terminal
❯ config commit -m "updated .bashrc"
```
```terminal
❯ config push
```
Write this alias in your .bashrc or .zshrc to make it permanent. Obviously, if you want to manage your files like this, you have to set up your own git repo, because you can't push to mine. You can do this with these commands:
```terminal
❯ git init --bare $HOME/.myconf
```
```terminal
❯ alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
```
```terminal
❯ config config status.showUntrackedFiles no
```

Then you have to add your own remote to the repository. 

Now go into the suckless-builds/dwm directory and execute the following command:
```terminal
❯ sudo make install
```

Execute the above command for all of my suckless builds to install them. Now that DWM is installed we need a way to launch it. For this, you have to copy a configuration file to your home folder and edit it, as follows:
```terminal
❯ cp /etc/X11/xinit/xinitrc /home/youruser/.xinitrc
```

Replace 'youruser' with your username. Open the copied file and delete the last five lines containing twm, xclock, etc. Replace it with with the following:
```bash    
exec dwm
```

Save the file and exit the editor. Now you should be able to launch dwm with the following command:
```terminal
❯ startx
```

Make sure you have a terminal emulator installed before running startx. If you installed all of my suckless builds you have [st](https://wiki.archlinux.org/index.php/St).

If you don't want to launch the X server manually with the startx command every time you start up your computer, you have to install a display manager. I am going to install [lightdm](https://wiki.archlinux.org/index.php/LightDM).
```terminal
❯ sudo pacman -S lightdm
```

We also need a greeter (a graphical login screen). My favourite one is called [lightdm-slick-greeter](https://github.com/linuxmint/slick-greeter). It's in the AUR, so you have to install it with an AUR helper. I am using yay.
```terminal
❯ yay -S lightdm-slick-greeter
```

We have to make some configurations to make lightdm work. Open the file located at /etc/lightdm/lightdm.conf with a texteditor and uncomment the following line under the [LightDM] section:

```text
[LightDM]
...
sessions-directory=/usr/share/lightdm/sessions:/usr/share/xsessions:/usr/share/wayland-sessions
...
```

Now under the [Seat:\*] section, set the default greeter to lightdm-slick-greeter and also set the user-session to dwm as you can see here:

```text
[Seat:*]
...
greeter-session=lightdm-slick-greeter
...
user-session=dwm
...
```

For the user-session to work we have to create a file called dwm.desktop. Place this file to the following location: /usr/share/xsessions/ . Open the file with a texteditor and write
the following configuration into it:

```text
[Desktop Entry]
Encoding=UTF-8
Name=dwm
Comment=Dynamic Window Manager
Exec=/usr/local/bin/dwm
Type=Application
```

Now lightdm is configured, but we have to enable it with [systemctl](https://wiki.archlinux.org/index.php/Systemd). This way lightdm will automatically launch when you boot up your computer.
```terminal
❯ systemctl enable lightdm
```

So we have a display manager with a greeter, but the greeter is just a black screen and a login form by default. If you want to set a wallpaper, you can set it through the 
lightdm-slick-greeter configuration file, but there is a nice graphical tool in the AUR called lightdm-settings which lets you manage the greeter's settings in an easy way.
Install it with the following command:
```terminal
❯ yay -S lightdm-settings
```

After you reboot, you should see the lightdm-slick-greeter login screen and DWM should automatically start after you log in.

Now I'm going to apply a nice dark theme for the system. My favourite dark theme is ArcDark, whit the Arc icon-theme. Install these with the following command:

```terminal
❯ sudo pacman -S arc-gtk-theme arc-icon-theme
```

The tools I'm using for managing themes are lxappearance for GTK and qt5ct for QT. Install them:

```terminal
❯ sudo pacman -S lxappearance qt5ct
```
For qt5ct to work, we have to set an enviromental variable in /etc/enviroment. Open the file and add this line:
```text
QT_QPA_PLATFORMTHEME=qt5ct
```
You can set up different color variations in these theme engines for your programs.

## Configuring the touchpad

Now I'm going to configure the touchpad of my laptop, because tap-to-click and natural scrolling are turned off by default. Create a file called 30-touchpad.conf and place it to /etc/X11/xorg.conf.d/ . Write these settings into it:

```text
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "NaturalScrolling" "true"
EndSection
```

Restart the X server for the changes to take effect.

## Enabling sound

I'm using [ALSA](https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture) to enable sound on my machine. Install alsa-utils with the following command. This will provide a program called alsa-mixer which you can use to control sound.
```terminal
❯ sudo pacman -S alsa-utils
```

I have media control buttons on my laptop (they can control for eg. switching to next/prev. song on Spotify). For these to work I'm going to install playerctl.
```terminal
❯ sudo pacman -S playerctl
```

I have alsamixer and playerctl commands binded to the volume level controlling and media controlling keys in my DWM config, thats how I make these keys functional.
