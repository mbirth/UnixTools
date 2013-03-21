#!/bin/bash
while [ "$1" ]; do
    KEYID=${1:-8}
    #echo Fetching key $KEYID ...
    #gpg --keyserver keyserver.ubuntu.com --recv $KEYID
    #echo Importing into apt-key ...
    #gpg --export --armor $KEYID | sudo apt-key add -
    echo Importing key $KEYID into apt-key ...
    sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com $KEYID
    #sudo apt-key adv --recv-keys --keyserver wwwkeys.de.pgp.net $KEYID
    shift
done

