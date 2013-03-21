#!/bin/bash
brctl addbr br0
ifconfig eth0 0.0.0.0
brctl addif br0 eth0

#if you have a dhcp-server uncomment this line:
#dhclient3 br0

#If you have a static IP uncomment the following lines and
#change the IP accordingly to your subnet:
ifconfig br0 192.168.0.235 up
route add default gw 192.168.0.40

#Now we will create the tap device for the vm,!
# change your username accordingly
tunctl -t tap0 -u mbirth

#Now add the tap-device to the bridge:
ifconfig tap0 up
brctl addif br0 tap0