#!/bin/bash
if [ -z "$1" ]; then
    echo "Syntax: $0 VIDEOFILE"
    exit 1
fi

while [ -n "$1" ]; do
    # Quality: -crf 18 = almost lossless, -crf 22 = medium, -crf 28 = low
    # Scale: -vf scale=-1:720
    ffmpeg -i "$1" -c:v h264 -c:a aac -c:s copy -preset fast -movflags +faststart -vf scale=1280:-2 -crf 22 -b:a 160k -ar 44100 -ac 2 "${1}_720p.mkv"
    shift
done
