#!/bin/sh
if [ "$#" = "0" ]; then
    echo "Usage: $0 file1 [file2 file3 ... fileN]"
    exit 1
fi

while [ "$#" -gt 0 ]; do
    echo "Processing $1 ($# more left)..."
    ffmpeg -i "$1" -f wav -vn - | lame -m j --replaygain-fast --vbr-new -V 4 -o --id3v2-only --resample 44.1 - "$1.mp3"
    shift
done
