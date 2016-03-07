#!/bin/sh
ffmpeg -i "$1" -vcodec copy -acodec copy -bsf:a aac_adtstoasc "$1.fixed.mp4"
