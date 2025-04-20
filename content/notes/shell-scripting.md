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
set -o noclobber # fail when trying to overwrite an existing file
```

#### List all options

```terminal
set -o
```

### Sort grouped file names based on timestamp in the name

For example, suppose you have these files, each has the same prefix in the name, delimited by a colon, then some different "group names":

```txt
commonprefix:groupname1-202504201002.csv
commonprefix:groupname1-202504201103.csv
commonprefix:groupname1-202504201204.csv
commonprefix:groupname2-202504201305.csv
commonprefix:groupname2-202504201406.csv
commonprefix:groupname2-202504201507.csv
commonprefix:groupname3-202504201608.csv
commonprefix:groupname3-202504201709.csv
commonprefix:groupname3-202504201810.csv
```

To get the most recent file from each group (based on the timestamp in the names):

```terminal
find . -type f -name '*.csv' \
    | grep --extended-regexp "commonprefix:[A-Za-z].+-[0-9]+.*csv" --only-matching \
    | cut -d : -f 2 \
    | awk -F'-' '{for(i=NF;i>1;i--)printf "%s-",$i;printf "%s",$1;print ""}' \
    | sort --reverse \
    | sort -u -t- -k2 \
    | awk -F'-' '{for(i=NF;i>1;i--)printf "%s-",$i;printf "%s",$1;print ""}'
```

```txt
groupname1-202504201204.csv
groupname2-202504201507.csv
groupname3-202504201810.csv
```

## Bash

### Add flags to a command conditionally

```shell
if [ "$myvar" = "value" ]; then
    params+=(--myflag 'my value')
fi
mycommand "${params[@]}"
```
