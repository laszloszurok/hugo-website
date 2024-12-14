---
title: "Tools for reduceing image file size"
date: 2024-12-14T15:44:27+01:00
---

## jpegoptim

```terminal
jpegoptim --size 256k /path/to/image.jpg
```

## imagemagick

### mogrify

```terminal
mogrify -compress JPEG -quality 50 /path/to/image.jpg
```

### magick

```terminal
magick -quality 80% /path/to/source/image.jpg /path/to/result/image.jpg
```
