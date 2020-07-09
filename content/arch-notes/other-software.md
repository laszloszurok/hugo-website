---
title: "Setting up my most used programs"
date: 2020-05-09T18:32:02+02:00
draft: false
toc: false
images:
tags:
  - software
  - setup
---

## The Z program

The [z program](https://github.com/rupa/z) will make your life easier on the command line. Installation:

```
❯ git clone https://github.com/rupa/z ~/z
```
```
❯ mkdir ~/.cache/z
```
```
❯ echo ". ~/z/z.sh" >> ~/.zshrc
```
```
❯ exec $SHELL
```
Use it like this:
```
❯ cd grandparent-folder/parent-folder/child-folder
❯ cd different/path/to/another/folder
❯ z child-folder
```
The last command will take you back directly inside the directory called child-folder. The z program automatically updates itself as you use it, so it will always know the path of the folders you visited. Makes it much faster to move around in the filesystem.

## Spotify settings

I have a workspace deticated to Spotify in my DWM build. By default Spotify is not following the rules specified in DWM's config.h file, so the window won't be moved to the right workspace. Here's the fix for this problem:

Install a little program called spotifywm. This will help us to give Spotify a classname when it starts up, so DWM will be able to apply the rules to the Spotify window.

```
❯ git clone https://github.com/dasJ/spotifywm.git
```
```
❯ cd spotifywm
```
```
❯ make
```

The make command will build a binary file called spotifywm.so.

Now create a file called spotify under this location: /usr/local/bin/ with the following content:

```text
LD_PRELOAD=/usr/lib/libcurl.so.4:/home/<USERNAME>/spotifywm/spotifywm.so /usr/bin/spotify
```

Replace \<USERNAME\> with your username, then save the file and make it executable. Now if you launch Spotify it should open on the workspace it's assigned to.
