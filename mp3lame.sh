#!/bin/sh
if [ "$#" = "0" ]; then
    echo "Usage: $0 file1 [file2 file3 ... fileN]"
    exit 1
fi

if [ -z "$CONCURRENCY_LEVEL" ]; then
    CONCURRENCY_LEVEL=1
fi

echo "Processing using $CONCURRENCY_LEVEL processes..."
find "$@" -print0 | xargs -0 -P $CONCURRENCY_LEVEL -n 1 -I {} lame -m j --replaygain-fast --vbr-new -V 2 -o --id3v2-only --resample 44.1 --quiet "{}" "{}.mp3"

echo "All done."
