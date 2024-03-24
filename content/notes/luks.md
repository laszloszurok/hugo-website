---
title: "Notes about LUKS"
date: 2023-10-14T15:39:59+02:00
---

## Add a label to a LUKS encrypted btrfs filesystem

Open the device:

```terminal
sudo cryptsetup open /dev/sdxx name
```

Mount it:

```terminal
udisksctl mount -b /dev/mapper/name
```

Add a label:

```terminal
sudo btrfs filesystem label /run/media/user/some-UUID yourlabel
```

Label is effective for subsequent mounts.

## Add a secondary PBKDF2 key for decryption

By default cryptsetup will use the Argon2i key derivation function.
Decrypting the partition on a device with less memory than of the machine on which the encryption took place could fail when using cryptsetup with the default settings.
(Argon2i is memory-hard, meaning it requires a significant amount of memory to compute, which makes it resistant to GPU and ASIC attacks.)

Add PBKDF2 key (PBKDF2 is more computationally intensive but does not have the same memory-hard properties as Argon2i):

```terminal
sudo cryptsetup luksAddKey --key-slot 1 --pbkdf pbkdf2 /dev/sdxx
```

Decrypt the partition using the added key slot:

```terminal
sudo cryptsetup open --key-slot 1 /dev/sdxx yourlabel
```
