#!/bin/sh

VLC=/usr/bin/vlc

VCODEC=DX50
VBITRATE=512

ACODEC=mpga
ABITRATE=96

$VLC \
-v \
-I dummy \
"$1" \
--sout "#transcode{width=224,height=176,vcodec=$VCODEC,acodec=$ACODEC,vb=$VBITRATE,ab=$ABITRATE}:std{access=file,mux=avi,dst=\"$2\"}" \
--sout-all