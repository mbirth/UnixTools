#! /bin/bash -x
# extracts .config info from a [b]zImage file
# uses: binoffset (new), dd, zcat, strings, grep
# $arg1 is [b]zImage filename

HDR=`./binoffset $1 0x1f 0x8b 0x08 0x0`
PID=$$
TMPFILE="$1.vmlin.$PID"

# dd if=$1 bs=1 skip=$HDR | zcat - | strings /dev/stdin \
# | grep "[A-Za-z_0-9]=[ynm]$" | sed "s/^/CONFIG_/" > $1.oldconfig.$PID
# exit

dd if=$1 bs=1 skip=$HDR | zcat - > $TMPFILE
#strings $TMPFILE | grep "^[\#[:blank:]]*CONFIG_[A-Za-z_0-9]*" > $1.oldconfig.$PID
#wc $1.oldconfig.$PID
#rm $TMPFILE