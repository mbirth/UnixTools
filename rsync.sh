#!/bin/sh
SOURCE_DIR=/home/mbirth/WualaDrive
TARGET_DIR=/mnt/box.com
if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory $SOURCE_DIR does not exist."
    exit 10
fi
if [ ! -d "$TARGET_DIR" ]; then
    echo "ERROR: Target directory $TARGET_DIR does not exist."
    exit 11
fi
rsync -KWuvr --size-only --delete --copy-unsafe-links --progress "$SOURCE_DIR" "$TARGET_DIR" | tee "/tmp/$0.log"
