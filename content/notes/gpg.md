---
title: "Gnupg notes"
date: 2024-12-08T20:19:17+01:00
---

## Reload the agent after a version update

Resolves the "gpg-agent is older than us" warning.

```terminal
gpgconf --kill all
```

## Renew expired key

```terminal
gpg --list-keys
```

```terminal
gpg --edit-key <keyid>
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
