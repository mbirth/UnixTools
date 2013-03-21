#!/bin/sh

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Use: $0 \"event\" prio \"message\""
    exit 1
fi

HERE=`dirname $0`

. $HERE/CONFIG

SEDSCRIPT=$HERE/urlencode.sed

EVENT=`echo "$1" | sed -f $SEDSCRIPT`
MESSAGE=`echo "$3" | sed -f $SEDSCRIPT`
APP=`echo "NSLU2" | sed -f $SEDSCRIPT`

# Priority can be -2 .. 2 (-2 = lowest, 2 = highest)
PRIORITY=$2

HOST="files.birth-online.de"
PORT="80"
URI="/prowlProxy.php?add"

POST_DATA="apikey=$PROWL_RECIPIENT&priority=$PRIORITY&application=$APP&event=$EVENT&description=$MESSAGE"

POST_LEN=`echo "$POST_DATA" | wc -c`

HTTP_QUERY="POST $URI HTTP/1.1
Host: $HOST
Content-Length: $POST_LEN
Content-Type: application/x-www-form-urlencoded

$POST_DATA"

# echo "$HTTP_QUERY"

echo "$HTTP_QUERY" | nc -w 10 $HOST $PORT > /dev/null

if [ $? -eq "0" ]; then
    exit 0
else
    exit 2
fi
