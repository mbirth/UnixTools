#!/bin/sh

VLC=/usr/bin/vlc

$VLC \
-v \
"$1" \
--play-and-exit \
--demux=dump \
--demuxdump-file="$2"
