---
title: 'Systemd ACPI events'
date: 2025-12-24T10:35:25+01:00
pagefind_index_page: true
---

## Change the power key behaviour

### Create logind drop-in configuration

Default values can be found in `/etc/systemd/logind.conf`.
Create directory `/etc/systemd/logind.conf.d` and a file inside it, e.g. `powerkey.conf`.
Content:

```ini
[Login]
HandlePowerKey=suspend
HandlePowerKeyLongPress=poweroff
```

### Reload the logind service

```terminal
systemctl reload systemd-logind.service
```
