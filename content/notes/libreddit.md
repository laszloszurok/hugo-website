---
title: "Redirect reddit to libreddit"
date: 2024-04-01T12:51:22+02:00
---

[Libreddit](https://github.com/libreddit/libreddit) will run locally on port 8080 and will be accessed on the `libreddit.local` url.

(The reddit API changes rendered most public libreddit instances [unusable](https://github.com/libreddit/libreddit/issues/840), but it still works fine if you run a local instance for yourself.)

## Nginx proxy to redirect libreddit.local to localhost:8080

Add to `/etc/hosts`:
```text
127.0.0.1 libreddit.local
```

Add to `/etc/nginx/nginx.conf`:
```text
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen 80;
        server_name libreddit.local;
        location / {
            proxy_set_header   X-Forwarded-For $remote_addr;
            proxy_set_header   Host $http_host;
            proxy_pass         "http://127.0.0.1:8080";
        }
    }
}
```

Launch nginx:
```terminal
systemctl start nginx
```

Launch libreddit:
```terminal
setsid -f libreddit
```

## Qutebrowser config for automatic rewriting of reddit urls

([qutebrowser](https://github.com/qutebrowser/qutebrowser))

Add to `~/.config/qutebrowser/config.py`:
```py
from qutebrowser.api import interceptor, message

REDIRECT_MAP = {
    "reddit.com": 'libreddit.local',
    "www.reddit.com": 'libreddit.local',
}

def int_fn(info: interceptor.Request):
    if (info.resource_type != interceptor.ResourceType.main_frame or
            info.request_url.scheme() in {"data", "blob"}):
        return
    url = info.request_url
    source_host = url.host()
    target_host = REDIRECT_MAP.get(source_host)
    if target_host is not None and url.setHost(target_host) is not False:
        if source_host == "reddit.com" or source_host == "www.reddit.com":
            url.setScheme('http')
        message.info("Redirecting to " + url.toString())
        info.redirect(url)

interceptor.register(int_fn)
```
