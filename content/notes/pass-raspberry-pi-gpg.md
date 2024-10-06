---
title: "Password management with pass and a Raspberry Pi"
date: 2022-08-28T10:43:35+02:00
---

## Requirements

* a working Raspberry Pi with ssh access and git installed
* an other computer with [pass](https://www.passwordstore.org/), [gpg](https://www.gnupg.org/) and git installed
* for android:
    * [OpenKeyChain](https://www.openkeychain.org/) and [Password Store](https://passwordstore.app/),
    * or [Termux](https://termux.dev/en/) (pkg install pass)

## Create a repository on the Pi

```terminal
git init --bare
```

## First time pass setup

Generate a gpg key:

```terminal
gpg --full-gen-key
```

Get the ID of the key:

```terminal
gpg --list-keys
```

```text
/home/user/.gnupg/pubring.kbx
-------------------------------------------
pub   rsa3072 2022-08-24 [SC]
      3B45F6I8F73C872F57B227F1232F1A65AC6F5044
uid           [ultimate] user <user@somedomain>
sub   rsa3072 2022-08-24 [E]
```

Initialize pass:

```terminal
pass init 3B45F6I8F73C872F57B227F1232F1A65AC6F5044
```
```terminal
pass git init
```
```terminal
pass git remote add password-store user@ip_addr_of_pi:/path/to/the/repo
```

Push to the Pi:

```
pass git push -u --all
```

## Set up pass on a new machince with an already existing repo on the Pi

For easy configuration of gnupg, copy the gnupg directory to the Pi:
```terminal
scp -rp ~/path/to/gnupg user@ip_addr_of_pi:.gnupg
```
then it can be pulled to the new machine:
```terminal
scp -rp user@ip_addr_of_pi:.gnupg ~/path/to/gnupg
```
clone the pass repository:
```terminal
git clone user@ip_addr_of_pi:/path/to/passwordstore ~/path/to/passwordstore
```

## Set up Password Store for Android

Export your private key:

```terminal
gpg --armor --export-secret-keys 3B45F6I8F73C872F57B227F1232F1A65AC6F5044 > gpg-private-key.asc
```

App settings:

Copy the exported key onto the Android device and import it to OpenKeyChain.
In the Password Store app provide the url of the repository on the Pi (e.g. `user@ip_addr_of_pi:/path/to/the/repo`) and clone with ssh.
