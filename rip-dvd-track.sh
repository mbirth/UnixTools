#!/bin/sh
if [ -z "$1" -o -z "$2" ]; then
    echo "Syntax: $0 track-number output-file.mp4"
    echo "Get track numbers with lsdvd."
    exit 1
fi
TEMPFILE=`tempfile -s '.vob'`
mplayer dvd://$1 -v -dumpstream -dumpfile $TEMPFILE
avconv -i $TEMPFILE -qscale:0 8 -qscale:2 2 $2
rm $TEMPFILE
exit 0
