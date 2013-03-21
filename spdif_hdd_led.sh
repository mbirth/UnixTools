#!/bin/bash

VERSION=01

if [ "$1" == "--help" ]; then
    echo "
MacBook LED indicator (v$VERSION)   Jason Parekh <jasonparekh@gmail.com> 
Put that SPDIF-out to use!    http://jasonparekh.com/linux-on-macbook

Usage: $0 <type> [dev]

type   Choose between 'disk' (default) or 'net' indicator
dev    Use the 'dev' device (eg: 'sda1' or even just 'sda' for all partitions)

Examples:
       $0              Monitors all block devices activity (disk and CD/DVD drives)
       $0 disk sda     Monitors all disk drives activity
       $0 net eth0     Monitors LAN activity
       $0 net          Monitors all network activity (WARNING: wlan0 will pickup ANY wifi activity)
       $0 net ath0     Monitors wireless activity
"   
    exit
fi

STATS_FILE="/proc/diskstats"

if [ "$1" == "net" ]; then
    STATS_FILE="/proc/net/dev"
fi

STATS_CMD="cat $STATS_FILE"
if [ "$2" != "" ]; then
    STATS_CMD="grep $2 $STATS_FILE"
fi

renice 19 -p $$ >/dev/null 2>&1

while [ 1 ]; do
    CUR_STATS=`$STATS_CMD`
    if [ "$CUR_STATS" != "$LAST_STATS" ]; then
        if [ "$LAST_OP" != "ACTIVE" ]; then
            amixer set IEC958 on >/dev/null 2>&1
        fi
        LAST_OP="ACTIVE"
    else
        if [ "$LAST_OP" != "IDLE" ]; then
            amixer set IEC958 off >/dev/null 2>&1
        fi
        LAST_OP="IDLE"
    fi
    LAST_STATS="$CUR_STATS"
    sleep 0.2
done
