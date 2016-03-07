#!/bin/sh
while [ -f "$1" ]; do
    ffmpeg -i "$1" -vcodec libx264 -acodec libmp3lame -crf 18 -ar 44100 -q:a 2 -profile:v high -level 4.0 -vf scale=768:576:flags=lanczos "$1.mp4"
    shift
done

