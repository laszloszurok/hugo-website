---
title: 'Disable USB wakeup'
date: 2025-12-19T10:50:45+01:00
pagefind_index_page: true
---

This fixes the problem where a Logitech Bolt USB dongle prevents the system from going to sleep.

## Using udev rules

### Find the vendor ID and product ID of the dongle:

```terminal
lsusb | grep -i logitech
```

```text
Bus 008 Device 005: ID 046d:c548 Logitech, Inc. Logi Bolt Receiver
```

### Create `/etc/udev/rules.d/90-logi-bolt-wakeup.rules` and add:

```text
ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c548", ATTR{power/wakeup}="disabled"
```

### Finally make sure the rule takes effect:

```terminal
sudo udevadm control --reload
```

```terminal
sudo udevadm trigger
```

## Alternative solution

This prevents a specific USB port from waking the system, so if you plug the dongle into an other port you'll have to repeat these steps.

### List USB devices that can wake up the system from sleep

```terminal
cat /proc/acpi/wakeup
```

```text
Device  S-state  Status     Sysfs node
GPP6    S0       *enabled   pci:0000:00:02.2
GPP7    S0       *disabled
GP11    S0       *disabled
SWUS    S4       *disabled
GP12    S0       *enabled   pci:0000:00:04.1
SWUS    S4       *disabled
XHC0    S3       *enabled   pci:0000:33:00.3
XHC1    S3       *disabled  pci:0000:33:00.4
NHI0    S0       *disabled
NHI1    S0       *enabled   pci:0000:34:00.6
XHC2    S3       *enabled   pci:0000:34:00.0
XHC3    S3       *enabled   pci:0000:34:00.3
XHC4    S3       *enabled   pci:0000:34:00.4
LID     S4       *enabled   platform:PNP0C0D:00
SLPB    S3       *enabled   platform:PNP0C0E:00
```

### Toggle device status

```terminal
echo XHC4 > /proc/acpi/wakeup
```
