#!/bin/sh
if [ "$1" == "" -or "$2" == "" ]; then
    echo "Syntax: $0 URL OUTPUTFILE"
fi

VLC=/usr/bin/vlc

$VLC \
-v \
"$1" \
--play-and-exit \
--demux=dump \
--demuxdump-file="$2"
