#!/bin/sh
HERE=$(dirname $0)

. $HERE/CONFIG

# https://unix.stackexchange.com/questions/437468/bluetooth-headset-volume-too-low-only-in-arch/562381#562381
# Needs patched bluetoothd. Find 48 8b 46 70 66 83 78 0a 7f and change 7f to ff.

# Query current volume
dbus-send --print-reply --system --dest=org.bluez /org/bluez/hci0/dev_${BTHEADSET_MAC}/sep1/fd0 org.freedesktop.DBus.Properties.Get string:org.bluez.MediaTransport1 string:Volume

# Set AirPod Pro volume to max. (Needs patched bluetoothd! See above!)
dbus-send --print-reply --system --dest=org.bluez /org/bluez/hci0/dev_${BTHEADSET_MAC}/sep1/fd0 org.freedesktop.DBus.Properties.Set string:org.bluez.MediaTransport1 string:Volume variant:uint16:127
