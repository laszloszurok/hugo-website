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

## Make a port on a remote host available for kubernetes pods through an ssh jump host

ssh `-g`: Allows  remote  hosts  to  connect to local forwarded ports.

### Remote forward the port to the jump host

`$remote_ip:$remote_port` has to be available on the network of the host from which this command is executed.

```terminal
ssh $user@$jumpserver_ip -gfNT -R $remote_port:$remote_ip:$remote_port
```

### Local forwad the port from the jump server to a pod

#### Create a pod in kubernetes with ssh in it an expose the target port

```terminal
kubectl run ssh-tunnel \
    --rm \
    --image=linuxserver/openssh-server \
    --restart=Never \
    --expose --port $remote_port \
    -- bash -c 'while true; do sleep 30; done;'
```

#### Exec into the pod

```terminal
kubectl exec -it ssh-tunnel -- bash
```

#### Open the tunnel inside the pod

```terminal
ssh $user@$jumpserver_ip -gfNT -L $remote_port:127.0.0.1:$remote_port
```

Now other pods can access `$remote_ip:$remote_port` using `ssh-tunnel:$remote_port`.
