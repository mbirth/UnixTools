#!/bin/sh

if [ -z "$1" -o -z "$2" ]; then
    echo "Syntax: $0 VTS_01_1.VOB|VTS_01_2.VOB|VTS_...VOB OUTPUT_FILE (.mp4 will be added!)"
    exit 1
fi

# -vf yadif=1:0     Deinterlace (doubles framerate)
# -vf yadif=0:0     Deinterlace (keep framerate)
# -vf crop=in_w-10:in_h-110      Crop width and height
# -vf scale=720:-2               Scale to width
# -vf setsar=1:1                 Set pixel size to 1
ffmpeg -i concat:"$1" -c:v h264 -c:a aac -preset fast -movflags +faststart -vf yadif=1:0,setsar=1:1 -crf 20 -b:a 160k -ar 44100 -ac 2 "$2.mp4"
