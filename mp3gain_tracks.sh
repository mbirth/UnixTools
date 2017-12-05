#!/bin/sh
# Install mp3gain from https://launchpad.net/~flexiondotorg/+archive/ubuntu/audio
if [ "$#" = "0" ]; then
    echo "Usage: $0 file1 [file2 file3 ... fileN]"
    echo "(Needs package python-rgain to be installed!)"
    exit 1
fi

if [ -z "$CONCURRENCY_LEVEL" ]; then
    CONCURRENCY_LEVEL=1
fi

echo "Processing using $CONCURRENCY_LEVEL processes..."
nice -n2 find "$@" -print0 | xargs -0 -P $CONCURRENCY_LEVEL -n 1 -I {} mp3gain -q -k -p -r -s i "{}"
#nice -n2 find "$@" -print0 | xargs -0 -P $CONCURRENCY_LEVEL -n 1 -I {} replaygain --no-album "{}"

echo "All done."
