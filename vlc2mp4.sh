#!/bin/sh

VLC=/usr/bin/vlc

VCODEC=mp4v
VBITRATE=384

ACODEC=mp3
ABITRATE=64

$VLC \
-v \
-I dummy \
"$1" \
--sout "#transcode{width=512,height=384,vcodec=$VCODEC,acodec=$ACODEC,vb=$VBITRATE,ab=$ABITRATE}:std{access=file,mux=ts,dst=\"$2\"}" \
--sout-all