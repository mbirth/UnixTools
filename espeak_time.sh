#!/bin/sh
HERE=`dirname $0`
#/usr/bin/espeak -v english-us+f2 "It is `date +\"%k\"` o'clock." >$HERE/espeak.log 2>&1
/usr/bin/espeak -v german+f2 "Es ist `date +\"%k\"` Uhr." >$HERE/espeak.log 2>&1
