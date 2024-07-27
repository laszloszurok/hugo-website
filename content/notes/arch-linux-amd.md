---
title: "Arch Linux AMD setup"
date: 2024-07-27T19:41:16+02:00
---

## Quick setup

```terminal
sudo pacman -S xf86-video-amdgpu mesa vulkan-radeon libva-mesa-driver
```

## Details

### 2D, 3D acceleration

docs: https://wiki.archlinux.org/title/AMDGPU

packages:
* xf86-video-amdgpu
* mesa

### Vulkan

docs: https://wiki.archlinux.org/title/Vulkan

packages:
* vulkan-radeon

### Hardware video acceleration

docs: https://wiki.archlinux.org/title/Hardware_video_acceleration

packages:
* libva-mesa-driver
