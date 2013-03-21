#!/bin/bash

OPERADIR=~/.opera
OPERACLEANDIRS="cache icons opcache"

for OPERACDIR in $OPERACLEANDIRS; do
    DIR=$OPERADIR/$OPERACDIR
    echo $DIR
    find $DIR -atime +14 -exec rm {} \;

done