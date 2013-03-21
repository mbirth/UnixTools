#!/bin/bash
SUBDIR="$1"
if [ -z "$SUBDIR" ]; then
    SUBDIR="."
fi
#default: JOURNAL_MODE=DELETE
#JOURNAL_MODE=TRUNCATE
JOURNAL_MODE=WAL
#JOURNAL_MODE=DELETE
cd "$SUBDIR"
for i in *; do
    if [ ! -f "$i" ]; then
        continue
    fi
    HDR=`head --bytes=15 "$i"`
    if [ "$HDR" != "SQLite format 3" ]; then
        continue
    fi
#    echo "Processing $i and setting journal mode to $JOURNAL_MODE ..."
#    echo "PRAGMA journal_mode; PRAGMA journal_mode=$JOURNAL_MODE; VACUUM;" | sqlite3 "$i"
    echo "Processing $i ..."
    echo "VACUUM;" | sqlite3 "$i"
done
cd -
