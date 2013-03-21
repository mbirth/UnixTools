#!/bin/bash
#bring the interfaces down
ifconfig tap0 down
ifconfig br0 down
brctl delif br0 tap0
brctl delbr br0

#now setup your network-interface again
#for dhcp uncomment the following line
#dhclient3 eth0

#For a static IP uncomment the following lines and change them accordingly:
ifconfig eth0 192.168.0.235
route add default gw 192.168.0.40 dev eth0