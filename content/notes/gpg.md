---
title: "Gnupg notes"
date: 2024-12-08T20:19:17+01:00
---

## Reload the agent after a version update

Resolves the "gpg-agent is older than us" warning.

```terminal
gpgconf --kill all
```

## Generate a new key

```terminal
gpg --full-gen-key
```

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

Key ID: 3B45F6I8F73C872F57B227F1232F1A65AC6F5044

## Export your private key

```terminal
gpg --armor --export-secret-keys '<keyid>' > gpg-private-key.asc
```

## Renew an expired key

```terminal
gpg --list-keys
```

```terminal
gpg --edit-key '<keyid>'
```

### Set new expiration date for the primary key (key 0)

```text
gpg> expire
```

### Select sub-keys and set new expiration date for them

```text
gpg> key 1
gpg> key 2
gpg> expire
```

### Make sure the keys are trusted after the edits

```text
gpg> trust
```

### Save

```text
gpg> save
```
