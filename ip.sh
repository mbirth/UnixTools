#!/bin/sh
IP1=`wget http://media.silversolutions.de/webco/ip.php -O - -q --no-cache`
IP2=`wget http://admin.birth-online.de/ip.php -O - -q --no-cache`
 echo "$IP1" | grep REMOTE_ADDR | cut -c 22-
 echo "$IP2"
