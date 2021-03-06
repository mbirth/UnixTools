#!/bin/sh
if [ "$#" = "0" ]; then
    echo "Usage: $0 youtube-url output-filename"
    exit 1
fi

youtube-dl "$1" -o - | avconv -i pipe:0 -f wav -vn - | lame -m j --replaygain-fast --vbr-new -V 4 -o --id3v2-only --resample 44.1 - "$2.mp3"
