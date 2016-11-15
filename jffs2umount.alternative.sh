#!/bin/sh
# From: http://wiki.maemo.org/Modifying_the_root_image
umount /mnt/temporary
modprobe -r block2mtd
modprobe -r mtdblock
modprobe -r jffs2
losetup -d /dev/loop0
rm /tmp/mtdblock0
