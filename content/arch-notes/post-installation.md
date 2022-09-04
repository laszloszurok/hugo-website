---
title: "Post-Installation"
date: 2020-07-02T10:14:55+02:00
draft: false
toc: true
summary: "Contents of this post: Various settings and configurations after the installation. (timezone, network, user account, etc.)"
tags:
  - arch
  - post-install
---

## Generating the filesystem table

Creating the [fstab](https://wiki.archlinux.org/index.php/Fstab) file:

```terminal
genfstab -U /mnt >> /mnt/etc/fstab
```

## Chroot into the installed system

With the [chroot](https://wiki.archlinux.org/index.php/Chroot) command you leave the live environment and enter the newly installed system.

```terminal
arch-chroot /mnt
```

## Timezone and locale

Choose your [timezone](https://wiki.archlinux.org/index.php/System_time#Time_zone):

```terminal
ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime
```

Run [hwclock](https://wiki.archlinux.org/index.php/System_time#Hardware_clock) to generate `/etc/adjtime`:

```terminal
hwclock --systohc
```

Uncomment the needed [locales](https://wiki.archlinux.org/index.php/Locale) in `/etc/locale.gen` (e.g. `en_US.UTF-8`):

```terminal
vim /etc/locale.gen
```

Generate the locales:

```terminal
locale-gen
```

Set the `LANG` variable in `locale.conf`:

```terminal
echo LANG=en_US.UTF-8 >> /etc/locale.conf
```

## Network configuration

Choose a [hostname](https://wiki.archlinux.org/index.php/Network_configuration#Set_the_hostname) (e.g. `arch`):

```terminal
echo arch >> /etc/hostname
```

To edit the [hosts](https://wiki.archlinux.org/index.php/Network_configuration#Local_hostname_resolution) file:

```terminal
vim /etc/hosts
```

Enter the following information (replace `arch` with your hostname):

```text
127.0.0.1   localhost
::1         localhost
127.0.1.1   arch.localdomain    arch
```

## Installing important packages

```terminal
pacman -S grub efibootmgr networkmanager wireless_tools wpa_supplicant dhcpcd os-prober mtools dosfstools base-devel linux-headers
```

* **grub**: the bootloader
* **efibootmgr**: only needed if you installed the system in UEFI mode
* **networkmanager, wireless-tools, wpa_supplicant, dhcpcd**: networking tools
* **os-prober**: needed if you want to dualboot this system with an other OS later
* **mtools, dosfstools**: filesystem tools
* **base-devel, linux-headers**: package groups which include basic libraries that you will probably need later

## Setting up GRUB (Grand Unified Bootloader)

Installing [GRUB](https://wiki.archlinux.org/index.php/GRUB):

UEFI:

```terminal
grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB
```

MBR (use the device name the system is installed on):

```terminal
grub-install --target=i386-pc /dev/sda
```

Creating the configuration file:

```terminal
grub-mkconfig -o /boot/grub/grub.cfg
```

## User account settings

More info on the [wiki](https://wiki.archlinux.org/index.php/Users_and_groups).

Set the root password:

```terminal
passwd
```

Create a user (replace `username` with your own username):

```terminal
useradd -m username
```

Set a password for the new user:

```terminal
passwd username
```

Add the user to some important groups (no spaces after the commas):

```terminal
usermod -aG wheel,audio,video,optical,storage username
```

To let the new user gain root privileges when needed, we have to edit a file called `sudoers`. Open the file with the following command:

```terminal
visudo
```

Uncomment this line:

```bash
%wheel ALL=(ALL) ALL
```

Save and exit the editor.

## Exiting and rebooting

To exit the installation back to the live environment:
```terminal
exit
```

To unmount all partitions:
```terminal
umount -a
```

Ignore the warning messages about the busy partitions.

Now reboot the system and log in with the newly created user.
```terminal
reboot
```

## Network services and WiFi

Starting and eanbling [network](https://wiki.archlinux.org/index.php/Network_configuration) services:
```terminal
systemctl enable --now NetworkManager
```

Fix for wireless driver problems, in case your card is not recognized:

Installing pre-requirements:
```terminal
sudo pacman -S dkms git
```

Installing the wireless driver:
```terminal
git clone https://github.com/lwfinger/rtw88.git
```
```terminal
cd rtw88
```
```terminal
make
```
```terminal
sudo make install
```

Installing the driver as a [kernel module](https://wiki.archlinux.org/index.php/Kernel_module) with [dkms](https://wiki.archlinux.org/index.php/Dynamic_Kernel_Module_Support), so it will be rebuilt automatically at kernel updates:
```terminal
sudo dkms add ./rtw88
```
```terminal
sudo dkms install rtlwifi-new/0.6
```

## Accessing the AUR

The [Arch User Repository](https://wiki.archlinux.org/index.php/Arch_User_Repository) - as the name suggests - is a repository which contains software made by the community. You can not access this repository directly with pacman. Install an AUR helper to be able to install packages from this repo. Install [paru](https://github.com/Morganamilo/paru) with the following commands:

```terminal
git clone https://aur.archlinux.org/paru.git
``` 
```terminal
cd paru
``` 
```terminal
makepkg -si
``` 

## Setting up a graphical environment (xorg)

To install graphical drivers:

For Intel cards:
```terminal
sudo pacman -S xf86-video-intel
```

For AMD cards:
```terminal
sudo pacman -S xf86-video-amdgpu
```

Install [xorg](https://wiki.archlinux.org/index.php/Xorg) and [xorg-xinit](https://wiki.archlinux.org/index.php/Xinit):
```terminal
sudo pacman -S xorg xorg-xinit
```

I am going to install my build of [DWM](https://wiki.archlinux.org/index.php/Dwm), which needs the following two fonts to work properly:
```terminal
sudo pacman -S ttf-font-awesome ttf-dejavu
```
A notification daemon, called [dunst](https://wiki.archlinux.org/index.php/Dunst), is also required:
```terminal
sudo pacman -S dunst
```

To clone my config files from github:
```terminal
git clone --bare https://github.com/laszloszurok/config $HOME/.cfg
```
```terminal
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME config --local status.showUntrackedFiles no
```
```terminal
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout -f
```

The `.cfg` folder will be a bare repo.
This is a great way of managing config files, because you can basicly forget about it after the setup.
You don't have to deal with the `.cfg` folder, just leave it there in your home directory. 

Set an alias:

```terminal
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

With the alias, you can use commands like this to manage your files:

```terminal
config status
```

```terminal
config add .bashrc
```

```terminal
config commit -m "updated .bashrc"
```

```terminal
config push
```

Write this alias in your `.bashrc` or `.zshrc` to make it permanent. If you want to set up a new bare repo, you can do it like this:

```terminal
git init --bare $HOME/.myconf
```

```terminal
alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
```

```terminal
config config status.showUntrackedFiles no
```

Then set a remote url for the repository. 

Cloning my [suckless](https://suckless.org/) builds:

```terminal
git clone https://github.com/laszloszurok/dwm.git source/suckless-builds/dwm
```

```terminal
git clone https://github.com/laszloszurok/dwmblocks.git source/suckless-builds/dwmblocks
```

```terminal
git clone https://github.com/laszloszurok/dmenu.git source/suckless-builds/dmenu
```

```terminal
git clone https://github.com/laszloszurok/st.git source/suckless-builds/st
```

```terminal
git clone https://github.com/laszloszurok/slock.git source/suckless-builds/slock
```

```terminal
git clone https://github.com/laszloszurok/wmname.git source/suckless-builds/wmname
```

Go into the `suckless-builds/dwm` directory and execute the following command:

```terminal
sudo make install
```

Execute the above command for all of my suckless builds to install them.
Now that DWM is installed we need a way to launch it.
For this, you have to copy a configuration file to your home folder and edit it, as follows:

```terminal
cp /etc/X11/xinit/xinitrc /home/youruser/.xinitrc
```

Replace `youruser` with your username.
Open the copied file and delete the last five lines containing twm, xclock, etc.
Replace it with with the following:

```bash    
exec dwm
```

Save the file and exit the editor.
Now you should be able to launch dwm with this command:

```terminal
startx
```

Make sure you have a terminal emulator installed before running `startx`.
If you installed all of my suckless builds you have [st](https://wiki.archlinux.org/index.php/St).

If you don't want to launch the X server manually with the `startx` command every time you start up your computer, you have to install a display manager.
I can recommend [lightdm](https://wiki.archlinux.org/index.php/LightDM).

You will also need a greeter (a graphical login screen).
My favourite one is called [lightdm-slick-greeter](https://github.com/linuxmint/slick-greeter).
It's in the AUR, so you have to install it with an AUR helper, like paru.

You have to do some configurations to make lightdm work.
Open the file located at `/etc/lightdm/lightdm.conf` with a texteditor and uncomment the following line under the [LightDM] section:

```text
[LightDM]
...
sessions-directory=/usr/share/lightdm/sessions:/usr/share/xsessions:/usr/share/wayland-sessions
...
```

Under the [Seat:\*] section, set the default greeter to lightdm-slick-greeter and also set the user-session to dwm:

```text
[Seat:*]
...
greeter-session=lightdm-slick-greeter
...
user-session=dwm
...
```

For the user-session to work, a file at `/usr/share/xsessions/dwm.desktop` has to be created with the following congent:

```text
[Desktop Entry]
Encoding=UTF-8
Name=dwm
Comment=Dynamic Window Manager
Exec=/usr/local/bin/dwm
Type=Application
```

Now lightdm is configured, but you have to enable it with [systemctl](https://wiki.archlinux.org/index.php/Systemd), so it will automatically launch after boot.

```terminal
systemctl enable lightdm
```

If you want to set a wallpaper for the greeter, you can set it through the lightdm-slick-greeter configuration file, but there is a nice graphical tool in the AUR called [lightdm-settings](https://github.com/linuxmint/lightdm-settings) which lets you manage the greeter's settings in an easy way.

To lock the screen after inactivity, you can use [light-locker](https://github.com/the-cavalry/light-locker) (install it with pacman).

You can find [slock](https://tools.suckless.org/slock/) between my suckless builds, which is a very lightweight screen locker utility, but I recommend light-locker if you use lightdm.

If you don't want a display manager you can just log in through the tty and use startx to launch a graphical session.

To install the ArcDark theme:

```terminal
sudo pacman -S arc-gtk-theme arc-icon-theme
```

Use lxappearance to manage themes:

```terminal
sudo pacman -S lxappearance
```
To apply a theme for every user, add these [environmental variables](https://wiki.archlinux.org/index.php/Environment_variables) to /etc/environment:

```text
GTK_THEME=Arc-Dark
QT_QPA_PLATFORMTHEME=gtk2
```

## Configuring the touchpad

To enable tap-to-click and natural scrolling, create a file, called `30-touchpad.conf` under `/etc/X11/xorg.conf.d/` with the following lines:

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

I'm using the [ALSA](https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture) sound system on my machine.
Install `alsa-utils` with the following command.
This will provide a program called `alsa-mixer` which you can use to control sound.

```terminal
sudo pacman -S alsa-utils
```

I have media control buttons on my laptop (e.g. they can control switching to next/prev. song on Spotify).
For these to work I'm going to install `playerctl`.

```terminal
sudo pacman -S playerctl
```

I have `alsamixer` and `playerctl` commands binded to the volume level controlling and media controlling keys in my DWM config, thats how I make these keys functional.
