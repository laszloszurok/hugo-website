---
title: "Open files in a single instance of neovim"
date: 2024-10-12T16:26:53+02:00
---

## Nvim wrapper script

```sh
#!/bin/sh

socket=~/.cache/nvim/server.sock # socket path

if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
    # on the tty just launch nvim
    nvim "$@"
elif echo "$@" | grep vifm.rename; then
    # when bulk renaming in vifm just launch nvim
    nvim "$@"
else
    if [ -S "$socket" ]; then
        # An instance is already running.
        # Update the current working directory of the instance,
        # then open the new file.
        nvim --server "$socket" --remote-send ":cd $(pwd)<cr>" > /dev/null 2>&1
        nvim --server "$socket" --remote "$@" > /dev/null 2>&1
    else
        # No instance is running yet.
        # Launch a new instance in a terminal window.
        setsid -f kitty nvim "$@" --listen "$socket" > /dev/null 2>&1
    fi
fi
```

Make sure you specify the socket path as the last argument when launching a new instance with `--listen`.

This will work:

```terminal
nvim file1 --listen /path/to/socket
```

```terminal
nvim --server /path/to/socket --remote file2
```

This won't:

```terminal
nvim --listen /path/to/socket file1
```

```terminal
nvim --server /path/to/socket --remote file2
```
