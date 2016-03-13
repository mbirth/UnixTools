#!/bin/sh
ffmpeg -i "$1" -c:v h264 -c:a libvo_aacenc -preset fast -movflags +faststart -crf 18 -b:a 192k -ac 2 "$1.mp4"
