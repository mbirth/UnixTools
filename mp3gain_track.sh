#!/bin/sh
#mp3gain -k -p -r -s i "$@"
replaygain --no-album "$@"
