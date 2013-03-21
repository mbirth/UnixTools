#!/bin/bash
(
    echo "#Waiting for things to settle down ..."
    sleep 40
    echo 0
    echo "#Mounting nextgen2 ..."
    mount /mnt/nextgen2
    echo 16
    echo "#Mounting extranet ..."
    mount /mnt/extranet
    echo 33
    echo "#Mounting intranet ..."
    mount /mnt/intranet
    echo 50
    echo "#Mounting web2 ..."
    mount /mnt/web2
    echo 66
    echo "#Mounting gemeinschaft ..."
    mount /mnt/gemeinschaft
    echo 83
    #mount /mnt/web3

    echo "#Setting mouse button order ..."
    #/usr/bin/xinput set-button-map "Kingsis Peripherals  Evoluent VerticalMouse 3" 1 9 2 4 5 6 7 3 8
    /usr/bin/xinput set-button-map 12 1 9 2 4 5 6 7 3 8
    echo 100
) | zenity --progress --auto-close --text "SSL Startup Actions" --title "silver.solutions gmbh"
