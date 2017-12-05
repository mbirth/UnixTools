#!/bin/sh
TMPFILE=`mktemp`
BASENAME=`basename "$1"`
while [ $# -gt 0 ]; do
  THISFILE=`realpath "$1"`
  echo "file '${THISFILE}'">>$TMPFILE
#  echo "file '${1}'">>$TMPFILE
  shift
done
EXT="${BASENAME##*.}"
NAMENOEXT="${BASENAME%.*}"
echo "Output ext: $EXT"
ffmpeg -f concat -safe 0 -i "$TMPFILE" -codec copy "${NAMENOEXT}_combined.${EXT}"
rm "$TMPFILE"
