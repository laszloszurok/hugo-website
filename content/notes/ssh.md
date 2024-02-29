---
title: "SSH notes"
date: 2024-02-29T11:42:51+01:00
draft: false
---

## Tunnel a remote port to localhost through a jump host

With `-o ProxyCommand`:

```terminal
ssh -o ProxyCommand='ssh -W %h:%p -i myssh.key $user@$jumpserver_ip' -i myssh.key -L $local_port:$address_to_forward:$port_to_forward $user@$remote_ip
```

Or with `-J` and the follwing `~/.ssh/config`:

```text
Host <jumpserver_ip>
    User <user>
    IdentityFile /path/to/myssh.key
```

```terminal
ssh -J $user@$jumpserver_ip -i myssh.key -L $local_port:$address_to_forward:$port_to_forward $user@remote
```
