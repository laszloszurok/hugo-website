---
title: "Disable status leds on a Raspberry Pi"
date: 2024-02-25T19:51:20+01:00
pagefind_index_page: true
---

## Switch to the root user

``` terminal
sudo su
```

## Disable the power led

```terminal
echo 0 > /sys/class/leds/PWR/brightness
```

## Disable the activity led

```terminal
echo 0 > /sys/class/leds/ACT/brightness
```
