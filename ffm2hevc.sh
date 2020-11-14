#!/bin/sh
ffmpeg -i "$1" -map 0 -map_metadata 0 -c:v libx265 -preset slow -pix_fmt yuvj420p -tag:v hvc1 -movflags +faststart -c:a aac -b:a 160k -ar 44100 -crf 20 -x265-params crf=20 "$1.hevc.mov"

