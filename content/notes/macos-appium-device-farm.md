---
title: 'Set up Appium Device Farm on MacOS'
date: 2025-10-17T20:04:00+02:00
pagefind_index_page: true
---

## Dependecies

Install these as a non-root user.

### Android Debug Bridge (adb)

If you install Android Studio, adb will be available on this path: `/Users/youruser/Library/Android/sdk/platform-tools`

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

### LaunchDaemon configuration

Create `/Library/LaunchDaemons/com.devicefarm.appium.plist`.
Node and appium are installed for your user, so absolute paths have to be used and some environment variables have to be set in the service plist for appium to launch successfully.
The user environment variables can be printed with the `env` command.

Validate the syntax with:

```terminal
sudo plutil -lint /Library/LaunchDaemons/com.devicefarm.appium.plist
```

The service will be started on boot.
You can also start it with:

```terminal
sudo launchctl load /Library/LaunchDaemons/com.devicefarm.appium.plist
```

View status:

```terminal
sudo launchctl list com.devicefarm.appium
```

Stop:

```terminal
sudo launchctl unload /Library/LaunchDaemons/com.devicefarm.appium.plist
```

`/Library/LaunchDaemons/com.devicefarm.appium.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.devicefarm.appium</string>

  <key>ProgramArguments</key>
  <array>
    <string>/Users/youruser/.nvm/versions/node/v20.19.5/bin/appium</string>
    <string>server</string>
    <string>-ka</string>
    <string>800</string>
    <string>--use-plugins</string>
    <string>device-farm</string>
    <string>-pa</string>
    <string>/wd/hub</string>
    <string>--plugin-device-farm-platform</string>
    <string>both</string>
    <string>--plugin-device-farm-ios-device-type</string>
    <string>real</string>
    <string>--plugin-device-farm-android-device-type</string>
    <string>real</string>
    <string>--allow-insecure</string>
    <string>'*:chromedriver_autodownload'</string>
  </array>

  <key>WorkingDirectory</key>
  <string>/Users/youruser</string>

  <key>EnvironmentVariables</key>
  <dict>
    <key>PATH</key>
    <string>/Users/youruser/.nvm/versions/node/v20.19.5/bin:/Users/youruser/Library/Android/sdk/platform-tools:/usr/local/bin</string>

    <key>HOME</key>
    <string>/Users/youruser</string>

    <key>ANDROID_HOME</key>
    <string>/Users/youruser/Library/Android/sdk</string>

    <key>ANDROID_SDK_ROOT</key>
    <string>/Users/youruser/Library/Android/sdk</string>

    <key>JAVA_HOME</key>
    <string>/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home</string>

    <key>NVM_DIR</key>
    <string>/Users/youruser/.nvm</string>

    <key>NVM_CD_FLAGS</key>
    <string>-q</string>

    <key>NVM_BIN</key>
    <string>/Users/youruser/.nvm/versions/node/v20.19.5/bin</string>

    <key>NVM_INC</key>
    <string>/Users/youruser/.nvm/versions/node/v20.19.5/include/node</string>
  </dict>

  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>

  <key>StandardOutPath</key>
  <string>/var/log/appium.out</string>
  <key>StandardErrorPath</key>
  <string>/var/log/appium.err</string>
</dict>
</plist>
```

## Log rotation

The above config writes appium logs to `/var/log/appium.out` and `/var/log/appium.err`.
By default these files will grow indefinitely, so rotation has to be configured for old logs to be removed from the filesystem.

Create `/etc/newsyslog.d/com.devicefarm.appium.conf` with the below content:

```txt
/var/log/appium.out  644  7  1000  *  Z
/var/log/appium.err  644  7  1000  *  Z
```

Explanation:

| field | meaning |
| :---- | :------ |
| /var/log/myapp.out | Log file path
| 644 | File mode after rotation
| 7 | Keep 7 old log files
|1000 | Rotate when file >1000 KB (1 MB)
| * | Don’t rotate on schedule (only by size)
| Z | Compress old logs with gzip

To execute a manual rotation, run:

```terminal
sudo newsyslog -v
```
