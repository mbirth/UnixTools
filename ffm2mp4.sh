#!/bin/sh

FFMPEG=/usr/bin/ffmpeg

VCODEC=h264
VBITRATE=384

ACODEC=mp3
ABITRATE=32
CHANNELS=1

$FFMPEG \
-map 0:0 \
-map 0:1 \
-i "$1" \
-r 24 \
-s 512x384 \
-b $VBITRATE \
-vcodec $VCODEC \
#-aspect 1.0 \
-ac $CHANNELS \
-ab $ABITRATE \
-acodec $ACODEC \
"$2"
