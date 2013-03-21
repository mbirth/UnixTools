#!/bin/bash
HERE=`dirname $0`
find $1 -type d -print0 | while read -d $'\0' i; do
    $HERE/sqlite_cleanup.sh "$i"
done
