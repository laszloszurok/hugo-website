---
title: "FFmpeg notes"
date: 2024-12-16T22:11:11+01:00
---

## Record video and sound

### Choose a microphone

```terminal
pactl list sources short
```

```terminal
microphone="alsa_input.usb-MU900_MU900_20190805V001-00.analog-stereo"
```

### Start recording

`/dev/video0` is usually the default webcam

```terminal
ffmpeg -f pulse -ac 2 -i "$microphone" -f v4l2 -i "/dev/video0" -vcodec libx265 /path/to/video.mkv
```

At higher resolutions encoding requires more resources.
The output might be very laggy if the computer is not beefy enough.

Workaround:
Record raw, then manually reencode.
(The raw file will be big, and reencoding will take some time.)

```terminal
ffmpeg -f pulse -ac 2 -i "$microphone" -f v4l2 -i "/dev/video$virt_cam_num" -c copy video-raw.mkv
```

```terminal
ffmpeg -i video-raw.mkv -vcodec libx265 encoded.mkv
```

## Reduce video file size

libx265 crf: https://trac.ffmpeg.org/wiki/Encode/H.265#ConstantRateFactorCRF

`crf 28` is the default constant rate factor for libx265.
Max value is 51.
A higher value means lower quality and smaller file size.

```terminal
ffmpeg -i input.mp4 -vcodec libx265 -crf 30 output.mp4
```

## Download m3u8 stream and convert it to mkv

Find the m3u8 stream on a website:

1. open dev tools
2. go to Network tab
3. filter to m3u8
4. click on the result
5. copy Request URL from Headers

```terminal
ffmpeg -i "$URL" -c copy output.mkv
```
