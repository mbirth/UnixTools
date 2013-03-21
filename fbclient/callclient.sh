#!/bin/sh
export LC_CTYPE="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US:en"
HERE=`dirname $0`
env > $HERE/callclient.log
/usr/bin/python3 $HERE/callclient.py >>$HERE/callclient.log 2>&1
