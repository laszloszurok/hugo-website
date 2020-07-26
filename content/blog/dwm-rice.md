---
title: "How to customize dwm"
date: 2020-07-20T17:28:04+02:00
toc: true
draft: false
summary: "This tutorial will go over how to customize DWM. I'm going to use my own DWM build as an example. This post was made for a request from a Reddit user after I posted an image of my Arch linux setup in [r/unixporn](https://www.reddit.com/r/unixporn/)."
tags:
 - dwm
 - rice
 - tutorial
---
This tutorial will go over how to customize DWM. I'm going to use my own DWM build as an example. If you want to see the final looks of the setup
I'm going to build here, you can check it out [here](/arch-notes/screenshots).

This post was made for a request from a Reddit user after I posted an image of my Arch linux setup in [r/unixporn](https://www.reddit.com/r/unixporn/). 

## About DWM
DWM stands for Dynamic Window Manager. As the name suggests it manages windows in a graphical enviroment. It supports different layouts, like tiled, stacked, etc.
DWM is written in C and it is very lightweight on resources. Many users love it for it's simplicity, but it is not the best choice for someone who is not familiar
with window managers, as it does not have a separate documentation or user guide. The code itself serves as the documentation. This does not mean you have to be
an expert in C to use DWM, but knowing a bit about the languege will defenetly help to customize the WM to your needs.

## Get the source code
Clone the source code of DWM to your computer with the following command:
```terminal
git clone https://git.suckless.org/dwm
```

## Pre-configuration
After you got the sources, you are going to see a file, called config.def.h in the dwm directory. This file contains some basic configuration which you can change, like 
keybindings, color values, etc. 

By default if you compile dwm, that will generate a file called config.h, with the exact same content as config.def.h. If you then want
to modify something, you have to edit the config.h file. This is not too sustainable as some patches (extra functionality that you can add to dwm) will modify the
config.def.h file, so you would have to manually copy the changes to config.h. 

The best solution is only modifying config.def.h and removing config.h after evrey new
build (as it is generated automatically every time). To remove config.h automatically, you can modify the Makefile. Open the file and locate the following part:
```makefile
clean:
	rm -f dwm ${OBJ} dwm-${VERSION}.tar.gz
```
Add config.h to the end of the line after the rm command like this:
```makefile
clean:
	rm -f dwm ${OBJ} dwm-${VERSION}.tar.gz config.h
```
So from now on you only have to deal with the config.def.h file and you can use the 'sudo make clean install' command to build dwm, as you normally would.
(The config.h file still will be generated, but you don't have to remove it anymore. Just leave it there and make your configurations in config.def.h)

## Patching
DWM in itself can display your windows and statusbar, supports different layouts but it is not full of features. You may want to use a different layout, or you want to add
other functionality like autostarting programs when dwm starts up. You can extend dwm with patches. You can find a lot of them on the [official site](https://dwm.suckless.org/patches/).
You can apply a patch with the 'patch' command like this (in the dwm directory):
```terminal
sudo patch -p1 < path/to/the/diff/file
```
A patch is a file that contains the differences between the state of a file before and after the patch is applied. In the case of dwm, a patch usually modifies the config.def.h
or the dwm.c file.

Automatic patching won't always work. Let's take a look at the following example:

Assume we have the following lines in a theoretical diff file:
```diff
diff --git a/config.def.h b/config.def.h
index 1c0b587..b67825e 100644
--- a/config.def.h
+++ b/config.def.h
- int some_variable = 0;
+ int some_variable = 1;
```
This part is telling us which file is being modified by the patch:
```diff
diff --git a/config.def.h b/config.def.h
index 1c0b587..b67825e 100644
--- a/config.def.h
+++ b/config.def.h
```
In this case it's config.def.h.

Then the red line starting with a single '-' symbol shows the state of the file before the patch is applied. So the patch assumes that in the original state of config.def.h
the value of *'some_variable'* is 0. The green line starting with a single '+' symbol shows the state of the file after the patch. So basicly the red line is removed, the green
line is added.

What if we apply multiple patches and some of them want to modify the same lines. If a patch is looking for this line:
```c
int some_variable = 0;
```
but an other patch changed/removed that line, then the patch will fail. The error message will show us what happend and we will have two new files: config.def.rej and config.def.orig.

The config.def.rej will contain the part of the patch that failed. You have to apply those changes manually. In this case you would have to open config.def.h, locate the part
where the patch failed and add the missing lines from config.def.h.rej. Usually the diff files show the untouched lines surrounding the changes, so you can locate the modified
parts based on those lines.

I recommend creating a directory called patches to separate the diff files inside the dwm directory, so it's a bit easier to follow what files you have and what patches you 
applied.

## Restart dwm in place
The first patch I'm going to apply is called [dwm-restartsig](https://dwm.suckless.org/patches/restartsig/). This makes it possible to restart dwm 'in place'. 
What I mean by this is you do not have to restart your X session by logging out, you can just refresh dwm, so for e.g. if you make some changes in your status bar,
you can see the changes instantly after the refresh. Use the patch command to apply pathces like this:
```terminal
sudo patch -p1 < dwm-restartsig-20180523-6.2.diff
```
After you have the restartsig patch, rebuild dwm. You have to restart it manually now, but after that, you can use the Mod+ctrl+shift+q keycombination to refresh dwm. No more logouts.

## Customizing the tag indicators
The [activetagindicatorbar](https://dwm.suckless.org/patches/activetagindicatorbar/) patch draws a little bar above the tag numbers instead of a square. 
I just think it looks better and I'm also gonna customize it. Apply the patch in the exact same way as I showed above. Refresh dwm to see the changes.

I want to make the indicator bars a little smaller and I want them to be always filled. Open up dwm.c and locate the following part:
```c
if (occ & 1 << i)
	drw_rect(drw, x + boxw, 0, w - ( 2 * boxw + 1), boxw,
		m == selmon && selmon->sel && selmon->sel->tags & 1 << i,
		urg & 1 << i);
```
Here are my changes (you can also make these changes in the diff file and patch afterwards, if you dont want to search in dwm.c):
```c
if (occ & 1 << i)
	drw_rect(drw, x + boxw, 0, w - ( 2 * boxw + 1), boxw/2+1, // box/2+1 is the height
		1, // 1 means draw a filled rect, 0 means draw only the border
		urg & 1 << i);
```

## Font Awesome
In my build, I'm using Font Awesome icons in the statusbar. They look very good in my opinion and there's a lot of them accessible for free. 
Here is a [cheat sheet](https://fontawesome.com/cheatsheet/free/solid) where you can copy the icons from. To be able to display Font Awesome 
icons in your statusbar, or anywhere else on you system, you need to install the Font Awsome package for your operating system.
On Arch linux the following command installs the font:
```terminal
sudo pacman -S ttf-font-awesome
```
You may have to reboot your computer to be able to see the icons once you copy them from the cheat sheet.

Let's try it out. Open config.def.h and locate the fonts[] array:
```c
static const char *fonts[] = { "monospace:size=10" };
```
Add Font Awesome to the array like this:
```c
static const char *fonts[] = { "FontAwesome:size=12", "monospace:size=10" };
```
Now locate the tags[] array:
```c
static const char *tags[] = { "1", "2", "3", "4", "5", "6",  "7", "8", "9" };
```
Copy some icons from the cheat sheet I linked previously and replace the numbers. After you're done, build and install dwm with the 'sudo make clean install' command.
Then restart dwm. Here's how my tags look like:

{{< image src="/img/blog/dwm-rice/2020-07-20-192425_290x24_scrot.png" alt="unixporn" position="center" style="border-radius: 4px;" >}}

I have rules set up in config.def.h for some programs, so for e.g. Firefox will always open on the second workspace.

## Statusbar padding
I have a little extra padding around my icons in the bar to make sure the window idicator does not cover them. To be able to set the padding apply the 
[statuspadding](https://dwm.suckless.org/patches/statuspadding/) patch. Then you will be able to set the padding in config.def.h like this:
```c
static const int horizpadbar = 0; /* horizontal padding for statusbar */
static const int vertpadbar  = 7; /* vertical padding for statusbar */
```

## Status indicators with dwmblocks
My status indicators will look like this:

{{< image src="/img/blog/dwm-rice/status-indicators.png" alt="unixporn" position="center" style="border-radius: 4px;" >}}

The icons are clickable, for e.g if I click the wifi icon, a little dunst notification will pop up to tell me the signal strength and which network I'm connected to.
This functionality is achived by [dwmblocks](https://github.com/torrinfail/dwmblocks) and some patching. I'll cover it a bit later.

Dwmblocks makes it possible to update the different indicators separately. This is much better
than running every status indicator in one infinite loop and update them every 1 sec or something. Like why would I want to update my keyboard or wifi indicator that
often. 

With dwmblocks you can set different update intervals and update signals for each indicator. I can update the wifi indicator every 20 seconds and my clock every
5 seconds. 

The keyboard layout indicator does not even have to be updated automatically. It only have to be updated if I switch keyboard layout. So I can just set an update
signal for it, then I can write a script to kill and refresh the keyboard indicator when I switch the layout. 

This solution is easier on system resources as there's no unnecessary updates.

Get the source code:
```terminal
git clone https://github.com/torrinfail/dwmblocks.git
```
Edit the blocks.h file to add your status indicators. I have these scripts in the statusbar:
```c
static const Block blocks[] = {
	/*Icon*/	/*Command*/		        /*Update Interval*/	   /*Update Signal*/
    { "  ",      "~/scripts/status/wifinetwork",         20,   15 },
    { "   ",     "~/scripts/status/cpu",                 0,    18 },
    { "   ",     "~/scripts/status/memory",              0,    19 },
    { "   ",     "~/scripts/status/disk",                60,   16 },
    { "   ",     "~/scripts/status/lightlockerstatus",   0,    14 },
    { "   ",     "~/scripts/status/kblayout",            0,    12 },
    { "   ",     "~/scripts/status/volume",              0,    10 },
    /* { "  ",     "~/scripts/status/brightness",          0,    11 }, */
    { "   ",     "~/scripts/status/battery",             5,    17 },
    { "   ",     "~/scripts/status/clock",               5,    13 },
};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim = ' ';
```
I'm using spaces in the Icons column to have some padding between the indicators. The actual icons are the output of my scripts.

Now I'll cover the click functionality, as I promised:

To be able to have clickable icons, we first have to apply two patches for dwm itself. The first one is called [autostart](https://dwm.suckless.org/patches/autostart/), 
the second one is called [statuscmd-signal](https://dwm.suckless.org/patches/statuscmd/). Download and apply them with the patch command, just like with the previous 
patches. After the autostart patch you have to make a directory in your home folder called .dwm. Then you have to make a script called autostart.sh in that directory. 
Add the following content to the script:
```bash
#!/bin/bash
dwmblocks
```
This will start dwmblocks automatically with dwm. Don't forget to make the script executable.

Then we have to patch dwmblocks to finally have the click functionality. The patch is called [dwmblocks-statuscmd](https://dwm.suckless.org/patches/statuscmd/). 
(This links to the same page as the statuscmd-signal dwm patch. They are on the same page, scroll down to find them. You can find three patches there, but we
only need the statuscmd-signal for dwm and the dwmblocks-statucmd for dwmblocks).
Download and apply it, then install dwmblocks.

Now you can write little status scripts and handle click events in them. Here is my wifi script as an example:
```bash
#!/bin/sh

icon={{< fontawesome wifi >}}
essid=`iwgetid wlo1 --raw`
signal=`awk 'NR==3 {printf("%.0f%%",$3*10/7)}' /proc/net/wireless`

if [ -z "$essid" ]; then
    icon={{< fontawesome sad-tear>}}
    essid="no wifi"
    signal=""
fi

echo "$icon"

case $BUTTON in
    1) dunstify --replace=1 "$essid $signal" "Right click to open nmtui";;
    3) st -e nmtui;;
esac
```
Basicly the 'echo' command displays the icon on the bar, which is either a little wifi icon or a sad face if there is no connection. The 'case $BUTTON...' part handles the click events.
The $BUTTON variable comes from the signal patches we applied to dwm and dwmblocks. Case 1) means a left click, case 3) means a right click. Case 2) would mean a click with the mouse
wheel. Here the left click shows a little dunst notification with the essid and the signal strength of the current network, a right click opens up nmtui (a network management tool) in 
st (which is a terminal emulator).

You can find all my status scripts [here](https://github.com/laszloszurok/suckless-arch/tree/master/scripts/status).

To kill and refresh a status indicator with a key combination you can have something like this in your config.def.h file:
```c
static Key keys[] = {
    /* modifier   key                    function        argument */
    ...
    
    { 0,      XF86XK_AudioRaiseVolume,    spawn,     SHCMD("amixer sset Master 5%+ ; pkill -RTMIN+10 dwmblocks") },
    { 0,      XF86XK_AudioLowerVolume,    spawn,     SHCMD("amixer sset Master 5%- ; pkill -RTMIN+10 dwmblocks") },
    
    ...
};
```
If you want to display the curent volume level on the status bar, it will update when you raise or lover the volume with the built-in keys (I have these keys on my laptop).

This part:
```bash
pkill -RTMIN+10 dwmblocks
```
is the command which updates only the volume indicator. -RTMIN+10 means the indicator with the signal number of 10. (The number you set in dwmblocks/blocks.h)

## Colors with pywal
I am using a program called [pywal](https://github.com/dylanaraps/pywal), that generates colors based on your wallpaper. I use these colors in my dwm configurations. 
On Arch you can install pywal with the following command:
```terminal
sudo pacman -S python-pywal
```
Now configure dwm to use the generated colors. Open config.def.h and locate the following part:
```c
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#005577";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};
```
Comment out/delete the above lines and replace them with this single line:
```c
#include "<HOME>/.cache/wal/colors-wal-dwm.h"
```
Replace <HOME> with the path to your home directory (eg. /home/my_username). Now open the dwm.c file and search for the following line:
```c
enum { SchemeNorm, SchemeSel }; /* color schemes */
```
Add SchemeUrg to the end, like this:
```c
enum { SchemeNorm, SchemeSel, SchemeUrg }; /* color schemes */
```
This is needed becouse pywal generates different border colors for urgent windows and the build would fail if SchemeUrg would not be defined.

Now run the following command to actually set your wallpaper and generate the colors:
```terminal
wal -i path/to/an/image
```
Then rebuild and restart dwm.

To make your new terminal colors permanent add this line to your bashrc or zshrc:
```bash
(cat ~/.cache/wal/sequences &)
```
To make the wallpaper permanent between reboots add this line to ~/.dwm/autostart.sh:
```bash
wal -R
```
This will always restore the last wallpaper you set.

## Gaps
I am using the [tilegap](https://dwm.suckless.org/patches/tilegap/) patch to have some gap around the windows in tiling mode. Download, then apply it like this:
```terminal
sudo patch -p1 < dwm-tilegap-6.2.diff
```
Then you can set the gapsize in config.def.h like this:
```c
static const unsigned int gappx = 21; /* gap pixel between windows */
```

That's all for now, happy ricing!
