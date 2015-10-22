#!/bin/sh
# Finds all JPG files and sets their file date to date from EXIF.
find -type f -iname '*.jpg' -print0 | xargs -0 exiv2 mv -T
