---
title: 'Home Assistant notes'
date: 2025-11-30T16:35:57+01:00
pagefind_index_page: true
---

## Add a Thread device to Home Assistant

### Get an OpenThread border router device

For example: Sonoff ZBDongle-E (Zigbee by default, but the OpenThread firmware can be flashed on it here: https://dongle.sonoff.tech/sonoff-dongle-flasher/)

### OpenThread border router add-on

Install the `OpenThread Border Router` add-on on your `Home Assistant`.
(to enable add-ons, go to `http://your.home.assistant/profile/general` and enable it in the `User settings` section)

This will also install the `Thread` and `Matter` integrations.

Set up the border router in the `OpenThread Border Router` add-on configuration section, then restart `Home Assistant`.

### Add a device

In the `Home Assistant` mobile application, go to: `Settings` -> `Companion app` -> `Troubleshooting` -> `Sync Thread credentials`.

After the sync, go to: `Settings` -> `Devices & services` -> `Matter` -> `Add device`, then follow the instructions.

In case of Android, if the device cannot be added, try installing the `Google Home` application, then go through the process again in the `Home Assistant` app.

If the thread network name is incorrect on Android, the storage of the `Google Play Services` app has to be deleted, because Google saves the first thread network name that you add and for some reason it can not be updated later with the home assistant app.
So delete the storage, reboot the phone and sync the credentials again from home assistant, then the network name should be correct.
