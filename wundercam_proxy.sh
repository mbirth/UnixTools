#!/bin/sh

HERE=`dirname $0`

. $HERE/CONFIG

WUNDERCAM_URL="ftp://webcam.wunderground.com/image.jpg"
TMPFILE=`tempfile -p "snap" -s ".jpg"`

curl -v -u "$SNAPSHOT_USERNAME:$SNAPSHOT_PASSWORD" $SNAPSHOT_URL -o "$TMPFILE"
if [ $? -eq 0 ]; then
    curl -v -T "$TMPFILE" --ftp-pasv -u "$WUNDERCAM_USERNAME:$WUNDERCAM_PASSWORD" $WUNDERCAM_URL
else
    echo "ERROR: Problem while downloading $SNAPSHOT_URL." 1>&2
fi

find /tmp -maxdepth 1 -type f -name "snap*.jpg" -mmin +120 -delete
