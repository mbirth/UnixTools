#!/bin/sh
if [ "$#" = "0" ]; then
    echo "Usage: $0 file1 [file2 file3 ... fileN]"
    exit 1
fi

while [ "$#" -gt 0 ]; do
    echo "Processing $1 ($# more left)..."
    #lame -m j --replaygain-fast --preset extreme -q 2 --vbr-new -V 2 -o --id3v2-only "$1" "$1.mp3"
    lame -m j --replaygain-fast --vbr-new -V 2 -o --id3v2-only --resample 44.1 "$1" "$1.mp3"
    shift
done
