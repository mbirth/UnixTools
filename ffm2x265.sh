#!/bin/sh

FFMPEG=/usr/bin/ffmpeg

VCODEC=libx265
VCRF=23

# Parameter suggestions:
# https://unix.stackexchange.com/questions/230800/re-encoding-video-library-in-x265-hevc-with-no-quality-loss
# Explanations: http://x265.readthedocs.io/en/default/cli.html

# <=1080p:
# merange=44:ctu=32:max-tu-size=16

#-x265-params crf=22:no-sao:deblock=-2,-2:qcomp=0.8:psy-rd=0.7:psy-rdoq=5.0:rdoq-level=1.0:merange=44:ctu=32:max-tu-size=16 \

$FFMPEG \
-hide_banner \
-i "$1" \
-map 0 \
-c:v $VCODEC \
-preset fast \
-x265-params crf=22 \
-c:a copy \
-c:s copy \
"${1}_x265.mkv"
