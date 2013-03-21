#!/bin/sh
EZ_ROOT_LOCAL=/home/euro-01/live/
EZ_ROOT_REMOTE=eurohost:/home/silver/public_html/
if [ -z $1 ]; then
    echo "Bitte Pfad (ausgehend vom eZ root $EZ_ROOT_LOCAL) angeben."
    exit 1
fi
SRC_DIR=$EZ_ROOT_LOCAL$1
if [ ! -d $SRC_DIR -a ! -f $SRC_DIR ]; then
    echo "$SRC_DIR ist weder ein Verzeichnis noch eine Datei."
    exit 2
fi
if [ -d $SRC_DIR ]; then
    echo "$SRC_DIR ist ein Verzeichnis."
fi
if [ -f $SRC_DIR ]; then
    echo "$SRC_DIR ist eine Datei."
fi
TRG_DIR=$EZ_ROOT_REMOTE$1
echo "Sync: $SRC_DIR --> $TRG_DIR"
rsync -uvrLtp8 --progress --stats --bwlimit=1000 $SRC_DIR $TRG_DIR
