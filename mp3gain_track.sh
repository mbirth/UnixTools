#!/bin/sh
# Install mp3gain from: https://launchpad.net/~flexiondotorg/+archive/ubuntu/audio
mp3gain -k -p -r -s i "$@"
#replaygain --no-album "$@"
