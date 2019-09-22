#!/bin/bash
# Find video files with >720 height
find . -type f \( -iname "*.wmv" -or -iname "*.mp4" -or -iname "*.avi" -or -iname "*.mkv" -or -iname "*.flv" -or -iname "*.mov" -or -iname "*.m4v" -or -iname "*.webm" \) -print0 | while read -d $'\0' i; do
    DIM=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$i")
    DIMS=($(echo $DIM | tr "x" " "))
    NARROW=${DIMS[0]}
    if [ ${DIMS[1]} -lt ${DIMS[0]} ]; then
        NARROW=${DIMS[1]}
    fi
    if [ $NARROW -gt 720 ]; then
        echo "$i"
    else
        echo -n "." > /dev/stderr
    fi
done
