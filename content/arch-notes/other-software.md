---
title: "Setting up my most used programs"
date: 2020-05-09T18:32:02+02:00
draft: false
toc: true
summary: "Contents of this post: Settings and configurations for my most used programs (z, zsh, vifm, pywal, etc.)"
tags:
  - software
  - setup
---

## The Z program

The [z program](https://github.com/rupa/z) will make your life easier on the command line. Installation:

```terminal
git clone https://github.com/rupa/z ~/z
```
```terminal
mkdir ~/.cache/z
```
```terminal
echo ". ~/z/z.sh" >> ~/.zshrc
```
```terminal
exec $SHELL
```
Use it like this:
```terminal
cd grandparent-folder/parent-folder/child-folder
```
```terminal
cd different/path/to/another/folder
```
```terminal
z child-folder
```
The last command will take you back directly inside the directory called child-folder. The z program automatically updates itself as you use it, so it will always know the path of the folders you visited. Makes it much faster to move around in the filesystem.

## Spotify settings

I have a workspace deticated to Spotify in my DWM build. By default Spotify is not following the rules specified in DWM's config.h file, so the window won't be moved to the right workspace when you launch the program. Here's the fix for this problem:

Install a little program called spotifywm. This will help us to give Spotify a classname when it starts up, so DWM will be able to apply the rules to the Spotify window.

```terminal
git clone https://github.com/dasJ/spotifywm.git
```
```terminal
cd spotifywm
```
```terminal
make
```

The make command will build a binary file called spotifywm.so.

Now create a file called spotify under this location: /usr/local/bin/ with the following content:

```text
LD_PRELOAD=/usr/lib/libcurl.so.4:/home/<USERNAME>/spotifywm/spotifywm.so /usr/bin/spotify
```

Replace \<USERNAME\> with your username, then save the file and make it executable. Now if you launch Spotify it should open on the workspace it's assigned to.

## Changing the default shell to zsh

Install zsh:
```terminal
sudo pacman -S zsh
```
Change the shell for the current user:
```terminal
chsh -s /usr/bin/zsh
```

## Pywal color genearation

I like to add some extra prettiness to my window manager. [Pywal](https://github.com/dylanaraps/pywal) can generate colors based on your wallpaper and you can use them in your configuration files to have a unified colorscheme across your system. It will also set your terminal colors.

Install it from the AUR:
```terminal
yay -S python-pywal
```
You also need a utility to set a chosen image as your wallpaper. I'm using [feh](https://wiki.archlinux.org/index.php/Feh).
```terminal
sudo pacman -S feh
```
Run the following command to set your wallpaper and generate your colors:
```terminal
wal -i /path/to/an/image
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
```terminal
sudo make clean install
```
Now restart DWM to see the new colors.

## Dunst

[Dunst](https://wiki.archlinux.org/index.php/Dunst) is a little program for showing notifications on the desktop.
My configuration file for it is on my [github page](https://github.com/laszloszurok/suckless-arch/tree/master/.config/dunst). There is a little script as well, which will apply pywal generated colors for the notifications. You have to autostart this script for the colors to be applied. My DWM build has the autostart patch and executes this script when you log in.

## Neovim
[Neovim](https://neovim.io/) is a highly extensible refactor of Vim.

To automatically install [vim-plug](https://github.com/junegunn/vim-plug), add this to your init.vim file and restart the editor:
```vim
if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ~/.config/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif
```

To make the usage of vim or nvim more comfortable, I recommend swapping the CapsLock and Esapce keys functionality, as CapsLock is kind of a useless key, but in an easily reachable
position on the keyboard, while Escape is used fairly often if you use vim bindings. To make this happen, autostart the following command with .xinitrc, or your distros autostart tool:
```bash
setxkbmap -option 'caps:swapescape'
```

## VSCodium
[VSCodium](https://vscodium.com/) is the community driven, free-licensed version of VSCode (no Microsoft telemetry/tracking).

If you want to use vim keybindings with this editor, you have to install an extention called VSCodeVim. To be able to use the CapsLock key as Escape with the previous method, add the 
following line to your
settings.json:
```text
{
    ... ,

    "keyboard.dispatch": "keyCode",

    ...
}
```

## Vifm

[Vifm](https://wiki.archlinux.org/index.php/Vifm) is a terminal file manager. It uses vim like keybindings. 
You can set [color schemes](https://vifm.info/colorschemes.shtml) for it, my favourite is the palenight theme. To apply a theme, download and place it
inside .config/vifm/colors/ . Then open .config/vifm/vifmrc and add this line:
```vim
colorscheme palenight
```
By default vifm won't show image previews. To make that work, you need to add the following configuration to vifmrc:
```vim
fileviewer *.pdf
    \ vifmimg pdfpreview %px %py %pw %ph %c
    \ %pc
    \ vifmimg clear

fileviewer *.epub
    \ vifmimg epubpreview %px %py %pw %ph %c
    \ %pc
    \ vifmimg clear

fileviewer *.avi,*.mp4,*.wmv,*.dat,*.3gp,*.ogv,*.mkv,*.mpg,*.mpeg,*.vob,
    \*.fl[icv],*.m2v,*.mov,*.webm,*.ts,*.mts,*.m4v,*.r[am],*.qt,*.divx,
    \ vifmimg videopreview %px %py %pw %ph %c
    \ %pc
    \ vifmimg clear

fileviewer *.bmp,*.jpg,*.jpeg,*.png,*.xpm
    \ vifmimg draw %px %py %pw %ph %c
    \ %pc
    \ vifmimg clear

fileviewer *.gif
    \ vifmimg gifpreview %px %py %pw %ph %c
    \ %pc
    \ vifmimg clear

fileviewer *.ico
    \ vifmimg magickpreview %px %py %pw %ph %c
    \ %pc
    \ vifmimg clear
        
fileviewer <audio/*>
    \ vifmimg audiopreview %px %py %pw %ph %c
    \ %pc
    \ vifmimg clear
        
fileviewer <font/*>
    \ vifmimg fontpreview %px %py %pw %ph %c
    \ %pc
    \ vifmimg clear
```
Then clone this repo: <https://github.com/cirala/vifmimg> and place the vifmimg and vifmrun scripts in a folder that is included in your $PATH variable.
From now on, you have to launch vifm with the vifmrun script to have image-, pdf-, video thumbnail-, etc. previews. For faster access: alias vf=vifmrun.
