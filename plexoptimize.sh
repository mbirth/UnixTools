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
#ffmpeg -i "$1" "${SUBPARAMS[@]}" -c:v h264 -c:a libvo_aacenc -preset fast -movflags +faststart -crf 18 -b:a 192k -ac 2 "$1.mp4"
ffmpeg -i "$1" "${SUBPARAMS[@]}" -c:v h264 -c:a aac -preset fast -movflags +faststart -crf 18 -b:a 160k -ar 44100 -ac 2 "$1.mp4"
