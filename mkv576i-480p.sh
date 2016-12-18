#!/bin/bash
if [ -z "$1" ]; then
    echo "Syntax: $0 VIDEOFILE"
    exit 1
fi

while [ -n "$1" ]; do
    # Quality: -crf 18 = almost lossless, -crf 22 = medium, -crf 28 = low
    # Deinterlace: -vf yadif=1 -field-dominance 0/1 (0=Top field first, 1=Bottom field first; doubles framerate)
    #           or -vf yadif=1:0 (or 1:1)
    #              -vf yadif=0 (calculates 1 frame from both fields; keeps framerate)
    # Scale: -vf scale=-1:720
    ffmpeg -i "$1" -c:v h264 -c:a aac -c:s copy -preset fast -movflags +faststart -vf yadif=1:0,scale=-1:480 -crf 18 -b:a 160k -ar 44100 -ac 2 "${1}_480p.mp4"
    shift
done
