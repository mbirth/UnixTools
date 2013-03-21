#!/bin/sh

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Use: $0 \"event\" prio \"message\""
    exit 1
fi

HERE=`dirname $0`

. $0/CONFIG

SEDSCRIPT=$HERE/urlencode.sed

EVENT=`echo "$1" | sed -f $SEDSCRIPT`
# Priority can be -2 .. 2 (-2 = lowest, 2 = highest)
PRIORITY=$2
MESSAGE=`echo "$3" | sed -f $SEDSCRIPT`
APP=`echo "Revo" | sed -f $SEDSCRIPT`

# API documentation: https://www.notifymyandroid.com/api.jsp
BASE_URI="https://www.notifymyandroid.com/publicapi"
POST_DATA="apikey=$NMA_RECIPIENT&priority=$PRIORITY&application=$APP&event=$EVENT&description=$MESSAGE"

RESULT=`wget --post-data="$POST_DATA" -q -O - "$BASE_URI/notify"`
OK=`echo "$RESULT" | grep "code=\"200\""`

if [ -n "$OK" ]; then
    exit 0
else
    echo "The following message could not be sent: $3" >&2
    exit 2
fi
