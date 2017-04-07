#!/bin/sh
if [ ! -f "download.txt" ]; then
    echo "Create a file download.txt containing one URL per line."
    exit 1
fi
cat download.txt | xargs -P 6 -n 1 -I {} youtube-dl "{}"
