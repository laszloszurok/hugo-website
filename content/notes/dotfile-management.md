---
title: "Linux dotfile management with git"
date: 2024-02-15T17:54:27+01:00
---

## First time initialization

```terminal
mkdir $HOME/.cfg
```
```terminal
git init --bare $HOME/.cfg
```
```terminal
alias cfg="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
```
```terminal
cfg remote add origin <remote-url>
```
```terminal
echo ".cfg" >> .gitignore 
```

## Clone existing repo

```terminal
git clone --bare <remote-git-repo-url> --branch <some-branch> $HOME/.cfg 
```
```terminal
alias cfg="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
```
```terminal
cfg checkout --force
```
