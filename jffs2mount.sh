#!/bin/sh
# From: https://www.kutukupret.com/2010/09/16/mounting-a-jffs2-filesystem-in-linux/
mknod /tmp/mtdblock0 b 31 0
modprobe mtd
modprobe jffs2
modprobe mtdram total_size=32767
modprobe mtdblock

dd if="$1" of=/dev/mtd0

mount -t jffs2 /tmp/mtdblock0 /mnt/temporary
# check dmesg again - if the above mount results in any errors there is a problem...
