#!/bin/sh
ffmpeg -i "$1" -vcodec libx264 -acodec libmp3lame -crf 18 -ar 44100 -q:a 2 -vf yadif -profile:v high -level 4.0 "$1.mp4"
