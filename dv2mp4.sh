#!/bin/sh
OUTFILE="$1.mp4"
if [ -n "$2" ]; then
    OUTFILE="$2"
fi

# INPUT: 720x576 (DV, interlaced, BFF)
# -vf yadif=1:0     Deinterlace (doubles framerate)
# -vf yadif=0:0     Deinterlace (keep framerate)
# -vf crop=in_w-10:in_h-110      Crop width and height
# -vf scale=720:-2               Scale to width
# -vf setsar=1:1                 Set pixel size to 1
#ffmpeg -i "$1" -c:v libx264 -c:a aac -crf 18 -ar 44100 -q:a 2 -b:a 128k -ac 2 -vf "yadif=1:1,scale=720x288,setsar=1:1,convolution=0 0 0 -64 384 -64 0 0 0,unsharp,eq=saturation=1.4:gamma=1.2" -aspect 4:3 -movflags +faststart -profile:v high -level 4.0 "$1.mp4"
#ffmpeg -i "$1" -c:v libx264 -c:a aac -crf 18 -ar 44100 -q:a 2 -b:a 128k -ac 2 -vf "yadif=1:1,scale=720x288,setsar=1:1,convolution=0 0 0 -64 384 -64 0 0 0,smartblur=1.5:-0.25:-3.5:0.75:0.25:0.5,eq=saturation=1.4:gamma=1.2" -aspect 4:3 -movflags +faststart -profile:v high -level 4.0 "$1.mp4"
nice ffmpeg -i "$1" -c:v libx264 -c:a aac -crf 20 -ar 44100 -q:a 2 -b:a 128k -ac 2 -vf "yadif=1:1,scale=720x288,setsar=1:1,convolution=0 0 0 -64 384 -64 0 0 0,smartblur=1.5:-0.35:-3.5:0.65:0.25:2.0,eq=saturation=1.4:gamma=1.2" -aspect 4:3 -movflags +faststart -profile:v high -level 4.0 "${OUTFILE}"
