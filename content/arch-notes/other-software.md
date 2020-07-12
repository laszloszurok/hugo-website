---
title: "Setting up my most used programs"
date: 2020-05-09T18:32:02+02:00
draft: false
toc: true
images:
tags:
  - software
  - setup
---

## The Z program

The [z program](https://github.com/rupa/z) will make your life easier on the command line. Installation:

```text
❯ git clone https://github.com/rupa/z ~/z
```
```text
❯ mkdir ~/.cache/z
```
```text
❯ echo ". ~/z/z.sh" >> ~/.zshrc
```
```text
❯ exec $SHELL
```
Use it like this:
```text
❯ cd grandparent-folder/parent-folder/child-folder
❯ cd different/path/to/another/folder
❯ z child-folder
```
The last command will take you back directly inside the directory called child-folder. The z program automatically updates itself as you use it, so it will always know the path of the folders you visited. Makes it much faster to move around in the filesystem.

## Spotify settings

I have a workspace deticated to Spotify in my DWM build. By default Spotify is not following the rules specified in DWM's config.h file, so the window won't be moved to the right workspace when you launch the program. Here's the fix for this problem:

Install a little program called spotifywm. This will help us to give Spotify a classname when it starts up, so DWM will be able to apply the rules to the Spotify window.

```text
❯ git clone https://github.com/dasJ/spotifywm.git
```
```text
❯ cd spotifywm
```
```text
❯ make
```

The make command will build a binary file called spotifywm.so.

Now create a file called spotify under this location: /usr/local/bin/ with the following content:

```text
LD_PRELOAD=/usr/lib/libcurl.so.4:/home/<USERNAME>/spotifywm/spotifywm.so /usr/bin/spotify
```

Replace \<USERNAME\> with your username, then save the file and make it executable. Now if you launch Spotify it should open on the workspace it's assigned to.

## Changing the default shell to zsh

Install zsh:
```text
❯ sudo pacman -S zsh
```
Change the shell for the current user:
```text
❯ chsh -s /usr/bin/zsh
```

## Pywal color genearation

I like to add some extra prettiness to my window manager. [Pywal](https://github.com/dylanaraps/pywal) can generate colors based on your wallpaper and you can use them in your configuration files to have a unified colorscheme across your system. It will also set your terminal colors.

Install it from the AUR:
```text
❯ yay -S python-pywal
```
You also need a utility to set a chosen image as your wallpaper. I'm using [feh](https://wiki.archlinux.org/index.php/Feh).
```text
❯ sudo pacman -S feh
```
Run the following command to set your wallpaper and generate your colors:
```text
❯ wal -i /path/to/an/image
```
Your terminal colors will be set automatically, but not permanently. To apply the colors for every new terminal window, you have to add the following line to your .bashrc or .zshrc file:
```bash
(cat ~/.cache/wal/sequences &)
```
Now configure DWM to use the generated colors. Open the config.h file and delete or comment out the following lines:
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
Replace them with this single line:
```c
#include "/home/<USER>/.cache/wal/colors-wal-dwm.h"
```
Replace \<USER\> with your username. 

You have to reinstall DWM to apply the changes:
```text
❯ sudo make clean install
```
Now restart DWM to see the new colors.

## Dunst

[Dunst](https://wiki.archlinux.org/index.php/Dunst) is a little program for showing notifications on the desktop.
My configuration file for it is on my [github page](https://github.com/laszloszurok/suckless-arch/tree/master/.config/dunst). There is a little script as well, which will apply pywal generated colors for the notifications. You have to autostart this script for the colors to be applied. My DWM build has the autostart patch and executes this script when you log in.
