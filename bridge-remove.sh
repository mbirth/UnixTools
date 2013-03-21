#!/bin/sh
ifconfig br0 down
brctl delif br0 wlan0
brctl delif br0 eth0
brctl delbr br0
ifconfig wlan0 -promisc up
ifconfig eth0 -promisc up
dhclient wlan0
