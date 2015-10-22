#!/bin/sh
if [ -z "$1" -o -z "$2" ]; then
    echo "Sets EXIF date to DATE."
    echo "Syntax: $0 DATE FILE1 [FILE2 [..FILEn]]"
    exit 1
fi

DATE=$1
shift
exiv2 mo -M "set Exif.Photo.DateTimeOriginal '$DATE'" -M "set Exif.Photo.DateTimeDigitized '$DATE'" $@
