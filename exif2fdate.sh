#!/bin/sh
find -type f -iname '*.jpg' -print0 | xargs -0 exiv2 mv -T
