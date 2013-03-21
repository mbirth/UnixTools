#!/bin/sh
# To use this, create files with the MAC addresses (1 MAC per file)
beep -f 1200 -l 500 -n -f 1200 -l 500 -n -f 1200 -l 500
wakeonlan `cat $1.mac`
