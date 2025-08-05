---
title: "VS Code caps-escape"
date: 2024-02-18T13:56:07+01:00
pagefind_index_page: true
---

## VS Code settings.json

By default VS Code will override keyboard keypress modifications.
To disable this, add the following to VS Code settings.json:

```text
{
    ... ,

    "keyboard.dispatch": "keyCode",

    ...
}
```
