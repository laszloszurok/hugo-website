---
title: "Redirect reddit to redlib"
date: 2024-04-01T12:51:22+02:00
pagefind_index_page: true
---

[redlib](https://github.com/redlib-org/redlib)

## Nginx proxy to forward redlib.yourdomain to localhost:8080

```text
server {
    listen 80;
    server_name redlib.yourdomain;
    location / {
        proxy_set_header   X-Forwarded-For $remote_addr;
        proxy_set_header   Host $http_host;
        proxy_pass         "http://127.0.0.1:8080";
    }
}
```

Launch nginx:
```terminal
systemctl start nginx
```

Launch redlib:
```terminal
setsid -f redlib
```

## Qutebrowser config for automatic rewriting of reddit urls

([qutebrowser](https://github.com/qutebrowser/qutebrowser))

Add to `~/.config/qutebrowser/config.py`:
```py
from qutebrowser.api import interceptor, message

REDIRECT_MAP = {
    "reddit.com": 'redlib.yourdomain',
    "www.reddit.com": 'redlib.yourdomain',
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
