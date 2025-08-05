---
title: "Linux dotfile management with git"
date: 2024-02-15T17:54:27+01:00
pagefind_index_page: true
---

## First time initialization

```terminal
mkdir $HOME/.dotfiles
```
```terminal
git init --bare $HOME/.dotfiles
```
```terminal
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
```
```terminal
dotfiles remote add origin <remote-url>
```
```terminal
echo ".dotfiles" >> .gitignore
```

## Clone existing repo

```terminal
git clone --bare <remote-git-repo-url> --branch <some-branch> $HOME/.dotfiles
```
```terminal
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
```
```terminal
dotfiles config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
```
```terminal
dotfiles checkout --force
```
