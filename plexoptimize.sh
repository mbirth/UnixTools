#!/bin/bash
if [ -z "$1" ]; then
    echo "Syntax: $0 VIDEOFILE [SUBTITLEFILE]"
    exit 1
fi

# Found: https://superuser.com/questions/852400/properly-downmix-5-1-to-stereo-using-ffmpeg
# and http://forum.doom9.org/showthread.php?t=168267
ATSC_MODE="pan=stereo|FL<1.0*FL+0.707*FC+0.707*BL|FR<1.0*FR+0.707*FC+0.707*BR"
NIGHT_MODE="pan=stereo|FL=FC+0.30*FL+0.30*BL|FR=FC+0.30*FR+0.30*BR"
STEREO="pan=stereo|c0=FL|c1=FR"

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
#ffmpeg -i "$1" "${SUBPARAMS[@]}" -c:v h264 -c:a aac -preset fast -movflags +faststart -vf scale=-2:720 -crf 24 -b:a 96k -ar 44100 -ac 2 "$1.mp4"
#ffmpeg -i "$1" "${SUBPARAMS[@]}" -c:v h264 -c:a aac -preset fast -movflags +faststart -crf 20 -b:a 160k -ar 44100 -ac 2 "$1.mp4"
ffmpeg -i "$1" "${SUBPARAMS[@]}" -c:v h264 -c:a aac -preset fast -movflags +faststart -crf 24 -b:a 96k -ar 44100 -ac 2 "$1.mp4"
#ffmpeg -i "$1" "${SUBPARAMS[@]}" -c:v libx265 -c:a aac -preset fast -movflags +faststart -crf 20 -b:a 160k -ar 44100 -ac 2 "$1.x265.mp4"
#ffmpeg -i "$1" "${SUBPARAMS[@]}" -map 0 -c:v h264 -c:a aac -preset fast -movflags +faststart -filter_complex "[0:v]scale=-2:720;[0:a:1]$NIGHT_MODE;[0:a:0]$STEREO" -metadata:s:a:0 language=eng -metadata:s:a:1 language=ger -crf 24 -b:a 96k -ar 44100 -ac 2 "$1.mkv"
