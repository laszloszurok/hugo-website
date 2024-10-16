---
title: "Shell scripting notes"
date: 2024-10-16T19:26:00+02:00
---

## POSIX

### Redirect multiple lines at once

```bash
{
    echo hello
    echo world
    echo !
} > myfile
```

## Bash

## Useful options

```bash
set -o errexit # exit when a command returns a non-zero exit code
set -o nounset # exit when an undefined varialbe is used
set -o pipefail # stop a pipeline if a command returns a non-zero exit code
set -o xtrace # print the currently executed line to stdout
```

### List all options

```terminal
set -o
```

### Add flags to a command conditionally

```bash
if [ "$myvar" = "value" ]; then
    params+=(--myflag 'my value')
fi
mycommand "${params[@]}"
```
