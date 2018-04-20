#!/bin/sh
if [ "$#" = "0" ]; then
    echo "Usage: $0 file1 [file2 file3 ... fileN]"
    exit 1
fi

if [ -z "$CONCURRENCY_LEVEL" ]; then
    CONCURRENCY_LEVEL=1
fi

CONCURRENCY_LEVEL=1

echo "Processing using $CONCURRENCY_LEVEL processes..."
nice -n2 find "$@" -print0 | xargs -0 -P $CONCURRENCY_LEVEL -n 1 -I {} nice -n10 /opt/mbirth/mp3loud_track.sh "{}"

echo "All done."
