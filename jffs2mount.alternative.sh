#!/bin/sh
# From: http://wiki.maemo.org/Modifying_the_root_image
mknod /tmp/mtdblock0 b 31 0
modprobe loop
losetup /dev/loop0 "$1"
modprobe mtdblock
modprobe block2mtd
# Note the ,128KiB is needed (on 2.6.26 at least) to set the eraseblock size.
#echo "/dev/loop0" > /sys/module/block2mtd/parameters/block2mtd
#echo "/dev/loop0,128KiB" > /sys/module/block2mtd/parameters/block2mtd
echo "/dev/loop0,64KiB" > /sys/module/block2mtd/parameters/block2mtd
modprobe jffs2
# check dmesg
mount -t jffs2 /tmp/mtdblock0 /mnt/temporary
# check dmesg again - if the above mount results in any errors there is a problem...
