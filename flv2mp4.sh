#!/bin/bash

while IFS= read -r -u3 -d $'\0' FLV; do
    MP4=${FLV/%.flv/.mp4}
    STREAMS=`avprobe -i "$FLV" -show_streams -of csv 2>/dev/null`
    VID_STREAM=`echo "$STREAMS" | grep "video" | awk -F ',' '{print $3}'`
    VID_STREAM_LONG=`echo "$STREAMS" | grep "video" | awk -F ',' '{print $4}'`

    if [ "$VID_STREAM" = "h264" ]; then
        echo "Converting $FLV ($VID_STREAM_LONG) to MP4 ..."
        avconv -i "$FLV" -codec copy "$MP4"
    else
        echo "ERROR: $FLV has $VID_STREAM_LONG, no H.264!"
    fi
done 3< <(find . -type f -iname "*.flv" -print0)
