#!/bin/sh
# Found: https://superuser.com/questions/852400/properly-downmix-5-1-to-stereo-using-ffmpeg
# and http://forum.doom9.org/showthread.php?t=168267

ATSC_MODE="pan=stereo|FL<1.0*FL+0.707*FC+0.707*BL|FR<1.0*FR+0.707*FC+0.707*BR"
NIGHT_MODE="pan=stereo|FL=FC+0.30*FL+0.30*BL|FR=FC+0.30*FR+0.30*BR"

ffmpeg -report -loglevel verbose -i "$1" -map 0:a:1 -c:a aac -b:a 160k -ar 44100 -ac 2 -af $NIGHT_MODE "${1}_2ch.m4a"


# Merge with:
# ffmpeg -i original_file.mkv -i audio_eng_downmix.m4a -i audio_ger_downmix.m4a -map 0 -map 1:0 -map 2:0 -codec copy -metadata:s:a:2 title="English (night mode)" -metadata:s:a:2 language=eng -metadata:s:a:3 title="Deutsch (Nachtmodus)" -metadata:s:a:3 language="ger" output_file.mkv
