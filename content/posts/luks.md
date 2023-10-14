---
title: "Notes about LUKS"
date: 2023-10-14T15:39:59+02:00
---

## Add a label to a LUKS encrypted btrfs filesystem

Open the device:

```terminal
sudo cryptsetup open /dev/sda1 axagon
```

Mount it:

```terminal
udisksctl mount -b /dev/sdx name
```

Add a label:

```terminal
sudo btrfs filesystem label /run/media/user/some-UUID yourlabel
```

Label is effective for subsequent mounts.
