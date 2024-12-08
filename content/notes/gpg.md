---
title: "Gnupg notes"
date: 2024-12-08T20:19:17+01:00
---

## Reload the agent after a version update

Resolves the "gpg-agent is older than us" warning.

```terminal
gpgconf --kill all
```
