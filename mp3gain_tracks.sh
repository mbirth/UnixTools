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
#  -q - Quiet mode: no status messages
#  -k - automatically lower Track/Album gain to not clip audio
#  -p - Preserve original file timestamp
#  -r - apply Track gain automatically (all files set to equal loudness)
#  -s i - use ID3v2 tag for MP3 gain info
#  -d <n> - modify suggested dB gain (89dB) by floating-point n
nice -n2 find "$@" -print0 | xargs -0 -P $CONCURRENCY_LEVEL -n 1 -I {} mp3gain -q -k -p -r -s i -d 4.0 "{}"
#nice -n2 find "$@" -print0 | xargs -0 -P $CONCURRENCY_LEVEL -n 1 -I {} replaygain --no-album "{}"

echo "All done."
