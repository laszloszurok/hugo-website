---
title: "Encrypt git repository content before pushing"
date: 2026-10-03T19:03:08+02:00
---

https://github.com/spwhitton/git-remote-gcrypt

`git-remote-gcrypt` will encrypt the repo content using GPG before pushing to the remote.

## Install git-remote-gcrypt

Ubuntu:

```terminal
sudo apt install git-remote-gcrypt
```

## Generate a GPG key if you don't have one already

```terminal
gpg --full-gen-key
```

## Git repo setup

### Create git repository as usual

```terminal
git init .
```

### Configure the remote

Using ssh:

```terminal
git remote add origin gcrypt::git@my.remote.url:myuser/myrepo
```

Using https:

```terminal
git remote add origin gcrypt::https://my.remote.url/myuser/myrepo
```

#### Editing an existing remote url

```terminal
git config remote.origin.url gcrypt::git@my.remote.url:myuser/myrepo
```
