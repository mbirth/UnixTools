#!/bin/sh
STAMP=`date +"%Y%m%d-%H%M%S"`
FILENAME="cam_$STAMP.jpeg"
DEVICE="/dev/video0"
echo "Capturing $DEVICE into file $FILENAME ..."
streamer -c "$DEVICE" -b 16 -o "$FILENAME"
