#!/bin/bash

CHROMEDIR=~/.cache/chromium
CHROMECLEANDIRS="Cache"

for CHROMECDIR in $CHROMECLEANDIRS; do
    DIR=$CHROMEDIR/$CHROMECDIR
    echo $DIR
    find $DIR -atime +14 -exec rm {} \;
done
