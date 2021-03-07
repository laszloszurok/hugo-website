---
title: "Extend your home network"
date: 2020-08-18T22:04:44+02:00
summary: "A repeater is a device that is used to extend transmissions so that the signal can cover longer distances. If you want to extend the 
coverage of your wireless network, you can set up a secondary router to connect to your main router and act as a repeater. Nowadays most routers
have this functionality built in. In this tutorial I'm going to show an example setup with a D-Link device as the repeater." 
toc: true
draft: false
tags:
 - wireless
 - router
 - repeater
---

A repeater is a device that is used to extend transmissions so that the signal can cover longer distances. 

If you want to extend the coverage of your wireless network, you can set up a secondary router to connect to your main router and act as a repeater. 
Nowadays most routers have this functionality built in. 

In this tutorial I'm going to show an example setup with a D-Link device as the repeater.

## Factory reset the secondary router

First you have to reset the device to its factory settings. Most routers have a little button on the back, labeled as RESET. You usually have to hold that button for
10 seconds to perform a factory reset.

## Accessing the settings

Connect the secondary router to your computer with an ethernet cable. Check the devices back for its default IP address and login credentials. In my case the IP is 192.168.0.1. Enter that IP
address to the url bar of your webbrowser to open the configuration page. Log in with the given credentials (usually admin-admin).

## Repeater settings

In the case of my D-Link device, the setting we're looking for is under the Wireless -> Wireless Repeater menupoint.

{{< image src="/img/blog/router-repeater/menupoint.png" alt="Where" position="center" style="border-radius: 4px;" >}}

Here, click Site Survey to begin the setup and wait until the process is finished. 

After that, select the network you want to extend and click next. 

{{< image src="/img/blog/router-repeater/select-network.png" alt="Where" position="center" style="border-radius: 4px;" >}}

Now you will have to enter the password for the extended network, which has to match with the password of the network you want to extend.

{{< image src="/img/blog/router-repeater/security.png" alt="Where" position="center" style="border-radius: 4px;" >}}

The next step is to change the default IP address of the device, so it won't conflict with the address of the main access point. I'm going to change it to 192.168.0.2, because 192.168.0.1 is the address of the main router.

{{< image src="/img/blog/router-repeater/change-ip.png" alt="Where" position="center" style="border-radius: 4px;" >}}

## Changing the SSID

Now locate the wireless settings in your device (in my case Wireless -> Wireless Basics) and enter an SSID for the device that differs from the SSID of the main router.

## Rebooting

Save your settings and look for the reboot option. In my case it's under Maintenance -> Reboot.

Give a little time for the repeater to boot up, then you should be able to connect to the network through it. 
