#!/bin/sh
# http://superuser.com/questions/556029/how-do-i-convert-a-video-to-gif-using-ffmpeg-with-reasonable-quality

TMPDIR=`mktemp -d /tmp/frames.XXXXXXXX` || exit 1

ffmpeg -i "$1" -vf scale=320:-1 -r 10 $TMPDIR/ffout%03d.png
convert -delay 5 -loop 0 $TMPDIR/ffout*.png $1.gif
