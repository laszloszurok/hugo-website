---
title: "Create a qrcode which can be scanned to connect to Wifi"
date: 2025-03-30T18:52:10+02:00
---

## Generate qrcode with qrencode

```terminal
qrencode 'WIFI:T:WPA;S:MySSID;P:MyPassword;;' -o qrcode.png
```

### Meaning of the fields

https://github.com/zxing/zxing/wiki/Barcode-Contents#wi-fi-network-config-android-ios-11

| parameter | example    | description |
| :-------- | :--------- | :---------- |
| T         | WPA        |  Authentication type; can be WEP or WPA or WPA2-EAP, or nopass for no password. Or, omit for no password. |
| S         | mynetwork  | Network SSID. Required. Enclose in double quotes if it is an ASCII name, but could be interpreted as hex (i.e. "ABCD") |
| P         | mypass     | Password, ignored if T is nopass (in which case it may be omitted). Enclose in double quotes if it is an ASCII name, but could be interpreted as hex (i.e. "ABCD") |
| H         | true       | Optional. True if the network SSID is hidden. Note this was mistakenly also used to specify phase 2 method in releases up to 4.7.8 / Barcode Scanner 3.4.0. If not a boolean, it will be interpreted as phase 2 method (see below) for backwards-compatibility |
| E         | ttls       | (WPA2-EAP only) EAP method, like TTLS or PWD |
| A         | anon       | (WPA2-EAP only) Anonymous identity |
| I         | myidentity | (WPA2-EAP only) Identity |
| PH2       | MSCHAPV2   | (WPA2-EAP only) Phase 2 method, like MSCHAPV2 |

