#!/bin/sh
if [ -z "$1" ]; then
    echo "Syntax: $0 date-stamp"
    exit 1
fi
GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1" git commit

