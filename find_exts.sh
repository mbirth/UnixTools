#!/bin/sh
find -type f -print | sed 's/^.*\.\([a-zA-Z0-9]\+\)$/\1/gm' | sort -u
