---
title: "Shell scripting notes"
date: 2024-10-16T19:26:00+02:00
---

## POSIX

### Redirect multiple lines at once

```shell
{
    echo hello
    echo world
    echo !
} > myfile
```

### Useful options

```shell
set -o errexit # exit when a command returns a non-zero exit code
set -o nounset # exit when an undefined varialbe is used
set -o xtrace # print the currently executed line to stdout
set -o pipefail # (this one is bash only) stop a pipeline if a command returns a non-zero exit code
```

#### List all options

```terminal
set -o
```

## Bash

### Add flags to a command conditionally

```shell
if [ "$myvar" = "value" ]; then
    params+=(--myflag 'my value')
fi
mycommand "${params[@]}"
```
