#!/bin/sh
PROWL_UP=""
PROWL_DISH=""
PROWL_FINISHFLAG=""

HERE=`dirname $0`

$HERE/prowl.sh "Torrent downloaded $PROWL_FINISHFLAG" -2 "Parameters are: $1 | $2 | $3 | $4 | $5"
