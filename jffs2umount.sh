#!/bin/sh
# From: http://wiki.maemo.org/Modifying_the_root_image
umount /mnt/temporary
modprobe -r mtdblock
modprobe -r mtdram
modprobe -r jffs2
modprobe -r mtd
rm /tmp/mtdblock0
