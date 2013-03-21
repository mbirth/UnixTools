#!/bin/sh
ifconfig eth0 0.0.0.0 promisc up
ifconfig wlan0 0.0.0.0 promisc up
brctl addbr br0
brctl addif br0 eth0
brctl addif br0 wlan0
#ip link set br0 up
#ip addr add 192.168.0.235/24 brd + dev br0
#route add default gw 192.168.0.40 dev br0
ifconfig br0 up
echo "1" >/proc/sys/net/ipv4/conf/br0/forwarding
dhclient br0
