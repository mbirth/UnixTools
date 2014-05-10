#!/bin/sh
BASE_URL="http://boards.4chan.org/"
THREAD_URL="/thread/$1"

echo -n "Reading boards..."
BOARDS=`wget -O - -q http://4chan.org/ | grep -o -P ".org/(\w+)/\"" | sed -e 's/.*\/\(\w\+\)\/"/\1/g'`
BOARDS_COUNT=`echo "$BOARDS" | wc -l`
echo " Found $BOARDS_COUNT boards."

if [ -z $1 ]; then
    echo "Syntax: $0 ThreadNo"
    exit 1
fi

for BOARD in $BOARDS; do
    URL="${BASE_URL}${BOARD}${THREAD_URL}"
    echo "$URL"
    wget --spider "$URL" -q
    RET=$?
    if [ $RET -eq 0 ]; then
        echo ""
        echo "Found: $URL"
        exit
    else
        echo -n ".$RET"
    fi
done
echo ""
