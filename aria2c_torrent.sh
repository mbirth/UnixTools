#!/bin/sh
PUBLIC_IP=`wget -O - -q http://admin.birth-online.de/ip.php | tr -d '\n'`
echo "Public IP: $PUBLIC_IP"
aria2c --bt-external-ip="$PUBLIC_IP" --dht-listen-port=25690-25699 --listen-port=25670-25679 -T $*

