#!/bin/bash
if [ -z "$1" ]; then
    echo "Syntax: $0 VIDEOFILE [SUBTITLEFILE]"
    exit 1
fi
SUBPARAMS=( )
if [ -n "$2" ]; then
    # http://stackoverflow.com/questions/8672809/use-ffmpeg-to-add-text-subtitles
    SUBPARAMS=( -f srt -i "$2" -map 0:0 -map 0:1 -map 1:0 -c:s mov_text )    # mp4
#    SUBPARAMS=( -f srt -i "$2" -map 0:0 -map 0:1 -map 1:0 -c:s srt )    # mkv
fi
# For source mpeg4: -bsf:v mpeg4_unpack_bframes
# Quality: -crf 18 = almost lossless, -crf 22 = medium, -crf 28 = low
# Deinterlace: -vf yadif=1 -field-dominance 0/1 (0=Top field first, 1=Bottom field first; doubles framerate)
#           or -vf yadif=1:0 (or 1:1)
#              -vf yadif=0 (calculates 1 frame from both fields; keeps framerate)
# Scale: -vf scale=-1:720 (or -2 for values dividable by 2)
# Scale to Aspect: -filter:v scale=iw*sar:ih,setsar=1:1
# Set audio language: -metadata:s:a:0 language=eng
#ffmpeg -i "$1" "${SUBPARAMS[@]}" -c:v h264 -c:a libvo_aacenc -preset fast -movflags +faststart -crf 18 -b:a 192k -ac 2 "$1.mp4"
#ffmpeg -i "$1" "${SUBPARAMS[@]}" -c:v h264 -c:a aac -preset fast -movflags +faststart -vf yadif=0,scale=-2:720 -crf 18 -b:a 160k -ar 44100 -ac 2 "$1.mp4"
#ffmpeg -i "$1" "${SUBPARAMS[@]}" -c:v h264 -c:a aac -preset fast -movflags +faststart -vf scale=-2:720 -crf 20 -b:a 160k -ar 44100 -ac 2 "$1.mp4"
#ffmpeg -i "$1" "${SUBPARAMS[@]}" -c:v h264 -c:a aac -preset fast -movflags +faststart -crf 20 -b:a 160k -ar 44100 -ac 2 "$1.mp4"
ffmpeg -i "$1" "${SUBPARAMS[@]}" -c:v h264 -c:a aac -preset fast -movflags +faststart -crf 25 -b:a 96k -ar 44100 -ac 2 "$1.mp4"
#ffmpeg -i "$1" "${SUBPARAMS[@]}" -c:v libx265 -c:a aac -preset fast -movflags +faststart -crf 20 -b:a 160k -ar 44100 -ac 2 "$1.x265.mp4"
