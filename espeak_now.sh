#!/bin/sh
HERE=`dirname $0`
#/usr/bin/espeak -v english-us "It is `date +\"%-M\"` past `date +\"%k\"`." >$HERE/espeak.log 2>&1
/usr/bin/espeak -v german "Es ist `date +\"%k\"` Uhr `date +\"%-M\"`." >$HERE/espeak.log 2>&1
