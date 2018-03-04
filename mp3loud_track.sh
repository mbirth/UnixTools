#!/bin/sh
# Install mp3gain from: https://launchpad.net/~flexiondotorg/+archive/ubuntu/audio
# Install bs1770gain from package manager

TARGET_LOUDNESS=-14

# Normalise MP3 to 89 dB, add tags to file
mp3gain -q -k -p -r -s i "$1" > /dev/null

# Find actual EBU R128 loudness, show relative to $TARGET_LOUDNESS LUFS
LOUDADJUST=`bs1770gain --norm $TARGET_LOUDNESS --xml "$1" | grep -m 1 integrated | sed -e 's/^.*lu="\(.*\)".*$/\1/'`
echo "[$1] Deviation from $TARGET_LOUDNESS LUFS: $LOUDADJUST LU"

# Calculate gain adjustment (in steps of 1.5 dB/~LU), round using printf
GAINADJUST=`echo "scale=4;$LOUDADJUST / 1.5" | bc`
GAINADJUST=`printf %0.f $GAINADJUST`

# To ALWAYS stay BELOW -14 LUFS, use this:
#GAINADJUST=`echo "$LOUDADJUST / 1.5" | bc`

if [ "$GAINADJUST" -ne 0 ]; then
    echo "[$1] Adjust gain by: $GAINADJUST"
    # Use this call to have clipping-prevention which doesn't work when modifying gain directly
    mp3gain -q -k -p -r -s i -m $GAINADJUST "$1"
else
    echo "[$1] No further adjustment necessary."
fi
