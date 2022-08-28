---
title: "Software setup"
date: 2020-05-09T18:32:02+02:00
draft: false
toc: true
summary: "Contents of this post: Settings and configurations for my most used programs (z, zsh, vifm, pywal, etc.)"
tags:
  - software
  - setup
---

## zsh
Install [zsh](https://wiki.archlinux.org/index.php/zsh):
```terminal
sudo pacman -S zsh
```
Change the shell for the current user:
```terminal
chsh -s /usr/bin/zsh
```

## Zoxide

[Zoxide](https://github.com/ajeetdsouza/zoxide) will make your life easier on the command line. Installation:

```terminal
paru -S zoxide-bin
```
Add this to your zshrc:
```bash
eval "$(zoxide init zsh)"
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
The last command will take you back directly inside the directory called child-folder. Zoxide automatically updates itself as you use it, so it will always know the path of the folders you visited. Makes it much faster to move around in the filesystem.

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
position on the keyboard, while Escape is used fairly often if you use vim bindings. To make this happen, autostart the following command (eg. with .xinitrc):
```bash
setxkbmap -option 'caps:swapescape'
```
## Vifm

[Vifm](https://wiki.archlinux.org/index.php/Vifm) is a terminal file manager. It uses vim like keybindings. 
To apply [color schemes](https://vifm.info/colorschemes.shtml), download and place it inside .config/vifm/colors/ . Then open .config/vifm/vifmrc and add this line
(replace themename):
```vim
colorscheme themename
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
Then clone this repo: [https://github.com/cirala/vifmimg](https://github.com/cirala/vifmimg) place the vifmimg and vifmrun scripts in a folder that is included in your $PATH variable.
From now on, you have to launch vifm with the vifmrun script to have image-, pdf-, video thumbnail-, etc. previews.

## Spotify

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


## VSCodium
[VSCodium](https://vscodium.com/) is the community driven, free-licensed version of VSCode (no Microsoft telemetry/tracking).

If you want to use vim keybindings with this editor, you have to install an extention called VSCodeVim. To be able to use the CapsLock key as Escape, like with Neovim, add the following line to your settings.json:
```text
{
    ... ,

    "keyboard.dispatch": "keyCode",

    ...
}
```

