---
title: 'Set up Appium Device Farm on MacOS'
date: 2025-10-17T20:04:00+02:00
draft: true
pagefind_index_page: true
---

## Dependecies

Install these as a non-root user.

### Node

#### Install node version manager (nvm)

https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating

```terminal
curl -LO https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh
```
```terminal
bash install.sh
```

#### Install node and the node package manager (npm) with nvm

https://github.com/nvm-sh/nvm?tab=readme-ov-file#usage

```terminal
nvm install node # "node" is an alias for the latest version
```

### Appium

#### Install the appium server

https://github.com/appium/appium

```terminal
npm -g install appium
```

#### Install the appium chrome driver

https://github.com/appium/appium-chromedriver

```terminal
npm install -g appium-chrome-driver
```

#### Install the appium device farm plugin

https://github.com/AppiumTestDistribution/appium-device-farm

```terminal
appium plugin install --source=npm appium-device-farm
```

#### For use of phisical mobile devices, install Android and iOS appium drivers

For android:

https://github.com/appium/appium-uiautomator2-driver

```terminal
appium driver install uiautomator2
```

For ios:

https://github.com/appium/appium-xcuitest-driver

```terminal
appium driver install xcuitest
```

## Start the appium server on boot

TODO
